import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/contact_us_screen.dart';
import 'package:trying_homy/modules/edit_profile_screen.dart';
import 'package:trying_homy/modules/faq_Screen.dart';
import 'package:trying_homy/modules/user_screens/fav_services.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';
import '../on_boarding.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {

  List<Map<String, dynamic>> settingsList = [
    {'title': 'عرض الحساب', 'icon': 'assets/eye.svg'},
    {'title': 'الخدمات المفضلة', 'icon': 'assets/heart.svg'},
    {'title': 'مشاركة التطبيق', 'icon': 'assets/share.svg'},
    {'title': 'تواصل معنا', 'icon': 'assets/chat.svg'},
    {'title': 'الأسئلة الشائعة', 'icon': 'assets/ques.svg'},
    {'title': 'الوضع المظلم', 'icon': 'assets/moon.svg'},
    {'title': 'تسجيل خروج', 'icon': 'assets/out.svg'},
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
                  value: AppCubit.get(context).isDark,
                  activeColor: mainColor,
                  onChanged: (v) {
                    setState(() {
                      AppCubit.get(context).isDark = v;
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
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit,AppStates>(
      builder: (context, state) {
          return BlocConsumer<AuthCubit,AuthStates>(
            listener: (context, state) {
              if (state is LogOutSuccessState) {
                showSnackBar(Colors.green, 'تم تسجيل خروجك بنجاح', context);
                moveAndReplace(context, const OnBoardingScreen());
                appCubit.changeIndex(0);
              }
              if (state is LogOutErrorState) {
                showSnackBar(Colors.red, state.error, context);
              }
            },
              builder: (context, state) {
              Map<String,dynamic> user = appCubit.allUsers[FirebaseAuth.instance.currentUser!.uid];
              AuthCubit authCubit = AuthCubit.get(context);
                return state is LogOutLoadingState ? const Center(child: CircularProgressIndicator())
                : Scaffold(
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
                                                  backgroundImage: NetworkImage(
                                                      user['profileImage']
                                                  ),
                                                ),
                                                SizedBox(height: 10.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      user['name'],
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h,),
                                                    Text(
                                                      user['phone'],
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
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
                            child: Column(
                              children: [
                                buildItem(
                                    title: settingsList[0]['title'],
                                    icon: settingsList[0]['icon'],
                                    onTap: ()=>move(context, const EditProfileScreen())
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[1]['title'],
                                    icon: settingsList[1]['icon'],
                                    onTap: ()=>move(context, const FavServices())
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[2]['title'],
                                    icon: settingsList[2]['icon'],
                                    onTap: () {}
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[3]['title'],
                                    icon: settingsList[3]['icon'],
                                    onTap: ()=>move(context, const ContactUsScreen())
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[4]['title'],
                                    icon: settingsList[4]['icon'],
                                    onTap: ()=>move(context, const FaqScreen())
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[5]['title'],
                                    icon: settingsList[5]['icon'],
                                    isSwitch: true,
                                    onTap: ()=>appCubit.changeTheme()
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[6]['title'],
                                    icon: settingsList[6]['icon'],
                                    isDanger: true,
                                    onTap: () => showDialog(
                                      context: context,
                                      barrierColor: Colors.black.withOpacity(0.2),
                                      builder: (BuildContext context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Stack(
                                            children: [
                                              BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                child: Container(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              Center(
                                                child: AlertDialog(
                                                  backgroundColor: appCubit.isDark ? lightDarkColor : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.r),
                                                  ),
                                                  contentPadding: EdgeInsets.all(20.r),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.all(15.r),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red.withOpacity(0.1),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.logout_rounded,
                                                          color: Colors.red,
                                                          size: 50.r,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20.h),
                                                      Text(
                                                        'تأكيد تسجيل الخروج',
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Text(
                                                        'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                      SizedBox(height: 25.h),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: defualtButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              text: 'إلغاء',
                                                            ),
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Expanded(
                                                            child: defualtOutlinedButton(
                                                              onPressed: () async =>
                                                              await authCubit.logOutUser(),
                                                              text: 'خروج',
                                                              border: Colors.red,
                                                              textColor: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                ),
                                Divider(color: Colors.grey.withOpacity(.4),),
                                buildItem(
                                    title: settingsList[7]['title'],
                                    icon: settingsList[7]['icon'],
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
              },
          );
        },
    );
  }
}
