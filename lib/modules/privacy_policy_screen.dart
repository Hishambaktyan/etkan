import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/styles/colors.dart';

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
                  'نوضح لك ما البيانات التي نحتاجها لتشغيل حجوزات الصيانة، وكيف نستخدمها لحماية المستخدم والفني وتحسين الخدمة.',
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
            '7 يونيو 2026',
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
      'title': 'البيانات التي نجمعها',
      'icon': 'assets/folder.svg',
      'body':
          'نجمع البيانات اللازمة لتشغيل التطبيق مثل الاسم، رقم الهاتف، نوع الحساب، الصورة الشخصية عند إضافتها، العناوين المحفوظة، بيانات الحجوزات، الخدمات، التقييمات، الإشعارات، والمحادثات المرتبطة بالحجوزات. لا نطلب بيانات غير لازمة لتقديم الخدمة.',
    },
    {
      'title': 'العناوين وبيانات الموقع',
      'icon': 'assets/loc.svg',
      'body':
          'يستخدم التطبيق العنوان أو الموقع الذي يحدده المستخدم لتوضيح مكان تنفيذ الخدمة للفني. تظهر بيانات العنوان للفني المرتبط بالحجز فقط وبالقدر اللازم لتنفيذ الخدمة. لا يتم استخدام الموقع لتتبع المستخدم خارج نطاق الحجز.',
    },
    {
      'title': 'بيانات الفنيين والتوثيق',
      'icon': 'assets/providers.svg',
      'body':
          'يطلب التطبيق من الفني إضافة تخصصه، نبذة عنه، خبراته، أعماله السابقة، ورفع مستندات للتوثيق مثل صورة الوثيقة والصورة الشخصية. تُستخدم بيانات التوثيق لمراجعة الحساب من الإدارة ولا تُعرض للمستخدمين، بينما قد تظهر علامة التوثيق فقط بعد الموافقة.',
    },
    {
      'title': 'المحادثات والإشعارات',
      'icon': 'assets/chat.svg',
      'body':
          'تُستخدم المحادثات داخل التطبيق للتواصل بين المستخدم والفني بخصوص الحجز فقط. كما يستخدم التطبيق الإشعارات لإبلاغك بالحجوزات الجديدة، تحديث حالة الحجز، الرسائل، الاشتراك، أو التوثيق.',
    },
    {
      'title': 'الصور والمرفقات',
      'icon': 'assets/image.svg',
      'body':
          ' يتم رفع صور متعلقة بالخدمة أو صور أعمال سابقة أو صور مستندات التوثيق. تُستخدم هذه الصور فقط للغرض الذي رُفعت من أجله، مثل توضيح المشكلة، عرض أعمال الفني، أو مراجعة طلب التوثيق.',
    },
    {
      'title': 'مشاركة البيانات داخل التطبيق',
      'icon': 'assets/share.svg',
      'body':
          'لا نبيع بيانات المستخدمين ولا نشاركها لأغراض تسويقية خارجية. قد تتم مشاركة بيانات محدودة بين المستخدم والفني لإتمام الحجز، مثل الاسم، العنوان، وصف الخدمة، وصور المشكلة. كما يمكن للإدارة الوصول للبيانات اللازمة للمراجعة والدعم.',
    },
    {
      'title': 'حماية البيانات',
      'icon': 'assets/lock.svg',
      'body':
          'نعمل على حماية البيانات من الوصول غير المصرح به باستخدام خدمات تخزين وإدارة آمنة قدر الإمكان. كما يجب على المستخدم الحفاظ على رقم هاتفه وكلمة المرور وعدم مشاركة بيانات الدخول أو كود التحقق مع أي شخص.',
    },
    {
      'title': 'حقوق المستخدم',
      'icon': 'assets/acc_setting.svg',
      'body':
          'يمكن للمستخدم تعديل بياناته الشخصية، إدارة عناوينه، تغيير صورته، متابعة حجوزاته، أو التواصل مع الدعم عند وجود مشكلة.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
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
                        'نستخدم بياناتك لتشغيل الحجوزات، إدارة العناوين، إرسال الإشعارات، وتحسين تجربة الاستخدام.',
                    icon: 'assets/eye.svg',
                  ),
                  SizedBox(height: 12.h),
                  _buildSmallInfoCard(
                    context: context,
                    cubit: cubit,
                    title: 'تحكم في حسابك',
                    subtitle: 'يمكنك تعديل بيانات حسابك وإدارة عناوينك.',
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
