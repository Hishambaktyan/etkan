import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/login_screen.dart';

import '../../shared/compenents/components.dart';
import '../../main.dart';
import '../../shared/styles/colors.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
   List<Map<String, dynamic>> settingsList = [
     {
       'title': 'تعديل الحساب',
       'icon': 'assets/pen.svg'
     },
     {
       'title': 'مشاركة التطبيق',
       'icon': 'assets/export.svg',
     },

     {
      'title': 'تواصل معنا',
      'icon': 'assets/chat2.svg',
    },
    {
      'title': 'الأسئلة الشائعة',
      'icon': 'assets/ques.svg',
    },
    {
      'title': 'الوضع المظلم',
      'icon': 'assets/moon.svg',
    },
     {
      'title': 'تسجيل خروج',
      'icon': 'assets/out.svg'
    },
  ];
   bool isDark = false;
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
          'الحساب',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.sp
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                  setState(() {
                  });
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.all(10),
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
                        width: 25.w,
                        height: 25.h,
                      ),
                      true?Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                      ):SizedBox()
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(top: 10.h,start: 20.w,end: 20.w),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: mainColor.withOpacity(0.2),
                      radius: 40.r,
                      backgroundImage: const NetworkImage(
                        'https://i.pinimg.com/736x/0e/45/8b/0e458b14989d9435ae048281a8b29c82.jpg',
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'هشام هاني احمد',
                      style: TextStyle(
                          fontSize: 15.sp
                      ),
                    ),
                    const Text(
                      '770770858',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Expanded(
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsetsDirectional.zero,
                          itemBuilder: (context, index){
                            final setting = settingsList[index];
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 45.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: index==5?Colors.red:Colors.grey
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SvgPicture.asset(
                                        setting['icon'],
                                        color: index==5?Colors.red:Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    setting['title'],
                                    style: TextStyle(
                                        color: index==5? Colors.red:Colors.black
                                    ),
                                  ),
                                  Spacer(),
                                  index==4?Switch(
                                    value: isDark,
                                    onChanged:(value){
                                      setState(() {
                                        isDark=value;
                                      });
                                    },
                                    activeColor: mainColor,

                                  ):SizedBox(),
                                  index==4?SizedBox():Icon(
                                    Icons.navigate_next_rounded,
                                    color: index==5?Colors.red.withOpacity(0.5):Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              onTap: (){
                                if(index==5){
                                  move(context, LoginScreen());
                                }
                                else if(!(index==4)){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text(
                                              'اعداد ${setting['title']}'
                                          )
                                      ),
                                      backgroundColor: mainColor,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  );
                                }
                              },
                            );
                          } ,
                          separatorBuilder: (context, index) => SizedBox(height: 15.h,),
                          itemCount: settingsList.length
                      ),
                    ),
                    SizedBox(
                      height: 45.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
