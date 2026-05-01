import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/aboutApp_screen.dart';
import 'package:trying_homy/modules/addresses_management_screen.dart';
import 'package:trying_homy/modules/contact_us_screen.dart';
import 'package:trying_homy/modules/edit_profile_screen.dart';
import 'package:trying_homy/modules/faq_Screen.dart';
import 'package:trying_homy/modules/notifications_screen.dart';
import 'package:trying_homy/modules/privacy_policy_screen.dart';
import 'package:trying_homy/modules/terms_conditions_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_account_verification_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_subscriptions_screen.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';
import 'on_boarding.dart';

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
    String name = user['name'] ?? 'مستخدم';
    String phone = user['phone'] ?? '';
    String image = user['profileImage'] ?? '';

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
                top: 35.h,
                start: 18.w,
                end: 18.w,
              ),
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
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                            ),
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 25.r,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  top: 9.h,
                                  end: 9.w,
                                ),
                                child: CircleAvatar(
                                  radius: 4.r,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
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
                        SizedBox(height: 13.h),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            phone,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12.sp,
                              letterSpacing: 1.5,
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
    required IconData icon,
    required AppCubit appCubit,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        bottom: 12.h,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 20.r,
            ),
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
      margin: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        bottom: 22.h,
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 14.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: appCubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade100),
        boxShadow: appCubit.isDark ? [] : shadow,
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
    required IconData icon,
    required VoidCallback onTap,
    bool isSwitch = false,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: isSwitch ? null : onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: isDanger
                    ? Colors.red.withOpacity(0.10)
                    : mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isDanger ? Colors.red : mainColor,
                size: 21.r,
              ),
            ),
            SizedBox(width: 12.w),
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

  Widget _buildQuickCard({
    required AppCubit appCubit,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: appCubit.isDark
              ? Border.all(color: const Color(0xFF30363D))
              : null,
          boxShadow: appCubit.isDark ? [] : shadow,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24.r,
              ),
            ),
            SizedBox(height: 9.h),
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(AppCubit appCubit) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: 18.h,
        bottom: 22.h,
      ),
      child: Row(
        children: [
          _buildQuickCard(
            appCubit: appCubit,
            title: 'العناوين',
            value: '2',
            icon: Icons.location_on_outlined,
            color: mainColor,
          ),
          SizedBox(width: 12.w),
          _buildQuickCard(
            appCubit: appCubit,
            title: 'المفضلة',
            value: '5',
            icon: Icons.favorite_border_rounded,
            color: Colors.red,
          ),
          SizedBox(width: 12.w),
          _buildQuickCard(
            appCubit: appCubit,
            title: 'الطلبات',
            value: '12',
            icon: Icons.receipt_long_outlined,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog({
    required AppCubit appCubit,
    required AuthCubit authCubit,
  }) {
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
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                          size: 48.r,
                        ),
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
                            child: defualtButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'إلغاء',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: defualtOutlinedButton(
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

            Map<String, dynamic> user = appCubit.allUsers[FirebaseAuth.instance.currentUser!.uid] ?? {};

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: state is LogOutLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        appCubit: appCubit,
                        user: user,
                      ),
                      _buildQuickInfo(appCubit),
                      _buildSectionTitle(
                        title: 'الحساب الشخصي',
                        icon: Icons.person_outline_rounded,
                        appCubit: appCubit,
                      ),
                      _buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'عرض الحساب',
                            icon: Icons.visibility_outlined,
                            onTap: () {
                              move(context, const EditProfileScreen());
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'إدارة العناوين',
                            icon: Icons.location_on_outlined,
                            onTap: () {
                              move(
                                context,
                                const AddressesManagementScreen(),
                              );
                            },
                          ),
                        ],
                      ),
                      _buildSectionTitle(
                        title: 'خدمات التطبيق',
                        icon: Icons.apps_rounded,
                        appCubit: appCubit,
                      ),
                      _buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'الإشتراكات',
                            icon: Icons.workspace_premium_outlined,
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
                            icon: Icons.verified_user_outlined,
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
                            icon: Icons.share_outlined,
                            onTap: () {},
                          ),
                        ],
                      ),
                      _buildSectionTitle(
                        title: 'الدعم والمعلومات',
                        icon: Icons.support_agent_rounded,
                        appCubit: appCubit,
                      ),
                      _buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'تواصل معنا',
                            icon: Icons.chat_bubble_outline_rounded,
                            onTap: () {
                              move(context, const ContactUsScreen());
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'الأسئلة الشائعة',
                            icon: Icons.help_outline_rounded,
                            onTap: () {
                              move(context, const FaqScreen());
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'حول التطبيق',
                            icon: Icons.info_outline_rounded,
                            onTap: () {
                              move(context, const AboutAppScreen());
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'سياسة الخصوصية',
                            icon: Icons.privacy_tip_outlined,
                            onTap: () {
                              move(context,  PrivacyPolicyScreen());
                            },
                          ),
                          _buildDivider(appCubit),
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'الشروط والأحكام',
                            icon: Icons.gavel_rounded,
                            onTap: () {
                              move(
                                  context, const TermsConditionsScreen());
                            },
                          ),
                        ],
                      ),
                      _buildSectionTitle(
                        title: 'الإعدادات',
                        icon: Icons.settings_outlined,
                        appCubit: appCubit,
                      ),
                      _buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'الوضع المظلم',
                            icon: Icons.dark_mode_outlined,
                            isSwitch: true,
                            onTap: () {},
                          ),
                        ],
                      ),
                      _buildSectionTitle(
                        title: 'إدارة الحساب',
                        icon: Icons.manage_accounts_outlined,
                        appCubit: appCubit,
                      ),
                      _buildMenuCard(
                        appCubit: appCubit,
                        children: [
                          _buildMenuItem(
                            appCubit: appCubit,
                            title: 'تسجيل خروج',
                            icon: Icons.logout_rounded,
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
                            icon: Icons.delete_outline_rounded,
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