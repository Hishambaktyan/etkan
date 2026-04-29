import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  Widget _buildHeaderCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: cubit.isDark
            ? []
            : [
                BoxShadow(
                  color: mainColor.withOpacity(0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Icon(
              Icons.home_repair_service_rounded,
              color: Colors.white,
              size: 42.r,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            'Homy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'تطبيق طلب خدمات الصيانة المنزلية',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border:
            cubit.isDark ? Border.all(color: const Color(0xFF30363D)) : null,
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.20)
                  : mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 23.r,
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
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  description,
                  style: TextStyle(
                    color:
                        cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                    fontSize: 12.sp,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border:
            cubit.isDark ? Border.all(color: const Color(0xFF30363D)) : null,
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 24.r,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required IconData icon,
  }) {
    return Row(
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
    );
  }

  Widget _buildVersionCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border:
            cubit.isDark ? Border.all(color: const Color(0xFF30363D)) : null,
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: mainColor,
              size: 22.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'إصدار التطبيق',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '1.0.0',
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 10,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.back,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'حول التطبيق',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 25.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'نبذة عن التطبيق',
                    icon: Icons.article_outlined,
                  ),
                  SizedBox(height: 15.h),
                  _buildInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'ما هو التطبيق؟',
                    description:
                        'تطبيق Homy يساعد العملاء على طلب خدمات الصيانة المنزلية بسهولة، مثل الكهرباء والسباكة والتكييف، مع إمكانية متابعة حالة الطلب والتواصل مع العامل داخل التطبيق.',
                    icon: Icons.phone_android_rounded,
                  ),
                  _buildInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'هدف التطبيق',
                    description:
                        'يهدف التطبيق إلى تسهيل الوصول إلى العمال ومقدمي الخدمات، وتنظيم عملية الحجز، ورفع مستوى الثقة بين العميل والعامل من خلال التقييمات والبيانات الواضحة.',
                    icon: Icons.flag_rounded,
                  ),
                  SizedBox(height: 10.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'مميزات التطبيق',
                    icon: Icons.star_border_rounded,
                  ),
                  SizedBox(height: 15.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.25,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildFeatureItem(
                        context: context,
                        cubit: cubit,
                        title: 'طلب خدمة بسهولة',
                        icon: Icons.handyman_rounded,
                      ),
                      _buildFeatureItem(
                        context: context,
                        cubit: cubit,
                        title: 'تتبع حالة الطلب',
                        icon: Icons.timeline_rounded,
                      ),
                      _buildFeatureItem(
                        context: context,
                        cubit: cubit,
                        title: 'دردشة مباشرة',
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                      _buildFeatureItem(
                        context: context,
                        cubit: cubit,
                        title: 'تقييم العمال',
                        icon: Icons.reviews_rounded,
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  _buildVersionCard(context, cubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
