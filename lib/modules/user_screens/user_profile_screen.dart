import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_edit_profile_screen.dart';
import 'package:trying_homy/modules/user_screens/addresses_management_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_states.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../shared/cubits/user_cubit/user_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();

    UserCubit.get(context).getUserRequests();
    LocationCubit.get(context).getAddresses(CacheHelper.getData(key: 'uid'));
  }

  Widget buildSectionHeader({
    required String title,
    required Widget icon,
    required AppCubit cubit,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.20)
                : mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: icon,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }

  Widget buildWhiteCard({
    required Widget child,
    required AppCubit cubit,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: child,
    );
  }

  Widget buildStatCard({
    required Widget icon,
    required String value,
    required String title,
    required AppCubit cubit,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.all(15.w),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const Spacer(),
                icon,
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
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
                  top: 30.h, start: 10.w, end: 10.w, bottom: 20.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42.w,
                          height: 42.h,
                          margin: EdgeInsetsDirectional.only(end: 10.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
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
                          move(
                            context,
                            UserEditProfileScreen(user: user),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/pen.svg',
                                color: Colors.white,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'تعديل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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

  Widget buildQuickStats({
    required AppCubit cubit,
    required UserCubit bookingCubit,
    required LocationCubit locationCubit,
  }) {
    return Row(
      children: [
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/services.svg',
            color: mainColor,
            width: 30.w,
          ),
          value: '${bookingCubit.userRequests.length}',
          title: 'حجز',
        ),
        SizedBox(width: 15.w),
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/loc.svg',
            color: mainColor,
            width: 30.w,
          ),
          value: '${locationCubit.allAddresses.length}',
          title: 'عنوان',
        ),
      ],
    );
  }

  Widget buildAccountInfoCard({
    required Map<String, dynamic> user,
    required AppCubit cubit,
  }) {
    return buildWhiteCard(
      cubit: cubit,
      child: Column(
        children: [
          buildInfoRow(
            cubit: cubit,
            icon: 'assets/acc.svg',
            title: 'الاسم',
            value: user['name'] ?? 'مستخدم',
          ),
          SizedBox(height: 15.h),
          buildInfoRow(
            cubit: cubit,
            icon: 'assets/phone.svg',
            title: 'رقم الهاتف',
            value: user['phone'] ?? 'غير متوفر',
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required AppCubit cubit,
    required String icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(10.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.18)
                : mainColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: SvgPicture.asset(
            icon,
            color: mainColor,
            width: 20.w,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
            fontSize: 12.sp,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildAddressShortcutCard({
    required AppCubit cubit,
  }) {
    return buildWhiteCard(
      cubit: cubit,
      child: InkWell(
        onTap: () {
          move(context, const AddressesManagementScreen());
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(13.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: SvgPicture.asset(
                'assets/loc.svg',
                color: mainColor,
                width: 25.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إدارة العناوين',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'إضافة وتعديل العناوين المستخدمة في الحجوزات.',
                    style: TextStyle(
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      fontSize: 12.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.navigate_next_rounded,
              color: cubit.isDark
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
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);

        Map<String, dynamic> user =
            appCubit.allUsers[CacheHelper.getData(key: 'uid')] ?? widget.user;

        return BlocBuilder<UserCubit, UserStates>(
          builder: (context, bookingState) {
            UserCubit userCubit = UserCubit.get(context);

            return BlocBuilder<LocationCubit, LocationStates>(
              builder: (context, locationState) {
                LocationCubit locationCubit = LocationCubit.get(context);

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildHeader(
                            appCubit: appCubit,
                            user: user,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 10.w,
                              end: 10.w,
                              top: 20.h,
                              bottom: 20.h,
                            ),
                            child: Column(
                              children: [
                                buildQuickStats(
                                  cubit: appCubit,
                                  bookingCubit: userCubit,
                                  locationCubit: locationCubit,
                                ),
                                SizedBox(height: 25.h),
                                buildSectionHeader(
                                  title: 'معلومات الحساب',
                                  icon: SvgPicture.asset(
                                    'assets/acc.svg',
                                    color: mainColor,
                                    width: 25.w,
                                  ),
                                  cubit: appCubit,
                                ),
                                SizedBox(height: 10.h),
                                buildAccountInfoCard(
                                  user: user,
                                  cubit: appCubit,
                                ),
                                SizedBox(height: 20.h),
                                buildSectionHeader(
                                  title: 'العناوين',
                                  icon: SvgPicture.asset(
                                    'assets/loc.svg',
                                    color: mainColor,
                                    width: 25.w,
                                  ),
                                  cubit: appCubit,
                                ),
                                SizedBox(height: 10.h),
                                buildAddressShortcutCard(cubit: appCubit),
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
      },
    );
  }
}
