import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Etkan/modules/images_view.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Etkan/shared/cubits/chat_cubit/chat_cubit.dart';
import 'package:Etkan/shared/cubits/chat_cubit/chat_states.dart';
import '../main.dart';
import '../shared/compenents/components.dart';
import '../shared/styles/colors.dart';

class TheChat extends StatefulWidget {
  final String chatId;
  final String otherUsername;
  final String otherUserImage;
  final String otherUserId;
  final String myId;
  static String? currentChatId;
  final String requestId;
  final String requestStatus;
  const TheChat(
      {super.key,
      required this.otherUsername,
      required this.otherUserImage,
      required this.otherUserId,
      required this.myId,
      required this.chatId,
      required this.requestId,
      required this.requestStatus});

  @override
  State<TheChat> createState() => _TheChatState();
}

class _TheChatState extends State<TheChat> {
  Stream<QuerySnapshot>? stream;

  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  FocusNode messageFocus = FocusNode();

  bool showScrollToBottomButton = false;

  Timer? typingTimer;
  bool isCurrentlyTyping = false;

  void setTypingStatus(bool typing) {
    if (isCurrentlyTyping == typing) return;

    isCurrentlyTyping = typing;

    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'typingStatus.${widget.myId}': typing,
    }).catchError((error) {
      print("Error updating typing status: $error");
    });
  }

  void clearTypingStatus() {
    typingTimer?.cancel();
    typingTimer = null;
    isCurrentlyTyping = false;

    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'typingStatus.${widget.myId}': false,
    }).catchError((error) {
      print("Error clearing typing status: $error");
    });
  }

  String? uploadingImageUrl;

  Future<void> pickAndSendImage({
    required ChatCubit chatCubit,
    required String chatId,
    required String receiverId,
    required String senderId,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedImage == null) return;
      if (!mounted) return;

      String? rText = replyMessage != null ? getReplyText(replyMessage!) : null;

      String? rName = replyMessage != null
          ? (replyMessage!['senderId'] == senderId
              ? 'أنت'
              : widget.otherUsername)
          : null;

      setState(() {
        replyMessage = null;
        uploadingImagePath = pickedImage.path;
      });

      clearTypingStatus();

      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return;
        scrollToBottom();
      });

      final String imageUrl =
          await chatCubit.uploadImageToCloudinary(pickedImage.path);

      if (!mounted) return;

      await chatCubit.sendImageMessage(
        requestId: widget.requestId,
        chatId: chatId,
        receiverId: receiverId,
        senderId: senderId,
        imageUrl: imageUrl,
        replyText: rText,
        replyName: rName,
      );

      if (!mounted) return;

      setState(() {
        uploadingImageUrl = imageUrl;
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return;
        scrollToBottom();
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        uploadingImagePath = null;
      });

      showSnackBar(
        Colors.red,
        'حدث خطأ أثناء إرسال الصورة',
        context,
      );
    }
  }

  Map<String, dynamic>? replyMessage;

  void onReply(Map<String, dynamic> message) {
    HapticFeedback.lightImpact();
    setState(() {
      replyMessage = message;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      if (messageFocus.canRequestFocus) {
        messageFocus.requestFocus();
      }
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  String? uploadingImagePath;

  late ChatCubit chatCubit;

  String getReplyText(Map<String, dynamic> message) {
    if (message['type'] == 'image') {
      return 'صورة';
    }

    final text = message['text']?.toString().trim() ?? '';
    return text.isEmpty ? 'رسالة' : text;
  }

  @override
  void initState() {
    super.initState();

    chatCubit = context.read<ChatCubit>();

    chatCubit.resetUnreadCount(widget.chatId, widget.myId);

    scrollController.addListener(() {
      if (scrollController.position.pixels > 100) {
        if (!showScrollToBottomButton) {
          setState(() => showScrollToBottomButton = true);
        }
      } else {
        if (showScrollToBottomButton) {
          setState(() => showScrollToBottomButton = false);
        }
      }
    });

    stream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    chatCubit.markAsSeen(widget.chatId, widget.myId);
    TheChat.currentChatId = widget.chatId;
  }

  @override
  void dispose() {
    chatCubit.markAsSeen(widget.chatId, widget.myId);
    clearTypingStatus();
    typingTimer?.cancel();
    messageFocus.dispose();
    scrollController.dispose();
    TheChat.currentChatId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String otherUserImage = widget.otherUserImage;
    String otherUsername = widget.otherUsername;
    String otherUserId = widget.otherUserId;
    String myId = widget.myId;
    String requestId = widget.requestId;
    final bool isChatClosed = widget.requestStatus == 'مكتمل' ||
        widget.requestStatus == 'قيد الانتظار';

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocBuilder<ChatCubit, ChatStates>(
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            ChatCubit chatCubit = ChatCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  titleSpacing: 0,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.back,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  title: Row(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => move(
                            context, ImageViewerPage(imageUrl: otherUserImage)),
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundImage: otherUserImage.isNotEmpty
                              ? NetworkImage(otherUserImage)
                              : null,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                          child: otherUserImage.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 22.r,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(
                          otherUsername,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'حدث خطأ ما...):',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'حدث خطأ في تحميل الرسائل',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    var docs = snapshot.data!.docs;
                    if (uploadingImageUrl != null &&
                        uploadingImagePath != null) {
                      final bool imageArrived = docs.any((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return data['type'] == 'image' &&
                            data['imageUrl'] == uploadingImageUrl;
                      });

                      if (imageArrived) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          setState(() {
                            uploadingImagePath = null;
                            uploadingImageUrl = null;
                          });

                          Future.delayed(const Duration(milliseconds: 50), () {
                            if (!mounted) return;
                            scrollToBottom();
                          });
                        });
                      }
                    }
                    final hasUnseenMessages = docs.any((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['receiverId'] == widget.myId &&
                          data['messageStatus'] != 'seen';
                    });
                    if (hasUnseenMessages) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        chatCubit.markAsSeen(widget.chatId, widget.myId);
                      });
                    }
                    return Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: docs.isEmpty && uploadingImagePath == null
                                  ? Center(
                                      child: Text(
                                        'ابدأ المحادثة الآن',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      reverse: true,
                                      padding: EdgeInsetsDirectional.only(
                                          bottom: 10.h),
                                      controller: scrollController,
                                      itemBuilder: (context, index) {
                                        if (uploadingImagePath != null &&
                                            index == 0) {
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                              vertical: 7.h,
                                              horizontal: 7.w,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.all(
                                                        5.r),
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.75,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: appCubit.isDark
                                                      ? Colors.blue.shade800
                                                      : Colors.blue.shade700,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.r),
                                                    topRight:
                                                        Radius.circular(15.r),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            0),
                                                    bottomRight:
                                                        Radius.circular(15.r),
                                                  ),
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      child: Image.file(
                                                        File(
                                                            uploadingImagePath!),
                                                        width: 200.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 45.r,
                                                      height: 45.r,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.45),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.r),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final realIndex =
                                            uploadingImagePath != null
                                                ? index - 1
                                                : index;

                                        var doc = docs[realIndex];
                                        var chatData =
                                            doc.data() as Map<String, dynamic>;
                                        bool isMe = chatData['senderId'] == myId
                                            ? true
                                            : false;
                                        return SwipeableMessage(
                                          onReply: () {
                                            onReply(chatData);
                                          },
                                          isMe: isMe,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    vertical: 7.h,
                                                    horizontal: 7.w),
                                            child: Align(
                                              alignment: isMe
                                                  ? AlignmentDirectional
                                                      .centerEnd
                                                  : AlignmentDirectional
                                                      .centerStart,
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 10.w,
                                                        end: 10.w,
                                                        top: 8.h,
                                                        bottom: 2.h),
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75),
                                                decoration: BoxDecoration(
                                                  color: isMe
                                                      ? appCubit.isDark
                                                          ? Colors.blue.shade800
                                                          : Colors.blue.shade700
                                                      : appCubit.isDark
                                                          ? const Color(
                                                              0xFF1C2128)
                                                          : Colors.blue
                                                              .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.r),
                                                    topRight:
                                                        Radius.circular(15.r),
                                                    bottomLeft: isMe
                                                        ? const Radius.circular(
                                                            0)
                                                        : Radius.circular(15.r),
                                                    bottomRight: isMe
                                                        ? Radius.circular(15.r)
                                                        : const Radius.circular(
                                                            0),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: isMe
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    if (chatData['replyText'] !=
                                                        null)
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 5.h),
                                                        padding:
                                                            EdgeInsets.all(8.r),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.05),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          border: Border(
                                                            right: BorderSide(
                                                              color: isMe
                                                                  ? Colors
                                                                      .white70
                                                                  : mainColor,
                                                              width: 3.w,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              chatData[
                                                                      'replyName'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                color: isMe
                                                                    ? Colors
                                                                        .white
                                                                    : mainColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              chatData[
                                                                  'replyText'],
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: isMe
                                                                    ? Colors
                                                                        .white70
                                                                    : Colors
                                                                        .grey
                                                                        .shade700,
                                                                fontSize: 10.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (chatData['type'] ==
                                                        'image')
                                                      Column(
                                                        children: [
                                                          InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () => move(
                                                                context,
                                                                ImageViewerPage(
                                                                    imageUrl:
                                                                        chatData['imageUrl'] ??
                                                                            '')),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.r),
                                                              child:
                                                                  Image.network(
                                                                chatData[
                                                                        'imageUrl'] ??
                                                                    '',
                                                                width: 200.w,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return Container(
                                                                    width:
                                                                        200.w,
                                                                    height:
                                                                        160.h,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        const CircularProgressIndicator(),
                                                                  );
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Container(
                                                                    width:
                                                                        200.w,
                                                                    height:
                                                                        120.h,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    child: const Icon(
                                                                        Icons
                                                                            .broken_image),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                        ],
                                                      )
                                                    else
                                                      Text(
                                                        chatData['text'] ?? '',
                                                        style: TextStyle(
                                                          color: isMe
                                                              ? Colors.white
                                                              : appCubit.isDark
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.9)
                                                                  : Colors
                                                                      .black,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment: isMe
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          chatData['timestamp'] ==
                                                                  null
                                                              ? ''
                                                              : timeFormatStatusTime(
                                                                  chatData[
                                                                      'timestamp']),
                                                          style: TextStyle(
                                                              color: isMe
                                                                  ? Colors.green
                                                                      .shade100
                                                                  : Colors.grey,
                                                              fontSize: 8.sp),
                                                        ),
                                                        SizedBox(width: 3.w),
                                                        isMe
                                                            ? chatCubit
                                                                .buildMessageStatus(
                                                                chatData[
                                                                        'messageStatus'] ??
                                                                    'sent',
                                                                isMe,
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: docs.length +
                                          (uploadingImagePath != null ? 1 : 0)),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(widget.chatId)
                                  .snapshots(),
                              builder: (context, typingSnapshot) {
                                if (typingSnapshot.hasData &&
                                    typingSnapshot.data!.exists) {
                                  var data = typingSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                  var typingMap = data['typingStatus']
                                      as Map<String, dynamic>?;
                                  bool isOtherTyping =
                                      typingMap?[widget.otherUserId] ?? false;

                                  if (isOtherTyping) {
                                    return AnimatedOpacity(
                                      opacity: isOtherTyping ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Container(
                                          margin: EdgeInsetsDirectional.only(
                                              start: 7.w),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 3, vertical: 8),
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          decoration: BoxDecoration(
                                            color: appCubit.isDark
                                                ? lightDarkColor
                                                : Colors.blue.withOpacity(0.3),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.r),
                                              topRight: Radius.circular(15.r),
                                              bottomLeft: Radius.circular(15.r),
                                              bottomRight:
                                                  const Radius.circular(0),
                                            ),
                                          ),
                                          child: SpinKitThreeBounce(
                                            color: appCubit.isDark
                                                ? Colors.grey.shade300
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return const SizedBox();
                              },
                            ),
                            Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: 13.w,
                                  end: 13.w,
                                  bottom: 13.h,
                                  top: 5.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: appCubit.isDark
                                              ? const Color(0xFF161B22)
                                              : Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(17.r),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (replyMessage != null)
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        top: 8.r,
                                                        bottom: 8.r,
                                                        start: 8.r),
                                                margin:
                                                    EdgeInsetsDirectional.all(
                                                        5.r),
                                                decoration: BoxDecoration(
                                                  color: appCubit.isDark
                                                      ? Colors.black
                                                          .withOpacity(0.3)
                                                      : Colors.white
                                                          .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: mainColor,
                                                      width: 4.w,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            replyMessage![
                                                                        'senderId'] ==
                                                                    myId
                                                                ? 'أنت'
                                                                : otherUsername,
                                                            style: TextStyle(
                                                              color: mainColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12.sp,
                                                            ),
                                                          ),
                                                          Text(
                                                            getReplyText(
                                                                replyMessage!),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 11.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          replyMessage = null;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.close_rounded,
                                                        size: 20.r,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            TextFormField(
                                              key: const ValueKey(
                                                  'chat_message_input'),
                                              controller: chatCubit.message,
                                              readOnly: isChatClosed,
                                              focusNode: messageFocus,
                                              style: TextStyle(fontSize: 12.sp),
                                              minLines: 1,
                                              maxLines: 5,
                                              onChanged: (value) {
                                                final bool typingNow =
                                                    value.trim().isNotEmpty;
                                                typingTimer?.cancel();

                                                if (typingNow) {
                                                  setTypingStatus(true);

                                                  typingTimer = Timer(
                                                    const Duration(seconds: 1),
                                                    () {
                                                      if (!mounted) return;
                                                      setTypingStatus(false);
                                                    },
                                                  );
                                                } else {
                                                  setTypingStatus(false);
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsetsDirectional
                                                        .symmetric(
                                                  horizontal: 15.w,
                                                  vertical: 10.h,
                                                ),
                                                hintText: isChatClosed
                                                    ? widget.requestStatus ==
                                                            'مكتمل'
                                                        ? 'تم إغلاق المحادثة بعد اكتمال الحجز'
                                                        : 'المحادثة متاحة بعد قبول الحجز'
                                                    : 'اكتب رسالة...',
                                                hintStyle: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      onTap: isChatClosed
                                                          ? null
                                                          : () {
                                                              pickAndSendImage(
                                                                chatCubit:
                                                                    chatCubit,
                                                                chatId: widget
                                                                    .chatId,
                                                                receiverId:
                                                                    otherUserId,
                                                                senderId: myId,
                                                              );
                                                            },
                                                      child: SvgPicture.asset(
                                                        'assets/image.svg',
                                                        height: 23.h,
                                                        width: 23.h,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Transform.scale(
                                      scale: 0.9,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          if (isChatClosed) {
                                            showSnackBar(
                                              Colors.orange,
                                              widget.requestStatus == 'مكتمل'
                                                  ? 'لا يمكن إرسال رسائل بعد اكتمال الحجز'
                                                  : 'المحادثة متاحة بعد قبول الحجز',
                                              context,
                                            );
                                            return;
                                          }
                                          final String messageText =
                                              chatCubit.message.text.trim();
                                          if (messageText.isEmpty) {
                                            return;
                                          }
                                          String? rText = replyMessage != null
                                              ? getReplyText(replyMessage!)
                                              : null;
                                          String? rName = replyMessage != null
                                              ? (replyMessage!['senderId'] ==
                                                      myId
                                                  ? 'أنت'
                                                  : widget.otherUsername)
                                              : null;
                                          final bool hadReply =
                                              replyMessage != null;
                                          chatCubit.message.clear();
                                          clearTypingStatus();
                                          if (hadReply) {
                                            setState(() {
                                              replyMessage = null;
                                            });
                                          }
                                          FocusScope.of(context)
                                              .requestFocus(messageFocus);
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (!mounted) return;
                                            FocusScope.of(context)
                                                .requestFocus(messageFocus);
                                          });
                                          chatCubit.sendMessage(
                                            chatId: widget.chatId,
                                            receiverId: otherUserId,
                                            senderId: myId,
                                            requestId: requestId,
                                            text: messageText,
                                            replyText: rText,
                                            replyName: rName,
                                          );
                                          Future.delayed(
                                            const Duration(milliseconds: 50),
                                            () {
                                              if (!mounted) return;
                                              scrollToBottom();
                                              FocusScope.of(context)
                                                  .requestFocus(messageFocus);
                                            },
                                          );
                                        },
                                        elevation: 0,
                                        shape: const CircleBorder(),
                                        backgroundColor: mainColor,
                                        splashColor: Colors.transparent,
                                        child: Transform.rotate(
                                          angle: 0.4,
                                          child: Icon(
                                            Icons.send_rounded,
                                            color: Colors.white,
                                            size: 25.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: showScrollToBottomButton ? 1.0 : 0.0,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: showScrollToBottomButton ? 1.0 : 0.0,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  bottom: 100.h, end: 10.w),
                              child: FloatingActionButton.small(
                                heroTag: 'scroll_down',
                                backgroundColor: appCubit.isDark
                                    ? const Color(0xFF161B22)
                                    : Colors.white,
                                elevation: 4,
                                shape: const CircleBorder(),
                                onPressed: () => scrollToBottom(),
                                child: SvgPicture.asset(
                                  'assets/down.svg',
                                  width: 23.w,
                                  height: 23.h,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SwipeableMessage extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;
  final bool isMe;

  const SwipeableMessage({
    super.key,
    required this.child,
    required this.onReply,
    required this.isMe,
  });

  @override
  State<SwipeableMessage> createState() => _SwipeableMessageState();
}

class _SwipeableMessageState extends State<SwipeableMessage> {
  double _offset = 0.0;

  bool get canSwipeToThisDirection {
    if (widget.isMe) {
      // رسالتي: السحب لليسار فقط
      return _offset < 0;
    } else {
      // رسالة الطرف الآخر: السحب لليمين فقط
      return _offset > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        setState(() {
          final double newOffset = _offset + details.delta.dx;

          if (widget.isMe) {
            // رسالتي: اسمح فقط بالسحب لليسار
            if (newOffset <= 0) {
              _offset = newOffset.clamp(-70.0, 0.0);
            } else {
              _offset = 0.0;
            }
          } else {
            // رسالة الطرف الآخر: اسمح فقط بالسحب لليمين
            if (newOffset >= 0) {
              _offset = newOffset.clamp(0.0, 70.0);
            } else {
              _offset = 0.0;
            }
          }
        });
      },
      onHorizontalDragEnd: (details) {
        if (_offset.abs() >= 50 && canSwipeToThisDirection) {
          widget.onReply();
        }

        setState(() {
          _offset = 0.0;
        });
      },
      onHorizontalDragCancel: () {
        setState(() {
          _offset = 0.0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(_offset, 0, 0),
        child: Stack(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            if (_offset.abs() > 10)
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Icon(
                  Icons.reply,
                  color: mainColor.withOpacity(
                    (_offset.abs() / 70).clamp(0, 1),
                  ),
                  size: 25,
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}
