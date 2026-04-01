import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/modules/user_screens/service_details.dart';
import 'package:trying_homy/modules/user_screens/worker_details.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';

import '../../shared/compenents/components.dart';
import '../../main.dart';
import '../../shared/styles/colors.dart';

class ElectricServices extends StatefulWidget {
  const ElectricServices({super.key});

  @override
  State<ElectricServices> createState() => _ElectricServicesState();
}

class _ElectricServicesState extends State<ElectricServices> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWithSearch(
                  title: 'خدمات الكهرباء',
                  isLeading: true,
                  searchKeyWords: [
                    'ابحث عن تصليح فيش',
                    'ابحث عن تركيب مروحة',
                    'ابحث عن تركيب شاحن',
                  ],
                context: context
              ),
              SizedBox(height: 15.h,),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 15.w),
                child: Text(
                  'أقسام الكهرباء',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp
                  ),
                ),
              ),
              SizedBox(height: 5.h,),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsetsDirectional.only(start: 15.w),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 90.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: mainColor.withOpacity(0.1),
                            radius: 27.r,
                          ),
                          SizedBox(height: 3.h,),
                          SizedBox(
                            height: 20.h,
                            child: Marquee(
                              text: 'تركيب فيش وبلاكات',
                              style: TextStyle(fontSize: 11.sp),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 40.0,
                              velocity: 50.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 1),
                              decelerationDuration: const Duration(milliseconds: 500),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                    separatorBuilder: (context, index) => SizedBox(width: 10.w,),
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  padding: EdgeInsetsDirectional.only(start:15.w,end: 15.w,bottom: 20.h),
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: ()=>move(context, const ServiceDetails()),
                      child: Container(
                        width: 300.w,
                        padding: EdgeInsetsDirectional.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: MyCubit.get(context).isDark ? lightDarkColor : mainColor.withOpacity(0.1),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(15.r),
                                topEnd: Radius.circular(15.r),
                              ),
                              child: Image.network(
                                'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                                height: 150.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadiusDirectional.only(
                                        topStart: Radius.circular(15.r),
                                        topEnd: Radius.circular(15.r),
                                      ),
                                      color: Colors.grey.shade200
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 10.w,end: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'تركيب بانيو مصري مصري مصري',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: MyCubit.get(context).isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 7.w),
                                        decoration: BoxDecoration(
                                          color: mainColor,
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Text(
                                          '100000 $reyalSymbol',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h,),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,color: Colors.orange,
                                      ),
                                      SizedBox(width: 5.w,),
                                      const Text(
                                        '3.8',
                                        style: TextStyle(
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        foregroundImage: const NetworkImage(
                                            'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'
                                        ),
                                        radius: 20.r,
                                      ),
                                      SizedBox(width: 10.w,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200.w,
                                            child: Text(
                                              'عبد الله عبد الرحمن ناصر ناصر',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12.sp
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'سباك',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 15.h,
                  ),
                  itemCount:7
              ),
            ],
          ),
        ),
      ),
    );
  }


}
