import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Etkan/shared/cubits/chat_cubit/chat_states.dart';

import '../../networks/remote/notification_service.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitState());

  static ChatCubit get(context) => BlocProvider.of(context);

  TextEditingController message = TextEditingController();

  Widget buildMessageStatus(String status, bool isMe) {
    if (!isMe) return const SizedBox.shrink();

    switch (status) {
      case 'sending':
        return SvgPicture.asset(
          'assets/timer.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.grey.shade300,
        );
      case 'sent':
        return SvgPicture.asset(
          'assets/check.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.green.shade100,
        );
      case 'seen':
        return SvgPicture.asset(
          'assets/checks.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.green.shade100,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> resetUnreadCount(String chatId, String myId) async {
    try {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'unreadCount.$myId': 0,
      });
    } catch (e) {
      print('خطأ أثناء تصفير العداد: $e');
    }
  }

  Future<void> sendChatNotification({
    required String receiverId,
    required String senderId,
    required String chatId,
    required String requestId,
    required String body,
    required bool isImage,
  }) async {
    try {
      if (receiverId == senderId) {
        print('لن يتم إرسال إشعار لنفس المستخدم');
        return;
      }

      final results = await Future.wait([
        FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
        FirebaseFirestore.instance.collection('users').doc(senderId).get(),
      ]);

      final receiverDoc = results[0];
      final senderDoc = results[1];

      final receiverData = receiverDoc.data() ?? {};
      final senderData = senderDoc.data() ?? {};

      final receiverToken = receiverData['token']?.toString() ?? '';

      if (receiverToken.isEmpty) {
        print('لا يوجد token لمستقبل الرسالة');
        return;
      }

      final String senderName = senderData['name']?.toString() ?? 'مستخدم';
      final String senderImage = senderData['profileImage']?.toString() ?? '';

      final nameParts = senderName.trim().split(RegExp(r'\s+'));
      final firstTwoNames = nameParts.take(2).join(' ');

      final String title = 'رسالة جديدة من $firstTwoNames';
      final String notificationBody = isImage ? 'تم إرسال صورة جديدة' : body;

      await NotificationService.sendNotification(
        receiverToken: receiverToken,
        title: title,
        body: notificationBody,
        type: 'new_message',
        relatedId: chatId,
        senderId: senderId,
        senderName: senderName,
        senderImage: senderImage,
        requestId: requestId,
      );
    } catch (error) {
      print('خطأ أثناء إرسال إشعار الرسالة: $error');
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String receiverId,
    required String senderId,
    required String requestId,
    required String text,
    String? replyText,
    String? replyName,
  }) async {
    try {
      final String finalText = text.trim();

      if (finalText.isEmpty) return;

      emit(SendMessageLoadingState());

      final Timestamp now = Timestamp.now();

      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      final messageRef = chatRef.collection('messages').doc();

      final batch = FirebaseFirestore.instance.batch();

      batch.set(messageRef, {
        'messageId': messageRef.id,
        'text': finalText,
        'messageStatus': 'sent',
        'receiverId': receiverId,
        'senderId': senderId,
        'timestamp': now,
        'type': 'text',
        'replyText': replyText,
        'replyName': replyName,
      });

      batch.update(chatRef, {
        'lastMessage': finalText,
        'lastMessageType': 'text',
        'lastUpdate': now,
        'lastSenderId': senderId,
        'unreadCount.$receiverId': FieldValue.increment(1),
        'typingStatus.$senderId': false,
      });

      await batch.commit();

      emit(SendMessageSuccessState());

      sendChatNotification(
        receiverId: receiverId,
        senderId: senderId,
        chatId: chatId,
        body: finalText,
        isImage: false,
        requestId: requestId,
      ).catchError((error) {
        print('فشل إرسال إشعار الرسالة: $error');
      });
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
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

  Future<void> sendImageMessage({
    required String chatId,
    required String receiverId,
    required String senderId,
    required String requestId,
    required String imageUrl,
    String? replyText,
    String? replyName,
  }) async {
    try {
      if (imageUrl.trim().isEmpty) return;

      emit(SendMessageLoadingState());

      final Timestamp now = Timestamp.now();

      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      final messageRef = chatRef.collection('messages').doc();

      final batch = FirebaseFirestore.instance.batch();

      batch.set(messageRef, {
        'messageId': messageRef.id,
        'text': '',
        'imageUrl': imageUrl,
        'messageStatus': 'sent',
        'receiverId': receiverId,
        'senderId': senderId,
        'timestamp': now,
        'type': 'image',
        'replyText': replyText,
        'replyName': replyName,
      });

      batch.update(chatRef, {
        'lastMessage': 'صورة',
        'lastMessageType': 'image',
        'lastUpdate': now,
        'lastSenderId': senderId,
        'unreadCount.$receiverId': FieldValue.increment(1),
        'typingStatus.$senderId': false,
      });

      await batch.commit();

      emit(SendMessageSuccessState());

      sendChatNotification(
        receiverId: receiverId,
        senderId: senderId,
        chatId: chatId,
        body: 'ارسل لك صورة',
        isImage: true,
        requestId: requestId,
      ).catchError((error) {
        print('فشل إرسال إشعار الرسالة: $error');
      });
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
    }
  }

  Future<void> markAsSeen(String chatId, String myId) async {
    try {
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      final query = await chatRef
          .collection('messages')
          .where('receiverId', isEqualTo: myId)
          .where('messageStatus', isNotEqualTo: 'seen')
          .limit(400)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in query.docs) {
        batch.update(doc.reference, {
          'messageStatus': 'seen',
        });
      }

      batch.update(chatRef, {
        'unreadCount.$myId': 0,
      });

      await batch.commit();
    } catch (e) {
      print('خطأ أثناء تحديث حالة القراءة: $e');
    }
  }

  @override
  Future<void> close() {
    message.dispose();
    return super.close();
  }
}
