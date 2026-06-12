import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/styles/colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  Widget _sectionHeader({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(.10),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(10.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, mainColor.withOpacity(.7)],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: Colors.white,
              width: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String desc,
    required String icon,
  }) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 14.h),
      padding: EdgeInsetsDirectional.all(16.r),
      decoration: BoxDecoration(
          color: cubit.isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: blueShadow),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, mainColor.withOpacity(.7)],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: Colors.white,
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.6,
                    color: cubit.isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
          color: cubit.isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: blueShadow),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor.withOpacity(.12),
            ),
            child: SvgPicture.asset(
              icon,
              color: mainColor,
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _version(BuildContext context, AppCubit cubit) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.r),
      decoration: BoxDecoration(
          color: cubit.isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: blueShadow),
      child: Row(
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: const Icon(Icons.info, color: mainColor),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'إصدار التطبيق',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          Text(
            '1.0.0',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: cubit.isDark ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(CupertinoIcons.back),
                  ),
                  Text(
                    'حول التطبيق',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(15.r),
              child: Column(
                children: [
                  _sectionHeader(
                    context: context,
                    cubit: cubit,
                    title: 'نبذة عن التطبيق',
                    icon: 'assets/bookings.svg',
                  ),
                  SizedBox(height: 15.h),
                  _card(
                    context: context,
                    cubit: cubit,
                    title: 'ما هو التطبيق؟',
                    desc:
                        'تطبيق إتقان يوفر خدمات الصيانة المنزلية بسهولة وسرعة مع متابعة الطلب والتواصل مع الفني.',
                    icon: 'assets/mobile.svg',
                  ),
                  _card(
                    context: context,
                    cubit: cubit,
                    title: 'هدف التطبيق',
                    desc:
                        'تسهيل الوصول إلى الفنيين وتحسين جودة الخدمات عبر نظام تقييم موثوق.',
                    icon: 'assets/flag.svg',
                  ),
                  SizedBox(height: 10.h),
                  _sectionHeader(
                    context: context,
                    cubit: cubit,
                    title: 'المميزات',
                    icon: 'assets/star.svg',
                  ),
                  SizedBox(height: 15.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.1,
                    children: [
                      _feature(
                        context: context,
                        cubit: cubit,
                        title: 'طلب خدمة',
                        icon: 'assets/services.svg',
                      ),
                      _feature(
                        context: context,
                        cubit: cubit,
                        title: 'متابعة الطلب',
                        icon: 'assets/timeline.svg',
                      ),
                      _feature(
                        context: context,
                        cubit: cubit,
                        title: 'محادثة',
                        icon: 'assets/chat.svg',
                      ),
                      _feature(
                        context: context,
                        cubit: cubit,
                        title: 'تقييم',
                        icon: 'assets/review.svg',
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _version(context, cubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
