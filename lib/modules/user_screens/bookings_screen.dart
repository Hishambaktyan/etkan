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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    headerWithSearch(
                        title: 'الحجوزات',
                      searchKeyWords: [
                        "ابحث عن حجوزات مقبولة",
                        "ابحث عن حجوزات مكتملة",
                        "ابحث عن حجوزات قيد الأنتظار"
                      ],
                      context: context
                    ),
                    SizedBox(height: 15.h,),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsetsDirectional.only(start: 10.w),
                        itemCount: statusFilters.length,
                        itemBuilder: (context, index) {
                          return  Padding(
                            padding:  EdgeInsetsDirectional.only(end:index==6?0: 15.w,),
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
                    SizedBox(height: 20.h,),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 5.h),
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
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: (){},
                            child: Container(
                              padding: const EdgeInsetsDirectional.all(10),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.r),
                                        child: Image.network(
                                          'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 80.w,
                                            height: 80.h,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200
                                            ),
                                          ),
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
                                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w),
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
                                        buildDetailRow('الفني:', 'مروان أحمد', 'assets/acc.svg', cubit),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
