import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/the_chat.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';

import '../../shared/networks/local/cache_helper.dart';

class UserChats extends StatefulWidget {
  const UserChats({super.key});

  @override
  State<UserChats> createState() => _UserChatsState();
}

class _UserChatsState extends State<UserChats> {
  String myUserId = CacheHelper.getData(key: 'uid');
  final Stream<QuerySnapshot> chatStreamBuilder = FirebaseFirestore.instance
      .collection('chats')
      .where('users', arrayContains: CacheHelper.getData(key: 'uid'))
      .orderBy('lastUpdate', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              header(
                title: 'الدردشة',
                context: context,
              ),
              StreamBuilder(
                stream: chatStreamBuilder,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'حدث خطأ ما...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ChatShimmerLoading(isDark: appCubit.isDark);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 500.h,
                      child: ChatShimmerLoading(isDark: appCubit.isDark),
                    );
                  }
                  var docs = snapshot.data!.docs;
                  return Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsetsDirectional.only(start: 10.w, top: 20.h, bottom: 20.h, end: 10.w),
                        itemCount: docs.length*4,
                        itemBuilder: (context, index) {
                          var doc = docs[0];
                          var chatData = doc.data() as Map<String, dynamic>;
                          String lastMessage = chatData['lastMessage'] ?? '';
                          var unReadCount = (chatData['unreadCount'] ?? {})[myUserId] ?? 0;
                          List users = chatData['users'] ?? [];
                          String otherUser = users.firstWhere((id) => id != myUserId, orElse: () => '');
                          Map<String, dynamic> usersInfo = chatData['userInfo'] ?? {};
                          var otherUserData = usersInfo[otherUser] ?? {};
                          var otherUsername = otherUserData['name'] ?? 'مستخدم';
                          var otherUserImage = otherUserData['image'] ?? '';
                          bool isMe = chatData['lastSenderId'] == myUserId;
                          Map<String, dynamic> unreadMap = chatData['unreadCount'] ?? {};
                          int otherUnread = unreadMap[otherUser] ?? 0;

                          bool otherHasRead = otherUnread == 0;
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => move(context, TheChat(
                                  otherUsername: otherUsername,
                                  otherUserImage: otherUserImage,
                                  otherUserId: otherUser,
                                  myId: myUserId,
                                  chatId: doc.id,
                                )),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: otherUserImage != null &&
                                      otherUserImage != ''
                                      ? NetworkImage(otherUserImage)
                                      : null,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  radius: 27.r,
                                  child: otherUserImage == null ||
                                          otherUserImage == ''
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                SizedBox(width: 10.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  fontSize: 14.sp,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            child: Text(
                                             timeFormatStatusTime(
                                                  chatData['lastUpdate']),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 9.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          isMe
                                              ? SvgPicture.asset(
                                                  otherHasRead
                                                      ? 'assets/checks.svg'
                                                      : 'assets/check.svg',
                                                  color: Colors.grey,
                                                  width: 13.w,
                                                )
                                              : const SizedBox(),
                                          SizedBox(width: 5.w,),
                                          Expanded(
                                            child: Text(
                                              lastMessage,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11.sp
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          unReadCount != 0
                                              ? Container(
                                                  height: 17.h,
                                                  width: 17.w,
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(top: 4.h),
                                                    child: Text(
                                                      '$unReadCount',
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        color: Colors.white,
                                                        height: 1,
                                                        leadingDistribution:
                                                            TextLeadingDistribution
                                                                .even,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 17.h,
                        ),
                      ));
                },
              ),
            ],
          ),
        ));
      },
    );
  }
}
