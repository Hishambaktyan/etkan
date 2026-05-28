import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/worker_screens/worker_request_details.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_states.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import '../../../main.dart';
import '../../../modules/the_chat.dart';
import '../../../modules/user_screens/booking_details.dart';

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
          builder: (_) => BookingDetails(
            request: requestData,
            providerData: providerData,
          ),
        ),
      );
    } catch (error) {
      print('خطأ أثناء فتح تفاصيل حجز المستخدم: $error');
    }
  }

  void handleNotificationClick(RemoteMessage message) {
    handleNotificationData(message.data);
  }

  void handleNotificationData(Map<String, dynamic> data) {
    final myId = CacheHelper.getData(key: 'uid')?.toString() ?? '';

    print('Notification Click Data: $data');

    if (data['type'] == 'new_message') {
      final String chatId = data['relatedId']?.toString() ?? '';
      final String requestId = data['requestId']?.toString() ?? '';
      final String senderId = data['senderId']?.toString() ?? '';
      final String senderName = data['senderName']?.toString() ?? '';
      final String senderImage = data['senderImage']?.toString() ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentState == null) {
          print('navigatorKey.currentState is null');
          return;
        }

        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => TheChat(
              otherUsername: senderName,
              otherUserImage: senderImage,
              otherUserId: senderId,
              myId: myId,
              chatId: chatId,
              requestId: requestId,
            ),
          ),
        );
      });
    }

    if (data['type'] == 'new_booking') {
      final String requestId = data['relatedId']?.toString() ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        openWorkerRequestDetails(requestId);
      });
    }

    if (data['type'] == 'booking_status') {
      final String requestId = data['relatedId']?.toString() ?? '';

      print('تم الضغط على إشعار تحديث الحجز');
      print('booking_status requestId: $requestId');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        openUserBookingDetails(requestId);
      });
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
}