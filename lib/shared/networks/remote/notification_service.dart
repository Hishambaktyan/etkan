import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String projectId = 'homy-1de67';

  static Future<String> getAccessToken() async {

    final jsonString = await rootBundle.loadString('assets/service-account.json');

    final accountCredentials = ServiceAccountCredentials.fromJson(jsonString);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging',];

    final client = await clientViaServiceAccount(accountCredentials, scopes,);

    final accessToken = client.credentials.accessToken.data;

    client.close();

    return accessToken;
  }

  static Future<void> sendNotification({
    required String receiverToken,
    required String title,
    required String body,
    required String type,
    required String relatedId,
    String senderId = '',
  })
  async {
    try {

      final accessToken = await getAccessToken();

      final response = await http.post(

        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send',),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': receiverToken,

            'notification': {
              'title': title,
              'body': body,
            },

            'data': {
              'type': type,
              'relatedId': relatedId,
              'senderId': senderId,
            },

            'android': {
              'priority': 'high',
              'notification': {
                'sound': 'default',
              },
            },
          },
        }),
      );

      print('FCM Status Code: ${response.statusCode}');
      print('FCM Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('تم إرسال إشعار FCM بنجاح');
      } else {
        print('فشل إرسال FCM');
      }
    } catch (error) {
      print('خطأ أثناء إرسال FCM: $error');
    }
  }

  static Future<void> createNotificationInFirestore({
    required String receiverId,
    required String receiverType,
    required String senderId,
    required String title,
    required String body,
    required String type,
    required String relatedId,
  })
  async {
    final notificationRef = FirebaseFirestore.instance.collection('notifications').doc();

    await notificationRef.set({
      'notificationId': notificationRef.id,
      'receiverId': receiverId,
      'receiverType': receiverType,
      'senderId': senderId,
      'title': title,
      'body': body,
      'type': type,
      'relatedId': relatedId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}