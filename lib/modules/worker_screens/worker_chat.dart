import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/the_chat.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';

class WorkerChat extends StatefulWidget {
  const WorkerChat({super.key});

  @override
  State<WorkerChat> createState() => _WorkerChatState();
}

class _WorkerChatState extends State<WorkerChat> {
  Future<void> createChat({
    required String receiverId,
    required String receiverName,
    required String receiverImage,
    required String myId,
    required String myName,
    required String myImage,
  })
  async {
    try {
      List<String> ids = [myId, receiverId];
      ids.sort();
      String chatId = ids.join('_');

      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'users': ids,
        'lastMessage': '',
        'lastUpdate': FieldValue.serverTimestamp(),
        'typingStatus': {
          myId: false,
          receiverId: false,
        },
        'userInfo': {
          myId: {
            'name': myName,
            'image': myImage,
          },
          receiverId: {
            'name': receiverName,
            'image': receiverImage,
          },
        },
      }, SetOptions(merge: true));

      print('^^^^^^^^^^^^^^^^^^^^^^^^^^Done^^^^^^^^^^^^^^^^^^^^^^^^^');

    } catch (e) {
    }
  }
  String myUserId = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> chatStreamBuilder = FirebaseFirestore.instance
      .collection('chats')
      .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid )
      .orderBy('lastUpdate',descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
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
                    color: Theme.of(context).textTheme.bodyLarge!.color
                ),
              ),
              actions: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey)
                    ),
                    child: SvgPicture.asset(
                      'assets/search.svg',
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    /* createChat(
                  receiverId: 'FeIIQoLQZuSiVK2T2q2WBcOjMsn2',
                  receiverName: 'رهوف',
                  receiverImage: 'https://i.pinimg.com/736x/4a/1e/04/4a1e04e7c7bc16fa60ecdbbc6ba0f132.jpg',
                  myId: 'zgyZCfttdmWsmKTNWneC4vbD7sX2',
                  myName: 'هشوم',
                  myImage: 'https://i.pinimg.com/736x/3a/c2/fb/3ac2fb4b957b419d53b85a4675e8770a.jpg',
              );*/
                    /*MyCubit.get(context).message.text='السلاااااااااااام';
              MyCubit.get(context).sendMessage(
                  'FeIIQoLQZuSiVK2T2q2WBcOjMsn2_zgyZCfttdmWsmKTNWneC4vbD7sX2',
                  'FeIIQoLQZuSiVK2T2q2WBcOjMsn2',
                'zgyZCfttdmWsmKTNWneC4vbD7sX2'
              );*/
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
                        SvgPicture.asset(
                          'assets/not.svg',
                          color: Theme.of(context).iconTheme.color,
                        ),
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
            body: StreamBuilder(
              stream: chatStreamBuilder,
              builder: (context, snapshot) {
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
                if (snapshot.connectionState == ConnectionState.waiting) return ChatShimmerLoading(isDark: cubit.isDark);
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
                return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(start:10.w,top: 20.h,bottom: 20.h,end:10.w),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {

                        var doc = docs[index];
                        var chatData = doc.data() as Map<String, dynamic>;
                        String lastMessage = chatData['lastMessage'] ?? '';
                        var unReadCount = (chatData['unreadCount'] ?? {})[myUserId] ?? 0;

                        List users = chatData['users'] ?? [];
                        String otherUser =
                        users.firstWhere((id) => id != myUserId, orElse: () => '');

                        Map<String, dynamic> usersInfo = chatData['userInfo'] ?? {};

                        var otherUserData = usersInfo[otherUser] ?? {};

                        var otherUsername = otherUserData['name'] ?? 'مستخدم';
                        var otherUserImage = otherUserData['image'] ?? '';

                        bool isMe = chatData['lastSenderId'] == myUserId;

                        Map<String, dynamic> unreadMap = chatData['unreadCount'] ?? {};
                        int otherUnread = unreadMap[otherUser] ?? 0;

                        bool otherHasRead = otherUnread == 0;
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
                                backgroundColor: Colors.grey.withOpacity(0.1),
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
                                            style: TextStyle(
                                                color: Theme.of(context).textTheme.bodyLarge!.color
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          alignment: AlignmentDirectional.centerEnd,
                                          child: Text(
                                            cubit.timeFormatStatusTime(chatData['lastUpdate']),
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
                                        isMe
                                            ? SvgPicture.asset(
                                          otherHasRead ? 'assets/checks.svg' : 'assets/check.svg',
                                          color: Colors.grey,
                                          width: 15.w,
                                          height: 15.w,
                                        )
                                            : const SizedBox(),
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
        },
    );
  }
}
