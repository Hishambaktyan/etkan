import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/aboutApp_screen.dart';
import 'package:trying_homy/modules/contact_us_screen.dart';
import 'package:trying_homy/modules/faq_Screen.dart';
import 'package:trying_homy/modules/notifications_screen.dart';
import 'package:trying_homy/modules/privacy_policy_screen.dart';
import 'package:trying_homy/modules/terms_conditions_screen.dart';
import 'package:trying_homy/modules/user_screens/user_profile.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import '../../shared/compenents/components.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../on_boarding.dart';
import 'user_addresses_list.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  Widget _buildHeader({
    required AppCubit appCubit,
    required Map<String, dynamic> user,
  }) {
    String name = user['name']?.toString().trim() ?? '';
    String phone = user['phone']?.toString().trim() ?? '';
    String image = user['profileImage']?.toString().trim() ?? '';

    if (name.isEmpty) {
      name = 'مستخدم';
    }
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(35.r),
      ),
      child: Container(
        width: double.infinity,
        height: 300.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              mainColor.withOpacity(0.9),
              const Color(0xFF0F0F1E),
            ],
            stops: const [0.0, 0.8],
          ),
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
            Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 30.h, start: 10.w, end: 10.w, bottom: 20.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'الحساب',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          move(context, const NotificationsScreen());
                        },
                        child: Container(
                          width: 42.w,
                          height: 42.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/not.svg',
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 98.r,
                          height: 98.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 48.r,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            backgroundImage:
                                image.isNotEmpty ? NetworkImage(image) : null,
                            child: image.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 48.r,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Container(
                          padding: EdgeInsetsDirectional.only(
                            start: 12.w,
                            end: 15.w,
                            top: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            phone.isEmpty ? 'رقم الهاتف غير متوفر' : phone,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              letterSpacing: phone.isEmpty ? 0 : 5,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String icon,
    required AppCubit appCubit,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 10.w,
        end: 10.w,
        bottom: 10.h,
      ),
      child: Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                icon,
                color: mainColor,
                width: 20.w,
              )),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required AppCubit appCubit,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(
        start: 10.w,
        end: 10.w,
        bottom: 20.h,
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 15.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider(AppCubit appCubit) {
    return Divider(
      height: 1,
      color: appCubit.isDark
          ? const Color(0xFF30363D)
          : Colors.grey.withOpacity(0.25),
    );
  }

  Widget _buildMenuItem({
    required AppCubit appCubit,
    required String title,
    required String icon,
    required VoidCallback onTap,
    bool isSwitch = false,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: isSwitch ? null : onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
        child: Row(
          children: [
            Container(
                width: 38.r,
                height: 38.r,
                padding: const EdgeInsetsDirectional.all(9),
                decoration: BoxDecoration(
                  color: isDanger
                      ? Colors.red.withOpacity(0.10)
                      : mainColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SvgPicture.asset(
                  icon,
                  color: isDanger ? Colors.red : mainColor,
                  width: 20.w,
                )),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDanger
                      ? Colors.red
                      : Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
            if (isSwitch)
              Transform.scale(
                scale: 0.82,
                child: Switch(
                  value: appCubit.isDark,
                  activeColor: mainColor,
                  onChanged: (value) {
                    appCubit.changeTheme();
                  },
                ),
              )
            else
              Icon(
                Icons.navigate_next_rounded,
                color: isDanger
                    ? Colors.red.withOpacity(0.5)
                    : appCubit.isDark
                        ? Colors.white.withOpacity(0.45)
                        : Colors.grey.withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LogOutLoadingState) {
              showLoadingDialog(context);
            }
            if (state is LogOutSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.green, 'تم تسجيل خروجك بنجاح', context);
              moveAndReplace(context, const OnBoardingScreen());
              appCubit.changeIndex(0);
            }
            if (state is LogOutErrorState) {
              showSnackBar(Colors.red, state.error, context);
            }
            if (state is DeleteUserAccLoadingState) {
              showLoadingDialog(context);
            }
            if (state is DeleteUserAccSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.green, 'تم حذف حسابك بنجاح', context);
              moveAndReplace(context, const OnBoardingScreen());
              appCubit.changeIndex(0);
            }
            if (state is DeleteUserAccErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, state) {
            AuthCubit authCubit = AuthCubit.get(context);

            final String uid = CacheHelper.getData(key: 'uid')?.toString() ?? '';

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                Map<String, dynamic> user = {};

                if (snapshot.hasData && snapshot.data!.exists) {
                  user = snapshot.data!.data() ?? {};
                } else {
                  final dynamic currentUserData = appCubit.allUsers[uid];

                  if (currentUserData is Map) {
                    user = Map<String, dynamic>.from(currentUserData);
                  }
                }

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(
                            appCubit: appCubit,
                            user: user,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          _buildSectionTitle(
                            title: 'الحساب الشخصي',
                            icon: 'assets/acc.svg',
                            appCubit: appCubit,
                          ),
                          _buildMenuCard(
                            appCubit: appCubit,
                            children: [
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'عرض الحساب',
                                icon: 'assets/eye.svg',
                                onTap: () {
                                  move(
                                    context,
                                    UserProfile(user: user),
                                  );
                                },
                              ),
                              _buildDivider(appCubit),
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'إدارة العناوين',
                                icon: 'assets/loc.svg',
                                onTap: () {
                                  move(
                                    context,
                                    const UserAddressesList(),
                                  );
                                },
                              ),
                            ],
                          ),
                          _buildSectionTitle(
                            title: 'الدعم والمعلومات',
                            icon: 'assets/support.svg',
                            appCubit: appCubit,
                          ),
                          _buildMenuCard(
                            appCubit: appCubit,
                            children: [
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'تواصل معنا',
                                icon: 'assets/chat.svg',
                                onTap: () {
                                  move(context, const ContactUsScreen());
                                },
                              ),
                              _buildDivider(appCubit),
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'الأسئلة الشائعة',
                                icon: 'assets/ques.svg',
                                onTap: () {
                                  move(context, const FaqScreen());
                                },
                              ),
                              _buildDivider(appCubit),
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'حول التطبيق',
                                icon: 'assets/info.svg',
                                onTap: () {
                                  move(context, const AboutAppScreen());
                                },
                              ),
                              _buildDivider(appCubit),
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'سياسة الخصوصية',
                                icon: 'assets/reports.svg',
                                onTap: () {
                                  move(context, PrivacyPolicyScreen());
                                },
                              ),
                              _buildDivider(appCubit),
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'الشروط والأحكام',
                                icon: 'assets/hammer.svg',
                                onTap: () {
                                  move(context, const TermsConditionsScreen());
                                },
                              ),
                            ],
                          ),
                          _buildSectionTitle(
                            title: 'الإعدادات',
                            icon: 'assets/setting.svg',
                            appCubit: appCubit,
                          ),
                          _buildMenuCard(
                            appCubit: appCubit,
                            children: [
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'الوضع المظلم',
                                icon: 'assets/moon.svg',
                                isSwitch: true,
                                onTap: () {},
                              ),
                            ],
                          ),
                          _buildSectionTitle(
                            title: 'إدارة الحساب',
                            icon: 'assets/acc_setting.svg',
                            appCubit: appCubit,
                          ),
                          _buildMenuCard(
                            appCubit: appCubit,
                            children: [
                              _buildMenuItem(
                                appCubit: appCubit,
                                title: 'تسجيل خروج',
                                icon: 'assets/login.svg',
                                isDanger: true,
                                onTap: () {
                                  defaultConfirmDialog(
                                    context: context,
                                    isDark: appCubit.isDark,
                                    icon: 'assets/out.svg',
                                    iconColor: Colors.red,
                                    title: 'تأكيد تسجيل الخروج',
                                    body:
                                        'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                                    cancelText: 'إلغاء',
                                    confirmText: 'خروج',
                                    onConfirm: () {
                                      Navigator.pop(context);
                                      authCubit.logoutUser();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
