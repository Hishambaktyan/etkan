import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Icon(
              Icons.privacy_tip_outlined,
              color: Colors.white,
              size: 34.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سياسة الخصوصية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'نوضح لك كيف يتم جمع بياناتك واستخدامها وحمايتها داخل التطبيق.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 12.sp,
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
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              Icons.update_rounded,
              color: mainColor,
              size: 22.r,
            ),
          ),
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

  Widget _buildPolicyCard({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String body,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : shadow,
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
            child: Icon(
              icon,
              color: mainColor,
              size: 21.r,
            ),
          ),
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
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 22.r,
            ),
          ),
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

  Widget _buildContactCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: mainColor.withOpacity(0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(11.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: mainColor,
              size: 25.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لديك استفسار حول الخصوصية؟',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'يمكنك التواصل مع فريق الدعم لمعرفة المزيد حول بياناتك وحقوقك داخل التطبيق.',
                  style: TextStyle(
                    color:
                        cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                    fontSize: 11.sp,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.navigate_next_rounded,
            color: mainColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    final List<Map<String, dynamic>> policies = [
      {
        'title': 'البيانات التي نقوم بجمعها',
        'icon': Icons.folder_copy_outlined,
        'body':
            'قد نقوم بجمع بعض البيانات الأساسية مثل الاسم، رقم الهاتف، البريد الإلكتروني، الموقع، نوع الحساب، بيانات الطلبات، التقييمات، والمحادثات المرتبطة بالخدمة، وذلك بهدف تشغيل التطبيق وتحسين تجربة المستخدم.',
      },
      {
        'title': 'استخدام بيانات الموقع',
        'icon': Icons.location_on_outlined,
        'body':
            'يتم استخدام الموقع لتحديد مكان العميل عند إنشاء الطلب، ولمساعدة العامل على معرفة عنوان الخدمة. لا يتم استخدام الموقع خارج نطاق تقديم الخدمة أو تحسين عملية الحجز داخل التطبيق.',
      },
      {
        'title': 'حماية البيانات',
        'icon': Icons.lock_outline_rounded,
        'body':
            'نحرص على حماية بيانات المستخدمين من الوصول غير المصرح به، ونستخدم الخدمات الآمنة لتخزين البيانات وإدارتها. كما ننصح المستخدم بعدم مشاركة بيانات الدخول مع أي شخص آخر.',
      },
      {
        'title': 'مشاركة البيانات',
        'icon': Icons.share_outlined,
        'body':
            'لا يتم بيع بيانات المستخدمين أو مشاركتها مع جهات خارجية لأغراض تسويقية. قد يتم مشاركة بعض المعلومات الضرورية بين العميل والعامل لإتمام الخدمة، مثل الاسم ورقم التواصل والعنوان.',
      },
      {
        'title': 'الصور والمرفقات',
        'icon': Icons.image_outlined,
        'body':
            'قد يطلب التطبيق رفع صور متعلقة بالخدمة أو مستندات توثيق حساب العامل. يتم استخدام هذه الصور فقط للأغراض المرتبطة بالخدمة أو التحقق من الحساب.',
      },
      {
        'title': 'حقوق المستخدم',
        'icon': Icons.manage_accounts_outlined,
        'body':
            'يحق للمستخدم تعديل بياناته الشخصية، إدارة عناوينه، طلب حذف حسابه، أو التواصل مع الدعم في حال وجود أي استفسار متعلق بالخصوصية أو استخدام البيانات.',
      },
    ];

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
                    'سياسة الخصوصية',
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
                  SizedBox(height: 16.h),
                  _buildLastUpdatedCard(context, cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'ملخص الخصوصية',
                    icon: Icons.fact_check_outlined,
                  ),
                  SizedBox(height: 15.h),
                  _buildSmallInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'استخدام واضح للبيانات',
                    subtitle:
                        'نستخدم بياناتك فقط لتشغيل الخدمات وتحسين التجربة.',
                    icon: Icons.visibility_outlined,
                  ),
                  SizedBox(height: 12.h),
                  _buildSmallInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'تحكم في حسابك',
                    subtitle:
                        'يمكنك تعديل بياناتك أو إدارة حسابك من الإعدادات.',
                    icon: Icons.settings_outlined,
                  ),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'تفاصيل السياسة',
                    icon: Icons.article_outlined,
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: policies.map((item) {
                      return _buildPolicyCard(
                        context: context,
                        cubit: cubit,
                        title: item['title'],
                        body: item['body'],
                        icon: item['icon'],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  _buildContactCard(context, cubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
