import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';

import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final List<Map<String, dynamic>> workers = [
    {
      "name": "محمد علي اليوسفي",
      "price": 5000,
      "image": "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
      "isBusy": false,
      "rating": 4.5,
    },
    {
      "name": "سعيد حسن القحطاني",
      "price": 11200,
      "image": "https://i.pinimg.com/736x/eb/76/a4/eb76a46ab920d056b02d203ca95e9a22.jpg",
      "isBusy": true,
      "rating": 4.0,
    },
    {
      "name": "أحمد خالد الفهد",
      "price": 9000,
      "image": "https://i.pinimg.com/736x/27/90/03/27900371354079f41e16751f2a320fdb.jpg",
      "isBusy": false,
      "rating": 4.2,
    },
    {
      "name": "خالد يوسف العتيبي",
      "price": 1100,
      "image": "https://i.pinimg.com/1200x/65/7c/e1/657ce19e18e65061190c7927400947cf.jpg",
      "isBusy": true,
      "rating": 3.8,
    },
    {
      "name": "سلمان عمر الحربي",
      "price": 9500,
      "image": "https://i.pinimg.com/736x/25/33/8f/25338f488af2c45912c15ebab325e363.jpg",
      "isBusy": false,
      "rating": 4.7,
    },
    {
      "name": "ياسر محمد الدوسري",
      "price": 13000,
      "image": "https://i.pinimg.com/1200x/d8/5a/f1/d85af1b5204c5a8546a7a2e929af45c7.jpg",
      "isBusy": true,
      "rating": 3.9,
    },
  ];
  List<String> statusFilters = ['الكل', 'قيد الانتظار', 'مقبول','في الطريق','مكتمل','مرفوض','ملغي'];
  String selectedStatus = 'الكل';
  Widget buildDetailRow(String label, String value, String iconPath,dynamic cubit) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
              color: cubit.isDark? mainColor.withOpacity(0.2): mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r)
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 22.w,
            height: 22.h,
            color: mainColor,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: TextStyle(
              color: cubit.isDark? darkSubTextColor: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: cubit.isDark? darkSubTextColor: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MyCubit cubit = MyCubit.get(context);
    return BlocConsumer<MyCubit,States>(
      listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
                    child: Container(
                      height: 160.h,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                mainColor.withOpacity(0.9),
                                const Color(0xFF0F0F1E),
                              ],
                              stops: const [
                                0.0,
                                0.8,
                              ]
                          )
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -50.h,
                            left: -50.w,
                            child: CircleAvatar(
                              radius: 100.r,
                              backgroundColor: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          Positioned(
                            top: 80.h,
                            right: -60.w,
                            child: Container(
                              width: 250.r,
                              height: 250.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF00F2FF).withOpacity(0.5),
                                    const Color(0xFF00F2FF).withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 200.h,
                            left: -40.w,
                            child: Container(
                              width: 200.r,
                              height: 200.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    mainColor.withOpacity(0.4),
                                    mainColor.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                                child: Container(color: Colors.transparent),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w,bottom: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'الحجوزات',
                                        style: TextStyle(
                                            fontSize: 23.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsetsDirectional.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/not.svg',
                                            width: 23.w,
                                            height: 23.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(15.r),
                                    onTap: () {},
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 17),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30.r),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/search.svg',
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                              child: SizedBox(
                                                height: 20,
                                                child: AnimatedTextKit(
                                                  repeatForever: true,
                                                  pause: const Duration(seconds: 2),
                                                  animatedTexts: [
                                                    TyperAnimatedText("ابحث عن حجوزات مقبولة",textStyle: const TextStyle(color: Colors.grey)),
                                                    TyperAnimatedText("ابحث عن حجوزات قيد الانتظار",textStyle: const TextStyle(color: Colors.grey)),
                                                    TyperAnimatedText("ابحث عن حجوزات مكتملة",textStyle: const TextStyle(color: Colors.grey)),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsetsDirectional.only(start: 10.w),
                      itemCount: statusFilters.length,
                      itemBuilder: (context, index) {
                        return  Padding(
                          padding:  EdgeInsetsDirectional.only(
                            end:index==6?0: 15.w,
                          ),
                          child: ChoiceChip(
                            backgroundColor: cubit.isDark ? const Color(0xFF161B22) : Colors.grey.shade100,
                            selectedColor: cubit.isDark ? mainColor.withOpacity(0.15) : mainColor.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: BorderSide(
                                color: cubit.isDark
                                    ? (selectedStatus == statusFilters[index] ? mainColor : const Color(0xFF30363D))
                                    : Colors.transparent,
                              ),
                            ),
                            label: Text(statusFilters[index]),
                            selected: selectedStatus == statusFilters[index],
                            onSelected: (value) {
                              setState(() {
                                selectedStatus = statusFilters[index];
                              });
                            },
                            labelStyle: TextStyle(
                              color: cubit.isDark
                                  ? (selectedStatus == statusFilters[index] ? mainColor : const Color(0xFFC9D1D9))
                                  : Colors.black,
                              fontSize: 12.sp,
                              fontWeight: selectedStatus == statusFilters[index] ? FontWeight.bold : FontWeight.normal,
                            ),
                            showCheckmark: false,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 5.h, bottom: 20.h),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        Color statusColor;
                        String status = ['مكتمل','مقبول','في الطريق','مرفوض','ملغي','قيد الانتظار','معلق'][index % 7];
                        switch (status) {
                          case 'مكتمل': statusColor = Colors.green; break;
                          case 'مقبول':
                          case 'في الطريق': statusColor = Colors.blueAccent; break;
                          case 'مرفوض':
                          case 'ملغي': statusColor = Colors.redAccent; break;
                          default: statusColor = Colors.orangeAccent;
                        }

                        return Padding(
                          padding: EdgeInsetsDirectional.only(bottom: 20.h),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                                        width: 90.w,
                                        height: 90.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'تركيب بانيو مصري',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Container(
                                                height: 30.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                  color: statusColor.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(6.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    status,
                                                    style: TextStyle(
                                                      color: statusColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 7.h),
                                          Text(
                                            'رقم الطلب: 12345',
                                            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                                          ),
                                          SizedBox(height: 7.h),
                                          Text(
                                            '10000 ريال',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: mainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    children: [
                                      buildDetailRow('العنوان:', 'الشعب - حي السعادة عمارة 12', 'assets/loc.svg', cubit),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: dashedDivider(Colors.grey),
                                      ),
                                      buildDetailRow('التاريخ والوقت:', '17/03/2026 - 10:00', 'assets/timer.svg', cubit),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: dashedDivider(Colors.grey),
                                      ),
                                      buildDetailRow('العميل:', 'مروان أحمد', 'assets/acc.svg', cubit),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )                ],
              ),
            ),
          );
        },
    );
  }
}
