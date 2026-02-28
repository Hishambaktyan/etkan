import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';
import 'modules/user_screens/the_chat.dart';

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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          List<String> data = payload.split('|');

          if (data.length >= 4) {
            String chatId = data[0];
            String otherUserId = data[1];
            String otherUsername = data[2];
            String otherUserImage = data[3];

            moveAndReplace(
              navigatorKey.currentContext!,
              TheChat(
                otherUserId: otherUserId,
                chatId: chatId,
                myId: FirebaseAuth.instance.currentUser!.uid,
                otherUsername: otherUsername,
                otherUserImage: otherUserImage,
              ),
            );
          }
        }
      },
    );
  }

  static Future<void> display(RemoteMessage message) async {
    try {

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      String chatId = message.data['chatId'] ?? '';
      if (chatId == TheChat.currentChatId) {
        print("المستخدم داخل صفحة الدردشة حالياً، لن يتم إظهار إشعار.");
        return;
      }
      String senderId = message.data['senderId'] ?? '';
      String senderName = message.data['senderName'] ?? 'مستخدم';
      String senderImage = message.data['senderImage'] ?? '';

      String payloadData = "$chatId|$senderId|$senderName|$senderImage";

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(
        id,
        message.data['title'] ?? "رسالة جديدة",
        message.data['body'] ?? "",
        notificationDetails,
        payload: payloadData,
      );
    } catch (e) {
      print("NotificationHelper.display error: $e");
    }
  }
}