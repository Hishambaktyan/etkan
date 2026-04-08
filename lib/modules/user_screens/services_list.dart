import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/modules/user_screens/service_details.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_states.dart';
import 'package:trying_homy/modules/user_screens/worker_details.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import '../../shared/compenents/components.dart';
import '../../main.dart';
import '../../shared/styles/colors.dart';

class ServicesList extends StatefulWidget {
  final String categoryType;
  const ServicesList({super.key, required this.categoryType});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  void initState() {
    UserServicesCubit.get(context).getUserSpecServices(widget.categoryType);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          return BlocBuilder<UserServicesCubit,UserServicesStates>(
            builder: (context, state) {
                UserServicesCubit  userServicesCubit = UserServicesCubit.get(context);
                return state is GetUserElecServicesLoadingState? const UserServicesShimmer():
                userServicesCubit.userElecServices.isEmpty? const Center(child: Text('لا توجد خدمات في الكهرباء حاليا'),):
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headerWithSearch(
                              title: 'خدمات ال${widget.categoryType}',
                              isLeading: true,
                              searchKeyWords: [
                                'ابحث عن تصليح فيش',
                                'ابحث عن تركيب مروحة',
                                'ابحث عن تركيب شاحن',
                              ],
                              context: context
                          ),
                          SizedBox(height: 15.h,),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 15.w),
                            child: Text(
                              'أقسام ال${widget.categoryType}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          SizedBox(
                            height: 100.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsetsDirectional.only(start: 15.w),
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 70.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: mainColor.withOpacity(0.1),
                                        radius: 27.r,
                                      ),
                                      SizedBox(height: 3.h,),
                                      SizedBox(
                                        height: 20.h,
                                        child: Marquee(
                                          text: 'تركيب فيش وبلاكات',
                                          style: TextStyle(fontSize: 10.sp),
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          blankSpace: 40.0,
                                          velocity: 50.0,
                                          pauseAfterRound: const Duration(seconds: 1),
                                          startPadding: 10.0,
                                          accelerationDuration: const Duration(seconds: 1),
                                          decelerationDuration: const Duration(milliseconds: 500),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(width: 10.w,),
                            ),
                          ),
                          ListView.separated(
                            itemCount: userServicesCubit.userElecServices.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsetsDirectional.only(start:15.w,end: 15.w,bottom: 20.h),
                            itemBuilder: (context, index) {
                              var service = userServicesCubit.userElecServices[index];
                              var providerData = cubit.allUsers[service['providerId']];
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: ()=>move(context, ServiceDetails(
                                  category: service['category'] ,
                                  subCategory: service['subCategory'],
                                  name: service['name'],
                                  image: service['serviceImage'],
                                  price: service['price'],
                                  period: service['period'],
                                  desc: service['description'],
                                  rate: service['rate'],
                                  providerName: providerData['name'],
                                  providerSpec: providerData['specialization'],
                                  reviews: service['reviews'],
                                  providerId: service['providerId'],
                                )
                                ),
                                child: Container(
                                  width: 300.w,
                                  padding: EdgeInsetsDirectional.only(bottom: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: AppCubit.get(context).isDark ? lightDarkColor : mainColor.withOpacity(0.1),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadiusDirectional.only(
                                          topStart: Radius.circular(15.r),
                                          topEnd: Radius.circular(15.r),
                                        ),
                                        child: Image.network(
                                          service['serviceImage'],
                                          height: 150.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 150.h,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadiusDirectional.only(
                                                  topStart: Radius.circular(15.r),
                                                  topEnd: Radius.circular(15.r),
                                                ),
                                                color: Colors.grey.shade200
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(start: 10.w,end: 10.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    service['name'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14.sp,
                                                      color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 7.w),
                                                  decoration: BoxDecoration(
                                                    color: mainColor,
                                                    border: Border.all(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(30.r),
                                                  ),
                                                  child: Text(
                                                    '${service['price']} $reyalSymbol',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h,),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star_rounded,color: Colors.orange,
                                                ),
                                                SizedBox(width: 5.w,),
                                                Text(
                                                  '${service['rate']}',
                                                  style: TextStyle(
                                                      color: Colors.grey
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h,),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  foregroundImage: const NetworkImage(
                                                      'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'
                                                  ),
                                                  radius: 20.r,
                                                ),
                                                SizedBox(width: 10.w,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 200.w,
                                                      child: Text(
                                                        '${providerData['name']}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12.sp
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${providerData['specialization']}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Colors.grey
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15.h,
                            ),
                          ),
                        ],
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
