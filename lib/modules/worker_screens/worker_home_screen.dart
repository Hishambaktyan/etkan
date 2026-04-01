import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/search_screen.dart';
import 'package:trying_homy/modules/worker_screens/add_service.dart';
import 'package:trying_homy/modules/worker_screens/worker_service_details.dart';
import 'package:trying_homy/modules/worker_screens/worker_services.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';

class WorkerHomeScreen extends StatelessWidget {
  WorkerHomeScreen({super.key});

  final List<Map<String, dynamic>> info = [
    {
      'title': 'كل الحجوزات',
      'icon': 'assets/receipt.svg',
    },
    {
      'title': 'الحجوزات المكتملة',
      'icon': 'assets/all.svg',
    },
    {
      'title': 'كل الخدمات',
      'icon': 'assets/tool.svg',
    },
    {
      'title': 'التقييم',
      'icon': 'assets/star.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    MyCubit cubit = MyCubit.get(context);
    return BlocConsumer<MyCubit, States>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is GetWorkerDataLoadingState
            ? WorkerHomeShimmer(isDark: cubit.isDark)
            : Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 340.h,
                          child: Stack(
                            children: [
                              Container(
                                height: 270.h,
                                padding: EdgeInsetsDirectional.only(
                                    start: 15.w, end: 15.w, top: 35.h),
                                decoration: BoxDecoration(
                                    gradient: cubit.amAvailable
                                        ? LinearGradient(
                                            colors: [
                                              mainColor,
                                              mainColor.withOpacity(0.7),
                                              mainColor.withOpacity(0.5),
                                              cubit.isDark
                                                  ? mainColor.withOpacity(0.5)
                                                  : Colors.white,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [0.0, 0.85, 0.95, 1.0])
                                        : LinearGradient(
                                            colors: [
                                              Colors.grey.shade500
                                                  .withOpacity(0.5),
                                              Colors.grey.shade700
                                                  .withOpacity(0.5),
                                              Colors.grey.shade300
                                                  .withOpacity(0.5),
                                              cubit.isDark
                                                  ? darkBgColor
                                                  : Colors.white,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [
                                              0.0,
                                              0.85,
                                              0.95,
                                              1.0
                                            ]),
                                    boxShadow: cubit.isDark
                                        ? [
                                            BoxShadow(
                                              color: (cubit.amAvailable
                                                      ? mainColor
                                                      : Colors.grey)
                                                  .withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ]
                                        : []),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 23.r,
                                          backgroundColor: Colors.white,
                                          foregroundImage: const NetworkImage(
                                              'https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg'),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                cubit.workerName ?? '',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                    color: Colors.white,
                                                    height: 1.2),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                cubit.workerDept ?? '',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.r),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white30),
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/not.svg',
                                                    width: 23.w,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            move(context, const SearchScreen());
                                          },
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.r),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white30),
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/search.svg',
                                                    width: 23.w,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 180.h,
                                          width: 300.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .vertical(
                                                          top: Radius.circular(
                                                              150.r)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0.2),
                                                  Colors.white.withOpacity(0.1),
                                                ],
                                              ),
                                              border: const BorderDirectional(
                                                top: BorderSide(
                                                    color: Colors.white),
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              bottom: 20.h),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${cubit.workerTotalAmount} \uFDFC',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28.sp,
                                                    height: 1),
                                              ),
                                              Text(
                                                'إجمالي الأرباح',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.sp,
                                                    height: 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 115.h,
                                  child: ListView.builder(
                                    padding: EdgeInsetsDirectional.only(
                                        end: 10.w, start: 10.w, bottom: 10.w),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: info.length,
                                    itemBuilder: (context, index) {
                                      var data = info[index];
                                      return Container(
                                        margin: EdgeInsetsDirectional.only(
                                            end: index == 3 ? 0 : 10.w),
                                        width: 170.w,
                                        decoration: BoxDecoration(
                                            color: cubit.isDark
                                                ? lightDarkColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            boxShadow:
                                                cubit.isDark ? [] : shadow),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: -10,
                                              left: -10,
                                              child: SvgPicture.asset(
                                                data['icon'],
                                                color: cubit.isDark
                                                    ? mainColor.withOpacity(0.1)
                                                    : mainColor
                                                        .withOpacity(0.2),
                                                width: 53.w,
                                                height: 53.h,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        index == 0
                                                            ? '${cubit.workerRequestsCount}'
                                                            : index == 1
                                                                ? '${cubit.workerComplatedRequestsCount}'
                                                                : index == 2
                                                                    ? '${cubit.workerServicesCount}'
                                                                    : index == 3
                                                                        ? '${cubit.workerRating}'
                                                                        : '0',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: cubit.isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 20.sp),
                                                      ),
                                                      const Spacer(),
                                                      CircleAvatar(
                                                        backgroundColor: cubit
                                                                .isDark
                                                            ? mainColor
                                                                .withOpacity(
                                                                    0.2)
                                                            : mainColor
                                                                .withOpacity(
                                                                    0.1),
                                                        radius: 23.r,
                                                        child: SvgPicture.asset(
                                                          data['icon'],
                                                          color: mainColor,
                                                          width: 23.w,
                                                          height: 23.h,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  Text(
                                                    data['title'],
                                                    style: TextStyle(
                                                        color: cubit.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13.sp,
                                                        height: 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          height: 120.h,
                          width: double.infinity,
                          margin:
                              EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            gradient: cubit.amAvailable
                                ? LinearGradient(
                                    colors: [
                                      mainColor,
                                      mainColor.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [
                                      0.0,
                                      0.85,
                                    ])
                                : LinearGradient(
                                    colors: [
                                      Colors.grey.shade500.withOpacity(0.5),
                                      Colors.grey.shade700.withOpacity(0.5),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [
                                      0.0,
                                      0.85,
                                    ]),
                            boxShadow: [
                              BoxShadow(
                                color: (cubit.amAvailable
                                        ? mainColor
                                        : Colors.grey)
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 20.h, vertical: 10.h),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28.r,
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset(
                                    'assets/power.svg',
                                    width: 28.w,
                                    height: 28.h,
                                    color: cubit.amAvailable
                                        ? mainColor
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'حالة الأتصال',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    ),
                                    Text(
                                      cubit.amAvailable
                                          ? 'انت الآن متصل'
                                          : 'انت الآن غير متصل',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: cubit.amAvailable,
                                    activeColor: Colors.white,
                                    onChanged: (value) =>
                                        cubit.changeAvailability(value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                          child: Row(
                            children: [
                              Text(
                                'الخدمات الحالية',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color),
                              ),
                              const Spacer(),
                              defaultTextButton(
                                  onPressed: () =>
                                      moveAndReplace(context, WorkerServices()),
                                  text: 'عرض الكل',
                                  isLined: false)
                            ],
                          ),
                        ),
                        cubit.workerServices.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Icon(Icons.inbox_outlined,
                                        size: 50.r,
                                        color: Colors.grey.shade400),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'لا يوجد لديك خدمات حالياً',
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey.shade400),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                itemCount: cubit.workerServices.length > 4
                                    ? 4
                                    : cubit.workerServices.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200.w,
                                        mainAxisExtent: 240.h,
                                        crossAxisSpacing: 10.w,
                                        mainAxisSpacing: 10.h),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12.r),
                                    onTap: () => move(
                                        context,
                                        WorkerServiceDetails(
                                          serviceId: cubit.workerServices[index]
                                              ['id'],
                                        )),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          color: cubit.isDark
                                              ? lightDarkColor
                                              : Colors.white,
                                          boxShadow: shadow),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 125.h,
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .only(
                                                              topStart: Radius
                                                                  .circular(
                                                                      12.r),
                                                              topEnd: Radius
                                                                  .circular(
                                                                      12.r)),
                                                  child: Image.network(
                                                    '${cubit.workerServices[index]['serviceImage']}',
                                                    height: 110.h,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Container(
                                                      height: 110.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadiusDirectional.only(
                                                                  topStart: Radius
                                                                      .circular(
                                                                          12.r),
                                                                  topEnd: Radius
                                                                      .circular(12
                                                                          .r)),
                                                          color: Colors
                                                              .grey.shade100),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .wifi_off_rounded,
                                                          size: 50,
                                                          color: Colors
                                                              .grey.shade400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomEnd,
                                                  child: Container(
                                                    height: 27.h,
                                                    width: 100.w,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(top: 3.h),
                                                    alignment: Alignment.center,
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .only(end: 10.w),
                                                    decoration: BoxDecoration(
                                                        color: mainColor,
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    30.r)),
                                                    child: Text(
                                                      '${cubit.workerServices[index]['price']} ﷼ ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topStart,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .only(
                                                                start: 10.w,
                                                                top: 10.h),
                                                    child: CircleAvatar(
                                                        radius: 18.r,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: SvgPicture.asset(
                                                          'assets/power.svg',
                                                          color: cubit
                                                                  .isServicesActive
                                                              ? Colors.green
                                                              : Colors.grey,
                                                          width: 22.w,
                                                          height: 22.h,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 5.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: List.generate(
                                                      5,
                                                      (i) => Icon(
                                                            Icons.star_rounded,
                                                            size: 16.r,
                                                            color: i < 4
                                                                ? Colors.orange
                                                                : Colors.grey
                                                                    .shade300,
                                                          )),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  '${cubit.workerServices[index]['name']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp,
                                                      color: cubit.isDark
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  '${cubit.workerServices[index]['description']}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: cubit.isDark
                                                          ? darkSubTextColor
                                                          : Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    mainColor,
                                    mainColor.withOpacity(0.7)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: mainColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -20,
                                    top: -20,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  Positioned(
                                    left: 30,
                                    bottom: -30,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20.r),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'وسع نطاق عملك',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                'أضف خدمات جديدة الآن وابدأ باستقبال المزيد من الطلبات',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              SizedBox(height: 15.h),
                                              ElevatedButton(
                                                onPressed: () => move(context,
                                                    const AddService()),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: mainColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  elevation: 0,
                                                ),
                                                child: const Text(
                                                    'إضافة خدمة جديدة'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.add_business_rounded,
                                          size: 70.r,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
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
