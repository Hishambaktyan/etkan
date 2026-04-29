import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              Icons.gavel_rounded,
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
                  'الشروط والأحكام',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'يرجى قراءة الشروط بعناية قبل استخدام خدمات التطبيق.',
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
              'آخر تحديث للشروط والأحكام',
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

  Widget _buildTermCard({
    required BuildContext context,
    required AppCubit cubit,
    required String number,
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
          leading: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
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
              Transform.translate(
                offset: Offset(5.w, -5.h),
                child: Container(
                  width: 18.r,
                  height: 18.r,
                  decoration: const BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildWarningCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.orange.withOpacity(0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade800,
              size: 24.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'باستخدامك للتطبيق فأنت توافق على الالتزام بهذه الشروط، وفي حال مخالفتها قد يتم إيقاف الحساب أو تقييد بعض الخدمات.',
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
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
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
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 23.r,
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

  Widget _buildAcceptanceCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isAccepted
              ? mainColor
              : cubit.isDark
                  ? const Color(0xFF30363D)
                  : Colors.grey.shade200,
        ),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Checkbox(
            value: isAccepted,
            activeColor: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
            onChanged: (value) {
              setState(() {
                isAccepted = value!;
              });
            },
          ),
          Expanded(
            child: Text(
              'أوافق على الشروط والأحكام وسياسة استخدام التطبيق',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 13.sp,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
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
            child: Text(
              'لأي استفسار حول الشروط والأحكام يمكنك التواصل مع فريق الدعم.',
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 12.sp,
                height: 1.7,
              ),
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

    final List<Map<String, dynamic>> terms = [
      {
        'number': '1',
        'title': 'استخدام التطبيق',
        'icon': Icons.phone_android_rounded,
        'body':
            'يجب استخدام التطبيق للأغراض المخصصة له فقط، وهي طلب خدمات الصيانة المنزلية أو تقديمها بطريقة نظامية ومحترمة دون إساءة استخدام أي ميزة من ميزات التطبيق.',
      },
      {
        'number': '2',
        'title': 'بيانات الحساب',
        'icon': Icons.account_circle_outlined,
        'body':
            'يلتزم المستخدم بإدخال بيانات صحيحة عند إنشاء الحساب، مثل الاسم ورقم الهاتف والبريد الإلكتروني والعنوان. يتحمل المستخدم مسؤولية أي بيانات غير صحيحة يتم إدخالها.',
      },
      {
        'number': '3',
        'title': 'طلبات الخدمة',
        'icon': Icons.receipt_long_outlined,
        'body':
            'عند إنشاء طلب خدمة يجب توضيح المشكلة بشكل مناسب وتحديد العنوان الصحيح. يحق للعامل قبول الطلب أو رفضه حسب توفره ونطاق الخدمة الخاص به.',
      },
      {
        'number': '4',
        'title': 'التسعير والدفع',
        'icon': Icons.payments_outlined,
        'body':
            'قد يتم تحديد سعر مبدئي للخدمة، ويمكن الاتفاق على التفاصيل النهائية بين العميل والعامل حسب طبيعة المشكلة. يجب الالتزام بطريقة الدفع المعتمدة داخل التطبيق.',
      },
      {
        'number': '5',
        'title': 'التقييمات والبلاغات',
        'icon': Icons.reviews_outlined,
        'body':
            'يحق للعميل تقييم العامل بعد اكتمال الخدمة، كما يمكنه إرسال بلاغ في حال وجود مشكلة في جودة العمل أو مخالفة في التعامل. يجب أن تكون التقييمات والبلاغات صادقة وغير مسيئة.',
      },
      {
        'number': '6',
        'title': 'حساب العامل',
        'icon': Icons.engineering_outlined,
        'body':
            'يلتزم العامل بتقديم خدماته بجودة مناسبة، واحترام مواعيد الطلبات، وعدم استخدام بيانات العملاء خارج إطار تنفيذ الخدمة. قد يتم إيقاف حساب العامل عند تكرار المخالفات.',
      },
      {
        'number': '7',
        'title': 'إيقاف أو حذف الحساب',
        'icon': Icons.block_rounded,
        'body':
            'يحق لإدارة التطبيق إيقاف أو حذف الحساب في حال وجود إساءة استخدام، بيانات مزيفة، بلاغات متكررة، أو مخالفة واضحة للشروط والأحكام.',
      },
      {
        'number': '8',
        'title': 'تعديل الشروط',
        'icon': Icons.edit_note_rounded,
        'body':
            'قد يتم تعديل هذه الشروط عند الحاجة، وسيتم عرض آخر تحديث داخل هذه الصفحة. استمرار استخدام التطبيق بعد التعديل يعني الموافقة على الشروط الجديدة.',
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
                    'الشروط والأحكام',
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
                  SizedBox(height: 16.h),
                  _buildWarningCard(context, cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'تطبق الشروط على',
                    icon: Icons.groups_rounded,
                  ),
                  SizedBox(height: 15.h),
                  _buildUserTypeCard(
                    context: context,
                    cubit: cubit,
                    title: 'العملاء',
                    subtitle: 'كل مستخدم يقوم بطلب خدمات الصيانة من التطبيق.',
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 12.h),
                  _buildUserTypeCard(
                    context: context,
                    cubit: cubit,
                    title: 'العمال ومقدمي الخدمات',
                    subtitle:
                        'كل عامل يقوم بتقديم خدمة أو استقبال طلبات داخل التطبيق.',
                    icon: Icons.engineering_outlined,
                  ),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'بنود الشروط والأحكام',
                    icon: Icons.article_outlined,
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: terms.map((item) {
                      return _buildTermCard(
                        context: context,
                        cubit: cubit,
                        number: item['number'],
                        title: item['title'],
                        body: item['body'],
                        icon: item['icon'],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  _buildAcceptanceCard(context, cubit),
                  SizedBox(height: 16.h),
                  _buildContactCard(context, cubit),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 20.h,
              ),
              decoration: BoxDecoration(
                color: cubit.isDark ? darkBgColor : Colors.white,
                boxShadow: cubit.isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
              ),
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: isAccepted
                      ? () {
                          showSnackBar(
                            Colors.green,
                            'تمت الموافقة على الشروط والأحكام',
                            context,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    disabledBackgroundColor: cubit.isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'موافق ومتابعة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
