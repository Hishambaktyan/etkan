/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/styles/colors.dart';

Directionality justTest(context){
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
              child: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.1),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: ()=>Navigator.pop(context),
                  child: Icon(
                      CupertinoIcons.back
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              'تفاصيل الحجز',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.sp,
                  color: Colors.black
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset('assets/not.svg'),
                      if (true)
                        CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'حالة الطلب',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsetsDirectional.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'رقم الطلب: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '343',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: mainColor
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'حالة الطلب الحالية: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'قيد الانتظار',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'تتبع حالة الطلب: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    buildHorizontalStepper(currentStep: 1),

                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'تفاصيل الخدمة',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsetsDirectional.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تركيب حوض حمام جداري جداري',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            'السعر: 1200 \uFDFC',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:mainColor,
                            ),
                          ),
                          Text(
                            'التاريخ: 23/2/2026',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:Colors.grey,
                            ),
                          ),
                          Text(
                            'الوقت: 04:12 م',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                        width: 110.w,
                        height: 110.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 90.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: Colors.grey.shade100
                          ),
                          child: const Icon(Icons.wifi_off_rounded,size: 40,color: Colors.grey,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'معلومات العميل',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  height: 220.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.grey.withOpacity(0.05)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.w,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'محمد عبد الله محمد',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/loc.svg',
                            color: Colors.grey,
                            width: 25.w,
                            height: 25.h,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'عدن - المنصورة - ريمي',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/phone.svg',
                            color: Colors.grey,
                            width: 25.w,
                            height: 25.h,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            '770770858',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: defualtButtonWithIcon(
                                  onPressed: (){},
                                  text: 'دردشة',
                                  height: 40.h,
                                  icon: SvgPicture.asset(
                                    'assets/chat.svg',
                                    color: Colors.white,
                                    width: 23.w,
                                    height: 23.h,
                                  )
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: defualtOutlinedButtonWithIcon(
                                  onPressed: (){},
                                  text: 'إتصال',
                                  height: 40.h,
                                  icon: SvgPicture.asset(
                                    'assets/phone.svg',
                                    color: mainColor,
                                    width: 23.w,
                                    height: 23.h,
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: defualtButton(
                  onPressed: (){},
                  text: 'قبول'
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: defualtOutlinedButton(
                    onPressed: (){},
                    text: 'رفض',
                    border: Colors.red,
                    textColor: Colors.red
                )
            )
          ],
        ),
      ),
    ),
  );
}*/