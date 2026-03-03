import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_order_details.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/cubit/states.dart';
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
    MyCubit.get(context).getWorkerRequests();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    MyCubit cubit = MyCubit.get(context);
    List<Map<String, dynamic>> filteredList = selectedStatus == 'الكل'
        ? cubit.workerRequests
        : cubit.workerRequests.where((item) => item['status'] == selectedStatus).toList();
    return BlocConsumer<MyCubit,States>(
      listener: (context, state) {},
        builder: (context, state) {
          return state is GetWorkerRequestsLoadingState?   BookingShimmerLoading(isDark: cubit.isDark)
          :  Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 10,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                title: Text(
                  'الحجوزات',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).textTheme.bodyLarge!.color!,
                              )
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              SvgPicture.asset(
                                'assets/not.svg',
                                color: Theme.of(context).iconTheme.color,
                              ),
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
              body: Column(
                children: [
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
                      padding:  EdgeInsetsDirectional.only(start: 20.w,end: 20.w,top: 5.h,bottom: 20.h),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        var booking = filteredList[index];

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
                          onLongPress: () async {
                            await cubit.createRequest(
                            category: "2",
                            customerId: "2",
                            providerId: "zgyZCfttdmWsmKTNWneC4vbD7sX2",
                            subCategory: "6",
                            address: "الشعب - حي السعادة عمارة 12",
                            latitude: "33",
                            clientName: "مروان أحمد عوض باقيان",
                            clientPhone: "771771771",
                            title: "ترميم بيبات الحمام",
                            description: "وصف تجريبي للخدمة المطلوبة للتأكد من ظهور البيانات",
                            image: "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
                            clientImage: "https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg",
                            price: 30000,
                            number: 2,
                            );
                          },
                          child: Padding(
                            padding:EdgeInsetsDirectional.only(bottom:index==9?0 : 20.h),
                            child: Container(
                              padding: EdgeInsetsDirectional.only(start: 10.w,end:10.w,top: 10.h,bottom: 10.h),
                              decoration: BoxDecoration(
                                  color: cubit.isDark?lightDarkColor:Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: cubit.isDark?[]:shadow,
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
                                      SizedBox(
                                          width: 10.w
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                booking['status']=='قيد الانتظار'?SizedBox(
                                                  width: 100.w,
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
                                                )
                                                    :booking['status']=='في الطريق'?SizedBox(
                                                  width: 110.w,
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
                                                )
                                                    :SizedBox(
                                                  width: 130.w,
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
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 30.h,
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
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: 7.h
                                            ),
                                            Text(
                                              'رقم الطلب: ${booking['number']} ' ?? '',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: darkSubTextColor,
                                                  height: 1
                                              ),
                                            ),
                                            SizedBox(
                                                height: 7.h
                                            ),
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
                                  SizedBox(
                                      height: 10.h
                                  ),
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
                                        buildDetailRow('العميل:', booking['clientName'] ?? '','assets/acc.svg',cubit),
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
                  ),
                ],
              ),
            ),
          );
        },

    );
  }
}