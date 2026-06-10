import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/user_request_details.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';

class UserRequestsList extends StatefulWidget {
  const UserRequestsList({super.key});

  @override
  State<UserRequestsList> createState() => _UserRequestsListState();
}

class _UserRequestsListState extends State<UserRequestsList> {
  List<String> statusFilters = [
    'الكل',
    'قيد الانتظار',
    'مقبول',
    'في الطريق',
    'مكتمل',
    'مرفوض',
    'ملغي'
  ];
  String selectedStatus = 'الكل';
  Widget buildDetailRow(
      String label, String value, String iconPath, dynamic cubit) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.2)
                  : mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r)),
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
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  bool hasInternet = true;
  bool checkingInternet = true;

  Future<void> checkConnectionAndGetData({bool forceRefresh = false}) async {
    if (!mounted) return;

    setState(() {
      checkingInternet = true;
    });

    final result = await checkInternet();

    if (!mounted) return;

    if (!result) {
      setState(() {
        hasInternet = false;
        checkingInternet = false;
      });
      return;
    }

    try {
      final userCubit = UserCubit.get(context);

      userCubit.getUserRequests(forceRefresh: forceRefresh);

      if (!mounted) return;

      setState(() {
        hasInternet = true;
        checkingInternet = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        hasInternet = true;
        checkingInternet = false;
      });

      debugPrint('Error loading home data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectionAndGetData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        UserCubit userCubit = UserCubit.get(context);
        List<Map<String, dynamic>> filteredList = selectedStatus == 'الكل'
            ? userCubit.userRequests
            : userCubit.userRequests
                .where((item) => item['status'] == selectedStatus)
                .toList();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              body: BlocBuilder<UserCubit, UserStates>(
            builder: (context, state) {
              UserCubit userCubit = UserCubit.get(context);
              return ConditionalBuilder(
                  condition:
                      checkingInternet || state is GetUserRequestLoadingState,
                  builder: (context) =>
                      UserBookingsShimmer(isDark: appCubit.isDark),
                  fallback: (context) => ConditionalBuilder(
                        condition: !hasInternet,
                        builder: (context) => NoInternet(
                          onRetry: () =>
                              checkConnectionAndGetData(forceRefresh: true),
                        ),
                        fallback: (context) => RefreshIndicator(
                          color: mainColor,
                          onRefresh: () =>
                              checkConnectionAndGetData(forceRefresh: true),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                header(
                                  title: 'الحجوزات',
                                  context: context,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                SizedBox(
                                  height: 55.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 10.w),
                                    itemCount: statusFilters.length,
                                    itemBuilder: (context, index) {
                                      bool isSelected = selectedStatus ==
                                          statusFilters[index];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            end: 10.w, bottom: 10.h),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedStatus =
                                                  statusFilters[index];
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
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
                                                  isSelected ? [] : blueShadow,
                                            ),
                                            child: Text(
                                              statusFilters[index],
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
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
                                SizedBox(
                                  height: 10.h,
                                ),
                                filteredList.isEmpty
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.55,
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 100.w,
                                              height: 100.w,
                                              padding: EdgeInsets.all(15.r),
                                              decoration: BoxDecoration(
                                                color:
                                                    mainColor.withOpacity(0.08),
                                                shape: BoxShape.circle,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/ticket.svg',
                                                color: mainColor,
                                              ),
                                            ),
                                            SizedBox(height: 20.h),
                                            Text(
                                              'لا توجد حجوزات لك',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.sp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              'عند حجز أي خدمة ستظهر تفاصيل الحجز هنا.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                height: 1.6,
                                                color: appCubit.isDark
                                                    ? darkSubTextColor
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsetsDirectional.only(
                                            start: 10.w, end: 10.w, top: 5.h),
                                        itemCount:
                                            userCubit.userRequests.length,
                                        itemBuilder: (context, index) {
                                          var booking =
                                              userCubit.userRequests[index];
                                          Color statusColor;
                                          String status = booking['status'];
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
                                          var providerData = appCubit
                                              .allUsers[booking['providerId']];
                                          return Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                bottom: 20.h),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () => move(
                                                  context,
                                                  UserRequestDetails(
                                                      request: booking,
                                                      providerData:
                                                          providerData)),
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.all(
                                                        15.r),
                                                decoration: BoxDecoration(
                                                  color: appCubit.isDark
                                                      ? lightDarkColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r),
                                                  boxShadow: blueShadow,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.r),
                                                            border: Border.all(
                                                              color: mainColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.r),
                                                            child:
                                                                Image.network(
                                                              booking['image'] ??
                                                                  '',
                                                              width: 70.w,
                                                              height: 70.h,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Container(
                                                                width: 70.w,
                                                                height: 70.h,
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                child: Icon(
                                                                    Icons
                                                                        .image_not_supported,
                                                                    color: Colors
                                                                        .grey,
                                                                    size:
                                                                        20.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 15.w),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      booking[
                                                                          'title'],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: appCubit.isDark
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5.w,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 10
                                                                            .w,
                                                                        vertical:
                                                                            4.h),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: statusColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.r),
                                                                      border: Border.all(
                                                                          color:
                                                                              statusColor.withOpacity(0.2)),
                                                                    ),
                                                                    child: Text(
                                                                      status,
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            statusColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            10.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 6.h),
                                                              Text(
                                                                '${booking['price']} $reyalSymbol',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color:
                                                                      mainColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15.h),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(12.r),
                                                      decoration: BoxDecoration(
                                                        color: mainColor
                                                            .withOpacity(0.04),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          buildDetailRow(
                                                              'العنوان:',
                                                              booking[
                                                                  'address'],
                                                              'assets/loc.svg',
                                                              appCubit),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8.h),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                height: 1),
                                                          ),
                                                          buildDetailRow(
                                                              'الموعد:',
                                                              formatStatusTime(
                                                                  booking[
                                                                      'scheduledAt']),
                                                              'assets/timer.svg',
                                                              appCubit),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8.h),
                                                            child: Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.1),
                                                                height: 1),
                                                          ),
                                                          buildDetailRow(
                                                              'الفني:',
                                                              providerData[
                                                                  'name'],
                                                              'assets/acc.svg',
                                                              appCubit),
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
                      ));
            },
          )),
        );
      },
    );
  }
}
