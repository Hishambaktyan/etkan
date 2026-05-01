import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_order_details.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';

class WorkerBookingScreen extends StatefulWidget {
  const WorkerBookingScreen({super.key});

  @override
  State<WorkerBookingScreen> createState() => _WorkerBookingScreenState();
}

class _WorkerBookingScreenState extends State<WorkerBookingScreen> {

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
  List<String> statusFilters = ['الكل', 'قيد الانتظار', 'مقبول','في الطريق','مكتمل','مرفوض','ملغي'];
  String selectedStatus = 'الكل';
  
  @override
  void initState() {
    AppCubit.get(context).getWorkerRequests();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    List<Map<String, dynamic>> filteredList = selectedStatus == 'الكل' ? cubit.workerRequests
        : cubit.workerRequests.where((item) => item['status'] == selectedStatus).toList();
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          return state is GetWorkerRequestsLoadingState?   UserBookingsShimmer(isDark: cubit.isDark)
          :  Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    headerWithSearch(title: 'الحجوزات',searchKeyWords: ['حجوزات مكتملة','حجوزات قيد الانتظار','حجوزات مقبولة'], context: context),
                    SizedBox(height: 20.h,),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        shrinkWrap: true,
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
                    SizedBox(height: 10.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:  EdgeInsetsDirectional.only(start: 10.w,end: 10.w,top: 5.h,bottom: 20.h),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        var booking = filteredList[index];
                        var userData = cubit.allUsers[booking['customerId']] ?? {};
                        Color statusColor;
                        switch (booking['status']) {
                          case 'مكتمل': statusColor = Colors.green; break;
                          case 'مقبول': statusColor = Colors.blueAccent; break;
                          case 'في الطريق': statusColor = Colors.blueAccent; break;
                          case 'مرفوض': statusColor = Colors.redAccent; break;
                          case 'ملغي': statusColor = Colors.redAccent; break;
                          default: statusColor = Colors.orangeAccent;
                        }
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: ()=>move(context, WorkerOrderDetails(request: booking,)),
                          child: Padding(
                            padding:EdgeInsetsDirectional.only(bottom:index==9?0 : 20.h),
                            child: Container(
                              padding: EdgeInsetsDirectional.only(start: 10.w,end:10.w,top: 10.h,bottom: 10.h),
                              decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.network(
                                          booking['image']?? '',
                                          width: 90.w,
                                          height: 90.h,
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
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    booking['title'] ?? '',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: cubit.isDark? Colors.white: Colors.black,
                                                        height: 1.2
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w,),
                                                Container(
                                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: statusColor.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(6.r),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      booking['status'] ?? '',
                                                      style: TextStyle(
                                                          color: statusColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11.sp,
                                                          height: 1.5
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              '${booking['price']} $reyalSymbol' ?? '',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color:mainColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    padding: const EdgeInsetsDirectional.all(10),
                                    decoration: BoxDecoration(
                                      color: cubit.isDark?darkBgColor:Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: cubit.isDark?const Color(0xFF30363D)  :Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      children: [
                                        buildDetailRow('العنوان:', booking['address'] ?? '','assets/loc.svg',cubit),
                                        Padding(
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                          child: dashedDivider(cubit.isDark? darkSubTextColor: Colors.grey),
                                        ),
                                        buildDetailRow('التاريخ والوقت:', cubit.formatStatusTime(booking['scheduledAt']) ?? '','assets/timer.svg',cubit),
                                        Padding(
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                          child: dashedDivider(cubit.isDark? darkSubTextColor: Colors.grey),
                                        ),
                                        buildDetailRow('العميل:', userData['name'] ?? '','assets/acc.svg',cubit),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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