import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/contact_us_screen.dart';
import 'package:trying_homy/modules/login_screen.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  bool isDark = false;

  List<Map<String, dynamic>> settingsList = [
    {'title': 'عرض الحساب', 'icon': 'assets/eye.svg'},
    {'title': 'مشاركة التطبيق', 'icon': 'assets/share.svg'},
    {'title': 'تواصل معنا', 'icon': 'assets/chat.svg'},
    {'title': 'الأسئلة الشائعة', 'icon': 'assets/ques.svg'},
    {'title': 'الوضع المظلم', 'icon': 'assets/moon.svg'},
    {'title': 'تسجيل خروج', 'icon': 'assets/login.svg'},
    {'title': 'حذف الحساب', 'icon': 'assets/delete.svg'},
  ];

  Widget buildItem({
    required String title,
    required String icon,
    bool isSwitch = false,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              color: isDanger ? Colors.red : Colors.black,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                color: isDanger ? Colors.red : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSwitch)
              Transform.scale(
                scale: .8,
                child: Switch(
                  value: isDark,
                  activeColor: mainColor,
                  onChanged: (v) {
                    setState(() {
                      isDark = v;
                    });
                  },
                ),
              )
            else
              Icon(
                Icons.navigate_next_rounded,
                color: isDanger
                    ? Colors.red.withOpacity(.5)
                    : Colors.grey.withOpacity(.6),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            mainColor.withOpacity(0.9),
                            const Color(0xFF0F0F1E),
                          ],
                          stops: const [
                            0.0,
                            0.8,
                          ]
                      )
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50.h,
                        left: -50.w,
                        child: CircleAvatar(
                          radius: 100.r,
                          backgroundColor: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      Positioned(
                        top: 80.h,
                        right: -60.w,
                        child: Container(
                          width: 250.r,
                          height: 250.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFF00F2FF).withOpacity(0.5),
                                const Color(0xFF00F2FF).withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 200.h,
                        left: -40.w,
                        child: Container(
                          width: 200.r,
                          height: 200.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                mainColor.withOpacity(0.4),
                                mainColor.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w,bottom: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'الحساب',
                                    style: TextStyle(
                                        fontSize: 23.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsetsDirectional.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/not.svg',
                                        width: 23.w,
                                        height: 23.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 45.r,
                                      backgroundColor: Colors.white.withOpacity(0.1),
                                      backgroundImage: const NetworkImage(
                                          'https://i.pinimg.com/736x/0e/45/8b/0e458b14989d9435ae048281a8b29c82.jpg'),
                                    ),
                                    SizedBox(height: 10.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'هشام هاني أحمد',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5.h,),
                                        Text(
                                          '770770858',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            letterSpacing: 5
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
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
                child: Column(
                  children: [
                    buildItem(
                        title: settingsList[0]['title'],
                        icon: settingsList[0]['icon'],
                        onTap: () {}
                    ),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    buildItem(
                        title: settingsList[1]['title'],
                        icon: settingsList[1]['icon'],
                        onTap: () {}
                    ),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    buildItem(
                        title: settingsList[2]['title'],
                        icon: settingsList[2]['icon'],
                        onTap: ()=>move(context, const ContactUsScreen())
                    ),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    buildItem(
                        title: settingsList[3]['title'],
                        icon: settingsList[3]['icon'],
                        onTap: () {}
                    ),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    buildItem(
                        title: settingsList[4]['title'],
                        icon: settingsList[4]['icon'],
                        isSwitch: true,
                      onTap: (){}
                    ),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    buildItem(
                        title: settingsList[5]['title'],
                        icon: settingsList[5]['icon'],
                        isDanger: true,
                        onTap: () => move(context, const LoginScreen())
                    ),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    buildItem(
                        title: settingsList[6]['title'],
                        icon: settingsList[6]['icon'],
                        isDanger: true,
                        onTap: () {}
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
