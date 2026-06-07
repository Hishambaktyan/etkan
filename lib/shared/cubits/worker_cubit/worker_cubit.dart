import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import '../../networks/local/cache_helper.dart';
import '../../networks/remote/notification_service.dart';

class WorkerCubit extends Cubit<WorkerStates> {
  WorkerCubit() : super(WorkerInitState());

  static WorkerCubit get(context) => BlocProvider.of(context);

  static const int freeServicesLimit = 5;
  static const int freeCompletedRequestsLimit = 5;

  bool isSubscriptionActive = false;
  String subscriptionStatus = 'not_submitted';
  DateTime? subscriptionEndDate;
  Timer? _subscriptionExpiryTimer;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _workerSubscriptionListener;
  String? _listenedWorkerId;

  bool get isSubscriptionExpired => subscriptionStatus == 'expired';

  bool get hasReachedFreeServicesLimit =>
      !isSubscriptionActive &&
      !isSubscriptionExpired &&
      (workerServicesCount ?? 0) >= freeServicesLimit;

  bool get hasReachedFreeCompletedRequestsLimit =>
      !isSubscriptionActive &&
      !isSubscriptionExpired &&
      (workerCompletedRequestsCount ?? 0) >= freeCompletedRequestsLimit;

  bool get shouldShowSubscriptionWarning =>
      isSubscriptionExpired ||
      hasReachedFreeServicesLimit ||
      hasReachedFreeCompletedRequestsLimit;

  String? get addServiceRestrictionMessage {
    if (isSubscriptionExpired) {
      return 'انتهت مدة اشتراكك. يرجى تجديد الاشتراك لإضافة خدمات جديدة.';
    }

    if (hasReachedFreeServicesLimit) {
      return 'لقد وصلت إلى الحد المجاني المسموح وهو 5 خدمات. اشترك الآن لإضافة خدمات غير محدودة.';
    }

    return null;
  }

  String get subscriptionWarningTitle {
    if (isSubscriptionExpired) {
      return 'انتهت مدة اشتراكك';
    }

    if (hasReachedFreeServicesLimit && hasReachedFreeCompletedRequestsLimit) {
      return 'لقد استهلكت الخطة المجانية';
    }

    if (hasReachedFreeCompletedRequestsLimit) {
      return 'أكملت 5 حجوزات مجانية';
    }

    return 'أضفت 5 خدمات مجانية';
  }

  String get subscriptionWarningBody {
    if (isSubscriptionExpired) {
      return 'انتهت باقتك المدفوعة. جدّد اشتراكك لإضافة خدمات جديدة واستقبال حجوزات جديدة.';
    }

    if (subscriptionStatus == 'pending') {
      return 'وصلت إلى الحد المجاني، وطلب اشتراكك قيد المراجعة حالياً. يمكنك إكمال الحجوزات القديمة فقط.';
    }

    if (hasReachedFreeServicesLimit && hasReachedFreeCompletedRequestsLimit) {
      return 'أضفت 5 خدمات وأكملت 5 حجوزات مجانية. اشترك الآن لإضافة خدمات واستقبال حجوزات جديدة بلا حدود.';
    }

    if (hasReachedFreeCompletedRequestsLimit) {
      return 'أكملت 5 حجوزات مجانية. اشترك الآن لاستقبال حجوزات جديدة بلا حدود، ويمكنك إكمال الحجوزات القديمة.';
    }

    return 'أضفت 5 خدمات مجانية. اشترك الآن لإضافة عدد غير محدود من الخدمات.';
  }

  String get subscriptionWarningButtonText {
    if (subscriptionStatus == 'pending') {
      return 'عرض حالة الاشتراك';
    }

    if (isSubscriptionExpired) {
      return 'تجديد الاشتراك';
    }

    return 'الاشتراك الآن';
  }

  Map<String, dynamic> _getSubscriptionData(Map<String, dynamic> userData) {
    final dynamic rawSubscription = userData['subscription'];

    if (rawSubscription is Map) {
      return Map<String, dynamic>.from(rawSubscription);
    }

    return {};
  }

  DateTime? _getSubscriptionDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  bool _isSubscriptionExpiredFromData(Map<String, dynamic> userData) {
    final subscription = _getSubscriptionData(userData);
    final status = subscription['status']?.toString() ?? 'not_submitted';

    if (status == 'expired') {
      return true;
    }

    final bool hasActiveFlag = userData['isSubscribed'] == true ||
        subscription['isActive'] == true ||
        status == 'active' ||
        status == 'approved';

    if (!hasActiveFlag) {
      return false;
    }

    final endDate = _getSubscriptionDate(
      subscription['endDate'] ??
          subscription['endAt'] ??
          subscription['expiresAt'],
    );

    if (endDate == null) {
      return false;
    }

    return !endDate.isAfter(DateTime.now());
  }

