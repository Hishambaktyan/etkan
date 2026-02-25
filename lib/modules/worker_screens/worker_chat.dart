import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/the_chat.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';

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
