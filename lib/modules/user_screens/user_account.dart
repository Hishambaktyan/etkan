import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
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

  Widget divider() {
    return Divider(
      color: Colors.grey.withOpacity(.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'الحساب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.sp,
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset(
                        'assets/not.svg',
                        width: 22.w,
                        height: 22.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w)
            ],
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              top: 10.h, start: 20.w, end: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: CircleAvatar(
                        radius: 35.r,
                        backgroundColor: Colors.grey.withOpacity(.1),
                        backgroundImage: const NetworkImage(
                            'https://i.pinimg.com/736x/0e/45/8b/0e458b14989d9435ae048281a8b29c82.jpg'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'هشام هاني أحمد',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '770770858',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 43.h,
                        child: defualtButton(
                          textSize: 12,
                          onPressed: () {},
                          text: 'عرض الحساب',
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: defualtOutlinedButton(
                        fontSize: 12,
                        onPressed: () {},
                        text: 'تعديل الحساب',
                        height: 43.h,
                        textColor: mainColor,
                        border: mainColor,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25.h),
                buildItem(
                    title: settingsList[0]['title'],
                    icon: settingsList[0]['icon'],
                    onTap: () {}),
                divider(),
                buildItem(
                    title: settingsList[1]['title'],
                    icon: settingsList[1]['icon'],
                    onTap: () {}),
                divider(),
                buildItem(
                    title: settingsList[2]['title'],
                    icon: settingsList[2]['icon'],
                    onTap: () {}),
                divider(),
                buildItem(
                    title: settingsList[3]['title'],
                    icon: settingsList[3]['icon'],
                    isSwitch: true,
                    onTap: () {}),
                divider(),
                buildItem(
                    title: settingsList[4]['title'],
                    icon: settingsList[4]['icon'],
                    isDanger: true,
                    onTap: () => move(context, const LoginScreen())),
                divider(),
                buildItem(
                    title: settingsList[5]['title'],
                    icon: settingsList[5]['icon'],
                    isDanger: true,
                    onTap: () {}),
                SizedBox(height: 40.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
