import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/worker_screens/worker_request_details.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_states.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import '../../../main.dart';
import '../../../modules/the_chat.dart';
import '../../../modules/user_screens/user_request_details.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitState());

  static NotificationCubit get(context) => BlocProvider.of(context);

  bool isFirebaseMessagingInitialized = false;

  Future<void> openWorkerRequestDetails(String requestId) async {
    try {
      if (requestId.isEmpty) {
        print('requestId فارغ');
        return;
      }

      final requestDoc = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .get();

      if (!requestDoc.exists || requestDoc.data() == null) {
        print('الحجز غير موجود');
        return;
      }

      final Map<String, dynamic> requestData = requestDoc.data()!;
      requestData['id'] = requestDoc.id;
      requestData['requestId'] = requestDoc.id;

      if (navigatorKey.currentState == null) {
        print('navigatorKey.currentState is null');
        return;
      }

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => WorkerRequestDetails(
            request: requestData,
          ),
        ),
      );
    } catch (error) {
      print('خطأ أثناء فتح تفاصيل الحجز: $error');
    }
  }

  Future<void> openUserBookingDetails(String requestId) async {
    try {
      if (requestId.isEmpty) {
        print('requestId فارغ');
        return;
      }

      final requestDoc = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .get();

      if (!requestDoc.exists || requestDoc.data() == null) {
        print('الحجز غير موجود');
        return;
      }

      final Map<String, dynamic> requestData = requestDoc.data()!;

      requestData['id'] = requestDoc.id;
      requestData['requestId'] = requestDoc.id;

      final String providerId = requestData['providerId']?.toString() ?? '';

      if (providerId.isEmpty) {
        print('providerId غير موجود داخل الحجز');
        return;
      }

      final providerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(providerId)
          .get();

      if (!providerDoc.exists || providerDoc.data() == null) {
        print('بيانات الفني غير موجودة');
        return;
      }

      final Map<String, dynamic> providerData = providerDoc.data()!;

      providerData['id'] = providerDoc.id;
      providerData['uid'] = providerDoc.id;

      if (navigatorKey.currentState == null) {
        print('navigatorKey.currentState is null');
        return;
      }

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => UserRequestDetails(
            request: requestData,
            providerData: providerData,
          ),
        ),
      );
    } catch (error) {
      print('خطأ أثناء فتح تفاصيل حجز المستخدم: $error');
    }
  }

  void _runWhenNavigatorReady(VoidCallback action, {int retry = 0}) {
    if (navigatorKey.currentState != null) {
      action();
      return;
    }

    if (retry >= 20) {
      print('Navigator is still null after retries');
      return;
    }

    Future.delayed(const Duration(milliseconds: 150), () {
      _runWhenNavigatorReady(action, retry: retry + 1);
    });
  }

  void handleNotificationClick(RemoteMessage message) {
    handleNotificationData(message.data);
  }

  void handleNotificationData(Map<String, dynamic> data) {
    final myId = CacheHelper.getData(key: 'uid')?.toString() ?? '';

    print('Notification Click Data: $data');

    final String type = data['type']?.toString() ?? '';

    if (type == 'new_message') {
      final String chatId = data['relatedId']?.toString() ?? '';
      final String requestId = data['requestId']?.toString() ?? '';
      final String requestStatus = data['requestStatus']?.toString() ?? '';
      final String senderId = data['senderId']?.toString() ?? '';
      final String senderName = data['senderName']?.toString() ?? '';
      final String senderImage = data['senderImage']?.toString() ?? '';

      if (chatId.isEmpty || senderId.isEmpty || myId.isEmpty) {
        print('Missing chat notification data');
        return;
      }

      _runWhenNavigatorReady(() {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => TheChat(
              otherUsername: senderName,
              otherUserImage: senderImage,
              otherUserId: senderId,
              myId: myId,
              chatId: chatId,
              requestId: requestId,
              requestStatus: requestStatus,
            ),
          ),
        );
      });

      return;
    }

    if (type == 'new_booking') {
      final String requestId = data['relatedId']?.toString() ?? '';

      if (requestId.isEmpty) {
        print('new_booking requestId is empty');
        return;
      }

      _runWhenNavigatorReady(() {
        openWorkerRequestDetails(requestId);
      });

      return;
    }

    if (type == 'booking_status') {
      final String requestId = data['relatedId']?.toString() ?? '';

      if (requestId.isEmpty) {
        print('booking_status requestId is empty');
        return;
      }

      print('تم الضغط على إشعار تحديث الحجز');
      print('booking_status requestId: $requestId');

      _runWhenNavigatorReady(() {
        openUserBookingDetails(requestId);
      });

      return;
    }
  }

  Future<void> initFirebaseMessaging() async {
    print('------------------------------------------------initFirebaseMessaging STARTED');

    if (isFirebaseMessagingInitialized) {
      print('----------------------------------------------initFirebaseMessaging already initialized');
      return;
    }

    try {
      emit(NotificationLoadingState());

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Notification permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('إشعار وصل والتطبيق مفتوح----------------------------------------------');
        print('Data: ${message.data}');

        await showLocalNotification(message);

        emit(NotificationReceivedState());
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('onMessageOpenedApp FIRED');
        print('تم فتح التطبيق من الإشعار');
        print('Data: ${message.data}');

        handleNotificationClick(message);

        emit(NotificationOpenedState());
      });


      final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      if (pendingNotificationData != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          handleNotificationData(pendingNotificationData!);
          pendingNotificationData = null;
        });
      }

      print('initialMessage data: ${initialMessage?.data}');

      if (initialMessage != null) {
        print('getInitialMessage FIRED');
        print('التطبيق كان مغلق وانفتح من إشعار');
        print('Data: ${initialMessage.data}');

        handleNotificationClick(initialMessage);

        emit(NotificationOpenedState());
      }

      isFirebaseMessagingInitialized = true;

      emit(NotificationSuccessState());
    } catch (error) {
      emit(NotificationErrorState(error: error.toString()));
    }
  }

  List<Map<String, dynamic>> userNotifications = [];

  int get unreadNotificationsCount {
    return userNotifications
        .where((notification) => notification['isRead'] != true)
        .length;
  }

  bool isNotificationsLoaded = false;
  bool isNotificationsLoading = false;

  Future<void> getUserNotifications() async {
    try {
      final String uid = CacheHelper.getData(key: 'uid')?.toString() ?? '';

      if (uid.isEmpty) {
        userNotifications = [];
        isNotificationsLoaded = true;
        isNotificationsLoading = false;
        emit(GetNotificationsErrorState(error: 'لم يتم العثور على معرف المستخدم'));
        return;
      }

      isNotificationsLoading = true;
      emit(GetNotificationsLoadingState());

      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverId', isEqualTo: uid)
          .get();

      userNotifications = snapshot.docs.map((doc) {
        final data = doc.data();

        data['id'] = doc.id;
        data['notificationId'] = data['notificationId'] ?? doc.id;

        return data;
      }).toList();

      userNotifications.sort((a, b) {
        final DateTime aDate = a['createdAt'] is Timestamp
            ? (a['createdAt'] as Timestamp).toDate()
            : DateTime.fromMillisecondsSinceEpoch(0);

        final DateTime bDate = b['createdAt'] is Timestamp
            ? (b['createdAt'] as Timestamp).toDate()
            : DateTime.fromMillisecondsSinceEpoch(0);

        return bDate.compareTo(aDate);
      });

      isNotificationsLoaded = true;
      isNotificationsLoading = false;

      emit(GetNotificationsSuccessState());
    } catch (error) {
      isNotificationsLoaded = true;
      isNotificationsLoading = false;
      emit(GetNotificationsErrorState(error: error.toString()));
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      if (notificationId.isEmpty) return;

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({
        'isRead': true,
      });

      final index = userNotifications.indexWhere((notification) {
        final String id =
            notification['notificationId']?.toString() ??
                notification['id']?.toString() ??
                '';

        return id == notificationId;
      });

      if (index != -1) {
        userNotifications[index]['isRead'] = true;
      }

      emit(MarkNotificationAsReadSuccessState());
    } catch (error) {
      print('خطأ أثناء جعل الإشعار مقروء: $error');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final unreadNotifications = userNotifications
          .where((notification) => notification['isRead'] != true)
          .toList();

      if (unreadNotifications.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();

      for (final notification in unreadNotifications) {
        final String notificationId =
            notification['notificationId']?.toString() ??
                notification['id']?.toString() ??
                '';

        if (notificationId.isNotEmpty) {
          final ref = FirebaseFirestore.instance
              .collection('notifications')
              .doc(notificationId);

          batch.update(ref, {'isRead': true});
        }
      }

      await batch.commit();

      for (final notification in userNotifications) {
        notification['isRead'] = true;
      }

      emit(MarkNotificationAsReadSuccessState());
    } catch (error) {
      print('خطأ أثناء جعل كل الإشعارات مقروءة: $error');
    }
  }

}