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
import '../../shared/styles/colors.dart';

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
            body: StreamBuilder(
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
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        header(title: 'المحادثات', context: context),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            width: double.infinity,
                            child:  Padding(
                              padding:  EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100.w,
                                    height:100.w,
                                    padding: EdgeInsets.all(15.r),
                                    decoration: BoxDecoration(
                                      color: mainColor.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/chat.svg',
                                      color: mainColor,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    'لا توجد محادثات لديك',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'عند حجز أي خدمة وقبولها من طرف الفني ستظهر المحادثات للحجز هنا.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      height: 1.6,
                                      color: appCubit.isDark
                                          ? darkSubTextColor
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  );
                }

                var docs = snapshot.data!.docs;
                return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        header(
                          title: 'المحادثات',
                          context: context,
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsetsDirectional.only(start: 10.w, top: 20.h, bottom: 20.h, end: 10.w),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var doc = docs[index];
                              var chatData = doc.data() as Map<String, dynamic>;
                              String lastMessage = chatData['lastMessage'] ?? '';
                              String lastMessageType = chatData['lastMessageType'] ?? 'text';

                              String displayLastMessage;

                              if (lastMessage.isEmpty) {
                                displayLastMessage = 'ابدأ المحادثة الآن';
                              }
                              else if (lastMessageType == 'image') {
                                displayLastMessage = 'صورة';
                              }
                              else {
                                displayLastMessage = lastMessage;
                              }

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
                              final requestId = chatData['requestId'] ?? '';
                              final requestStatus = chatData['requestStatus'] ?? '';

                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(18.r),
                                onTap: () => move(context,
                                  TheChat(
                                    otherUsername: otherUsername,
                                    otherUserImage: otherUserImage,
                                    otherUserId: otherUser,
                                    myId: myUserId,
                                    chatId: doc.id,
                                    requestId: requestId,
                                    requestStatus: requestStatus,
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h,),
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? const Color(0xFF161B22)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow
                                  ),
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.bottomStart,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: otherUserImage.toString().isNotEmpty
                                                ? NetworkImage(otherUserImage)
                                                : null,
                                            backgroundColor: Colors.grey.withOpacity(0.12),
                                            radius: 25.r,
                                            child: otherUserImage.toString().isEmpty
                                                ? Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                              size: 25.r,
                                            )
                                                : null,
                                          ),
                                          if (unReadCount != 0)
                                            Container(
                                              height: 18.h,
                                              width: 18.w,
                                              padding: EdgeInsetsDirectional.only(top: 4.r),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: appCubit.isDark
                                                      ? const Color(0xFF161B22)
                                                      : Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                '$unReadCount',
                                                style: TextStyle(
                                                  fontSize: 8.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    otherUsername,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Text(
                                                  timeFormatStatusTime(chatData['lastUpdate']),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 9.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h),
                                            Container(
                                              padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h,),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.10),
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              child: Text(
                                                requestId.isNotEmpty
                                                    ? 'عنوان الحجز: ${chatData['requestTitle']}'
                                                    : 'حجز خدمة',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 9.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 6.h),

                                            Row(
                                              children: [
                                                if (isMe)
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.only(end: 5.w),
                                                    child: SvgPicture.asset(
                                                      otherHasRead
                                                          ? 'assets/checks.svg'
                                                          : 'assets/check.svg',
                                                      color: Colors.grey,
                                                      width: 14.w,
                                                      height: 14.w,
                                                    ),
                                                  ),

                                                Expanded(
                                                  child: Text(
                                                    displayLastMessage,
                                                    style: TextStyle(
                                                      color: unReadCount != 0
                                                          ? Theme.of(context).textTheme.bodyLarge!.color
                                                          : Colors.grey,
                                                      fontSize: 11.sp,
                                                      fontWeight: unReadCount != 0
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 17.h,
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            ));
      },
    );
  }
}
