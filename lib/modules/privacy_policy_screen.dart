import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  Widget _buildHeaderCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              mainColor,
              mainColor.withOpacity(0.75),
            ],
          ),
          boxShadow: blueShadow),
      child: Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(15.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: SvgPicture.asset(
                'assets/reports.svg',
                color: Colors.white,
                width: 40.w,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سياسة الخصوصية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'نوضح لك كيف يتم جمع بياناتك واستخدامها وحمايتها داخل التطبيق.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 11.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(8.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                'assets/update.svg',
                color: mainColor,
                width: 20.w,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'آخر تحديث لسياسة الخصوصية',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '29 أبريل 2026',
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
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
    required String icon,
  }) {
    return Row(
      children: [
        Container(
            padding: EdgeInsetsDirectional.all(8.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: mainColor,
              width: 25.w,
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
    );
  }

  Widget _buildPolicyCard({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String body,
    required String icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: blueShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          childrenPadding: EdgeInsetsDirectional.only(
            start: 15.w,
            end: 15.w,
            bottom: 16.h,
          ),
          iconColor: mainColor,
          collapsedIconColor:
              cubit.isDark ? Colors.white.withOpacity(0.6) : Colors.grey,
          leading: Container(
              padding: EdgeInsets.all(9.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: SvgPicture.asset(
                icon,
                color: mainColor,
                width: 20.w,
              )),
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Text(
              body,
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 12.sp,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallInfoCard({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(8.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                icon,
                color: mainColor,
                width: 20.w,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: cubit.isDark ? darkSubTextColor : Colors.grey,
                    fontSize: 11.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> policies = [
    {
      'title': 'البيانات التي نقوم بجمعها',
      'icon': 'assets/folder.svg',
      'body':
          'قد نقوم بجمع بعض البيانات الأساسية مثل الاسم، رقم الهاتف، البريد الإلكتروني، الموقع، نوع الحساب، بيانات الطلبات، التقييمات، والمحادثات المرتبطة بالخدمة، وذلك بهدف تشغيل التطبيق وتحسين تجربة المستخدم.',
    },
    {
      'title': 'استخدام بيانات الموقع',
      'icon': 'assets/loc.svg',
      'body':
          'يتم استخدام الموقع لتحديد مكان العميل عند إنشاء الطلب، ولمساعدة العامل على معرفة عنوان الخدمة. لا يتم استخدام الموقع خارج نطاق تقديم الخدمة أو تحسين عملية الحجز داخل التطبيق.',
    },
    {
      'title': 'حماية البيانات',
      'icon': 'assets/lock.svg',
      'body':
          'نحرص على حماية بيانات المستخدمين من الوصول غير المصرح به، ونستخدم الخدمات الآمنة لتخزين البيانات وإدارتها. كما ننصح المستخدم بعدم مشاركة بيانات الدخول مع أي شخص آخر.',
    },
    {
      'title': 'مشاركة البيانات',
      'icon': 'assets/share.svg',
      'body':
          'لا يتم بيع بيانات المستخدمين أو مشاركتها مع جهات خارجية لأغراض تسويقية. قد يتم مشاركة بعض المعلومات الضرورية بين العميل والعامل لإتمام الخدمة، مثل الاسم ورقم التواصل والعنوان.',
    },
    {
      'title': 'الصور والمرفقات',
      'icon': 'assets/image.svg',
      'body':
          'قد يطلب التطبيق رفع صور متعلقة بالخدمة أو مستندات توثيق حساب العامل. يتم استخدام هذه الصور فقط للأغراض المرتبطة بالخدمة أو التحقق من الحساب.',
    },
    {
      'title': 'حقوق المستخدم',
      'icon': 'assets/acc_setting.svg',
      'body':
          'يحق للمستخدم تعديل بياناته الشخصية، إدارة عناوينه، طلب حذف حسابه، أو التواصل مع الدعم في حال وجود أي استفسار متعلق بالخصوصية أو استخدام البيانات.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
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
                    'سياسة الخصوصية',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 10.w,
                end: 10.w,
                top: 10.h,
                bottom: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(cubit),
                  SizedBox(height: 20.h),
                  _buildLastUpdatedCard(context, cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'ملخص الخصوصية',
                    icon: 'assets/all.svg',
                  ),
                  SizedBox(height: 15.h),
                  _buildSmallInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'استخدام واضح للبيانات',
                    subtitle:
                        'نستخدم بياناتك فقط لتشغيل الخدمات وتحسين التجربة.',
                    icon: 'assets/eye.svg',
                  ),
                  SizedBox(height: 12.h),
                  _buildSmallInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'تحكم في حسابك',
                    subtitle:
                        'يمكنك تعديل بياناتك أو إدارة حسابك من الإعدادات.',
                    icon: 'assets/setting.svg',
                  ),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'تفاصيل السياسة',
                    icon: 'assets/bookings.svg',
                  ),
                  SizedBox(height: 15.h),
                  ListView.builder(
                    itemCount: policies.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final police = policies[index];
                      return _buildPolicyCard(
                          context: context,
                          cubit: cubit,
                          title: police['title'],
                          body: police['body'],
                          icon: police['icon']);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
