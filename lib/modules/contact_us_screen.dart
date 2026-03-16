import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

TextEditingController problem = TextEditingController();
TextEditingController problemdescription = TextEditingController();

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Text(
            'تواصل معنا',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                top: 10.h, bottom: 10.h, start: 15.w, end: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: mainColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.support_agent,
                        size: 100.sp,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'فريقنا جاهز لخدمتك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'خيارات التواصل المباشر',
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 400,
                  height: 80,
                  padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.grey.shade100,
                    boxShadow: shadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey,
                        ),
                        child: Icon(
                          Icons.phone,
                          size: 35.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إتصال هاتفي',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            '770770858',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: mainColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 400,
                  height: 80,
                  padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.grey.shade100,
                    boxShadow: shadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.message,
                          size: 35.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'واتساب',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'متاح على مدار الساعة',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: mainColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 400,
                  height: 80,
                  padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.grey.shade100,
                    boxShadow: shadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrange,
                        ),
                        child: Icon(
                          Icons.email_rounded,
                          size: 35.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'البريد الألكتروني',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'support@gmail.com',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: mainColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: 400.w,
                  height: 450.h,
                  padding: EdgeInsetsDirectional.only(
                      top: 20.h, start: 20.w, end: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.grey.shade100,
                    boxShadow: shadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فتح تذكرة دعم',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        'الموضوع',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      defaultTextFormfeild(
                        text: "ماهي مشكلتك؟",
                        prefixIcon: 'assets/phone.',
                        errorMes: 'يجب ان لا يكون فارغ',
                        controller: problem,
                        type: TextInputType.text,
                        cubit: MyCubit.get(context),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'التفاصيل',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        maxLines: 5,
                        minLines: 5,
                        controller: problemdescription,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'يرجى شرح المشكلة بالتفصيل...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      defualtButton(
                          onPressed: () {
                            if (problem.text.isNotEmpty &&
                                problemdescription.text.isNotEmpty) {
                              showSnackBar(
                                  Colors.green, 'تم إرسال التذكرة', context);
                            } else {
                              showSnackBar(
                                  Colors.red, 'يرجى تعبة كل الحقول', context);
                            }
                          },
                          text: 'إرسال التذكرة',
                          height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
