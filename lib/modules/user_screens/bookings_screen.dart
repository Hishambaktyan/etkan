import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/booking_details.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/booking_cubit/booking_cubit.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/booking_cubit/booking_states.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
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
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: BlocProvider(
                create: (context) => BookingCubit()..getUserRequests(),
                child: BlocBuilder<BookingCubit,BookingStates>(
                  builder:(context, state) {
                    BookingCubit bookingCubit = BookingCubit.get(context);
                  return ConditionalBuilder(
                      condition: state is GetUserRequestLoadingState,
                      builder: (context) => UserBookingsShimmer(isDark: appCubit.isDark),
                      fallback: (context) => SingleChildScrollView(
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
                                      backgroundColor: appCubit.isDark ? const Color(0xFF161B22) : Colors.grey.shade100,
                                      selectedColor: appCubit.isDark ? mainColor.withOpacity(0.15) : mainColor.withOpacity(0.2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.r),
                                        side: BorderSide(
                                          color: appCubit.isDark
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
                                        color: appCubit.isDark
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
                              itemCount:bookingCubit.userRequests.length,
                              itemBuilder: (context, index) {
                                var booking = bookingCubit.userRequests[index];
                                Color statusColor;
                                String status = booking['status'] ;
                                switch (status) {
                                  case 'مكتمل': statusColor = Colors.green; break;
                                  case 'مقبول':
                                  case 'في الطريق': statusColor = Colors.blueAccent; break;
                                  case 'مرفوض':
                                  case 'ملغي': statusColor = Colors.redAccent; break;
                                  default: statusColor = Colors.orangeAccent;
                                }
                                var providerData = appCubit.allUsers[booking['providerId']];
                                return Padding(
                                  padding: EdgeInsetsDirectional.only(bottom: 20.h),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: ()=>move(context, BookingDetails(request: booking, providerData: providerData)),
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
                                                  booking['image'] ?? '',
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
                                                            booking['title'],
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
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                       '${booking['price']} $reyalSymbol',
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
                                                buildDetailRow('العنوان:', booking['address'], 'assets/loc.svg', appCubit),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                  child: dashedDivider(Colors.grey),
                                                ),
                                                buildDetailRow('التاريخ والوقت:', appCubit.formatStatusTime(booking['scheduledAt']), 'assets/timer.svg', appCubit),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                                  child: dashedDivider(Colors.grey),
                                                ),
                                                buildDetailRow('الفني:', providerData['name'], 'assets/acc.svg', appCubit),
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
                  );
                },),
              )
            ),
          );
        },
    );
  }
}
