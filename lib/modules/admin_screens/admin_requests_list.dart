import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/admin_screens/admin_request_details.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
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

  Widget buildDetailRow(
      String label, String value, String iconPath, dynamic cubit) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 22.w,
            height: 22.h,
            color: mainColor,
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: cubit.isDark ? Colors.white : Colors.black87,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required String icon,
    required AppCubit appCubit,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.all(10.r),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: blueShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SvgPicture.asset(
                  icon,
                  width: 20.w,
                  height: 20.h,
                  color: mainColor,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  color: appCubit.isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: appCubit.isDark ? darkSubTextColor : Colors.grey,
            ),
          ),
        ],
      ),
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
        final AppCubit appCubit = context.watch<AppCubit>();

        List<Map<String, dynamic>> requests = selectedStatus == 'الكل'
            ? adminCubit.requests
            : adminCubit.requests
                .where((booking) => booking['status'] == selectedStatus)
                .toList();

        int pendingCount = adminCubit.requests
            .where((r) => r['status'] == 'قيد الانتظار')
            .length;

        int acceptedCount =
            adminCubit.requests.where((r) => r['status'] == 'مقبول').length;

        int onWayCount =
            adminCubit.requests.where((r) => r['status'] == 'في الطريق').length;

        int completedCount =
            adminCubit.requests.where((r) => r['status'] == 'مكتمل').length;

        int rejectedCount =
            adminCubit.requests.where((r) => r['status'] == 'مرفوض').length;

        int cancelledCount =
            adminCubit.requests.where((r) => r['status'] == 'ملغي').length;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: appCubit.isDark ? darkBgColor : bgColor,
            body: SingleChildScrollView(
              child: state is GetRequestsLoadingState
                  ? const AdminRequestsShimmer()
                  : Column(
                      children: [
                        header(
                            title: 'قائمة الحجوزات',
                            context: context,
                            isLeading: true,
                            isNotif: false),
                        Column(
                          children: [
                            SizedBox(
                              height: 280.h,
                              child: GridView(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsetsGeometry.all(15),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2,
                                        crossAxisSpacing: 10.w,
                                        mainAxisSpacing: 10.h),
                                children: [
                                  buildStatCard(
                                    title: 'قيد الانتظار',
                                    value: pendingCount.toString(),
                                    icon: 'assets/timer.svg',
                                    appCubit: appCubit,
                                  ),
                                  buildStatCard(
                                    title: 'مقبولة',
                                    value: acceptedCount.toString(),
                                    icon: 'assets/grid.svg',
                                    appCubit: appCubit,
                                  ),
                                  buildStatCard(
                                    title: 'في الطريق',
                                    value: onWayCount.toString(),
                                    icon: 'assets/timer.svg',
                                    appCubit: appCubit,
                                  ),
                                  buildStatCard(
                                    title: 'مكتملة',
                                    value: completedCount.toString(),
                                    icon: 'assets/grid.svg',
                                    appCubit: appCubit,
                                  ),
                                  buildStatCard(
                                    title: 'مرفوضة',
                                    value: rejectedCount.toString(),
                                    icon: 'assets/delete.svg',
                                    appCubit: appCubit,
                                  ),
                                  buildStatCard(
                                    title: 'ملغية',
                                    value: cancelledCount.toString(),
                                    icon: 'assets/delete.svg',
                                    appCubit: appCubit,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 55.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 15.w),
                                itemCount: statusFilters.length,
                                itemBuilder: (context, index) {
                                  bool isSelected =
                                      selectedStatus == statusFilters[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        end: 10.w, bottom: 10.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedStatus = statusFilters[index];
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? mainColor
                                              : appCubit.isDark
                                                  ? lightDarkColor
                                                  : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          boxShadow:
                                              isSelected || appCubit.isDark
                                                  ? []
                                                  : blueShadow,
                                        ),
                                        child: Text(
                                          statusFilters[index],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : appCubit.isDark
                                                    ? darkSubTextColor
                                                    : Colors.grey.shade700,
                                            fontSize: 12.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsetsDirectional.all(15.w),
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            var request = requests[index];
                            final providerData =
                                adminCubit.providers.firstWhere(
                              (element) =>
                                  element['id'] == request['providerId'],
                              orElse: () => {'name': 'غير محدد'},
                            );
                            final userData = adminCubit.users.firstWhere(
                              (element) =>
                                  element['id'] == request['customerId'],
                              orElse: () => {'name': 'غير محدد'},
                            );

                            String status = request['status'];
                            Color statusColor;
                            switch (request['status']) {
                              case 'مكتمل':
                                statusColor = Colors.green;
                                break;
                              case 'مقبول':
                              case 'في الطريق':
                                statusColor = Colors.blue;
                                break;
                              case 'مرفوض':
                              case 'ملغي':
                                statusColor = Colors.red;
                                break;
                              default:
                                statusColor = Colors.orange;
                            }

                            return InkWell(
                              onTap: () => move(
                                  context,
                                  AdminRequestDetails(
                                      request: request,
                                      providerData: providerData,
                                      userData: userData)),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.only(bottom: 20.h),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () => move(
                                      context,
                                      AdminRequestDetails(
                                          request: request,
                                          providerData: providerData,
                                          userData: userData)),
                                  child: Container(
                                    width: 330.w,
                                    padding: EdgeInsetsDirectional.all(15.r),
                                    decoration: BoxDecoration(
                                      color: appCubit.isDark
                                          ? lightDarkColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: blueShadow,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                border: Border.all(
                                                  color: mainColor
                                                      .withOpacity(0.1),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(18.r),
                                                child: Image.network(
                                                  request['image'] ?? '',
                                                  width: 70.w,
                                                  height: 70.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Container(
                                                    width: 70.w,
                                                    height: 70.h,
                                                    color: appCubit.isDark
                                                        ? darkBgColor
                                                        : Colors.grey.shade200,
                                                    child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                        size: 20.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          request['title'] ??
                                                              '',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: appCubit
                                                                    .isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.w,
                                                                vertical: 4.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: statusColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.r),
                                                          border: Border.all(
                                                              color: statusColor
                                                                  .withOpacity(
                                                                      0.2)),
                                                        ),
                                                        child: Text(
                                                          status,
                                                          style: TextStyle(
                                                            color: statusColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  Text(
                                                    '${request['price'] ?? ''} $reyalSymbol',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                            color: appCubit.isDark
                                                ? darkBgColor
                                                : mainColor.withOpacity(0.04),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Column(
                                            children: [
                                              buildDetailRow(
                                                  'العنوان:',
                                                  request['address'] ?? '',
                                                  'assets/loc.svg',
                                                  appCubit),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.h),
                                                child: Divider(
                                                    color: appCubit.isDark
                                                        ? darkSubTextColor
                                                            .withOpacity(0.25)
                                                        : Colors.grey
                                                            .withOpacity(0.1),
                                                    height: 1),
                                              ),
                                              buildDetailRow(
                                                  'الموعد:',
                                                  formatStatusTime(
                                                      request['scheduledAt'] ??
                                                          ''),
                                                  'assets/timer.svg',
                                                  appCubit),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.h),
                                                child: Divider(
                                                    color: appCubit.isDark
                                                        ? darkSubTextColor
                                                            .withOpacity(0.25)
                                                        : Colors.grey
                                                            .withOpacity(0.1),
                                                    height: 1),
                                              ),
                                              buildDetailRow(
                                                  'الفني:',
                                                  providerData['name'] ?? '',
                                                  'assets/providers.svg',
                                                  appCubit),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.h),
                                                child: Divider(
                                                    color: appCubit.isDark
                                                        ? darkSubTextColor
                                                            .withOpacity(0.25)
                                                        : Colors.grey
                                                            .withOpacity(0.1),
                                                    height: 1),
                                              ),
                                              buildDetailRow(
                                                  'المستخدم:',
                                                  userData['name'] ?? '',
                                                  'assets/acc.svg',
                                                  appCubit),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
