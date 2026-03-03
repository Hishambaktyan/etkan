import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/cubit/states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/styles/colors.dart';

class TheChat extends StatefulWidget {
  final String chatId;
  final String otherUsername;
  final String otherUserImage;
  final String otherUserId;
  final String myId;
  static String? currentChatId;
  const TheChat(
      {super.key,
      required this.otherUsername,
      required this.otherUserImage,
      required this.otherUserId,
      required this.myId,
      required this.chatId});

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
    setState(() {
      isCurrentlyTyping = typing;
    });
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'typingStatus.${widget.myId}': typing,
    }).catchError((error) {
      print("Error updating typing status: $error");
    });
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

  @override
  void initState() {
    MyCubit cubit = MyCubit.get(context);

    cubit.resetUnreadCount(widget.chatId, widget.myId);

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
        .orderBy('timestamp',descending: true)
        .snapshots();
    cubit.markAsSeen(widget.chatId, widget.myId);
    TheChat.currentChatId = widget.chatId;
    super.initState();
  }

  late MyCubit cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit = MyCubit.get(context);
  }

  @override
  void dispose() {
    cubit.markAsSeen(widget.chatId, widget.myId);
    typingTimer?.cancel();
    messageFocus.dispose();
    scrollController.dispose();
    TheChat.currentChatId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyCubit cubit = MyCubit.get(context);
    String otherUserImage = widget.otherUserImage;
    String otherUsername = widget.otherUsername;
    String otherUserId = widget.otherUserId;
    String myId = widget.myId;
    return BlocConsumer<MyCubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon:  Icon(
                    CupertinoIcons.back,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(otherUserImage),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                      otherUsername,
                      style:
                          TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge!.color
                          )
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon:  Icon(
                        Icons.more_vert_rounded,
                      color: Theme.of(context).iconTheme.color,
                    )
                )
              ],
            ),
            body: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                MyCubit.get(context).markAsSeen(widget.chatId, widget.myId);
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'حدث خطأ ما...):',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    )
                    ,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد دردشات...):',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    )
                    ,
                  );
                }
                var docs = snapshot.data!.docs;
                for (var doc in docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  if (data['receiverId'] == widget.myId && data['isSeen'] == false) {
                    cubit.markAsSeen(widget.chatId, widget.myId);
                    break;
                  }
                }
                return Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                              padding: EdgeInsetsDirectional.only(bottom: 10.h),
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                var doc = docs[index];
                                var chatData = doc.data() as Map<String, dynamic>;
                                bool isMe = chatData['senderId'] == myId ? true : false;
                                return SwipeableMessage(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.symmetric(
                                          vertical: 7.h, horizontal: 7.w),
                                      child: Align(
                                        alignment: isMe
                                            ? AlignmentDirectional.centerEnd
                                            : AlignmentDirectional.centerStart,
                                        child: Container(
                                          padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 8.h, bottom: 2.h),
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context).size.width * 0.75),
                                          decoration: BoxDecoration(
                                            color: isMe
                                                ? cubit.isDark ? Colors.blue.shade800 : Colors.blue.shade700
                                                : cubit.isDark ? const Color(0xFF1C2128) : Colors.blue.withOpacity(0.3),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.r),
                                              topRight: Radius.circular(15.r),
                                              bottomLeft: isMe ? const Radius.circular(0) : Radius.circular(15.r),
                                              bottomRight: isMe ? Radius.circular(15.r) : const Radius.circular(0),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                            children: [
                                              if (chatData['replyText'] != null)
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 5.h),
                                                  padding: EdgeInsets.all(8.r),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.05),
                                                    borderRadius: BorderRadius.circular(10.r),
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: isMe ? Colors.white70 : mainColor,
                                                        width: 3.w,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        chatData['replyName'] ?? '',
                                                        style: TextStyle(
                                                          color: isMe ? Colors.white : mainColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        chatData['replyText'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: isMe ? Colors.white70 : Colors.grey.shade700,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              Text(
                                                chatData['text'],
                                                style: TextStyle(
                                                    color: isMe
                                                        ? Colors.white
                                                        : cubit.isDark ? Colors.white.withOpacity(0.9) : Colors.black,
                                                    fontSize: 13.sp),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cubit.timeFormatStatusTime(chatData['timestamp']),
                                                    style: TextStyle(
                                                        color: isMe ? Colors.green.shade100 : Colors.grey,
                                                        fontSize: 8.sp),
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  isMe
                                                      ? cubit.buildMessageStatus(
                                                    chatData['messageStatus'] ?? 'sent',
                                                    chatData['isSeen'] ?? false,
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
                                    onReply: (){
                                      onReply(chatData);
                                    },
                                );
                              },
                              itemCount: docs.length),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('chats').doc(widget.chatId).snapshots(),
                          builder: (context, typingSnapshot) {
                            if (typingSnapshot.hasData && typingSnapshot.data!.exists) {
                              var data = typingSnapshot.data!.data() as Map<String, dynamic>;
                              var typingMap = data['typingStatus'] as Map<String, dynamic>?;
                              bool isOtherTyping = typingMap?[widget.otherUserId] ?? false;

                              if (isOtherTyping) {
                                return AnimatedOpacity(
                                  opacity: isOtherTyping ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Container(
                                      margin: EdgeInsetsDirectional.only(start: 7.w),
                                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 3,vertical: 8),
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.15),
                                      decoration: BoxDecoration(
                                        color: cubit.isDark? lightDarkColor: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.r),
                                          topRight: Radius.circular(15.r),
                                          bottomLeft: Radius.circular(15.r),
                                          bottomRight: const Radius.circular(0),
                                        ),
                                      ),
                                      child:  SpinKitThreeBounce(
                                        color: cubit.isDark? Colors.grey.shade300: Colors.grey,
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
                                      color: cubit.isDark ? const Color(0xFF161B22) : Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(17.r),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (replyMessage != null)
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(8.r),
                                            margin: EdgeInsets.all(5.r),
                                            decoration: BoxDecoration(
                                              color: cubit.isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(12.r),
                                              border: Border(
                                                right: BorderSide(color: mainColor, width: 4.w),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        replyMessage!['senderId']==myId?
                                                          'أنت'
                                                            : otherUsername,
                                                        style: TextStyle(
                                                          color: mainColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                      Text(
                                                        replyMessage!['text'] ?? '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      replyMessage = null;
                                                    });
                                                  },
                                                  child: Icon(Icons.close, size: 18.r, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        TextFormField(
                                          controller: cubit.message,
                                          focusNode: messageFocus,
                                          style: TextStyle(fontSize: 12.sp),
                                          minLines: 1,
                                          maxLines: 5,
                                          onChanged: (value) {
                                            setState(() {
                                              cubit.isTyping = value.isNotEmpty;
                                            });

                                            if (value.isNotEmpty) {
                                              setTypingStatus(true);
                                              typingTimer?.cancel();
                                              typingTimer = Timer(const Duration(seconds: 1), () {
                                                setTypingStatus(false);
                                              });
                                            } else {
                                              typingTimer?.cancel();
                                              setTypingStatus(false);
                                            }
                                          },
                                          keyboardType: TextInputType.multiline,
                                          textAlignVertical: TextAlignVertical.center,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsetsDirectional.symmetric(
                                              horizontal: 15.w,
                                              vertical: 10.h,
                                            ),
                                            hintText: 'ارسل رسالة...',
                                            hintStyle: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.grey,
                                            ),
                                            border: InputBorder.none,
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (!cubit.isTyping)
                                                  InkWell(
                                                    splashColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    onTap: () {},
                                                    child: SvgPicture.asset(
                                                      'assets/camera.svg',
                                                      height: 23.h,
                                                      width: 23.h,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                SizedBox(width: 15.w),
                                                InkWell(
                                                  onTap: () {},
                                                  child: SvgPicture.asset(
                                                    'assets/clip.svg',
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
                                FloatingActionButton(
                                  onPressed: () async {
                                    String? rText = replyMessage != null ? replyMessage!['text'] : null;
                                    String? rName = replyMessage != null
                                        ? (replyMessage!['senderId'] == myId ? 'أنت' : widget.otherUsername)
                                        : null;
                                    setState(() {
                                      replyMessage = null;
                                    });
                                    await cubit.sendMessage(widget.chatId, otherUserId, myId,rText,rName  );

                                  },
                                  elevation: 0,
                                  shape: const CircleBorder(),
                                  backgroundColor: mainColor,
                                  splashColor: Colors.transparent,
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 25.h,
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
                            backgroundColor: cubit.isDark? const Color(0xFF161B22) :Colors.white,
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
  }
}

class SwipeableMessage extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;

  const SwipeableMessage({super.key, required this.child, required this.onReply});

  @override
  State<SwipeableMessage> createState() => _SwipeableMessageState();
}

class _SwipeableMessageState extends State<SwipeableMessage> {
  double _offset = 0.0; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        setState(() {
          _offset += details.delta.dx;
          if (_offset.abs() > 70) _offset = _offset.sign * 70;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_offset.abs() >= 50) {
          widget.onReply(); 
        }
        setState(() => _offset = 0.0); 
      },
      onHorizontalDragCancel: () {
        setState(() {
          _offset = 0.0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack, //  (Bounce)
        transform: Matrix4.translationValues(_offset, 0, 0),
        child: Stack(
          alignment: _offset > 0 ? Alignment.centerLeft : Alignment.centerRight,
          children: [
            if (_offset.abs() > 10)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.reply,
                  color: mainColor.withOpacity((_offset.abs() / 70).clamp(0, 1)),
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