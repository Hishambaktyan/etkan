import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';

import '../../networks/local/cache_helper.dart';
import '../../networks/remote/notification_service.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitState());

  static UserCubit get(context) => BlocProvider.of(context);

  static const int freeCompletedRequestsLimit = 5;

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

  bool _isSubscriptionExpired(Map<String, dynamic> userData) {
    final subscription = _getSubscriptionData(userData);
    final String status = subscription['status']?.toString() ?? 'not_submitted';

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

    final DateTime? endDate = _getSubscriptionDate(
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
    if (_isSubscriptionExpired(userData)) {
      return false;
    }

    final subscription = _getSubscriptionData(userData);
    final String status = subscription['status']?.toString() ?? 'not_submitted';

    return userData['isSubscribed'] == true ||
        subscription['isActive'] == true ||
        status == 'active' ||
        status == 'approved';
  }

  bool _hasVisibleActiveSubscription(Map<String, dynamic> userData) {
    if (_isSubscriptionExpired(userData)) {
      return false;
    }

    final subscription = _getSubscriptionData(userData);
    final String status = subscription['status']?.toString() ?? 'not_submitted';

    return userData['isSubscribed'] == true &&
        subscription['isActive'] == true &&
        (status == 'active' || status == 'approved');
  }

  Future<Set<String>> _getActiveProviderIds() async {
    final providersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'provider')
        .get();

    final Set<String> activeProviderIds = {};
    final batch = FirebaseFirestore.instance.batch();
    bool hasExpiredSubscriptions = false;

    for (final providerDoc in providersSnapshot.docs) {
      final providerData = providerDoc.data();
      final subscription = _getSubscriptionData(providerData);
      final String status =
          subscription['status']?.toString() ?? 'not_submitted';

      if (_isSubscriptionExpired(providerData)) {
        final bool needsExpirationUpdate =
            providerData['isSubscribed'] == true ||
                subscription['isActive'] == true ||
                status != 'expired';

        if (needsExpirationUpdate) {
          batch.update(providerDoc.reference, {
            'isSubscribed': false,
            'subscription.isActive': false,
            'subscription.status': 'expired',
            'subscription.expiredAt': FieldValue.serverTimestamp(),
          });

          hasExpiredSubscriptions = true;
        }

        continue;
      }

      if (_hasVisibleActiveSubscription(providerData)) {
        activeProviderIds.add(providerDoc.id);
      }
    }

    if (hasExpiredSubscriptions) {
      try {
        await batch.commit();
      } catch (error) {
        print('تعذر تحديث حالات الاشتراكات المنتهية: $error');
      }
    }

    return activeProviderIds;
  }

  bool _isServiceVisibleToCustomers(
    Map<String, dynamic> service,
    Set<String> activeProviderIds,
  ) {
    final String providerId = service['providerId']?.toString() ?? '';
    final bool isServiceActive = service['isActive'] != false;

    return isServiceActive &&
        providerId.isNotEmpty &&
        activeProviderIds.contains(providerId);
  }

  Map<String, dynamic> allUsers = {};
  bool isAllUsersLoaded = false;

  Future<void> getAllUsers({bool forceRefresh = false}) async {
    if (isAllUsersLoaded && !forceRefresh) {
      return;
    }
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    allUsers = {};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }
    isAllUsersLoaded = true;
  }

  Map<String, List<Map<String, dynamic>>> loadedUserSpecServices = {};

  List<Map<String, dynamic>> userSpecServices = [];

  String? currentUserSpecServicesType;

  Future<void> getUserSpecServices(String type,
      {bool forceRefresh = false}) async {
    try {
      final String categoryType = type.trim();
      currentUserSpecServicesType = categoryType;

      emit(GetUserSpecServicesLoadingState());

      final activeProviderIdsFuture = _getActiveProviderIds();

      final servicesFuture = FirebaseFirestore.instance
          .collection('services')
          .where('category', isEqualTo: categoryType)
          .get();

      await Future.wait([
        activeProviderIdsFuture,
        servicesFuture,
      ]);

      final activeProviderIds = await activeProviderIdsFuture;
      final getServicesSnapshot = await servicesFuture;

      final List<Map<String, dynamic>> services = [];

      for (var doc in getServicesSnapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        if (_isServiceVisibleToCustomers(data, activeProviderIds)) {
          services.add(data);
        }
      }

      loadedUserSpecServices[categoryType] = services;

      if (currentUserSpecServicesType == categoryType) {
        userSpecServices = services;
        emit(GetUserSpecServicesSuccessState());
      }
    } catch (e) {
      emit(GetUserSpecServicesErrorState(error: e.toString()));
    }
  }

  List<Map<String, dynamic>> userServices = [];
  bool isUserServicesLoaded = false;

  Future<void> getUserServices({bool forceRefresh = false}) async {
    try {
      emit(GetUserAllServicesLoadingState());

      userServices.clear();

      final activeProviderIdsFuture = _getActiveProviderIds();
      final servicesFuture =
          FirebaseFirestore.instance.collection('services').get();

      await Future.wait([
        activeProviderIdsFuture,
        servicesFuture,
      ]);

      final activeProviderIds = await activeProviderIdsFuture;
      final servicesSnapshot = await servicesFuture;

      for (var doc in servicesSnapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        if (_isServiceVisibleToCustomers(data, activeProviderIds)) {
          userServices.add(data);
        }
      }

      isUserServicesLoaded = true;

      emit(GetUserAllServicesSuccessState());
    } catch (e) {
      emit(GetUserAllServicesErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  List<Map<String, dynamic>> categories = [];
  bool isUserGetCategoriesLoaded = false;

  Future<void> getCategories({bool forceRefresh = false}) async {
    try {
      if (isUserGetCategoriesLoaded && !forceRefresh) {
        return;
      }
      emit(GetCategoryLoadingState());

      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      categories = [];
      for (var doc in categoriesSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        categories.add(data);
      }
      isUserGetCategoriesLoaded = true;

      emit(GetCategorySuccessState());
    } catch (e) {
      emit(GetCategoryErrorState(error: e.toString()));
    }
  }

  List<Map<String, dynamic>> userRequests = [];
  bool isUserRequestsLoaded = false;

  Future<void> getUserRequests({bool forceRefresh = false}) async {
    try {
      if (isUserRequestsLoaded && !forceRefresh) {
        return;
      }
      emit(GetUserRequestLoadingState());
      userRequests.clear();
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('customerId', isEqualTo: CacheHelper.getData(key: 'uid'))
          .get();

      for (var doc in requestSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        userRequests.add(data);
      }
      isUserRequestsLoaded = true;
      emit(GetUserRequestSuccessState());
    } catch (e) {
      emit(GetUserRequestErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  Future<void> createRequest({
    required String category,
    required String customerId,
    required String providerId,
    required String address,
    required String title,
    required String description,
    required String image,
    required String duration,
    required int price,
    required Timestamp scheduledAt,
  }) async {
    try {
      emit(CreateRequestLoadingState());

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final providerFuture = providerRef.get();
      final completedRequestsCountFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: providerId)
          .where('status', isEqualTo: 'مكتمل')
          .count()
          .get();

      await Future.wait([
        providerFuture,
        completedRequestsCountFuture,
      ]);

      final providerDoc = await providerFuture;
      final completedRequestsCountSnapshot = await completedRequestsCountFuture;

      if (!providerDoc.exists || providerDoc.data() == null) {
        emit(CreateRequestErrorState(
          error: 'تعذر العثور على بيانات الفني',
        ));
        return;
      }

      final providerData = providerDoc.data()!;

      if (_isSubscriptionExpired(providerData)) {
        final subscription = _getSubscriptionData(providerData);

        if (subscription['status']?.toString() != 'expired') {
          await providerRef.update({
            'isSubscribed': false,
            'subscription.isActive': false,
            'subscription.status': 'expired',
            'subscription.expiredAt': FieldValue.serverTimestamp(),
          });
        }

        emit(CreateRequestErrorState(
          error:
              'انتهى اشتراك هذا الفني، ولا يمكنه استقبال حجوزات جديدة حالياً.',
        ));
        return;
      }

      if (!_hasVisibleActiveSubscription(providerData)) {
        emit(CreateRequestErrorState(
          error:
              'اشتراك هذا الفني غير نشط، ولا يمكنه استقبال حجوزات جديدة حالياً.',
        ));
        return;
      }

      final int completedRequestsCount =
          completedRequestsCountSnapshot.count ?? 0;

      if (!_hasActiveSubscription(providerData) &&
          completedRequestsCount >= freeCompletedRequestsLimit) {
        emit(CreateRequestErrorState(
          error:
              'أكمل هذا الفني 5 حجوزات مجانية، ولا يمكنه استقبال حجوزات جديدة حتى يقوم بالاشتراك.',
        ));
        return;
      }

      final DateTime now = DateTime.now();
      final Timestamp nowTimestamp = Timestamp.fromDate(now);

      final requestRef =
          FirebaseFirestore.instance.collection('requests').doc();

      final Map<String, dynamic> requestData = {
        'requestId': requestRef.id,
        'id': requestRef.id,
        'address': address,
        'category': category,
        'customerId': customerId,
        'providerId': providerId,
        'title': title,
        'description': description,
        'image': image,
        'duration': duration,
        'price': price,
        'scheduledAt': scheduledAt,
        'status': 'قيد الانتظار',
        'createdAt': nowTimestamp,
        'updatedAt': nowTimestamp,
        'statusHistory': {
          'pendingAt': nowTimestamp,
          'acceptedAt': null,
          'rejectedAt': null,
          'completedAt': null,
          'cancelledAt': null,
        },
      };

      await requestRef.set(requestData);

      final receiverToken = providerData['token']?.toString() ?? '';

      if (receiverToken.isNotEmpty) {
        await NotificationService.sendNotification(
          receiverToken: receiverToken,
          title: 'حجز جديد',
          body: 'لديك حجز خدمة جديد: $title',
          type: 'new_booking',
          relatedId: requestRef.id,
          senderId: customerId,
        );
      }
      await NotificationService.createNotificationInFirestore(
        receiverId: providerId,
        receiverType: 'worker',
        senderId: customerId,
        title: 'حجز جديد',
        body: 'لديك حجز خدمة جديد: $title',
        type: 'new_booking',
        relatedId: requestRef.id,
      );

      emit(CreateRequestSuccessState());
    } catch (e) {
      emit(CreateRequestErrorState(error: e.toString()));
    }
  }

  Future<void> deleteStatusHistorySubCollection(String requestId) async {
    final statusHistorySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .collection('statusHistory')
        .get();

    if (statusHistorySnapshot.docs.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in statusHistorySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<bool> deleteUserRequest({
    required String requestId,
  }) async {
    try {
      if (requestId.trim().isEmpty) {
        throw 'رقم الحجز غير صحيح';
      }

      emit(DeleteUserRequestLoadingState());

      final String currentUserId =
          CacheHelper.getData(key: 'uid')?.toString() ?? '';

      final requestRef =
          FirebaseFirestore.instance.collection('requests').doc(requestId);

      final requestDoc = await requestRef.get();

      if (!requestDoc.exists) {
        throw 'الحجز غير موجود';
      }

      final requestData = requestDoc.data() ?? {};

      if ((requestData['customerId'] ?? '').toString() != currentUserId) {
        throw 'لا يمكنك حذف حجز لا يخصك';
      }

      final String status = (requestData['status'] ?? '').toString();

      final List<String> blockedDeleteStatuses = [
        'مقبول',
        'في الطريق',
        'مكتمل',
      ];

      if (blockedDeleteStatuses.contains(status)) {
        throw 'لا يمكن حذف الحجز بعد قبوله أو أثناء التنفيذ أو بعد اكتماله';
      }

      await deleteStatusHistorySubCollection(requestId);

      await requestRef.delete();

      userRequests.removeWhere((request) {
        final id = (request['id'] ?? request['requestId'] ?? '').toString();
        return id == requestId;
      });

      emit(DeleteUserRequestSuccessState());
      return true;
    } catch (e) {
      emit(DeleteUserRequestErrorState(error: e.toString()));
      return false;
    }
  }

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

  Future<void> editUserData({
    required String name,
    String? profileImagePath,
    String? oldProfileImage,
  }) async {
    emit(EditUserDataLoadingState());

    try {
      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(EditUserDataErrorState(error: 'تعذر العثور على معرف المستخدم'));
        return;
      }

      if (name.trim().isEmpty) {
        emit(EditUserDataErrorState(error: 'الاسم يجب أن لا يكون فارغًا'));
        return;
      }

      String finalProfileImage = oldProfileImage ?? '';

      if (profileImagePath != null && profileImagePath.trim().isNotEmpty) {
        finalProfileImage = await uploadImageToCloudinary(profileImagePath);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid.toString())
          .update({
        'name': name.trim(),
        'profileImage': finalProfileImage,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (allUsers.containsKey(uid.toString())) {
        allUsers[uid.toString()] = {
          ...Map<String, dynamic>.from(allUsers[uid.toString()] ?? {}),
          'name': name.trim(),
          'profileImage': finalProfileImage,
        };
      }

      emit(EditUserDataSuccessState());
    } catch (e) {
      emit(EditUserDataErrorState(error: e.toString()));
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
}