  bool _hasActiveSubscription(Map<String, dynamic> userData) {
    if (_isSubscriptionExpiredFromData(userData)) {
      return false;
    }

    final subscription = _getSubscriptionData(userData);
    final status = subscription['status']?.toString() ?? 'not_submitted';

    return userData['isSubscribed'] == true ||
        subscription['isActive'] == true ||
        status == 'active' ||
        status == 'approved';
  }

  void _setSubscriptionInfo(Map<String, dynamic> userData) {
    final subscription = _getSubscriptionData(userData);

    final String storedStatus =
        subscription['status']?.toString() ?? 'not_submitted';
    final String requestId = subscription['requestId']?.toString() ?? '';

    subscriptionStatus = storedStatus == 'pending' && requestId.isEmpty
        ? 'not_submitted'
        : storedStatus;
    subscriptionEndDate = _getSubscriptionDate(
      subscription['endDate'] ??
          subscription['endAt'] ??
          subscription['expiresAt'],
    );
    isSubscriptionActive = _hasActiveSubscription(userData);

    if (_isSubscriptionExpiredFromData(userData)) {
      subscriptionStatus = 'expired';
      isSubscriptionActive = false;
    }

    final String uid = userData['uid']?.toString() ??
        CacheHelper.getData(key: 'uid')?.toString() ??
        '';

    _scheduleSubscriptionExpiry(uid);
  }

