import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_states.dart';

class ChatCubit extends Cubit<ChatStates>{
  ChatCubit(): super(ChatInitState());

  static ChatCubit get(context)=>BlocProvider.of(context);

  TextEditingController message = TextEditingController();

  Widget buildMessageStatus(String status, bool isSeen, bool isMe) {
    if (!isMe) return const SizedBox.shrink();

    switch(status) {
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
  Future<void> sendMessage(String chatId, String receiverId, String senderId,String? replyText,String? replyName)
  async {
    try{
      if (message.text.trim().isEmpty) return;
      String text = message.text.trim();


      message.clear();
      emit(SendMessageLoadingState());
      DocumentReference messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();
      await messageRef.set({
        'messageId': messageRef.id,
        'chatId': chatId,
        'text': text,
        'messageStatus': 'sending',
        'receiverId': receiverId,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
        'isSeen': false,
        'replyText': replyText,
        'replyName': replyName,
      });

      await messageRef.update({
        'messageStatus': 'sent',
      }) ;
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .update({
        'lastMessage': text,
        'lastUpdate': FieldValue.serverTimestamp(),
        'lastSenderId': senderId,
        'unreadCount.$receiverId': FieldValue.increment(1),
      });
      emit(SendMessageSuccessState());
    }catch(e){
      emit(SendMessageErrorState(error: e.toString()));
    }
  }
  Future<void> markAsSeen(String chatId, String myId) async {
    var query = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: myId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      await doc.reference.update({
        'isSeen': true,
        'messageStatus': 'seen',
      });
    }

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .update({
      'unreadCount.$myId': 0,
      'isLastMessagesRead': true,
    });
  }
  bool isTyping=false;


}