import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitState());

  static NotificationCubit get(context) => BlocProvider.of(context);

  bool isFirebaseMessagingInitialized = false;

  Future<void> initFirebaseMessaging() async {
    if (isFirebaseMessagingInitialized) return;

    try {
      emit(NotificationLoadingState());

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Notification permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('إشعار وصل والتطبيق مفتوح');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');

        emit(NotificationReceivedState());
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('تم فتح التطبيق من الإشعار');
        print('Data: ${message.data}');

        emit(NotificationOpenedState());
      });

      final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        print('التطبيق كان مغلق وانفتح من إشعار');
        print('Data: ${initialMessage.data}');

        emit(NotificationOpenedState());
      }

      isFirebaseMessagingInitialized = true;

      emit(NotificationSuccessState());
    } catch (error) {
      emit(NotificationErrorState(error: error.toString()));
    }
  }

}