  void _listenToSubscriptionChanges(String uid) {
    if (uid.isEmpty || _listenedWorkerId == uid) {
      return;
    }

    _workerSubscriptionListener?.cancel();
    _listenedWorkerId = uid;

    _workerSubscriptionListener = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
      (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return;
        }

        _setSubscriptionInfo(snapshot.data()!);

        if (!isClosed && isWorkerDataLoaded) {
          emit(GetWorkerDataSuccessState());
        }
      },
      onError: (error) {
        print('خطأ أثناء متابعة حالة الاشتراك: $error');
      },
    );
  }

  void _scheduleSubscriptionExpiry(String uid) {
    _subscriptionExpiryTimer?.cancel();

    if (uid.isEmpty || !isSubscriptionActive || subscriptionEndDate == null) {
      return;
    }

    final Duration remaining = subscriptionEndDate!.difference(DateTime.now());

    if (remaining <= Duration.zero) {
      Future.microtask(() async {
        try {
          await _markSubscriptionAsExpired(uid);
          emit(GetWorkerDataSuccessState());
        } catch (error) {
          print('خطأ أثناء إيقاف الاشتراك المنتهي: $error');
        }
      });
      return;
    }

    _subscriptionExpiryTimer = Timer(remaining, () async {
      try {
        await _markSubscriptionAsExpired(uid);
        emit(GetWorkerDataSuccessState());
      } catch (error) {
        print('خطأ أثناء إيقاف الاشتراك المنتهي: $error');
      }
    });
  }

  Future<void> _markSubscriptionAsExpired(String uid) async {
    _subscriptionExpiryTimer?.cancel();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isSubscribed': false,
      'subscription.isActive': false,
      'subscription.status': 'expired',
      'subscription.expiredAt': FieldValue.serverTimestamp(),
    });

    isSubscriptionActive = false;
    subscriptionStatus = 'expired';
  }

  Map<String, dynamic> allUsers = {};

  Future<void> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    allUsers = {};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }
  }

  bool amAvailable = true;

  Future<void> changeAvailability(bool value) async {
    try {
      amAvailable = value;
      emit(ChangeAvailabilityState());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'uid'))
          .update({
        'isAvailable': value,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> changeServiceActivity({
    required bool value,
    required String serviceId,
  }) async {
    try {
      final index = workerServices.indexWhere(
        (service) => service['id'] == serviceId,
      );

      if (index != -1) {
        workerServices[index]['isActive'] = value;
        emit(ChangeServiceActivitySuccessState());
      }

      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .update({
        'isActive': value,
      });
    } catch (e) {
      emit(ChangeServiceActivityErrorState(error: e.toString()));
    }
  }

  String? workerName;
  String? workerDept;
  int? workerRequestsCount;
  int? workerServicesCount;
  int? workerCompletedRequestsCount;
  double? workerRating;

  List<Map<String, dynamic>> workerServices = [];
  List<Map<String, dynamic>> workerRequests = [];

  bool isWorkerDataLoaded = false;
  bool isWorkerRequestsLoaded = false;
  bool isWorkerServicesLoaded = false;

  Future<void> getWorkerData({bool forceRefresh = false}) async {
    final uid = CacheHelper.getData(key: 'uid');

    if (uid == null || uid.toString().isEmpty) {
      emit(GetWorkerDataErrorState(error: 'لم يتم العثور على معرف المستخدم'));
      return;
    }

    _listenToSubscriptionChanges(uid.toString());

    if (isWorkerDataLoaded && !forceRefresh) {
      if (isSubscriptionActive &&
          subscriptionEndDate != null &&
          !subscriptionEndDate!.isAfter(DateTime.now())) {
        await _markSubscriptionAsExpired(uid.toString());
        emit(GetWorkerDataSuccessState());
      }
      return;
    }

    emit(GetWorkerDataLoadingState());

    try {
      workerName = '';
      workerDept = '';
      workerRequestsCount = 0;
      workerServicesCount = 0;
      workerCompletedRequestsCount = 0;
      workerRating = 0.0;

      final userFuture = FirebaseFirestore.instance.collection('users').doc(uid).get();

      final completedRequestsCountFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .where('status', isEqualTo: 'مكتمل')
          .count()
          .get();

      final requestsCountFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .count()
          .get();

      final servicesFuture = FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      await Future.wait([
        userFuture,
        completedRequestsCountFuture,
        requestsCountFuture,
        servicesFuture,
      ]);

      final userSnapshot = await userFuture;
      final completedRequestSnapshot = await completedRequestsCountFuture;
      final requestSnapshot = await requestsCountFuture;
      final getServicesSnapshot = await servicesFuture;

      if (!userSnapshot.exists || userSnapshot.data() == null) {
        emit(GetWorkerDataErrorState(error: 'بيانات الفني غير موجودة'));
        return;
      }

      final userData = userSnapshot.data()!;

      if (_isSubscriptionExpiredFromData(userData)) {
        final currentStatus =
            _getSubscriptionData(userData)['status']?.toString() ?? '';

        if (currentStatus != 'expired') {
          await _markSubscriptionAsExpired(uid.toString());
        } else {
          _setSubscriptionInfo(userData);
        }
      } else {
        _setSubscriptionInfo(userData);
      }

      workerName = userData['name'] ?? '';
      workerDept = userData['specialization'] ?? '';
      workerRequestsCount = requestSnapshot.count ?? 0;
      workerCompletedRequestsCount = completedRequestSnapshot.count ?? 0;
      workerRating = (userData['avgRating'] ?? 0.0).toDouble();

      workerServices = [];
      for (var doc in getServicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerServices.add(data);
      }

      workerServicesCount = workerServices.length;

      isWorkerDataLoaded = true;

      emit(GetWorkerDataSuccessState());
    } catch (e) {
      emit(GetWorkerDataErrorState(error: e.toString()));
    }
  }

  Future<void> getWorkerServices({bool forceRefresh = false}) async {
    final uid = CacheHelper.getData(key: 'uid');
    if (uid == null) {
      print("لا يوجد مستخدم، تم إلغاء جلب البيانات");
      return;
    }
    if (isWorkerServicesLoaded && !forceRefresh) {
      return;
    }

    workerServices = [];

    emit(GetWorkerServicesLoadingState());
    try {
      final userFuture =
          FirebaseFirestore.instance.collection('users').doc(uid).get();

      final servicesFuture = FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      await Future.wait([
        userFuture,
        servicesFuture,
      ]);

      final userSnapshot = await userFuture;
      final servicesSnapshot = await servicesFuture;

      if (userSnapshot.exists && userSnapshot.data() != null) {
        final userData = userSnapshot.data()!;

        if (_isSubscriptionExpiredFromData(userData)) {
          final currentStatus =
              _getSubscriptionData(userData)['status']?.toString() ?? '';

          if (currentStatus != 'expired') {
            await _markSubscriptionAsExpired(uid.toString());
          } else {
            _setSubscriptionInfo(userData);
          }
        } else {
          _setSubscriptionInfo(userData);
        }
      }

      for (var doc in servicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerServices.add(data);
      }

      workerServicesCount = workerServices.length;
      isWorkerServicesLoaded = true;

      emit(GetWorkerServicesSuccessState());
    } catch (e) {
      emit(GetWorkerServicesErrorState(error: e.toString()));
    }
  }

  Future<void> getWorkerRequests({bool forceRefresh = false}) async {
    final uid = CacheHelper.getData(key: 'uid');
    if (uid == null) {
      emit(GetWorkerRequestsErrorState(
          error: 'لا يوجد مستخدم، تم إلغاء جلب البيانات'));
      return;
    }
    if (isWorkerRequestsLoaded && !forceRefresh) {
      return;
    }

    emit(GetWorkerRequestsLoadingState());

    try {
      workerRequests = [];
      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .get();

      workerRequests = [];
      for (var doc in requestsSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerRequests.add(data);
      }
      isWorkerRequestsLoaded = true;

      emit(GetWorkerRequestsSuccessState());
    } catch (e) {
      emit(GetWorkerRequestsErrorState(error: e.toString()));
    }
  }

  TextEditingController serviceName = TextEditingController();

  TextEditingController servicePrice = TextEditingController();

  TextEditingController serviceDuration = TextEditingController();

  TextEditingController serviceDesc = TextEditingController();

  Future<String> uploadImageToCloudinary(String imagePath) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
      'upload_preset': 'unsiged_upload',
    });

    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
      data: formData,
    );

    return response.data['secure_url'];
  }

  Future<List<String>> uploadImagesToCloudinary(List<String> imagePaths) async {
    List<String> uploadedUrls = [];

    for (String path in imagePaths) {
      final url = await uploadImageToCloudinary(path);
      uploadedUrls.add(url);
    }

    return uploadedUrls;
  }

  String getCategoryFromSpecialization(String specialization) {
    switch (specialization.trim()) {
      case 'كهربائي':
        return 'الكهرباء';

      case 'سباك':
        return 'السباكة';

      case 'فني تكييف':
      case 'تكييف':
        return 'التكييف';

      case 'بناء':
      case 'بنّاء':
        return 'البناء';

      case 'حداد':
        return 'الحدادة';

      case 'نجار':
        return 'النجارة';

      case 'دهان':
        return 'الدهان';

      case 'فني مياه':
      case 'مياه':
        return 'الماء';

      default:
        return specialization;
    }
  }

  Future<void> uploadService({
    required String serviceName,
    required String serviceDescription,
    required String servicePrice,
    required String servicePeriod,
    required String serviceImage,
  }) async {
    try {
      String serviceImageLink = '';
      emit(UploadServiceLoadingState());
      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(UploadServiceErrorState(error: 'لم يتم العثور على معرف الفني'));
        return;
      }

      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userSnapshot.exists || userSnapshot.data() == null) {
        emit(UploadServiceErrorState(error: 'بيانات الفني غير موجودة'));
        return;
      }

      final userData = userSnapshot.data()!;

      if (_isSubscriptionExpiredFromData(userData)) {
        final currentStatus =
            _getSubscriptionData(userData)['status']?.toString() ?? '';

        if (currentStatus != 'expired') {
          await _markSubscriptionAsExpired(uid.toString());
        } else {
          _setSubscriptionInfo(userData);
        }

        emit(UploadServiceErrorState(
          error: 'انتهت مدة اشتراكك. يرجى تجديد الاشتراك لإضافة خدمات جديدة.',
        ));
        return;
      }

      final bool hasActiveSubscription = _hasActiveSubscription(userData);
      _setSubscriptionInfo(userData);

      final servicesCountSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .count()
          .get();

      final int currentServicesCount = servicesCountSnapshot.count ?? 0;
      workerServicesCount = currentServicesCount;

      if (!hasActiveSubscription && currentServicesCount >= freeServicesLimit) {
        emit(UploadServiceErrorState(
          error:
              'لقد وصلت إلى الحد المجاني المسموح وهو 5 خدمات. اشترك الآن لإضافة خدمات غير محدودة.',
        ));
        return;
      }

      final specialization = userData['specialization'] ?? '';
      final serviceCategory = getCategoryFromSpecialization(specialization);

      if (serviceImage.trim().isNotEmpty) {
        serviceImageLink = await uploadImageToCloudinary(serviceImage);
      }

      final price = int.tryParse(servicePrice.trim());

      if (price == null) {
        emit(UploadServiceErrorState(error: 'السعر غير صحيح'));
        return;
      }

      Map<String, dynamic> serviceData = {
        'name': serviceName.trim(),
        'description': serviceDescription.trim(),
        'category': serviceCategory,
        'price': price,
        'period': servicePeriod.trim(),
        'serviceImage': serviceImageLink,
        'providerId': uid,
        'isActive': true,
        'rate': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'reviews': [],
      };

      final docRef = await FirebaseFirestore.instance
          .collection('services')
          .add(serviceData);
      serviceData['id'] = docRef.id;

      workerServices.add(serviceData);
      workerServicesCount = currentServicesCount + 1;

      isWorkerServicesLoaded = true;

      emit(UploadServiceSuccessState());
    } catch (e) {
      emit(UploadServiceErrorState(error: e.toString()));
    }
  }

  Future<void> editService({
    required String serviceId,
    required String serviceName,
    required String serviceDescription,
    required String servicePrice,
    required String servicePeriod,
    String? newServiceImagePath,
    required String oldServiceImageUrl,
  }) async {
    emit(EditServiceLoadingState());

    try {
      String finalServiceImage = oldServiceImageUrl;

      if (newServiceImagePath != null &&
          newServiceImagePath.trim().isNotEmpty) {
        finalServiceImage = await uploadImageToCloudinary(newServiceImagePath);
      }

      final price = int.tryParse(servicePrice.trim());

      if (price == null) {
        emit(EditServiceErrorState(error: 'السعر غير صحيح'));
        return;
      }

      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .update({
        'name': serviceName.trim(),
        'description': serviceDescription.trim(),
        'price': price,
        'period': servicePeriod.trim(),
        'serviceImage': finalServiceImage,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final index = workerServices.indexWhere(
        (service) => service['id'] == serviceId,
      );

      if (index != -1) {
        workerServices[index]['name'] = serviceName.trim();
        workerServices[index]['description'] = serviceDescription.trim();
        workerServices[index]['price'] = price;
        workerServices[index]['period'] = servicePeriod.trim();
        workerServices[index]['serviceImage'] = finalServiceImage;
      }

      emit(EditServiceSuccessState());
    } catch (e) {
      emit(EditServiceErrorState(error: e.toString()));
    }
  }

  Future<void> deleteService({
    required String serviceId,
  }) async {
    emit(DeleteServiceLoadingState());

    try {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .delete();

      workerServices.removeWhere(
        (service) => service['id'] == serviceId,
      );
      workerServicesCount = workerServices.length;

      emit(DeleteServiceSuccessState());
    } catch (e) {
      emit(DeleteServiceErrorState(error: e.toString()));
    }
  }

  Future<void> editWorkerData({
    required String name,
    required String about,
    required List<String> experiences,
    String? address,
    String? specialization,
    String? profileImagePath,
    String? oldProfileImage,
    required List<String> previousWorks,
  }) async {
    emit(EditWorkerDataLoadingState());

    try {
      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(EditWorkerDataErrorState(
          error: 'تعذر العثور على معرف المستخدم',
        ));
        return;
      }

      String finalProfileImage = oldProfileImage ?? '';

      if (profileImagePath != null && profileImagePath.trim().isNotEmpty) {
        finalProfileImage = await uploadImageToCloudinary(profileImagePath);
      }

      List<String> oldImages =
          previousWorks.where((image) => image.startsWith('http')).toList();

      List<String> newImages =
          previousWorks.where((image) => !image.startsWith('http')).toList();

      List<String> uploadedNewImages = await Future.wait(
        newImages.map((imagePath) => uploadImageToCloudinary(imagePath)),
      );

      List<String> finalPreviousWorks = [
        ...oldImages,
        ...uploadedNewImages,
      ];

      List<String> finalExperiences =
          experiences.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final Map<String, dynamic> updatedData = {
        'name': name.trim(),
        'about': about.trim(),
        'experiences': finalExperiences,
        'previousWorks': finalPreviousWorks,
        'profileImage': finalProfileImage,
      };

      if (address != null) {
        updatedData['address'] = address.trim();
      }

      if (specialization != null) {
        updatedData['specialization'] = specialization.trim();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updatedData);

      workerName = name.trim();

      isWorkerDataLoaded = false;
      emit(EditWorkerDataSuccessState());
    } catch (e) {
      emit(EditWorkerDataErrorState(error: e.toString()));
    }
  }

  String getStatusNotificationTitle(String status) {
    if (status == 'مقبول') {
      return 'تم قبول الحجز';
    } else if (status == 'في الطريق') {
      return 'الفني في الطريق';
    } else if (status == 'مكتمل') {
      return 'تم إكمال الحجز';
    } else if (status == 'مرفوض') {
      return 'تم رفض الحجز';
    } else if (status == 'ملغي') {
      return 'تم إلغاء الحجز';
    } else {
      return 'تحديث حالة الحجز';
    }
  }

  String getStatusNotificationBody({
    required String status,
    required String requestTitle,
  }) {
    if (status == 'مقبول') {
      return 'تم قبول حجزك: $requestTitle';
    } else if (status == 'في الطريق') {
      return 'الفني في الطريق لتنفيذ حجزك: $requestTitle';
    } else if (status == 'مكتمل') {
      return 'تم إكمال حجزك: $requestTitle';
    } else if (status == 'مرفوض') {
      return 'تم رفض حجزك: $requestTitle';
    } else if (status == 'ملغي') {
      return 'تم إلغاء حجزك: $requestTitle';
    } else {
      return 'تم تحديث حالة حجزك: $requestTitle';
    }
  }

  Future<void> _handleCompletedRequestLimit({
    required String providerId,
    required String requestId,
  }) async {
    if (providerId.isEmpty) return;

    try {
      final completedCountSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: providerId)
          .where('status', isEqualTo: 'مكتمل')
          .count()
          .get();

      final int completedCount = completedCountSnapshot.count ?? 0;
      workerCompletedRequestsCount = completedCount;

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);
      final providerDoc = await providerRef.get();

      if (!providerDoc.exists || providerDoc.data() == null) return;

      final providerData = providerDoc.data()!;

      await providerRef.update({
        'completedJobs': completedCount,
      });

      _setSubscriptionInfo(providerData);

      if (_hasActiveSubscription(providerData) ||
          _isSubscriptionExpiredFromData(providerData) ||
          completedCount != freeCompletedRequestsLimit) {
        return;
      }

      const String title = 'اكتملت حجوزاتك المجانية';
      const String body =
          'لقد أكملت 5 حجوزات مجانية. اشترك الآن لاستقبال حجوزات جديدة بلا حدود.';

      final String receiverToken = providerData['token']?.toString() ?? '';

      if (receiverToken.isNotEmpty) {
        await NotificationService.sendNotification(
          receiverToken: receiverToken,
          title: title,
          body: body,
          type: 'subscription_limit',
          relatedId: requestId,
          senderId: 'system',
        );
      }

      await NotificationService.createNotificationInFirestore(
        receiverId: providerId,
        receiverType: 'worker',
        senderId: 'system',
        title: title,
        body: body,
        type: 'subscription_limit',
        relatedId: requestId,
      );
    } catch (error) {
      print('خطأ أثناء فحص حد الحجوزات المجانية: $error');
    }
  }

  Future<void> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      emit(UpdateRequestStatusLoadingState());

      String? timeField;

      if (status == 'مقبول') {
        timeField = 'acceptedAt';
      } else if (status == 'في الطريق') {
        timeField = 'onWayAt';
      } else if (status == 'مكتمل') {
        timeField = 'completedAt';
      } else if (status == 'مرفوض') {
        timeField = 'rejectedAt';
      } else if (status == 'ملغي') {
        timeField = 'cancelledAt';
      }

      final requestRef =
          FirebaseFirestore.instance.collection('requests').doc(requestId);

      final requestSnapshot = await requestRef.get();

      if (!requestSnapshot.exists || requestSnapshot.data() == null) {
        emit(UpdateRequestStatusErrorState(error: 'الحجز غير موجود'));
        return;
      }

      final oldRequestData = requestSnapshot.data()!;
      final oldStatus = oldRequestData['status']?.toString() ?? '';

      final customerId = oldRequestData['customerId']?.toString() ?? '';
      final providerId = oldRequestData['providerId']?.toString() ?? '';
      final requestTitle = oldRequestData['title']?.toString() ?? 'حجز خدمة';

      final Map<String, dynamic> requestData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (timeField != null) {
        requestData['statusHistory.$timeField'] = FieldValue.serverTimestamp();
      }

      final bool isChatClosed = status == 'مكتمل' || status == 'قيد الانتظار';

      final chatsSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('requestId', isEqualTo: requestId)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      batch.update(requestRef, requestData);

      batch.set(
        requestRef.collection('statusHistory').doc(),
        {
          'status': status,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      for (final chatDoc in chatsSnapshot.docs) {
        batch.update(chatDoc.reference, {
          'requestStatus': status,
          'isChatClosed': isChatClosed,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (status == 'مكتمل' && oldStatus != 'مكتمل') {
        await _handleCompletedRequestLimit(
          providerId: providerId,
          requestId: requestId,
        );
      }

      emit(UpdateRequestStatusSuccessState());

      if (customerId.isNotEmpty) {
        final notificationTitle = getStatusNotificationTitle(status);

        final notificationBody = getStatusNotificationBody(
          status: status,
          requestTitle: requestTitle,
        );

        Future.wait([
          NotificationService.createNotificationInFirestore(
            receiverId: customerId,
            receiverType: 'user',
            senderId: providerId,
            title: notificationTitle,
            body: notificationBody,
            type: 'booking_status',
            relatedId: requestId,
          ),
          FirebaseFirestore.instance
              .collection('users')
              .doc(customerId)
              .get()
              .then((customerDoc) async {
            final customerData = customerDoc.data() ?? {};
            final receiverToken = customerData['token']?.toString() ?? '';

            if (receiverToken.isEmpty) return;

            await NotificationService.sendNotification(
              receiverToken: receiverToken,
              title: notificationTitle,
              body: notificationBody,
              type: 'booking_status',
              relatedId: requestId,
              senderId: providerId,
            );
          }),
        ]).catchError((error) {
          print('خطأ أثناء إرسال أو حفظ إشعار تحديث الحجز: $error');
        });
      }
    } catch (error) {
      emit(UpdateRequestStatusErrorState(error: error.toString()));
    }
  }

  Future<void> createOrGetChat({
    required String customerId,
    required String providerId,
    required String requestTitle,
    required String requestId,
    required String requestStatus,
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> providerData,
  }) async {
    try {
      emit(CreateOrGetChatLoadingState());

      final String chatId = '${customerId}_${providerId}_$requestId';

      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          'chatId': chatId,
          'requestId': requestId,
          'requestStatus': requestStatus,
          'requestTitle': requestTitle,
          'users': [
            customerId,
            providerId,
          ],
          'userInfo': {
            customerId: {
              'name': customerData['name'] ?? 'مستخدم',
              'image': customerData['profileImage'] ?? '',
            },
            providerId: {
              'name': providerData['name'] ?? 'فني',
              'image': providerData['profileImage'] ?? '',
            },
          },
          'lastMessage': '',
          'lastMessageType': 'text',
          'lastSenderId': '',
          'lastUpdate': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'typingStatus': {
            customerId: false,
            providerId: false,
          },
          'unreadCount': {
            customerId: 0,
            providerId: 0,
          },
        });
      }

      emit(CreateOrGetChatSuccessState(chatId: chatId));
    } catch (error) {
      emit(CreateOrGetChatErrorState(error: error.toString()));
    }
  }

  Future<void> sendSubscriptionRequest({
    required File transferImage,
    required Map<String, dynamic> plan,
    required Map<String, dynamic> paymentMethod,
  }) async {
    try {
      emit(SendSubscriptionRequestLoadingState());

      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(SendSubscriptionRequestErrorState(
          error: 'لم يتم العثور على معرف الفني',
        ));
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists || userDoc.data() == null) {
        emit(SendSubscriptionRequestErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final userData = userDoc.data()!;
      final subscription = _getSubscriptionData(userData);
      final currentStatus =
          subscription['status']?.toString() ?? 'not_submitted';

      final String currentRequestId =
          subscription['requestId']?.toString() ?? '';

      if (currentStatus == 'pending' && currentRequestId.isNotEmpty) {
        emit(SendSubscriptionRequestErrorState(
          error: 'لديك طلب اشتراك قيد المراجعة بالفعل',
        ));
        return;
      }

      if (_hasActiveSubscription(userData)) {
        emit(SendSubscriptionRequestErrorState(
          error: 'لديك اشتراك نشط بالفعل',
        ));
        return;
      }

      if (_isSubscriptionExpiredFromData(userData) &&
          currentStatus != 'expired') {
        await _markSubscriptionAsExpired(uid.toString());
      }

      final String transferImageUrl =
          await uploadImageToCloudinary(transferImage.path);

      final requestRef =
          FirebaseFirestore.instance.collection('subscriptionRequests').doc();

      final int price = int.tryParse(plan['price'].toString()) ?? 0;
      final int durationMonths =
          int.tryParse(plan['durationMonths'].toString()) ?? 1;

      final requestData = <String, dynamic>{
        'requestId': requestRef.id,
        'providerId': uid,
        'providerName': userData['name'] ?? '',
        'providerPhone': userData['phone'] ?? '',
        'providerImage': userData['profileImage'] ?? '',
        'planId': plan['id'] ?? '',
        'packageName': plan['title'] ?? '',
        'period': plan['period'] ?? '',
        'durationMonths': durationMonths,
        'price': price,
        'paymentMethodId': paymentMethod['id'] ?? '',
        'paymentMethodTitle': paymentMethod['title'] ?? '',
        'transferImage': transferImageUrl,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      final batch = FirebaseFirestore.instance.batch();

      batch.set(requestRef, requestData);

      batch.update(userRef, {
        'isSubscribed': false,
        'subscription': {
          'isActive': false,
          'status': 'pending',
          'requestId': requestRef.id,
          'planId': plan['id'] ?? '',
          'packageName': plan['title'] ?? '',
          'period': plan['period'] ?? '',
          'durationMonths': durationMonths,
          'price': price,
          'paymentMethodId': paymentMethod['id'] ?? '',
          'paymentMethodTitle': paymentMethod['title'] ?? '',
          'transferImage': transferImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
          'startDate': null,
          'endDate': null,
          'rejectionReason': null,
        },
      });

      await batch.commit();

      isSubscriptionActive = false;
      subscriptionStatus = 'pending';
      subscriptionEndDate = null;

      emit(SendSubscriptionRequestSuccessState());
    } catch (error) {
      emit(SendSubscriptionRequestErrorState(error: error.toString()));
    }
  }

  Future<void> sendVerificationRequest({
    required String documentType,
    required File frontImage,
    required File backImage,
    required File personalImage,
  }) async {
    try {
      emit(SendVerificationRequestLoadingState());

      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(SendVerificationRequestErrorState(
          error: 'لم يتم العثور على معرف الفني',
        ));
        return;
      }

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        emit(SendVerificationRequestErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final userData = userDoc.data()!;

      final Map<String, dynamic> verificationData =
          userData['verification'] is Map
              ? Map<String, dynamic>.from(userData['verification'])
              : {};

      final String currentVerificationStatus =
          verificationData['status']?.toString() ??
              userData['verificationStatus']?.toString() ??
              'not_submitted';

      if (currentVerificationStatus == 'pending') {
        emit(SendVerificationRequestErrorState(
          error: 'لديك طلب توثيق قيد المراجعة بالفعل',
        ));
        return;
      }

      if (currentVerificationStatus == 'approved' ||
          userData['isVerified'] == true) {
        emit(SendVerificationRequestErrorState(
          error: 'حسابك موثق بالفعل',
        ));
        return;
      }

      final uploadedImages = await Future.wait([
        uploadImageToCloudinary(frontImage.path),
        uploadImageToCloudinary(backImage.path),
        uploadImageToCloudinary(personalImage.path),
      ]);

      final frontImageUrl = uploadedImages[0];
      final backImageUrl = uploadedImages[1];
      final personalImageUrl = uploadedImages[2];

      final requestRef = FirebaseFirestore.instance
          .collection('profile_verification_requests')
          .doc();

      final requestData = <String, dynamic>{
        'requestId': requestRef.id,
        'providerId': uid,
        'providerName': userData['name'] ?? '',
        'providerPhone': userData['phone'] ?? '',
        'providerImage': userData['profileImage'] ?? '',
        'documentType': documentType,
        'frontDocumentImage': frontImageUrl,
        'backDocumentImage': backImageUrl,
        'personalImage': personalImageUrl,
        'status': 'pending',
        'rejectionReason': null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final batch = FirebaseFirestore.instance.batch();

      batch.set(requestRef, requestData);

      batch.update(
        FirebaseFirestore.instance.collection('users').doc(uid),
        {
          'isVerified': false,
          'verificationStatus': 'pending',
          'verificationRequestId': requestRef.id,
          'verification': {
            'status': 'pending',
            'requestId': requestRef.id,
            'documentType': documentType,
            'createdAt': FieldValue.serverTimestamp(),
            'approvedAt': null,
            'rejectionReason': null,
          },
        },
      );

      await batch.commit();

      emit(SendVerificationRequestSuccessState());
    } catch (error) {
      emit(SendVerificationRequestErrorState(error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    _subscriptionExpiryTimer?.cancel();
    await _workerSubscriptionListener?.cancel();
    return super.close();
  }
}
