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
  void initState() {
    BookingCubit.get(context).getUserRequests();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: BlocBuilder<BookingCubit,BookingStates>(
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
                            padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 5.h),
                            itemCount: bookingCubit.userRequests.length,
                            itemBuilder: (context, index) {
                              var booking = bookingCubit.userRequests[index];
                              Color statusColor;
                              String status = booking['status'];
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
                                  onTap: () => move(context, BookingDetails(request: booking, providerData: providerData)),
                                  child: Container(
                                    padding: EdgeInsetsDirectional.all(15.r),
                                    decoration: BoxDecoration(
                                      color: appCubit.isDark ? lightDarkColor : Colors.white,
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: blueShadow,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.r),
                                                border: Border.all(
                                                  color: mainColor.withOpacity(0.1),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18.r),
                                                child: Image.network(
                                                  booking['image'] ?? '',
                                                  width: 70.w,
                                                  height: 70.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    width: 70.w,
                                                    height: 70.h,
                                                    color: Colors.grey.shade200,
                                                    child: Icon(Icons.image_not_supported, color: Colors.grey, size: 20.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15.w),
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
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: appCubit.isDark ? Colors.white : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                                        decoration: BoxDecoration(
                                                          color: statusColor.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(30.r),
                                                          border: Border.all(color: statusColor.withOpacity(0.2)),
                                                        ),
                                                        child: Text(
                                                          status,
                                                          style: TextStyle(
                                                            color: statusColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  Text(
                                                    '${booking['price']} $reyalSymbol',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w900,
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        Container(
                                          padding: EdgeInsets.all(12.r),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(0.04),
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: Column(
                                            children: [
                                              buildDetailRow('العنوان:', booking['address'], 'assets/loc.svg', appCubit),
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                                child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                              ),
                                              buildDetailRow('الموعد:',formatStatusTime(booking['scheduledAt']), 'assets/timer.svg', appCubit),
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                                child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
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
              },)
            ),
          );
        },
    );
  }
}
