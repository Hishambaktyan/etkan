import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool isAccepted = false;

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
              'assets/tool.svg',
              color: Colors.white,
              width: 40.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الشروط والأحكام',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'تحدد هذه الشروط طريقة استخدام التطبيق وحقوق العميل والفني والتزامات كل طرف داخل خدمة الصيانة المنزلية.',
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
              'آخر تحديث للشروط والأحكام',
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
            padding: EdgeInsets.all(8.r),
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

  Widget _buildTermCard({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String body,
    required String icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
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
          childrenPadding: EdgeInsetsDirectional.all(15.w),
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

  Widget _buildWarningCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: Colors.orange.withOpacity(0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(9.r),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/reports.svg',
                color: Colors.orange.shade900,
                width: 20.w,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'باستخدامك للتطبيق فأنت توافق على الالتزام بهذه الشروط. قد يتم تقييد الحساب أو إيقافه عند إساءة الاستخدام، تقديم بيانات غير صحيحة، مخالفة قواعد الحجز، أو الإضرار بالمستخدمين أو الفنيين.',
              style: TextStyle(
                color: cubit.isDark
                    ? Colors.orange.shade200
                    : Colors.orange.shade900,
                fontSize: 12.sp,
                height: 1.7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeCard({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12.r),
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

  final List<Map<String, dynamic>> terms = [
    {
      'title': 'استخدام التطبيق',
      'icon': 'assets/mobile.svg',
      'body':
          'يُستخدم التطبيق لطلب خدمات الصيانة المنزلية أو تقديمها من خلال حساب مستخدم أو حساب فني. يجب استخدام التطبيق بطريقة نظامية ومحترمة، ويُمنع استخدامه للإزعاج، الاحتيال، نشر بيانات غير صحيحة، أو تنفيذ أي نشاط خارج هدف التطبيق.',
    },
    {
      'title': 'بيانات الحساب والتحقق',
      'icon': 'assets/acc.svg',
      'body':
          'يلتزم المستخدم بإدخال بيانات صحيحة مثل الاسم، رقم الهاتف، كلمة المرور، نوع الحساب، والعنوان عند التسجيل. يتم استخدام كود التحقق للتأكد من رقم الهاتف، ويتحمل المستخدم مسؤولية الحفاظ على بيانات الدخول وعدم مشاركة كود التحقق مع أي شخص.',
    },
    {
      'title': 'العناوين والموقع',
      'icon': 'assets/loc.svg',
      'body':
          'يجب على المستخدم إضافة عنوان صحيح وواضح حتى يتمكن الفني من الوصول لمكان الخدمة. يتحمل المستخدم مسؤولية أي تأخير أو مشكلة ناتجة عن عنوان غير دقيق، ويجب استخدام العنوان فقط لغرض تنفيذ الحجز داخل التطبيق.',
    },
    {
      'title': 'الحجوزات وحالاتها',
      'icon': 'assets/bookings.svg',
      'body':
          'يستطيع المستخدم إنشاء حجز خدمة، ثم تتم متابعة الحجز حسب حالته مثل قيد الانتظار، مقبول، في الطريق، مكتمل، مرفوض، أو ملغي. يجب على المستخدم والفني احترام حالة الحجز وعدم استغلال النظام أو إنشاء حجوزات وهمية.',
    },
    {
      'title': 'التواصل داخل التطبيق',
      'icon': 'assets/chat.svg',
      'body':
          'تُستخدم المحادثة بين المستخدم والفني لمناقشة تفاصيل الحجز فقط. يُمنع إرسال محتوى مسيء، تهديدات، روابط ضارة، أو استخدام بيانات التواصل خارج إطار تنفيذ الخدمة أو الدعم.',
    },
    {
      'title': 'الأسعار والدفع',
      'icon': 'assets/money.svg',
      'body':
          'تُعرض أسعار الخدمات داخل التطبيق كقيمة أساسية أو تقديرية حسب الخدمة. قد تختلف التفاصيل النهائية حسب طبيعة المشكلة وما يتم الاتفاق عليه بين المستخدم والفني. يجب الالتزام بأي تعليمات دفع أو إثبات دفع يطلبها التطبيق أو الإدارة.',
    },
    {
      'title': 'حساب الفني والخطة المجانية',
      'icon': 'assets/providers.svg',
      'body':
          'يستطيع الفني الجديد تجربة التطبيق بإضافة حتى 5 خدمات وإكمال حتى 5 حجوزات مكتملة فقط. بعد الوصول إلى الحد المجاني يجب الاشتراك حتى يتمكن من إضافة خدمات أو استقبال حجوزات جديدة. عند تفعيل الاشتراك تصبح الخدمات والحجوزات غير محدودة حسب مدة الباقة.',
    },
    {
      'title': 'اشتراك الفني',
      'icon': 'assets/subs.svg',
      'body':
          'يخضع اشتراك الفني لمراجعة الإدارة بعد إرسال طلب الاشتراك وإرفاق سند الدفع عند الحاجة. يبدأ الاشتراك بعد قبول الإدارة للطلب، وينتهي عند تاريخ انتهاء الباقة. عند انتهاء الاشتراك قد تتوقف خدمات الفني عن الظهور للعملاء ولا يمكنه استقبال حجوزات جديدة حتى التجديد.',
    },
    {
      'title': 'توثيق حساب الفني',
      'icon': 'assets/acc_setting.svg',
      'body':
          'يمكن للفني إرسال طلب توثيق بإرفاق المستندات المطلوبة. تقوم الإدارة بمراجعة الطلب وقبوله أو رفضه. ظهور علامة التوثيق يعني أن الطلب تمت مراجعته داخل التطبيق، ولا يعفي الفني من مسؤولية جودة الخدمة أو صحة بياناته.',
    },
    {
      'title': 'التقييمات',
      'icon': 'assets/review.svg',
      'body':
          'يحق للعميل تقييم الفني بعد اكتمال الخدمة. يجب أن تكون التقييمات صادقة وواضحة، ويُمنع استخدامها للإساءة أو التشهير أو تقديم معلومات كاذبة.',
    },
    {
      'title': 'إيقاف أو حذف الحساب',
      'icon': 'assets/block.svg',
      'body':
          'يحق لإدارة التطبيق تقييد أو إيقاف أو حذف الحساب عند وجود إساءة استخدام، بيانات مزيفة، محاولة التحايل على الاشتراك، استخدام غير آمن للمحادثات، أو مخالفة واضحة للشروط والأحكام.',
    },
    {
      'title': 'تعديل الشروط',
      'icon': 'assets/pen.svg',
      'body':
          'قد يتم تعديل هذه الشروط عند الحاجة لتطوير التطبيق أو تحسين الخدمة. سيتم عرض تاريخ آخر تحديث داخل هذه الصفحة، ويُعد استمرار استخدام التطبيق بعد التعديل موافقة على الشروط الجديدة.',
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
                    'الشروط والأحكام',
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
                  _buildWarningCard(context, cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'تطبق الشروط على',
                    icon: 'assets/users.svg',
                  ),
                  SizedBox(height: 15.h),
                  _buildUserTypeCard(
                    context: context,
                    cubit: cubit,
                    title: 'المستخدمين',
                    subtitle:
                        'كل مستخدم يطلب أو يدير حجوزات الصيانة المنزلية من خلال التطبيق.',
                    icon: 'assets/acc.svg',
                  ),
                  SizedBox(height: 12.h),
                  _buildUserTypeCard(
                    context: context,
                    cubit: cubit,
                    title: 'الفنيين',
                    subtitle:
                        'كل فني يضيف خدماته أو يستقبل حجوزات الصيانة من خلال التطبيق.',
                    icon: 'assets/providers.svg',
                  ),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'بنود الشروط والأحكام',
                    icon: 'assets/bookings.svg',
                  ),
                  SizedBox(height: 15.h),
                  ListView.builder(
                    itemCount: terms.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final term = terms[index];
                      return _buildTermCard(
                        context: context,
                        cubit: cubit,
                        title: term['title'],
                        body: term['body'],
                        icon: term['icon'],
                      );
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
