import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Etkan/shared/cubits/user_cubit/user_states.dart';

import '../../networks/local/cache_helper.dart';
import '../../networks/remote/notification_service.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitState());

  static UserCubit get(context) => BlocProvider.of(context);

  static const int freeCompletedRequestsLimit = 5;

  Map<String, dynamic> getSubscriptionData(Map<String, dynamic> userData) {
    final dynamic rawSubscription = userData['subscription'];

    if (rawSubscription is Map) {
      return Map<String, dynamic>.from(rawSubscription);
    }

    return {};
  }

  DateTime? getSubscriptionDate(dynamic value) {
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

  bool isSubscriptionExpired(Map<String, dynamic> userData) {
    final subscription = getSubscriptionData(userData);
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

    final DateTime? endDate = getSubscriptionDate(
      subscription['endDate'] ??
          subscription['endAt'] ??
          subscription['expiresAt'],
    );

    if (endDate == null) {
      return false;
    }

    return !endDate.isAfter(DateTime.now());
  }

  bool hasActiveSubscription(Map<String, dynamic> userData) {
    if (isSubscriptionExpired(userData)) {
      return false;
    }

    final subscription = getSubscriptionData(userData);
    final String status = subscription['status']?.toString() ?? 'not_submitted';

    return userData['isSubscribed'] == true ||
        subscription['isActive'] == true ||
        status == 'active' ||
        status == 'approved';
  }

  bool canProviderUseFreePlan({
    required Map<String, dynamic> providerData,
    required int completedRequestsCount,
  }) {
    if (isSubscriptionExpired(providerData)) {
      return false;
    }

    if (hasActiveSubscription(providerData)) {
      return true;
    }

    return completedRequestsCount < freeCompletedRequestsLimit;
  }

  Future<Map<String, int>> getCompletedRequestsCountByProvider() async {
    final completedRequestsSnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'مكتمل')
        .get();

    final Map<String, int> completedRequestsCountByProvider = {};

    for (final requestDoc in completedRequestsSnapshot.docs) {
      final requestData = requestDoc.data();
      final String providerId = requestData['providerId']?.toString() ?? '';

      if (providerId.isEmpty) continue;

      completedRequestsCountByProvider[providerId] =
          (completedRequestsCountByProvider[providerId] ?? 0) + 1;
    }

    return completedRequestsCountByProvider;
  }

  Future<Set<String>> getVisibleProviderIds() async {
    final providersFuture = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'provider')
        .get();

    final completedRequestsCountFuture = getCompletedRequestsCountByProvider();

    await Future.wait([
      providersFuture,
      completedRequestsCountFuture,
    ]);

    final providersSnapshot = await providersFuture;
    final completedRequestsCountByProvider = await completedRequestsCountFuture;

    final Set<String> visibleProviderIds = {};
    final batch = FirebaseFirestore.instance.batch();
    bool hasExpiredSubscriptions = false;

    for (final providerDoc in providersSnapshot.docs) {
      final providerData = providerDoc.data();
      final subscription = getSubscriptionData(providerData);
      final String status =
          subscription['status']?.toString() ?? 'not_submitted';

      if (isSubscriptionExpired(providerData)) {
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

      final int completedRequestsCount =
          completedRequestsCountByProvider[providerDoc.id] ?? 0;

      if (canProviderUseFreePlan(
        providerData: providerData,
        completedRequestsCount: completedRequestsCount,
      )) {
        visibleProviderIds.add(providerDoc.id);
      }
    }

    if (hasExpiredSubscriptions) {
      try {
        await batch.commit();
      } catch (error) {
        print('تعذر تحديث حالات الاشتراكات المنتهية: $error');
      }
    }

    return visibleProviderIds;
  }

  bool isServiceVisibleToCustomers(
    Map<String, dynamic> service,
    Set<String> visibleProviderIds,
  ) {
    final String providerId = service['providerId']?.toString() ?? '';
    final bool isServiceActive = service['isActive'] != false;

    return isServiceActive &&
        providerId.isNotEmpty &&
        visibleProviderIds.contains(providerId);
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

      final visibleProviderIdsFuture = getVisibleProviderIds();

      final servicesFuture = FirebaseFirestore.instance
          .collection('services')
          .where('category', isEqualTo: categoryType)
          .where('isActive', isEqualTo: true)
          .get();

      await Future.wait([
        visibleProviderIdsFuture,
        servicesFuture,
      ]);

      final visibleProviderIds = await visibleProviderIdsFuture;
      final getServicesSnapshot = await servicesFuture;

      final List<Map<String, dynamic>> services = [];

      for (var doc in getServicesSnapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        if (isServiceVisibleToCustomers(data, visibleProviderIds)) {
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

      final visibleProviderIdsFuture = getVisibleProviderIds();
      final servicesFuture = FirebaseFirestore.instance
          .collection('services')
          .where('isActive', isEqualTo: true)
          .get();

      await Future.wait([
        visibleProviderIdsFuture,
        servicesFuture,
      ]);

      final visibleProviderIds = await visibleProviderIdsFuture;
      final servicesSnapshot = await servicesFuture;

      for (var doc in servicesSnapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;

        if (isServiceVisibleToCustomers(data, visibleProviderIds)) {
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

  List<Map<String, dynamic>> serviceReviews = [];
  double serviceRate = 0.0;
  int serviceReviewsCount = 0;
  bool isServiceReviewsLoaded = false;

  Future<void> getServiceReviews({
    required String serviceId,
  }) async {
    try {
      emit(GetServiceReviewsLoadingState());

      serviceReviews.clear();
      serviceRate = 0.0;
      serviceReviewsCount = 0;
      isServiceReviewsLoaded = false;

      if (serviceId.trim().isEmpty) {
        emit(GetServiceReviewsErrorState(
          error: 'معرف الخدمة غير موجود',
        ));
        return;
      }

      final serviceRef =
          FirebaseFirestore.instance.collection('services').doc(serviceId);

      final serviceDoc = await serviceRef.get();

      if (!serviceDoc.exists) {
        emit(GetServiceReviewsErrorState(
          error: 'الخدمة غير موجودة',
        ));
        return;
      }

      final serviceData = serviceDoc.data() ?? {};

      serviceRate = double.tryParse('${serviceData['rate'] ?? 0}') ?? 0.0;
      serviceReviewsCount =
          int.tryParse('${serviceData['reviewsCount'] ?? 0}') ?? 0;

      final reviewsSnapshot = await serviceRef
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      for (var doc in reviewsSnapshot.docs) {
        final Map<String, dynamic> reviewData =
            Map<String, dynamic>.from(doc.data());

        reviewData['id'] = doc.id;

        final String customerId = '${reviewData['customerId'] ?? ''}';

        if (customerId.isNotEmpty) {
          final customerDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(customerId)
              .get();

          final customerData = customerDoc.data() ?? {};

          reviewData['customerName'] = customerData['name'] ?? 'مستخدم';
          reviewData['customerImage'] = customerData['profileImage'] ?? '';
        } else {
          reviewData['customerName'] = 'مستخدم';
          reviewData['customerImage'] = '';
        }

        serviceReviews.add(reviewData);
      }

      if (serviceReviewsCount == 0) {
        serviceReviewsCount = serviceReviews.length;
      }

      isServiceReviewsLoaded = true;

      emit(GetServiceReviewsSuccessState());
    } catch (e) {
      emit(GetServiceReviewsErrorState(error: e.toString()));
    }
  }

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
    required String serviceId,
    required String category,
    required String customerId,
    required String providerId,
    required String address,
    required String addressId,
    required GeoPoint addressLocation,
    required String title,
    required String description,
    required String image,
    required String duration,
    required int price,
    required Timestamp scheduledAt,
  })
  async {
    try {
      emit(CreateRequestLoadingState());

      final providerRef = FirebaseFirestore.instance.collection('users').doc(providerId);

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
        emit(CreateRequestErrorState(error: 'تعذر العثور على بيانات الفني',));
        return;
      }

      final providerData = providerDoc.data()!;

      if (isSubscriptionExpired(providerData)) {
        final subscription = getSubscriptionData(providerData);

        if (subscription['status']?.toString() != 'expired') {
          await providerRef.update({
            'isSubscribed': false,
            'subscription.isActive': false,
            'subscription.status': 'expired',
            'subscription.expiredAt': FieldValue.serverTimestamp(),
          });
        }

        emit(CreateRequestErrorState(error: 'انتهى اشتراك هذا الفني، ولا يمكنه استقبال حجوزات جديدة حالياً.',));
        return;
      }

      final int completedRequestsCount =
          completedRequestsCountSnapshot.count ?? 0;

      if (!canProviderUseFreePlan(
        providerData: providerData,
        completedRequestsCount: completedRequestsCount,
      )) {
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
        'serviceId': serviceId,
        'address': address,
        'addressId': addressId,
        'addressLocation': addressLocation,
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

        'isReviewed': false,
        'customerConfirmed': false,
        'customerConfirmedAt': null,
        'reviewId': null,

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

  Future<void> confirmBookingAndReview({
    required String requestId,
    required String serviceId,
    required String providerId,
    required String customerId,
    required double rating,
    required String review,
  }) async {
    try {
      emit(ConfirmBookingReviewLoadingState());

      if (rating < 1 || rating > 5) {
        emit(ConfirmBookingReviewErrorState(
          error: 'يرجى اختيار تقييم من 1 إلى 5',
        ));
        return;
      }

      if (review.trim().isEmpty) {
        emit(ConfirmBookingReviewErrorState(
          error: 'يرجى كتابة مراجعة للخدمة',
        ));
        return;
      }

      final requestRef =
          FirebaseFirestore.instance.collection('requests').doc(requestId);

      final serviceRef =
          FirebaseFirestore.instance.collection('services').doc(serviceId);

      final providerRef =
          FirebaseFirestore.instance.collection('users').doc(providerId);

      final reviewRef = serviceRef.collection('reviews').doc(requestId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final requestDoc = await transaction.get(requestRef);
        final serviceDoc = await transaction.get(serviceRef);
        final providerDoc = await transaction.get(providerRef);
        final reviewDoc = await transaction.get(reviewRef);

        if (!requestDoc.exists) {
          throw 'الحجز غير موجود';
        }

        if (!serviceDoc.exists) {
          throw 'الخدمة غير موجودة';
        }

        if (!providerDoc.exists) {
          throw 'الفني غير موجود';
        }

        final requestData = requestDoc.data() ?? {};
        final serviceData = serviceDoc.data() ?? {};
        final providerData = providerDoc.data() ?? {};

        if (requestData['status'] != 'مكتمل') {
          throw 'لا يمكن تقييم الخدمة قبل اكتمالها';
        }

        if (requestData['isReviewed'] == true || reviewDoc.exists) {
          throw 'تم تقييم هذا الحجز مسبقًا';
        }

        final int oldServiceReviewsCount =
            int.tryParse('${serviceData['reviewsCount'] ?? 0}') ?? 0;

        final double oldServiceRatingSum =
            double.tryParse('${serviceData['ratingSum'] ?? 0}') ?? 0.0;

        final int newServiceReviewsCount = oldServiceReviewsCount + 1;
        final double newServiceRatingSum = oldServiceRatingSum + rating;
        final double newServiceRate =
            newServiceRatingSum / newServiceReviewsCount;

        final int oldProviderRatingsCount =
            int.tryParse('${providerData['ratingsCount'] ?? 0}') ?? 0;

        final double oldProviderRatingSum =
            double.tryParse('${providerData['ratingSum'] ?? 0}') ?? 0.0;

        final int newProviderRatingsCount = oldProviderRatingsCount + 1;
        final double newProviderRatingSum = oldProviderRatingSum + rating;
        final double newProviderAvgRating =
            newProviderRatingSum / newProviderRatingsCount;

        transaction.set(reviewRef, {
          'requestId': requestId,
          'serviceId': serviceId,
          'providerId': providerId,
          'customerId': customerId,
          'rating': rating,
          'review': review.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        transaction.update(serviceRef, {
          'ratingSum': newServiceRatingSum,
          'reviewsCount': newServiceReviewsCount,
          'rate': double.parse(newServiceRate.toStringAsFixed(1)),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        transaction.update(providerRef, {
          'ratingSum': newProviderRatingSum,
          'ratingsCount': newProviderRatingsCount,
          'avgRating': double.parse(newProviderAvgRating.toStringAsFixed(1)),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        transaction.update(requestRef, {
          'isReviewed': true,
          'customerConfirmed': true,
          'customerConfirmedAt': FieldValue.serverTimestamp(),
          'reviewId': requestId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      emit(ConfirmBookingReviewSuccessState());
    } catch (e) {
      emit(ConfirmBookingReviewErrorState(error: e.toString()));
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

  Map<String, dynamic> singleUserData = {};
  bool isSingleUserDataLoaded = false;

  Future<void> getSingleUserData({
    String? userId,
    bool forceRefresh = false,
  }) async {
    try {
      if (isSingleUserDataLoaded && !forceRefresh) {
        return;
      }

      emit(GetSingleUserDataLoadingState());

      final String uid =
          userId ?? CacheHelper.getData(key: 'uid')?.toString() ?? '';

      if (uid.isEmpty) {
        emit(GetSingleUserDataErrorState(
          error: 'تعذر العثور على معرف المستخدم',
        ));
        return;
      }

      singleUserData.clear();

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        emit(GetSingleUserDataErrorState(
          error: 'تعذر العثور على بيانات المستخدم',
        ));
        return;
      }

      singleUserData = userDoc.data() ?? {};
      singleUserData['id'] = userDoc.id;

      isSingleUserDataLoaded = true;

      emit(GetSingleUserDataSuccessState());
    } catch (e) {
      emit(GetSingleUserDataErrorState(error: e.toString()));
    }
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

  Future<void> cancelRequest({
    required String requestId,
  }) async {
    try {
      emit(CancelRequestLoadingState());

      final requestRef =
          FirebaseFirestore.instance.collection('requests').doc(requestId);

      final requestSnapshot = await requestRef.get();

      if (!requestSnapshot.exists || requestSnapshot.data() == null) {
        emit(
          CancelRequestErrorState(
            error: 'الحجز غير موجود',
          ),
        );
        return;
      }

      final requestData = requestSnapshot.data()!;

      final customerId = requestData['customerId']?.toString() ?? '';

      final providerId = requestData['providerId']?.toString() ?? '';

      final requestTitle = requestData['title']?.toString() ?? 'حجز خدمة';

      final chatsSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('requestId', isEqualTo: requestId)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      batch.update(
        requestRef,
        {
          'status': 'ملغي',
          'updatedAt': FieldValue.serverTimestamp(),
          'statusHistory.cancelledAt': FieldValue.serverTimestamp(),
        },
      );

      batch.set(
        requestRef.collection('statusHistory').doc(),
        {
          'status': 'ملغي',
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      for (final chatDoc in chatsSnapshot.docs) {
        batch.update(
          chatDoc.reference,
          {
            'requestStatus': 'ملغي',
            'isChatClosed': true,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }

      await batch.commit();

      emit(CancelRequestSuccessState());

      if (providerId.isNotEmpty) {
        const notificationTitle = 'تم إلغاء الحجز';

        final notificationBody = 'تم إلغاء الحجز الخاص بخدمة $requestTitle';

        Future.wait([
          NotificationService.createNotificationInFirestore(
            receiverId: providerId,
            receiverType: 'provider',
            senderId: customerId,
            title: notificationTitle,
            body: notificationBody,
            type: 'booking_cancelled',
            relatedId: requestId,
          ),
          FirebaseFirestore.instance
              .collection('users')
              .doc(providerId)
              .get()
              .then((providerDoc) async {
            final providerData = providerDoc.data() ?? {};

            final receiverToken = providerData['token']?.toString() ?? '';

            if (receiverToken.isEmpty) return;

            await NotificationService.sendNotification(
              receiverToken: receiverToken,
              title: notificationTitle,
              body: notificationBody,
              type: 'booking_cancelled',
              relatedId: requestId,
              senderId: customerId,
            );
          }),
        ]).catchError((error) {
          print(
            'خطأ أثناء إرسال إشعار إلغاء الحجز: $error',
          );
          return [];
        });
      }
    } catch (error) {
      emit(
        CancelRequestErrorState(
          error: error.toString(),
        ),
      );
    }
  }
}
