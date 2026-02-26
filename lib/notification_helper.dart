import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../modules/user_screens/the_chat.dart';
import '../main.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final chatId = response.payload;
        if (chatId != null && chatId.isNotEmpty) {
          String senderId = '';
          try {
            var chatDoc = await FirebaseFirestore.instance
                .collection('chats')
                .doc(chatId)
                .get();

            Map<String, dynamic> chatData =
                chatDoc.data() ?? <String, dynamic>{};
            List users = chatData['users'] ?? [];
            String myId = FirebaseAuth.instance.currentUser!.uid;
            String otherUserId =
            users.firstWhere((id) => id != myId, orElse: () => '');

            Map<String, dynamic> usersInfo = chatData['userInfo'] ?? {};
            String otherUsername = usersInfo[otherUserId]?['name'] ?? 'مستخدم';
            String otherUserImage = usersInfo[otherUserId]?['image'] ?? '';

            move(
              navigatorKey.currentContext!,
              TheChat(
                otherUserId: otherUserId,
                chatId: chatId,
                myId: myId,
                otherUsername: otherUsername,
                otherUserImage: otherUserImage,
              ),
            );
          } catch (e) {
            print("Error opening chat from notification: $e");
          }
        }
      },
    );
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          channelDescription:
          "This channel is used for important notifications.",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? "رسالة جديدة",
        message.notification?.body ?? "",
        notificationDetails,
        payload: message.data['chatId'],
      );
    } catch (e) {
      print("NotificationHelper.display error: $e");
    }
  }
}