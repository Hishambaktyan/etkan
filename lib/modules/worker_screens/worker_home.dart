import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_add_service.dart';
import 'package:trying_homy/modules/worker_screens/worker_service_details.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  final List<Map<String, dynamic>> info = [
    {
      'title': 'كل الحجوزات',
      'icon': 'assets/bookings.svg',
    },
    {
      'title': 'الحجوزات المكتملة',
      'icon': 'assets/all.svg',
    },
    {
      'title': 'كل الخدمات',
      'icon': 'assets/services.svg',
    },
    {
      'title': 'التقييم',
      'icon': 'assets/star.svg',
    },
  ];

  Widget _buildSectionTitle({
    required String title,
    required String icon,
    required AppCubit appCubit,
  }) =>
      Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                icon,
                color: mainColor,
                width: 20.w,
              )),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  bool hasInternet = true;
  bool checkingInternet = true;

  Future<void> checkConnectionAndGetData({bool forceRefresh = false}) async {
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
      await WorkerCubit.get(context).getWorkerData(forceRefresh: forceRefresh);
    }
  }

  late NotificationCubit notificationCubit;

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
        return BlocConsumer<WorkerCubit, WorkerStates>(
          listener: (context, state) {
            if (state is ChangeServiceActivitySuccessState) {
              showSnackBar(Colors.green, 'تم تغيير حالة الخدمة', context);
            }
            if (state is ChangeServiceActivityErrorState) {
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, state) {
            WorkerCubit workerCubit = WorkerCubit.get(context);
            final publishedServices = workerCubit.workerServices
                .where((service) => service['isActive'] == true)
                .toList();
            return ConditionalBuilder(
              condition: checkingInternet || state is GetWorkerDataLoadingState,
              builder: (context) => WorkerHomeShimmer(isDark: appCubit.isDark),
              fallback: (context) => ConditionalBuilder(
                condition: !hasInternet,
                builder: (context) => NoInternet(
                  onRetry: () => checkConnectionAndGetData(forceRefresh: true),
                ),
                fallback: (context) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: RefreshIndicator(
                      onRefresh: () =>
                          checkConnectionAndGetData(forceRefresh: true),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header(
                              title:
                                  'مرحبا، ${workerCubit.workerName!.split(' ')[0] ?? ''}',
                              context: context,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 1.2,
                              ),
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(
                                  end: 10.w, start: 10.w, bottom: 15.w),
                              itemCount: info.length,
                              itemBuilder: (context, index) {
                                var data = info[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow,
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      PositionedDirectional(
                                        bottom: -15.h,
                                        start: -15.w,
                                        child: Transform.rotate(
                                          angle: 0.5,
                                          child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            decoration: BoxDecoration(
                                              color:
                                                  mainColor.withOpacity(0.03),
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              data['icon'],
                                              // ignore: deprecated_member_use
                                              color: mainColor.withOpacity(
                                                  appCubit.isDark ? 0.05 : 0.1),
                                              width: 70.w,
                                              height: 70.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15.r),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10.r),
                                                  decoration: BoxDecoration(
                                                    color: mainColor
                                                        .withOpacity(0.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    data['icon'],
                                                    // ignore: deprecated_member_use
                                                    color: mainColor,
                                                    width: 22.w,
                                                  ),
                                                ),
                                                Text(
                                                  index == 0
                                                      ? '${workerCubit.workerRequestsCount ?? ''}'
                                                      : index == 1
                                                          ? '${workerCubit.workerCompletedRequestsCount ?? ''}'
                                                          : index == 2
                                                              ? '${workerCubit.workerServicesCount ?? ''}'
                                                              : index == 3
                                                                  ? '${workerCubit.workerRating ?? ''}'
                                                                  : '0',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : mainColor,
                                                    fontSize: 22.sp,
                                                    letterSpacing: -1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['title'],
                                                  style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                            .withOpacity(0.9)
                                                        : Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Container(
                                                  width: 25.w,
                                                  height: 3.h,
                                                  decoration: BoxDecoration(
                                                    color: mainColor
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10.w, end: 2.w),
                                child: _buildSectionTitle(
                                    title: 'حالة الاتصال',
                                    icon: 'assets/power.svg',
                                    appCubit: appCubit)),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.w),
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: appCubit.isDark
                                    ? lightDarkColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: blueShadow,
                                border: Border.all(
                                  color: workerCubit.amAvailable
                                      ? mainColor.withOpacity(0.1)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        width: 58.w,
                                        height: 58.w,
                                        decoration: BoxDecoration(
                                          color: workerCubit.amAvailable
                                              ? mainColor.withOpacity(0.08)
                                              : Colors.grey.withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/power.svg',
                                        width: 26.w,
                                        height: 26.h,
                                        color: workerCubit.amAvailable
                                            ? mainColor
                                            : Colors.grey,
                                      ),
                                      if (workerCubit.amAvailable)
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: Container(
                                            width: 12.w,
                                            height: 12.w,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workerCubit.amAvailable
                                              ? 'متاح لاستقبال الطلبات'
                                              : 'غير متاح حالياً',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w900,
                                            color: appCubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          workerCubit.amAvailable
                                              ? 'يمكن للعملاء إرسال طلبات جديدة إليك'
                                              : 'لن تظهر للعملاء كعامل متاح حالياً',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Switch(
                                    value: workerCubit.amAvailable,
                                    activeColor: mainColor,
                                    activeTrackColor:
                                        mainColor.withOpacity(0.4),
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: appCubit.isDark
                                        ? Colors.grey.withOpacity(0.3)
                                        : Colors.grey.shade300,
                                    onChanged: (value) {
                                      workerCubit.changeAvailability(value);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 10.w,
                                end: 2.w,
                              ),
                              child: _buildSectionTitle(
                                title: 'الخدمات المنشورة',
                                icon: 'assets/services.svg',
                                appCubit: appCubit,
                              ),
                            ),
                            publishedServices.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 50,
                                          color: Colors.grey.shade400,
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          'لا توجد لديك خدمات منشورة حالياً',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : GridView.builder(
                                    itemCount: publishedServices.length > 4
                                        ? 4
                                        : publishedServices.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 250.h,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 15.h,
                                    ),
                                    itemBuilder: (context, index) {
                                      final service = publishedServices[index];

                                      return Container(
                                        decoration: BoxDecoration(
                                          color: appCubit.isDark
                                              ? lightDarkColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.r),
                                          boxShadow: blueShadow,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 135.h,
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.r),
                                                    child: Image.network(
                                                      '${service['serviceImage'] ?? ''}',
                                                      height: 120.h,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) =>
                                                          Container(
                                                        height: 120.h,
                                                        color: Colors
                                                            .grey.shade100,
                                                        child: Icon(
                                                          Icons
                                                              .wifi_off_rounded,
                                                          color: Colors
                                                              .grey.shade400,
                                                          size: 30.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  PositionedDirectional(
                                                    bottom: 5.h,
                                                    end: 10.w,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 6.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: mainColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.r),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            blurRadius: 8,
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        '${service['price'] ?? ''} ﷼',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => move(
                                                context,
                                                WorkerServiceDetails(
                                                    service: service),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: Colors.amber,
                                                          size: 16.sp,
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          '${service['rate'] ?? ''}',
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    Text(
                                                      '${service['name'] ?? ''}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 13.sp,
                                                        color: appCubit.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      '${service['description'] ?? ''}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        height: 1.3,
                                                        color: appCubit.isDark
                                                            ? darkSubTextColor
                                                            : Colors
                                                                .grey.shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.w),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.vertical(
                                          top: Radius.circular(30.r)),
                                  boxShadow: blueShadow,
                                  gradient: const LinearGradient(
                                    colors: [mainColor, Color(0xFF1A1A2E)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: -15.w,
                                      top: -15.h,
                                      child: Container(
                                        width: 100.r,
                                        height: 100.r,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 40.w,
                                      bottom: -20.h,
                                      child: Transform.rotate(
                                        angle: 0.8,
                                        child: Container(
                                          width: 80.r,
                                          height: 80.r,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.03),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(22.r),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Text(
                                                    'فرصة جديدة ✨',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                Text(
                                                  'وسع نطاق عملك',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                SizedBox(height: 6.h),
                                                Text(
                                                  'أضف خدمات جديدة الآن وابدأ باستقبال المزيد من الطلبات',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    fontSize: 12.sp,
                                                    height: 1.3,
                                                  ),
                                                ),
                                                SizedBox(height: 20.h),
                                                InkWell(
                                                  onTap: () => move(context,
                                                      const WorkerAddService()),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.w,
                                                            vertical: 10.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                              0, 4),
                                                        )
                                                      ],
                                                    ),
                                                    child: Text(
                                                      'إضافة خدمة جديدة',
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 80.r,
                                                height: 80.r,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.08),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Icon(
                                                Icons.add_business_rounded,
                                                size: 50.r,
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
