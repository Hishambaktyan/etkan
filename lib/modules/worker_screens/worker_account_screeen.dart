import 'dart:ui';

 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/contact_us_screen.dart';
import 'package:trying_homy/modules/edit_profile_screen.dart';
import 'package:trying_homy/modules/faq_Screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_account_verification_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_profile_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_subscriptions_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../aboutApp_screen.dart';
import '../notifications_screen.dart';
import '../on_boarding.dart';
import '../privacy_policy_screen.dart';
import '../terms_conditions_screen.dart';

class WorkerAccountScreeen extends StatefulWidget {
  const WorkerAccountScreeen({super.key});

  @override
  State<WorkerAccountScreeen> createState() => _WorkerAccountScreeenState();
}

class _WorkerAccountScreeenState extends State<WorkerAccountScreeen> {

  Widget _buildSectionTitle({
    required String title,
    required String icon,
    required AppCubit appCubit,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, bottom: 10.h,),
      child: Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(icon,color: mainColor,width: 20.w,)
          ),
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
      margin: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, bottom: 20.h,),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 5.h,),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: appCubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade100),
        boxShadow: appCubit.isDark ? [] : blueShadow,
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
                child: SvgPicture.asset(icon,color: isDanger?Colors.red: mainColor,width: 20.w,)
            ),
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
  void _showLogoutDialog({
    required AppCubit appCubit,
    required AuthCubit authCubit,
  })
  {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: AlertDialog(
                  backgroundColor:
                  appCubit.isDark ? lightDarkColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(22.r),
                  ),
                  contentPadding: EdgeInsetsDirectional.all(22.r),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                          size: 48.r,
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
                          color: appCubit.isDark
                              ? darkSubTextColor
                              : Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        children: [
                          Expanded(
                            child: defaultButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'إلغاء',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: defaultOutlinedButton(
                              onPressed: ()=>authCubit.logoutUser(),
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
    );
  }

  void _showDeleteAccountDialog(AppCubit appCubit) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: AlertDialog(
                  backgroundColor:
                  appCubit.isDark ? lightDarkColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  contentPadding: EdgeInsets.all(22.r),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset('assets/delete.svg',color: Colors.red,width: 50.w,)
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'حذف الحساب',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'هل أنت متأكد من حذف الحساب؟ لا يمكن التراجع عن هذه العملية بعد تنفيذها.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: appCubit.isDark
                              ? darkSubTextColor
                              : Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        children: [
                          Expanded(
                            child: defaultButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'إلغاء',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: defaultOutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showSnackBar(
                                  Colors.red,
                                  'سيتم ربط حذف الحساب لاحقاً',
                                  context,
                                );
                              },
                              text: 'حذف',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if(state is LogOutLoadingState){
              showLoadingDialog(context);
            }
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
            AuthCubit authCubit = AuthCubit.get(context);
            Map<String, dynamic> user = appCubit.allUsers[CacheHelper.getData(key: 'uid')] ?? {};
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: state is LogOutLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header(title: 'الحساب',context: context),
                      SizedBox(height: 20.h,),
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
                              move(context, const WorkerProfileScreen());
                            },
                          ),
                        ],
                      ),
                      _buildSectionTitle(
                        title: 'خدمات التطبيق',
                        icon: 'assets/grid.svg',
                        appCubit: appCubit,
                      ),
                      _buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'الإشتراكات',
                            icon: 'assets/subs.svg',
                            onTap: () {
                              move(
                                context,
                                const WorkerSubscriptionsScreen(),
                              );
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'توثيق الحساب',
                            icon: 'assets/verf.svg',
                            onTap: () {
                              move(
                                context,
                                const WorkerAccountVerificationScreen(),
                              );
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'مشاركة التطبيق',
                            icon: 'assets/share.svg',
                            onTap: () {},
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
                              move(context,  PrivacyPolicyScreen());
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'الشروط والأحكام',
                            icon: 'assets/hammer.svg',
                            onTap: () {
                              move(
                                  context, const TermsConditionsScreen());
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
                              _showLogoutDialog(
                                appCubit: appCubit,
                                authCubit: authCubit,
                              );
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'حذف الحساب',
                            icon: 'assets/delete.svg',
                            isDanger: true,
                            onTap: () {
                              _showDeleteAccountDialog(appCubit);
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
