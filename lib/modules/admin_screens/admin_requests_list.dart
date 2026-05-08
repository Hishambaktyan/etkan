import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AdminRequestsList extends StatefulWidget {
  const AdminRequestsList({super.key});

  @override
  State<AdminRequestsList> createState() => _AdminRequestsListState();
}

class _AdminRequestsListState extends State<AdminRequestsList> {
  String selectedStatus = 'الكل';

  final List<String> statusFilters = [
    'الكل',
    'قيد الانتظار',
    'مقبول',
    'في الطريق',
    'مكتمل',
    'مرفوض',
    'ملغي',
  ];

  Widget buildDetailRow(String label, String value, String iconPath, dynamic cubit) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            color:  mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
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
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    AdminCubit.get(context).getRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminStates>(
      builder: (context, state) {
        AdminCubit adminCubit = AdminCubit.get(context);
        List<Map<String, dynamic>> requests = selectedStatus == 'الكل'
            ? adminCubit.requests
            : adminCubit.requests
                .where((booking) => booking['status'] == selectedStatus)
                .toList();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: state is GetRequestsLoadingState ? const AdminRequestsShimmer()
                  :Column(
                children: [
                  header(title: 'قائمة الحجوزات', context: context,isLeading: true,isNotif: false),
                  Padding(
                    padding:  EdgeInsetsDirectional.only(top: 15.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w,bottom: 10.h),
                            itemCount: statusFilters.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedStatus == statusFilters[index];
                              return Padding(
                                padding: EdgeInsetsDirectional.only(end: 10.w),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedStatus = statusFilters[index];
                                    });
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected ? mainColor : Colors.white,
                                      borderRadius: BorderRadius.circular(15.r),
                                      boxShadow: isSelected ? [] : blueShadow,
                                      border: Border.all(
                                        color: isSelected ? mainColor : Colors.grey.shade100,
                                      ),
                                    ),
                                    child: Text(
                                      statusFilters[index],
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.grey.shade700,
                                        fontSize: 13.sp,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsetsDirectional.only(start: 20.w,end: 20.w,top: 5.h,),
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            var request = requests[index];
                            final providerData = adminCubit.providers.firstWhere((element) => element['id']==request['providerId'],);
                            final userData = adminCubit.providers.firstWhere((element) => element['id']==request['providerId'],);
                            Color statusColor;
                            String status = request['status'];

                            switch (status) {
                              case 'مكتمل':
                                statusColor = Colors.green;
                                break;
                              case 'مقبول':
                              case 'في الطريق':
                                statusColor = Colors.blueAccent;
                                break;
                              case 'مرفوض':
                              case 'ملغي':
                                statusColor = Colors.redAccent;
                                break;
                              default:
                                statusColor = Colors.orangeAccent;
                            }
                            return Padding(
                              padding: EdgeInsetsDirectional.only(bottom: 20.h),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: (){},
                                child: Container(
                                  width: 330.w,
                                  padding: EdgeInsetsDirectional.all(15.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                                request['image'] ?? '',
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
                                                        request['title'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
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
                                                  '${request['price']} $reyalSymbol',
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
                                            buildDetailRow('العنوان:', request['address'], 'assets/loc.svg', adminCubit),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.h),
                                              child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                            ),
                                            buildDetailRow('الموعد:', formatStatusTime(request['scheduledAt']), 'assets/timer.svg', adminCubit),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.h),
                                              child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                            ),
                                            buildDetailRow('الفني:', providerData['name'], 'assets/providers.svg', adminCubit),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8.h),
                                              child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                            ),
                                            buildDetailRow('المستخدم:', userData['name'], 'assets/acc.svg', adminCubit),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}