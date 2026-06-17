import 'dart:async';
import 'dart:io';
import 'package:Etkan/shared/networks/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_states.dart';
import '../../networks/local/sms_bridge.dart';
import '../../networks/remote/notification_service.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitState());

  static AdminCubit get(context) => BlocProvider.of(context);

  StreamSubscription? streamSubscription;
  String adminName = 'مشرف';

  void startListening() {
    streamSubscription = FirebaseFirestore.instance
        .collection('verification_requests')
        .where('status', isEqualTo: 'pending')
        .where('sentByAdmin', isEqualTo: false)
        .snapshots()
        .listen(
      (event) async {
        for (final doc in event.docs) {
          final data = doc.data();
          final phone = data['clientPhone'] ?? '';
          final code = data['code'] ?? '';

          if (phone.toString().isEmpty || code.toString().isEmpty) continue;

          final sent = await SmsBridge.sendSms(
            phone: phone,
            message: 'رمز التحقق الخاص بك في تطبيق إتقان هو: $code',
          );

          if (sent) {
            await doc.reference.update({
              'sentByAdmin': true,
              'sentAt': FieldValue.serverTimestamp(),
            });
          }
        }
      },
    );
  }

  void stopListening() {
    streamSubscription?.cancel();
  }

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> providers = [];
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> requests = [];
  List<Map<String, dynamic>> categories = [];

  bool isGetUsersLoading = false;
  bool isGetServicesLoading = false;
  bool isGetRequestsLoading = false;
  bool isGetProvidersLoading = false;
  bool isGetAdminDataLoading = false;
  bool isGetCategoriesLoading = false;

  StreamSubscription? verificationSubscription;
  List<Map<String, dynamic>> verificationRequests = [];

  StreamSubscription? subscriptionStream;
  List<Map<String, dynamic>> subscriptionRequests = [];

  Future<void> getUsers() async {
    try {
      users = [];
      isGetUsersLoading = true;
      emit(GetUsersLoadingState());
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      for (var doc in usersSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        users.add(data);
      }
      isGetUsersLoading = false;
      emit(GetUsersSuccessState());
    } catch (e) {
      isGetUsersLoading = false;
      emit(GetUsersErrorState(error: e.toString()));
    }
  }

  Future<void> getServices() async {
    try {
      services = [];
      isGetServicesLoading = true;
      emit(GetServicesLoadingState());

      final servicesSnapshot =
          await FirebaseFirestore.instance.collection('services').get();

      for (var doc in servicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        services.add(data);
      }

      isGetServicesLoading = false;
      emit(GetServicesSuccessState());
    } catch (e) {
      isGetServicesLoading = false;
      emit(GetServicesErrorState(error: e.toString()));
    }
  }

  Future<void> getRequests() async {
    try {
      requests = [];
      isGetRequestsLoading = true;
      emit(GetRequestsLoadingState());

      final requestsSnapshot =
          await FirebaseFirestore.instance.collection('requests').get();

      for (var doc in requestsSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        requests.add(data);
      }

      isGetRequestsLoading = false;
      emit(GetRequestsSuccessState());
    } catch (e) {
      isGetRequestsLoading = false;
      emit(GetRequestsErrorState(error: e.toString()));
    }
  }

  Future<void> getProviders() async {
    try {
      providers = [];
      isGetProvidersLoading = true;
      emit(GetProvidersLoadingState());

      final providersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'provider')
          .get();

      for (var doc in providersSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        providers.add(data);
      }

      isGetProvidersLoading = false;
      emit(GetProvidersSuccessState());
    } catch (e) {
      isGetProvidersLoading = false;
      emit(GetProvidersErrorState(error: e.toString()));
    }
  }

  Future<void> getAdminData() async {
    emit(GetAdminDataLoadingState());
    try {
      users = [];
      services = [];
      requests = [];
      providers = [];
      categories = [];
      isGetAdminDataLoading = true;
      await getCurrentAdminName();
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();
      final servicesSnapshot =
          await FirebaseFirestore.instance.collection('services').get();
      final requestsSnapshot =
          await FirebaseFirestore.instance.collection('requests').get();
      final providersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'provider')
          .get();
      final categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      await verificationSubscription?.cancel();
      FirebaseFirestore.instance
          .collection('profile_verification_requests')
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((event) {
        verificationRequests = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data();
          data['id'] = element.id;
          verificationRequests.add(data);
        }
        emit(GetAdminDataSuccessState());
      });

      await subscriptionStream?.cancel();

      subscriptionStream = FirebaseFirestore.instance
          .collection('subscriptionRequests')
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((event) {
        subscriptionRequests = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data();
          data['id'] = element.id;
          subscriptionRequests.add(data);
        }
        emit(GetAdminDataSuccessState());
      });

      for (var doc in usersSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        users.add(data);
      }
      for (var doc in servicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        services.add(data);
      }
      for (var doc in requestsSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        requests.add(data);
      }
      for (var doc in providersSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        providers.add(data);
      }
      for (var doc in categoriesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        categories.add(data);
      }
      isGetAdminDataLoading = false;

      emit(GetAdminDataSuccessState());
    } catch (e) {
      isGetAdminDataLoading = false;
      emit(GetAdminDataErrorState(error: e.toString()));
    }
  }

  Future<void> updateAccountStatus({
    required String userId,
    required bool isActive,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isActive': isActive,
      });
      emit(ChangeProviderActivity());
    } catch (e) {
      print('Error updating account status: $e');
    }
  }

  Future<void> updateServiceStatus({
    required String serviceId,
    required bool isActive,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .update({
        'isActive': isActive,
      });

      emit(ChangeServiceActivity());
    } catch (e) {
      print('Error updating service status: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      categories = [];
      isGetCategoriesLoading = true;
      emit(GetCategoryLoadingState());
      final categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      for (var doc in categoriesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        categories.add(data);
      }
      isGetCategoriesLoading = false;
      emit(GetCategorySuccessState());
    } catch (e) {
      isGetCategoriesLoading = false;
      emit(GetCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> createCategory({
    required String title,
    required File imageFile,
    required bool isActive,
  }) async {
    final dio = Dio();
    String? imageUrl;
    try {
      emit(AddCategoryLoadingState());
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg'),
        'upload_preset': 'unsiged_upload',
      });
      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
        data: formData,
      );
      imageUrl = response.data['secure_url'];

      await FirebaseFirestore.instance.collection('categories').add({
        'title': title,
        'image': imageUrl,
        'isActive': isActive,
      });

      emit(AddCategorySuccessState());
    } catch (e) {
      emit(AddCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> deleteCategory(String docId) async {
    try {
      emit(DeleteCategoryLoadingState());
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .delete();
      emit(DeleteCategorySuccessState());
    } catch (e) {
      emit(DeleteGetCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> editCategory({
    required String docId,
    required String title,
    required bool isActive,
    required File imageFile,
  }) async {
    final dio = Dio();
    String? imageUrl;

    try {
      emit(EditCategoryLoadingState());

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg'),
        'upload_preset': 'unsiged_upload',
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
        data: formData,
      );

      imageUrl = response.data['secure_url'];

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .update({'title': title, 'isActive': isActive, 'image': imageUrl});
      emit(EditCategorySuccessState());
    } catch (e) {
      emit(EditCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> editUser({
    required String docId,
    required bool isActive,
  }) async {
    try {
      emit(EditUserLoadingState());
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'isActive': isActive,
      });
      emit(EditUserSuccessState());
    } catch (e) {
      emit(EditUserErrorState(error: e.toString()));
    }
  }

  Map<String, dynamic>? providerSubscriptionRequest;
  Map<String, dynamic>? providerVerificationRequest;

  bool isGetProviderReviewRequestsLoading = false;

  int _getCreatedAtMilliseconds(Map<String, dynamic> data) {
    final dynamic createdAt = data['createdAt'];

    if (createdAt is Timestamp) {
      return createdAt.millisecondsSinceEpoch;
    }

    if (createdAt is DateTime) {
      return createdAt.millisecondsSinceEpoch;
    }

    if (createdAt is String) {
      return DateTime.tryParse(createdAt)?.millisecondsSinceEpoch ?? 0;
    }

    return 0;
  }

  Map<String, dynamic>? _getLatestRequest(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (snapshot.docs.isEmpty) return null;

    final List<Map<String, dynamic>> allRequests = snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      data['requestId'] = data['requestId'] ?? doc.id;
      return data;
    }).toList();

    final List<Map<String, dynamic>> pendingRequests = allRequests
        .where((request) => request['status']?.toString() == 'pending')
        .toList();

    final requestsToSort =
        pendingRequests.isNotEmpty ? pendingRequests : allRequests;

    requestsToSort.sort(
      (a, b) => _getCreatedAtMilliseconds(b).compareTo(
        _getCreatedAtMilliseconds(a),
      ),
    );

    return requestsToSort.first;
  }

  Future<void> _loadProviderReviewRequests({
    required String providerId,
  }) async {
    final subscriptionFuture = FirebaseFirestore.instance
        .collection('subscriptionRequests')
        .where('providerId', isEqualTo: providerId)
        .get();

    final verificationFuture = FirebaseFirestore.instance
        .collection('profile_verification_requests')
        .where('providerId', isEqualTo: providerId)
        .get();

    await Future.wait([
      subscriptionFuture,
      verificationFuture,
    ]);

    providerSubscriptionRequest = _getLatestRequest(await subscriptionFuture);
    providerVerificationRequest = _getLatestRequest(await verificationFuture);
  }

  Future<void> getProviderReviewRequests({
    required String providerId,
  }) async {
    try {
      isGetProviderReviewRequestsLoading = true;
      providerSubscriptionRequest = null;
      providerVerificationRequest = null;

      emit(GetProviderReviewRequestsLoadingState());

      await _loadProviderReviewRequests(providerId: providerId);

      isGetProviderReviewRequestsLoading = false;
      emit(GetProviderReviewRequestsSuccessState());
    } catch (error) {
      isGetProviderReviewRequestsLoading = false;
      emit(GetProviderReviewRequestsErrorState(error: error.toString()));
    }
  }

  DateTime _addMonthsClamped(DateTime date, int months) {
    final DateTime firstDayAfterTargetMonth =
        DateTime(date.year, date.month + months + 1, 1);

    final int lastDayOfTargetMonth =
        firstDayAfterTargetMonth.subtract(const Duration(days: 1)).day;

    final int targetDay =
        date.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : date.day;

    return DateTime(
      date.year,
      date.month + months,
      targetDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  void _updateProviderLocalData({
    required String providerId,
    required Map<String, dynamic> updatedData,
  }) {
    final int index = providers.indexWhere(
      (provider) =>
          provider['id']?.toString() == providerId ||
          provider['uid']?.toString() == providerId,
    );

    if (index == -1) return;

    providers[index] = {
      ...providers[index],
      ...updatedData,
    };
  }

  Future<void> _sendProviderNotification({
    required String providerId,
    required Map<String, dynamic> providerData,
    required String title,
    required String body,
    required String type,
    required String relatedId,
  }) async {
    try {
      final String receiverToken = providerData['token']?.toString() ?? '';

      if (receiverToken.isNotEmpty) {
        await NotificationService.sendNotification(
          receiverToken: receiverToken,
          title: title,
          body: body,
          type: type,
          relatedId: relatedId,
          senderId: 'admin',
        );
      }

      await NotificationService.createNotificationInFirestore(
        receiverId: providerId,
        receiverType: 'worker',
        senderId: 'admin',
        title: title,
        body: body,
        type: type,
        relatedId: relatedId,
      );
    } catch (error) {
      print('خطأ أثناء إرسال إشعار الإدارة للفني: $error');
    }
  }

  Future<void> approveSubscriptionRequest({
    required String requestId,
  }) async {
    try {
      emit(ApproveSubscriptionRequestLoadingState());

      final requestRef = FirebaseFirestore.instance
          .collection('subscriptionRequests')
          .doc(requestId);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists || requestDoc.data() == null) {
        emit(ApproveSubscriptionRequestErrorState(
          error: 'طلب الاشتراك غير موجود',
        ));
        return;
      }

      final requestData = requestDoc.data()!;

      if (requestData['status']?.toString() != 'pending') {
        emit(ApproveSubscriptionRequestErrorState(
          error: 'تمت مراجعة طلب الاشتراك مسبقاً',
        ));
        return;
      }

      final String providerId = requestData['providerId']?.toString() ?? '';

      if (providerId.isEmpty) {
        emit(ApproveSubscriptionRequestErrorState(
          error: 'معرف الفني غير موجود داخل طلب الاشتراك',
        ));
        return;
      }

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final providerDoc = await providerRef.get();

      if (!providerDoc.exists || providerDoc.data() == null) {
        emit(ApproveSubscriptionRequestErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final providerData = providerDoc.data()!;
      final int durationMonths =
          int.tryParse(requestData['durationMonths']?.toString() ?? '') ?? 1;

      final DateTime startDate = DateTime.now();
      final DateTime endDate = _addMonthsClamped(
        startDate,
        durationMonths < 1 ? 1 : durationMonths,
      );

      final Map<String, dynamic> subscriptionData = {
        'isActive': true,
        'status': 'active',
        'requestId': requestId,
        'planId': requestData['planId'] ?? '',
        'packageName': requestData['packageName'] ?? '',
        'period': requestData['period'] ?? '',
        'durationMonths': durationMonths,
        'price': requestData['price'] ?? 0,
        'paymentMethodId': requestData['paymentMethodId'] ?? '',
        'paymentMethodTitle': requestData['paymentMethodTitle'] ?? '',
        'transferImage': requestData['transferImage'] ?? '',
        'createdAt': requestData['createdAt'],
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'approvedAt': FieldValue.serverTimestamp(),
        'expiredAt': null,
        'rejectionReason': null,
      };

      final batch = FirebaseFirestore.instance.batch();

      batch.update(requestRef, {
        'status': 'approved',
        'reviewedAt': FieldValue.serverTimestamp(),
        'approvedAt': FieldValue.serverTimestamp(),
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'rejectionReason': null,
      });

      batch.update(providerRef, {
        'isSubscribed': true,
        'subscription': subscriptionData,
      });

      await batch.commit();

      _updateProviderLocalData(
        providerId: providerId,
        updatedData: {
          'isSubscribed': true,
          'subscription': subscriptionData,
        },
      );

      await _loadProviderReviewRequests(providerId: providerId);

      await _sendProviderNotification(
        providerId: providerId,
        providerData: providerData,
        title: 'تم تفعيل اشتراكك',
        body:
            'تم قبول طلب اشتراكك في ${requestData['packageName'] ?? 'الباقة المختارة'} ويمكنك الآن إضافة خدمات واستقبال حجوزات بلا حدود.',
        type: 'subscription_status',
        relatedId: requestId,
      );

      emit(ApproveSubscriptionRequestSuccessState());
    } catch (error) {
      emit(ApproveSubscriptionRequestErrorState(error: error.toString()));
    }
  }

  Future<void> rejectSubscriptionRequest({
    required String requestId,
    required String reason,
  }) async {
    try {
      if (reason.trim().isEmpty) {
        emit(RejectSubscriptionRequestErrorState(
          error: 'يرجى كتابة سبب رفض طلب الاشتراك',
        ));
        return;
      }

      emit(RejectSubscriptionRequestLoadingState());

      final requestRef = FirebaseFirestore.instance
          .collection('subscriptionRequests')
          .doc(requestId);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists || requestDoc.data() == null) {
        emit(RejectSubscriptionRequestErrorState(
          error: 'طلب الاشتراك غير موجود',
        ));
        return;
      }

      final requestData = requestDoc.data()!;

      if (requestData['status']?.toString() != 'pending') {
        emit(RejectSubscriptionRequestErrorState(
          error: 'تمت مراجعة طلب الاشتراك مسبقاً',
        ));
        return;
      }

      final String providerId = requestData['providerId']?.toString() ?? '';

      if (providerId.isEmpty) {
        emit(RejectSubscriptionRequestErrorState(
          error: 'معرف الفني غير موجود داخل طلب الاشتراك',
        ));
        return;
      }

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final providerDoc = await providerRef.get();

      if (!providerDoc.exists || providerDoc.data() == null) {
        emit(RejectSubscriptionRequestErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final providerData = providerDoc.data()!;

      final Map<String, dynamic> subscriptionData = {
        'isActive': false,
        'status': 'rejected',
        'requestId': requestId,
        'planId': requestData['planId'] ?? '',
        'packageName': requestData['packageName'] ?? '',
        'period': requestData['period'] ?? '',
        'durationMonths': requestData['durationMonths'] ?? 1,
        'price': requestData['price'] ?? 0,
        'paymentMethodId': requestData['paymentMethodId'] ?? '',
        'paymentMethodTitle': requestData['paymentMethodTitle'] ?? '',
        'transferImage': requestData['transferImage'] ?? '',
        'createdAt': requestData['createdAt'],
        'startDate': null,
        'endDate': null,
        'approvedAt': null,
        'expiredAt': null,
        'rejectionReason': reason.trim(),
      };

      final batch = FirebaseFirestore.instance.batch();

      batch.update(requestRef, {
        'status': 'rejected',
        'reviewedAt': FieldValue.serverTimestamp(),
        'rejectedAt': FieldValue.serverTimestamp(),
        'rejectionReason': reason.trim(),
      });

      batch.update(providerRef, {
        'isSubscribed': false,
        'subscription': subscriptionData,
      });

      await batch.commit();

      _updateProviderLocalData(
        providerId: providerId,
        updatedData: {
          'isSubscribed': false,
          'subscription': subscriptionData,
        },
      );

      await _loadProviderReviewRequests(providerId: providerId);

      await _sendProviderNotification(
        providerId: providerId,
        providerData: providerData,
        title: 'تم رفض طلب الاشتراك',
        body: 'سبب الرفض: ${reason.trim()}',
        type: 'subscription_status',
        relatedId: requestId,
      );

      emit(RejectSubscriptionRequestSuccessState());
    } catch (error) {
      emit(RejectSubscriptionRequestErrorState(error: error.toString()));
    }
  }

  Future<void> stopProviderSubscription({
    required String providerId,
  }) async {
    try {
      emit(StopProviderSubscriptionLoadingState());

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final providerDoc = await providerRef.get();

      if (!providerDoc.exists || providerDoc.data() == null) {
        emit(StopProviderSubscriptionErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final providerData = providerDoc.data()!;
      final dynamic rawSubscription = providerData['subscription'];
      final Map<String, dynamic> subscriptionData = rawSubscription is Map
          ? Map<String, dynamic>.from(rawSubscription)
          : {};

      final String requestId =
          subscriptionData['requestId']?.toString() ?? providerId;

      subscriptionData['isActive'] = false;
      subscriptionData['status'] = 'expired';
      subscriptionData['expiredAt'] = FieldValue.serverTimestamp();

      await providerRef.update({
        'isSubscribed': false,
        'subscription': subscriptionData,
      });

      _updateProviderLocalData(
        providerId: providerId,
        updatedData: {
          'isSubscribed': false,
          'subscription': subscriptionData,
        },
      );

      await _sendProviderNotification(
        providerId: providerId,
        providerData: providerData,
        title: 'تم إيقاف اشتراكك',
        body:
            'تم إيقاف اشتراكك. يمكنك إكمال الحجوزات القديمة، ويلزم التجديد لاستقبال حجوزات جديدة.',
        type: 'subscription_status',
        relatedId: requestId,
      );

      emit(StopProviderSubscriptionSuccessState());
    } catch (error) {
      emit(StopProviderSubscriptionErrorState(error: error.toString()));
    }
  }

  Future<void> approveVerificationRequest({
    required String requestId,
  }) async {
    try {
      emit(ApproveVerificationRequestLoadingState());

      final requestRef = FirebaseFirestore.instance
          .collection('profile_verification_requests')
          .doc(requestId);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists || requestDoc.data() == null) {
        emit(ApproveVerificationRequestErrorState(
          error: 'طلب التوثيق غير موجود',
        ));
        return;
      }

      final requestData = requestDoc.data()!;

      if (requestData['status']?.toString() != 'pending') {
        emit(ApproveVerificationRequestErrorState(
          error: 'تمت مراجعة طلب التوثيق مسبقاً',
        ));
        return;
      }

      final String providerId = requestData['providerId']?.toString() ?? '';

      if (providerId.isEmpty) {
        emit(ApproveVerificationRequestErrorState(
          error: 'معرف الفني غير موجود داخل طلب التوثيق',
        ));
        return;
      }

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final providerDoc = await providerRef.get();

      if (!providerDoc.exists || providerDoc.data() == null) {
        emit(ApproveVerificationRequestErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final providerData = providerDoc.data()!;

      final Map<String, dynamic> verificationData = {
        'status': 'approved',
        'requestId': requestId,
        'documentType': requestData['documentType'] ?? '',
        'createdAt': requestData['createdAt'],
        'approvedAt': FieldValue.serverTimestamp(),
        'rejectionReason': null,
      };

      final batch = FirebaseFirestore.instance.batch();

      batch.update(requestRef, {
        'status': 'approved',
        'reviewedAt': FieldValue.serverTimestamp(),
        'approvedAt': FieldValue.serverTimestamp(),
        'rejectionReason': null,
      });

      batch.update(providerRef, {
        'isVerified': true,
        'verificationStatus': 'approved',
        'verificationRequestId': requestId,
        'verification': verificationData,
      });

      await batch.commit();

      _updateProviderLocalData(
        providerId: providerId,
        updatedData: {
          'isVerified': true,
          'verificationStatus': 'approved',
          'verificationRequestId': requestId,
          'verification': verificationData,
        },
      );

      await _loadProviderReviewRequests(providerId: providerId);

      await _sendProviderNotification(
        providerId: providerId,
        providerData: providerData,
        title: 'تم توثيق حسابك',
        body: 'تم قبول طلب توثيق حسابك، وستظهر علامة التوثيق للعملاء.',
        type: 'verification_status',
        relatedId: requestId,
      );

      emit(ApproveVerificationRequestSuccessState());
    } catch (error) {
      emit(ApproveVerificationRequestErrorState(error: error.toString()));
    }
  }

  Future<void> rejectVerificationRequest({
    required String requestId,
    required String reason,
  }) async {
    try {
      if (reason.trim().isEmpty) {
        emit(RejectVerificationRequestErrorState(
          error: 'يرجى كتابة سبب رفض طلب التوثيق',
        ));
        return;
      }

      emit(RejectVerificationRequestLoadingState());

      final requestRef = FirebaseFirestore.instance
          .collection('profile_verification_requests')
          .doc(requestId);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists || requestDoc.data() == null) {
        emit(RejectVerificationRequestErrorState(
          error: 'طلب التوثيق غير موجود',
        ));
        return;
      }

      final requestData = requestDoc.data()!;

      if (requestData['status']?.toString() != 'pending') {
        emit(RejectVerificationRequestErrorState(
          error: 'تمت مراجعة طلب التوثيق مسبقاً',
        ));
        return;
      }

      final String providerId = requestData['providerId']?.toString() ?? '';

      if (providerId.isEmpty) {
        emit(RejectVerificationRequestErrorState(
          error: 'معرف الفني غير موجود داخل طلب التوثيق',
        ));
        return;
      }

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final providerDoc = await providerRef.get();

      if (!providerDoc.exists || providerDoc.data() == null) {
        emit(RejectVerificationRequestErrorState(
          error: 'بيانات الفني غير موجودة',
        ));
        return;
      }

      final providerData = providerDoc.data()!;

      final Map<String, dynamic> verificationData = {
        'status': 'rejected',
        'requestId': requestId,
        'documentType': requestData['documentType'] ?? '',
        'createdAt': requestData['createdAt'],
        'approvedAt': null,
        'rejectionReason': reason.trim(),
      };

      final batch = FirebaseFirestore.instance.batch();

      batch.update(requestRef, {
        'status': 'rejected',
        'reviewedAt': FieldValue.serverTimestamp(),
        'rejectedAt': FieldValue.serverTimestamp(),
        'rejectionReason': reason.trim(),
      });

      batch.update(providerRef, {
        'isVerified': false,
        'verificationStatus': 'rejected',
        'verificationRequestId': requestId,
        'verification': verificationData,
      });

      await batch.commit();

      _updateProviderLocalData(
        providerId: providerId,
        updatedData: {
          'isVerified': false,
          'verificationStatus': 'rejected',
          'verificationRequestId': requestId,
          'verification': verificationData,
        },
      );

      await _loadProviderReviewRequests(providerId: providerId);

      await _sendProviderNotification(
        providerId: providerId,
        providerData: providerData,
        title: 'تم رفض طلب التوثيق',
        body: 'سبب الرفض: ${reason.trim()}',
        type: 'verification_status',
        relatedId: requestId,
      );

      emit(RejectVerificationRequestSuccessState());
    } catch (error) {
      emit(RejectVerificationRequestErrorState(error: error.toString()));
    }
  }

  Future<void> getCurrentAdminName() async {
    final uid = CacheHelper.getData(key: 'uid')?.toString();

    if (uid == null || uid.isEmpty) {
      adminName = 'مشرف';
      return;
    }

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final data = doc.data();
    final name = data?['name']?.toString().trim();

    adminName = name == null || name.isEmpty
        ? 'مشرف'
        : name.split(RegExp(r'\s+')).first;
  }


  Map<String, dynamic> allUsers = {};

  Future<void> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    allUsers = {};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }
  }
}
