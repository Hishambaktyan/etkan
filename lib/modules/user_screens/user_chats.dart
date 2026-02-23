import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/the_chat.dart';

import '../../shared/compenents/components.dart';

class UserChats extends StatefulWidget {
  const UserChats({super.key});

  @override
  State<UserChats> createState() => _UserChatsState();
}

class _UserChatsState extends State<UserChats> {
  final List<Map<String, dynamic>> chatData = [
    {
      'name': 'محمد علي اليوسفي',
      'message': 'السلام عليكم، لو سمحت اشتي اركب حوض',
      'time': '١٠:٣٠ ص',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
    {
      'name': 'أحمد عبدالله',
      'message': 'تم إرسال الموقع، بانتظارك في الموقع الجديد',
      'time': '٠٩:١٥ ص',
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
      'isRead': false,
      'unreadCount': 3,
    },
    {
      'name': 'خالد جابر',
      'message': 'شكراً جزيلاً على الخدمة الممتازة يا هندسة',
      'time': 'أمس',
      'image': 'https://randomuser.me/api/portraits/men/45.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
    {
      'name': 'عمر الشريف',
      'message': 'بكم تكلفة إصلاح تسريب الحمام؟',
      'time': '٢٠٢٦/١/٢١',
      'image': 'https://randomuser.me/api/portraits/men/22.jpg',
      'isRead': false,
      'unreadCount': 1,
    },
    {
      'name': 'ياسين المقطري',
      'message': 'اتصلت بك ولم ترد، يرجى التواصل للضرورة',
      'time': '٢٠٢٦/١/٢٠',
      'image': 'https://randomuser.me/api/portraits/men/55.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
    {
      'name': 'عبدالرحمن قاسم',
      'message': 'ارسل لي الفاتورة لو سمحت على الواتساب',
      'time': '٢٠٢٦/١/١٩',
      'image': 'https://randomuser.me/api/portraits/men/60.jpg',
      'isRead': false,
      'unreadCount': 5,
    },
    {
      'name': 'إبراهيم الصبري',
      'message': 'أحتاج صيانة دورية للمجمع السكني',
      'time': '٢٠٢٦/١/١٨',
      'image': 'https://randomuser.me/api/portraits/men/75.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
    {
      'name': 'فؤاد حسن',
      'message': 'متى تقدر تجي البيت؟ الوالد ينتظرك',
      'time': '٢٠٢٦/١/١٥',
      'image': 'https://randomuser.me/api/portraits/men/80.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
    {
      'name': 'هشام الخولاني',
      'message': 'تمام، اتفقنا على السعر المذكور',
      'time': '٢٠٢٦/١/١٠',
      'image': 'https://randomuser.me/api/portraits/men/90.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
    {
      'name': 'صالح المحمدي',
      'message': 'تم تحويل المبلغ لحسابك البنكي الآن',
      'time': '٢٠٢٦/١/٠١',
      'image': 'https://randomuser.me/api/portraits/men/12.jpg',
      'isRead': false,
      'unreadCount': 2,
    },
    {
      'name': 'ماجد الضبيبي',
      'message': 'يا باشا القطع اللي ركبناها ممتازة جداً',
      'time': '٢٠٢٦/١/٠١',
      'image': 'https://randomuser.me/api/portraits/men/18.jpg',
      'isRead': true,
      'unreadCount': 0,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
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
           Row( // 4. إذا لم يكن هناك تحديد، نظهر أزرارك القديمة (البحث والإشعارات)
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
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(start:10.w,top: 20.h,bottom: 20.h,end:10.w),
              itemBuilder: (context, index) {
              var chat = chatData[index];
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: ()=>move(context, TheChat(pfp: chat['image'], name: chat['name'])),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                        radius: 27.r,
                        backgroundImage:NetworkImage(
                            chat['image']
                        )
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
                                  chat['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(
                                  chat['time'],
                                  style: TextStyle(
                                      color: chat['unreadCount']!=0?Colors.green:Colors.grey,
                                      fontSize: 11.sp
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if(chat['unreadCount']==0)
                                SvgPicture.asset(
                                  chat['isRead']?'assets/checks.svg':'assets/check.svg',
                                  color: chat['isRead']?Colors.blue:Colors.grey,
                                  width: 15.w,
                                  height: 15.w,
                                ),
                              SizedBox(
                                width: 3.w,
                              ),
                              SizedBox(
                                width: chat['unreadCount']!=0?240.w:250.w,
                                child: Text(
                                  chat['message'],
                                  style: TextStyle(
                                      color:Colors.grey,
                                      fontSize: 11.sp
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              if(chat['unreadCount']!=0)
                                Container(
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
                                      '${chat['unreadCount']}',
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        color: Colors.white,
                                        height: 1,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                    ),
                                  ),
                                ),
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
              itemCount: 11
          )
      ),
    );
  }
}
