import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/cubit/states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../shared/styles/colors.dart';

class WorkerChat extends StatefulWidget {
  const WorkerChat({super.key});

  @override
  State<WorkerChat> createState() => _WorkerChatState();
}

class _WorkerChatState extends State<WorkerChat> {
  String myUserId = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> chatStreamBuilder = FirebaseFirestore.instance
      .collection('chats')
      .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid )
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'الدردشة',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.sp,
              color: Colors.black
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: SvgPicture.asset('assets/search.svg'),
                ),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: () {
                  setState(() {

                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset('assets/not.svg'),
                      if (true)
                        CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: chatStreamBuilder,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('حدث خطأ ما...:('));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var docs = snapshot.data!.docs;
          return Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsetsDirectional.only(start:10.w,top: 20.h,bottom: 20.h,end:10.w),
                itemCount: docs.length,
                itemBuilder: (context, index) {

                  var doc = docs[index];
                  var chatData = doc.data() as Map<String, dynamic>;

                  Timestamp lastUpdate = chatData['lastUpdate'];
                  DateTime date = lastUpdate.toDate();
                  String time = DateFormat('hh:mm a').format(date).replaceAll('AM', 'ص').replaceAll('PM', 'م');

                  String lastMessage = chatData['lastMessage'] ?? '';
                  var unReadCount = (chatData['unreadCount'] ?? {})[myUserId] ?? 0;

                  List users = chatData['users'] ?? [];
                  String otherUser =
                  users.firstWhere((id) => id != myUserId, orElse: () => '');

                  Map<String,dynamic> usersInfo = chatData['userInfo'] ?? {};
                  var otherUsername = usersInfo[otherUser]['name'] ?? 'مستخدم';
                  var otherUserImage = usersInfo[otherUser]['image'] ?? '';

                  bool isMe = chatData['lastSenderId'] == myUserId;
                  return InkWell(
                    onLongPress: ()=>print(lastMessage),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: ()=>move(context, TheChat(otherUsername: otherUsername, otherUserImage: otherUserImage,
                      otherUserId: otherUser, myId: myUserId,chatId: doc.id,)),
                    child:  Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: otherUserImage != null && otherUserImage != ''
                              ? NetworkImage(otherUserImage)
                              : null,
                          radius: 23.r,
                          child: otherUserImage == null || otherUserImage == ''
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 190.w,
                                    child: Text(
                                      otherUsername,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Text(
                                      time,
                                      style: TextStyle(
                                          color:Colors.grey,
                                          fontSize: 10.sp
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  isMe && unReadCount == 0
                                      ? SvgPicture.asset(
                                    chatData['isLastMessagesRead']
                                        ? 'assets/checks.svg'
                                        : 'assets/check.svg',
                                    color: chatData['isLastMessagesRead']
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 15.w,
                                    height: 15.w,
                                  ) : const SizedBox(),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      lastMessage,
                                      style: TextStyle(
                                          color:Colors.grey,
                                          fontSize: 11.sp
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  unReadCount != 0 ? Container(
                                    height: 17.h,
                                    width: 17.w,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(top: 4.h),
                                      child: Text(
                                        '$unReadCount',
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                          height: 1,
                                          leadingDistribution: TextLeadingDistribution.even,
                                        ),
                                      ),
                                    ),
                                  ) : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height:17.h,),
              )
          );
        },
      ),
    );
  }
}



class TheChat extends StatefulWidget {
  final String chatId;
  final String otherUsername;
  final String otherUserImage;
  final String otherUserId;
  final String myId;
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
                icon: const Icon(CupertinoIcons.back),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(otherUserImage),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(otherUsername,
                      style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
              ],
            ),
            body: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                MyCubit.get(context).markAsSeen(widget.chatId, widget.myId);
                if (snapshot.hasError) {
                  return const Center(child: Text('حدث خطأ ما...:('));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('لا توجد رسائل بعد'));
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
                                var chatData =
                                doc.data() as Map<String, dynamic>;
                                bool isMe =
                                chatData['senderId'] == myId ? true : false;

                                final DateTime date =
                                    (chatData['timestamp'] as Timestamp?)
                                        ?.toDate() ??
                                        DateTime.now();
                                final String time = DateFormat('hh:mm a')
                                    .format(date)
                                    .replaceAll('AM', 'ص')
                                    .replaceAll('PM', 'م');

                                return Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      vertical: 7.h, horizontal: 7.w),
                                  child: Align(
                                    alignment: isMe
                                        ? AlignmentDirectional.centerEnd
                                        : AlignmentDirectional.centerStart,
                                    child: Container(
                                      padding: EdgeInsetsDirectional.only(start: 10.w,end: 10.w,top: 8.h,bottom: 2.h),
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.75),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? Colors.green.shade400
                                            : Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.r),
                                          topRight: Radius.circular(15.r),
                                          bottomLeft: isMe
                                              ? const Radius.circular(0)
                                              : Radius.circular(15.r),
                                          bottomRight: isMe
                                              ? Radius.circular(15.r)
                                              : const Radius.circular(0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chatData['text'],
                                            style: TextStyle(
                                                color: isMe
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 11.sp),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: isMe
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                time,
                                                style: TextStyle(
                                                    color: isMe
                                                        ? Colors
                                                        .green.shade100
                                                        : Colors.grey,
                                                    fontSize: 8.sp),
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              isMe
                                                  ? cubit
                                                  .buildMessageStatus(
                                                chatData[
                                                'messageStatus'] ??
                                                    'sent',
                                                chatData['isSeen'] ??
                                                    false,
                                                isMe,
                                              )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.r),
                                          topRight: Radius.circular(15.r),
                                          bottomLeft: Radius.circular(15.r),
                                          bottomRight: const Radius.circular(0),
                                        ),
                                      ),
                                      child: const SpinKitThreeBounce(
                                        color: Colors.grey,
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
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 15.w,
                                      vertical: 5.h,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(17.r),
                                    ),
                                    child: TextFormField(
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
                                      textAlignVertical:
                                      TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: 'ارسل رسالة...',
                                        hintStyle: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey,
                                        ),
                                        border: InputBorder.none,
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            !cubit.isTyping
                                                ? InkWell(
                                              splashColor:
                                              Colors.transparent,
                                              highlightColor:
                                              Colors.transparent,
                                              child: SvgPicture.asset(
                                                'assets/camera.svg',
                                                height: 23.h,
                                                width: 23.h,
                                                color: Colors.grey,
                                              ),
                                            )
                                                : const SizedBox(),
                                            SizedBox(width: 15.w),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                              Colors.transparent,
                                              child: SvgPicture.asset(
                                                'assets/clip.svg',
                                                height: 23.h,
                                                width: 23.h,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                FloatingActionButton(
                                  onPressed: () async {
                                    await cubit.sendMessage(widget.chatId, otherUserId, myId);
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
                            backgroundColor: Colors.white,
                            elevation: 4,
                            shape: const CircleBorder(),
                            onPressed: () => scrollToBottom(),
                            child: SvgPicture.asset(
                              'assets/down.svg',
                              width: 23.w,
                              height: 23.h,
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
