import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_add_service.dart';
import 'package:trying_homy/modules/worker_screens/worker_service_details.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../layout/worker_layout/worker_main_screen.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';

class WorkerServicesList extends StatefulWidget {
   const WorkerServicesList({super.key});

  @override
  State<WorkerServicesList> createState() => _WorkerServicesListState();
}

class _WorkerServicesListState extends State<WorkerServicesList> {

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
      await WorkerCubit.get(context).getWorkerServices(forceRefresh: forceRefresh);
    }
  }

   @override
  void initState() {
    super.initState();
    checkConnectionAndGetData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocBuilder<AppCubit,AppStates>(
          builder: (context, state) {
            AppCubit appCubit = AppCubit.get(context);
            return BlocConsumer<WorkerCubit,WorkerStates>(
              listener: (context, state) {
                if(state is ChangeServiceActivitySuccessState){
                  showSnackBar(Colors.green, 'تم تغيير حالة الخدمة', context);
                }
                if(state is ChangeServiceActivityErrorState){
                  showSnackBar(Colors.red, state.error, context);
                }
              },
              builder: (context, state) {
                WorkerCubit workerCubit = WorkerCubit.get(context);
                return ConditionalBuilder(
                    condition: checkingInternet || state is GetWorkerServicesLoadingState,
                    builder: (context) => WorkerServicesShimmer(isDark: appCubit.isDark),
                    fallback: (context) => ConditionalBuilder(
                        condition: !hasInternet,
                        builder: (context) => NoInternet(onRetry: () => checkConnectionAndGetData(forceRefresh: true),),
                        fallback: (context) => PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, result) {
                            if(didPop) result;
                            moveAndReplace(context, const WorkerMainScreen());
                          },
                          child: RefreshIndicator(
                            onRefresh: () => checkConnectionAndGetData(forceRefresh: true),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  header(
                                      title: 'قائمة خدماتي',
                                      context: context,
                                      isNotif: false,
                                      isLeading: true
                                  ),
                                  SizedBox(height: 10.h,),
                                  GridView.builder(
                                    itemCount: workerCubit.workerServices.length,
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
                                      final service = workerCubit.workerServices[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: appCubit.isDark ? lightDarkColor : Colors.white,
                                          borderRadius: BorderRadius.circular(25.r),
                                          boxShadow: blueShadow,
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 135.h,
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(25.r),
                                                    child: Image.network(
                                                      '${service['serviceImage'] ?? ''}',
                                                      height: 120.h,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Container(
                                                        height: 120.h,
                                                        color: Colors.grey.shade100,
                                                        child: Icon(Icons.wifi_off_rounded, color: Colors.grey.shade400, size: 30.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  PositionedDirectional(
                                                    bottom: 5.h,
                                                    end: 10.w,
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                      decoration: BoxDecoration(
                                                        color: mainColor,
                                                        borderRadius: BorderRadius.circular(15.r),
                                                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                                                        border: Border.all(color: Colors.white, width: 1.5),
                                                      ),
                                                      child: Text(
                                                        '${service['price'] ?? ''} ﷼',
                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  PositionedDirectional(
                                                    top: 10.h,
                                                    start: 10.w,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await workerCubit.changeServiceActivity(
                                                            value: !(service['isActive'] ?? true),
                                                            serviceId: service['id']
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                                          child: Container(
                                                            padding: EdgeInsets.all(8.r),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withOpacity(0.8),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: SvgPicture.asset(
                                                              'assets/power.svg',
                                                              color: service['isActive']==true ? Colors.green : Colors.grey,
                                                              width: 18.w,
                                                              height: 18.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () => move(context, WorkerServiceDetails(service: service,)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          '${service['rate'] ?? ''}',
                                                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    Text(
                                                      '${service['name'] ?? ''}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 13.sp,
                                                        color: appCubit.isDark ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      '${service['description'] ?? ''}',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        height: 1.3,
                                                        color: appCubit.isDark ? darkSubTextColor : Colors.grey.shade600,
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
                                ],
                              ),
                            ),
                          ),
                        ),
                    ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()=>move(context,  const WorkerAddService()),
          backgroundColor: mainColor,
          label: const Text(
            'إضافة خدمة',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          icon: const Icon(Icons.add_rounded,color: Colors.white,),
        ),
      ),
    );
  }
}
