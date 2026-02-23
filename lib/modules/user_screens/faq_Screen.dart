import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<Map<String, dynamic>> faqData = [
    {
      'question': 'كيف يمكنني حجز خدمة جديدة؟',
      'answer': 'يمكنك ذلك من خلال الصفحة الرئيسية، اختر القسم المطلوب ثم الخدمة، واضغط على زر "احجز الآن".',
      'category': 'الحجز',
    },
    {
      'question': 'ما هي طرق الدفع المتاحة؟',
      'answer': 'نوفر الدفع النقدي (عند الاستلام).',
      'category': 'الدفع',
    },
    {
      'question': 'هل يمكنني إلغاء الطلب بعد تأكيده؟',
      'answer': 'نعم، يمكنك إلغاء الطلب قبل وصول العامل بـ ساعتين على الأقل.',
      'category': 'الإلغاء',
    },
    {
      'question': 'كيف يتم اختيار العمال في التطبيق؟',
      'answer': 'نتبع معايير صارمة تشمل فحص الهوية، الخبرة السابقة، وتقييمات العملاء لضمان جودة الخدمة.',
      'category': 'الأمان',
    },
    {
      'question': 'ماذا أفعل إذا لم أكن راضياً عن الخدمة؟',
      'answer': 'نحن نهتم برأيك! يمكنك تقديم شكوى عبر صفحة الطلب أو التواصل مع الدعم الفني مباشرة.',
      'category': 'الدعم',
    },
    {
      'question': 'كيف يمكنني تغيير موقع الخدمة؟',
      'answer': 'يمكنك تعديل العنوان من خلال إعدادات الحساب أو عند تأكيد الطلب قبل البدء.',
      'category': 'الحساب',
    },
    {
      'question': 'لماذا يختلف السعر أحياناً عن السعر التقديري؟',
      'answer': 'السعر التقديري يعتمد على وصفك الأولي، وقد يختلف السعر النهائي بعد معاينة العامل للأدوات المطلوبة.',
      'category': 'الأسعار',
    },
    {
      'question': 'كيف يمكنني تحديث بيانات حسابي؟',
      'answer': 'اذهب إلى صفحة "الملف الشخصي" ثم اختر "تعديل البيانات" لتحديث رقم الهاتف أو الاسم.',
      'category': 'الحساب',
    },
    {
      'question': 'هل التطبيق يعمل في جميع المدن؟',
      'answer': 'حالياً نغطي مدينة عدن بشكل كامل، وقريباً سنتوسع لتشمل خدماتنا بقية المحافظات.',
      'category': 'عن التطبيق',
    },
    {
      'question': 'كيف أحصل على خصومات أو كوبونات؟',
      'answer': 'تابع صفحاتنا على مواقع التواصل الاجتماعي وفعل التنبيهات لتصلك أحدث العروض الحصرية.',
      'category': 'العروض',
    },
    {
      'question': 'نسيت كلمة المرور، كيف أستعيدها؟',
      'answer': 'في صفحة تسجيل الدخول، اضغط على "نسيت كلمة المرور" وسنرسل لك رمز تحقق إلى رقمك المسجل.',
      'category': 'الحساب',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(7),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: ()=>Navigator.pop(context),
                    child: const Icon(
                        CupertinoIcons.back
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'الأسئلة الشائعة',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.sp,
                    color: Colors.black
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: ListView.separated(
          padding: EdgeInsets.all(16.r),
          itemCount: faqData.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: shadow,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: mainColor,
                  collapsedIconColor: Colors.grey,
                  tilePadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                  childrenPadding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, bottom: 15.h),
                  title: Text(
                    faqData[index]['question'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.help_outline_rounded, color: mainColor, size: 20.r),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8F6),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        faqData[index]['answer'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
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
      ),
    );
  }
}