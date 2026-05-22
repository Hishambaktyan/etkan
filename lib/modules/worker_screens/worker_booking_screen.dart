import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_order_details.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
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

  bool hasInternet = true;
  bool checkingInternet = true;

  Future<void> checkConnectionAndGetData({bool forceRefresh =false}) async {
    setState(() {
      checkingInternet = true;
    });

    final result = await checkInternet();

    if (!mounted) return;

    setState(() {
      hasInternet = result;
      checkingInternet = false;
    });

    if (result) {
      await WorkerCubit.get(context).getWorkerRequests(forceRefresh: forceRefresh);
    }
  }
  
  @override
  void initState() {
    super.initState();
    checkConnectionAndGetData();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return  BlocBuilder<WorkerCubit,WorkerStates>(
              builder: (context, state) {
                WorkerCubit workerCubit = WorkerCubit.get(context);
                List<Map<String, dynamic>> filteredList = selectedStatus == 'الكل' ? workerCubit.workerRequests
                    : workerCubit.workerRequests.where((item) => item['status'] == selectedStatus).toList();
                return ConditionalBuilder(
                    condition: checkingInternet,
                    builder: (context) => UserBookingsShimmer(isDark: appCubit.isDark),
                    fallback: (context) => ConditionalBuilder(
                        condition: !hasInternet,
                        builder: (context) => NoInternet(onRetry: () => checkConnectionAndGetData(forceRefresh: true),),
                        fallback: (context) => ConditionalBuilder(
                            condition: state is GetWorkerRequestsLoadingState,
                            builder: (context) => UserBookingsShimmer(isDark: appCubit.isDark),
                            fallback: (context) => Directionality(
                              textDirection: TextDirection.rtl,
                              child: Scaffold(
                                body: RefreshIndicator(
                                  onRefresh: () => checkConnectionAndGetData(forceRefresh: true),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        headerWithSearch(title: 'الحجوزات',searchKeyWords: ['حجوزات مكتملة','حجوزات قيد الانتظار','حجوزات مقبولة'], context: context),
                                        SizedBox(height: 20.h,),
                                        SizedBox(
                                          height: 55.h,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                                            itemCount: statusFilters.length,
                                            itemBuilder: (context, index) {
                                              bool isSelected = selectedStatus == statusFilters[index];
                                              return Padding(
                                                padding: EdgeInsetsDirectional.only(end: 10.w,bottom: 10.h),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedStatus = statusFilters[index];
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 300),
                                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? mainColor : Colors.white,
                                                      borderRadius: BorderRadius.circular(15.r),
                                                      boxShadow: isSelected ? [] : blueShadow,
                                                    ),
                                                    child: Text(
                                                      statusFilters[index],
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : Colors.grey.shade700,
                                                        fontSize: 12.sp,
                                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
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
                                            var userData = appCubit.allUsers[booking['customerId']] ?? {};
                                            Color statusColor;
                                            switch (booking['status']) {
                                              case 'مكتمل': statusColor = Colors.green; break;
                                              case 'مقبول': statusColor = Colors.blueAccent; break;
                                              case 'في الطريق': statusColor = Colors.blueAccent; break;
                                              case 'مرفوض': statusColor = Colors.redAccent; break;
                                              case 'ملغي': statusColor = Colors.redAccent; break;
                                              default: statusColor = Colors.orangeAccent;
                                            }
                                            return Padding(
                                              padding: EdgeInsetsDirectional.only(bottom: 20.h),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () => move(context, WorkerOrderDetails(request: booking,)),
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
                                                                        booking['status'],
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
                                                            buildDetailRow('الموعد:', formatStatusTime(booking['scheduledAt']), 'assets/timer.svg', appCubit),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 8.h),
                                                              child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                                            ),
                                                            buildDetailRow('المستخدم:', userData['name'], 'assets/acc.svg', appCubit),
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
                              ),
                            ),
                        )
                    ),
                );
              },
          );
        },

    );
  }
}