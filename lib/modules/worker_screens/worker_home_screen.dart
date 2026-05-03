import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/add_service.dart';
import 'package:trying_homy/modules/worker_screens/worker_service_details.dart';
import 'package:trying_homy/modules/worker_screens/worker_services.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
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
  }) {
    return Row(
      children: [
        Container(
            padding: EdgeInsetsDirectional.all(10.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(icon,color: mainColor,width: 20.w,)
        ),
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
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        if (state is GetWorkerDataLoadingState) {
          return WorkerHomeShimmer(isDark: cubit.isDark);
        } else {
          return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerWithSearch(
                            title: 'مرحبا، ${cubit.workerName}',
                            searchKeyWords:['ايحث عن خدماتك','ايحث عن حجوزاتك المكتملة','ايحث عن خدماتك الرائجة',] ,
                            context: context
                        ),
                        SizedBox(height: 10.h,),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.w,
                            mainAxisSpacing: 15.h,
                            childAspectRatio: 1.5
                          ),
                          shrinkWrap: true,
                          padding: EdgeInsetsDirectional.only(end: 10.w, start: 10.w, bottom: 10.w),
                          itemCount: info.length,
                          itemBuilder: (context, index) {
                            var data = info[index];
                            return Container(
                              margin: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 10.w),
                              decoration: BoxDecoration(
                                  color: cubit.isDark ? lightDarkColor : Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: blueShadow
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: -10,
                                    left: -10,
                                    child: Transform.rotate(
                                      angle: 0.4,
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
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsetsDirectional.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: cubit.isDark ? mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1),
                                              radius: 25.r,
                                              child: SvgPicture.asset(
                                                data['icon'],
                                                color: mainColor,
                                                width: 27.w,
                                              ),
                                            ),
                                            const Spacer(),
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
                                                  color: mainColor,
                                                  fontSize: 20.sp),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
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
                        SizedBox(height: 20.h,),
                        Padding(
                            padding: EdgeInsetsDirectional.only(start: 10.w,end: 2.w),
                            child: _buildSectionTitle(title: 'حالة الاتصال', icon: 'assets/power.svg', appCubit: cubit)
                        ),
                        SizedBox(height: 10.h,),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                          padding: EdgeInsetsDirectional.all(15.r),
                          decoration: BoxDecoration(
                            color: cubit.isDark ? lightDarkColor : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: cubit.amAvailable
                                  ? mainColor.withOpacity(0.35)
                                  : Colors.grey.withOpacity(0.25),
                            ),
                            boxShadow: cubit.isDark ? [] : blueShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 55.w,
                                height: 55.w,
                                decoration: BoxDecoration(
                                  color: cubit.amAvailable
                                      ? mainColor.withOpacity(0.12)
                                      : Colors.grey.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/power.svg',
                                    width: 27.w,
                                    height: 27.h,
                                    color: cubit.amAvailable ? mainColor : Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cubit.amAvailable ? 'متاح لاستقبال الطلبات' : 'غير متاح حالياً',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      cubit.amAvailable
                                          ? 'يمكن للعملاء إرسال طلبات جديدة إليك'
                                          : 'لن تظهر للعملاء كعامل متاح حالياً',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        height: 1.5,
                                        color: cubit.isDark ? darkSubTextColor : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: () => cubit.changeAvailability(!cubit.amAvailable),
                                borderRadius: BorderRadius.circular(30.r),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: 75.w,
                                  height: 36.h,
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    color: cubit.amAvailable ? mainColor : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: AnimatedAlign(
                                    duration: const Duration(milliseconds: 250),
                                    alignment: cubit.amAvailable
                                        ? AlignmentDirectional.centerStart
                                        : AlignmentDirectional.centerEnd,
                                    child: Container(
                                      width: 28.w,
                                      height: 28.w,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        cubit.amAvailable
                                            ? Icons.check_rounded
                                            : Icons.close_rounded,
                                        color: cubit.amAvailable ? mainColor : Colors.grey,
                                        size: 18.r,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: 10.w,end: 2.w),
                          child: Row(
                            children: [
                              _buildSectionTitle(title: 'الخدمات الحالية', icon: 'assets/services.svg', appCubit: cubit),
                              const Spacer(),
                              defaultTextButton(onPressed: ()=>move(context, WorkerServices()), text: 'عرض الكل',isLined: false),
                            ],
                          )
                        ),
                        cubit.workerServices.isEmpty ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        Icons.inbox_outlined,
                                        size: 50,
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
                                itemCount: cubit.workerServices.length > 4 ? 4 : cubit.workerServices.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 230.h,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.w,
                                        mainAxisSpacing: 15.h
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        color: mainColor.withOpacity(0.09),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 125.h,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadiusDirectional.only(
                                                    topStart: Radius.circular(20.r),
                                                    topEnd: Radius.circular(20.r)
                                                ),
                                                child: Image.network(
                                                  '${cubit.workerServices[index]['serviceImage']}',
                                                  height: 110.h,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Container(
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
                                                alignment: AlignmentDirectional.bottomEnd,
                                                child: Container(
                                                  height: 30.h,
                                                  width: 110.w,
                                                  padding: EdgeInsetsDirectional.only(top: 3.h),
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsetsDirectional.only(end: 10.w),
                                                  decoration: BoxDecoration(
                                                      color: mainColor,
                                                      border: Border.all(
                                                          color: Colors.white
                                                      ),
                                                      borderRadius: BorderRadius.circular(30.r)
                                                  ),
                                                  child: Text(
                                                    '${cubit.workerServices[index]['price']} ﷼ ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13.sp),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topStart,
                                                child: InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      showSnackBar(
                                                          Colors.green,
                                                          cubit.isServicesActive? 'تم الغاء تفعيل الخدمة':'تم تفعيل الخدمة',
                                                          context
                                                      );
                                                      cubit.isServicesActive=!cubit.isServicesActive;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.only(start: 10.w, top: 10.h),
                                                    child: CircleAvatar(
                                                        radius: 18.r,
                                                        backgroundColor: Colors.white,
                                                        child: SvgPicture.asset(
                                                          'assets/power.svg',
                                                          color: cubit.isServicesActive ? Colors.green : Colors.grey,
                                                          width: 22.w,
                                                          height: 22.h,
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => move(context, WorkerServiceDetails(serviceId: cubit.workerServices[index]['id'],)),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(start: 10.w,end: 10.w,top: 5.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                 Row(
                                                   crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    const Icon(Icons.star_rounded,color: Colors.orange,),
                                                    SizedBox(width: 3.w,),
                                                    Text(
                                                      '${cubit.workerServices[index]['rate']}',
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        height: 1,
                                                        color: Colors.grey.shade500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5.h,),
                                                Text(
                                                  '${cubit.workerServices[index]['name']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13.sp,
                                                      color: cubit.isDark ? Colors.white : Colors.black
                                                  ),
                                                ),
                                                SizedBox(height: 5.h,),
                                                Text(
                                                  '${cubit.workerServices[index]['description']} ',
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
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        SizedBox(height: 20.h,),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                          child: ClipRRect(
                            borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.r)),
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
                                boxShadow: blueShadow
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
                      ],
                    ),
                  ),
                ),
              );
        }
      },
    );
  }
}
