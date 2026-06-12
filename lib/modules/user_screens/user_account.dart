import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/aboutApp_screen.dart';
import 'package:Etkan/modules/contact_us_screen.dart';
import 'package:Etkan/modules/faq_Screen.dart';
import 'package:Etkan/modules/notifications_screen.dart';
import 'package:Etkan/modules/privacy_policy_screen.dart';
import 'package:Etkan/modules/terms_conditions_screen.dart';
import 'package:Etkan/modules/user_screens/user_profile.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
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
  Widget buildSectionTitle({
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

  Widget buildMenuCard({
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

  Widget buildDivider(AppCubit appCubit) {
    return Divider(
      height: 1,
      color: appCubit.isDark
          ? const Color(0xFF30363D)
          : Colors.grey.withOpacity(0.25),
    );
  }

  Widget buildMenuItem({
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
          },
          builder: (context, state) {
            AuthCubit authCubit = AuthCubit.get(context);
            final String uid =
                CacheHelper.getData(key: 'uid')?.toString() ?? '';
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(
                        context: context,
                        title: 'الإعدادات',
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      buildSectionTitle(
                        title: 'الحساب الشخصي',
                        icon: 'assets/acc.svg',
                        appCubit: appCubit,
                      ),
                      buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'عرض الحساب',
                            icon: 'assets/eye.svg',
                            onTap: () {
                              move(
                                context,
                                const UserProfile(),
                              );
                            },
                          ),
                          buildDivider(appCubit),
                          buildMenuItem(
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
                      buildSectionTitle(
                        title: 'الدعم والمعلومات',
                        icon: 'assets/support.svg',
                        appCubit: appCubit,
                      ),
                      buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'تواصل معنا',
                            icon: 'assets/chat.svg',
                            onTap: () {
                              move(context, const ContactUsScreen());
                            },
                          ),
                          buildDivider(appCubit),
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'الأسئلة الشائعة',
                            icon: 'assets/ques.svg',
                            onTap: () {
                              move(context, const FaqScreen());
                            },
                          ),
                          buildDivider(appCubit),
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'حول التطبيق',
                            icon: 'assets/info.svg',
                            onTap: () {
                              move(context, const AboutAppScreen());
                            },
                          ),
                          buildDivider(appCubit),
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'سياسة الخصوصية',
                            icon: 'assets/reports.svg',
                            onTap: () {
                              move(context, PrivacyPolicyScreen());
                            },
                          ),
                          buildDivider(appCubit),
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'الشروط والأحكام',
                            icon: 'assets/hammer.svg',
                            onTap: () {
                              move(context, const TermsConditionsScreen());
                            },
                          ),
                        ],
                      ),
                      buildSectionTitle(
                        title: 'الإعدادات',
                        icon: 'assets/setting.svg',
                        appCubit: appCubit,
                      ),
                      buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          buildMenuItem(
                            appCubit: appCubit,
                            title: 'الوضع المظلم',
                            icon: 'assets/moon.svg',
                            isSwitch: true,
                            onTap: () {},
                          ),
                        ],
                      ),
                      buildSectionTitle(
                        title: 'إدارة الحساب',
                        icon: 'assets/acc_setting.svg',
                        appCubit: appCubit,
                      ),
                      buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          buildMenuItem(
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
                                body: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
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
  }
}
