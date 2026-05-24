import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_states.dart';

import '../../networks/remote/notification_service.dart';

class ChatCubit extends Cubit<ChatStates>{
  ChatCubit(): super(ChatInitState());

  static ChatCubit get(context)=>BlocProvider.of(context);

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

      case 'delivered':
        return SvgPicture.asset(
          'assets/checks.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.grey.shade300,
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
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .update({
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
    required String body,
    required bool isImage,
  }) async {
    try {
      if (receiverId == senderId) {
        print('لن يتم إرسال إشعار لنفس المستخدم');
        return;
      }

      final receiverDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();

      final receiverData = receiverDoc.data() ?? {};

      final receiverToken = receiverData['token']?.toString() ?? '';

      print('Receiver ID: $receiverId');
      print('Sender ID: $senderId');
      print('Receiver Data: $receiverData');
      print('Receiver Token: $receiverToken');

      if (receiverToken.isEmpty) {
        print('لا يوجد token لمستقبل الرسالة');
        return;
      }

      const String title = 'رسالة جديدة';
      final String notificationBody = isImage ? 'تم إرسال صورة جديدة' : body;

      await NotificationService.createNotificationInFirestore(
        receiverId: receiverId,
        receiverType: 'chat',
        senderId: senderId,
        title: title,
        body: notificationBody,
        type: 'new_message',
        relatedId: chatId,
      );

      await NotificationService.sendNotification(
        receiverToken: receiverToken,
        title: title,
        body: notificationBody,
        type: 'new_message',
        relatedId: chatId,
        senderId: senderId,
      );
    } catch (error) {
      print('خطأ أثناء إرسال إشعار الرسالة: $error');
    }
  }

  Future<void> sendMessage(
      String chatId,
      String receiverId,
      String senderId,
      String? replyText,
      String? replyName,
      )
  async {
    try {
      if (message.text.trim().isEmpty) return;

      final String text = message.text.trim();
      message.clear();
      isTyping = false;

      emit(SendMessageLoadingState());

      final Timestamp now = Timestamp.now();

      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId);

      final messageRef = chatRef
          .collection('messages')
          .doc();

      final batch = FirebaseFirestore.instance.batch();

      batch.set(messageRef, {
        'messageId': messageRef.id,
        'text': text,
        'messageStatus': 'sent',
        'receiverId': receiverId,
        'senderId': senderId,
        'timestamp': now,
        'type': 'text',
        'replyText': replyText,
        'replyName': replyName,
      });

      batch.update(chatRef, {
        'lastMessage': text,
        'lastMessageType': 'text',
        'lastUpdate': now,
        'lastSenderId': senderId,
        'unreadCount.$receiverId': FieldValue.increment(1),
        'typingStatus.$senderId': false,
      });

      await batch.commit();

      await sendChatNotification(
        receiverId: receiverId,
        senderId: senderId,
        chatId: chatId,
        body: text,
        isImage: false,
      );

      emit(SendMessageSuccessState());
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
    required String imageUrl,
    String? replyText,
    String? replyName,
  })
  async {
    try {
      if (imageUrl.trim().isEmpty) return;

      emit(SendMessageLoadingState());

      final Timestamp now = Timestamp.now();

      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId);

      final messageRef = chatRef
          .collection('messages')
          .doc();

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

      await sendChatNotification(
        receiverId: receiverId,
        senderId: senderId,
        chatId: chatId,
        body: 'أرسل لك صورة',
        isImage: true,
      );

      emit(SendMessageSuccessState());
    } catch (e) {
      emit(SendMessageErrorState(error: e.toString()));
    }
  }

  Future<void> markAsSeen(String chatId, String myId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: myId)
          .get();

      final unreadDocs = query.docs.where((doc) {
        final data = doc.data();
        return data['messageStatus'] != 'seen';
      }).toList();

      if (unreadDocs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .update({
          'unreadCount.$myId': 0,
        });
        return;
      }

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in unreadDocs) {
        batch.update(doc.reference, {
          'messageStatus': 'seen',
        });
      }

      batch.update(
        FirebaseFirestore.instance.collection('chats').doc(chatId),
        {
          'unreadCount.$myId': 0,
        },
      );

      await batch.commit();
    } catch (e) {
      print('خطأ أثناء تحديث حالة القراءة: $e');
    }
  }

  bool isTyping=false;


}