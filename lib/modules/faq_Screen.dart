import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/styles/colors.dart';
import '../shared/cubits/app_cubit/app_cubit.dart';
import '../shared/cubits/app_cubit/app_states.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<Map<String, dynamic>> faqData = [
    {
      'question': 'كيف يمكنني حجز خدمة جديدة؟',
      'answer':
          'يمكنك ذلك من خلال الصفحة الرئيسية، اختر القسم المطلوب ثم الخدمة، واضغط على زر "احجز الآن".',
      'category': 'الحجز',
    },
    {
      'question': 'ما هي طرق الدفع المتاحة؟',
      'answer': 'نوفر الدفع النقدي (عند الاستلام).',
      'category': 'الدفع',
    },
    {
      'question': 'هل يمكنني إلغاء الحجز؟',
      'answer': 'نعم، يمكنك إلغاء الحجز قبل قبوله من الفني.',
      'category': 'الإلغاء',
    },
    {
      'question': 'كيف يتم اختيار الفنيين في التطبيق؟',
      'answer':
          'نتبع معايير صارمة تشمل فحص الهوية، الخبرة السابقة، وتقييمات المستخدمين لضمان جودة الخدمة.',
      'category': 'الأمان',
    },
    {
      'question': 'ماذا أفعل إذا لم أكن راضياً عن الخدمة؟',
      'answer':
          'يمكنك التقييم عبر صفحة الحجز أو التواصل مع الدعم الفني مباشرة.',
      'category': 'الدعم',
    },
    {
      'question': 'كيف يمكنني تغيير موقعي الحالي؟',
      'answer':
          'يمكنك تعديل العنوان من خلال إعدادات الحساب أو عند تأكيد الطلب قبل البدء.',
      'category': 'الحساب',
    },
    {
      'question': 'لماذا يختلف السعر أحياناً عن السعر التقديري؟',
      'answer':
          'السعر التقديري يعتمد على وصفك الأولي، وقد يختلف السعر النهائي بعد معاينة الفني.',
      'category': 'الأسعار',
    },
    {
      'question': 'كيف يمكنني تحديث بيانات حسابي؟',
      'answer': 'اذهب إلى صفحة الحساب ثم اختر تعديل لتحديث البيانات.',
      'category': 'الحساب',
    },
    {
      'question': 'هل التطبيق يعمل في جميع المدن؟',
      'answer':
          'حالياً نغطي مدينة عدن بشكل كامل، وقريباً سنتوسع لبقية المحافظات.',
      'category': 'عن التطبيق',
    },
    {
      'question': 'نسيت كلمة المرور، كيف أستعيدها؟',
      'answer':
          'اضغط على نسيت كلمة المرور في تسجيل الدخول وسيتم إرسال رمز التحقق.',
      'category': 'الحساب',
    },
  ];

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.back,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'الأسئلة الشائعة',
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
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                    padding: EdgeInsetsDirectional.all(18.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: mainColor,
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.quiz_rounded,
                            color: Colors.white,
                            size: 26.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مركز المساعدة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '${faqData.length} سؤال شائع',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsetsDirectional.all(10.r),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: faqData.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                            color: cubit.isDark
                                ? const Color(0xFF161B22)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: blueShadow),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            iconColor: mainColor,
                            collapsedIconColor: Colors.grey,
                            tilePadding: EdgeInsetsDirectional.symmetric(
                              horizontal: 15.w,
                              vertical: 8.h,
                            ),
                            childrenPadding: EdgeInsetsDirectional.only(
                              start: 15.w,
                              end: 15.w,
                              bottom: 15.h,
                            ),
                            trailing: Container(
                              padding: EdgeInsetsDirectional.all(8.r),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.chevron_down,
                                size: 16.r,
                                color: mainColor,
                              ),
                            ),
                            leading: Container(
                                width: 50.w,
                                height: 50.w,
                                padding: EdgeInsetsDirectional.all(10.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      mainColor,
                                      mainColor.withOpacity(.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: SvgPicture.asset(
                                  'assets/ques.svg',
                                  color: Colors.white,
                                )),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(.12),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    faqData[index]['category'],
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  faqData[index]['question'],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Divider(color: mainColor.withOpacity(.15)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.r),
                                child: Text(
                                  faqData[index]['answer'],
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
