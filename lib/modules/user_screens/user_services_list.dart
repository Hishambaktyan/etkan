import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/modules/user_screens/user_service_details.dart';
import 'package:trying_homy/modules/user_screens/user_worker_profile.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';
import '../../shared/compenents/components.dart';
import '../../main.dart';
import '../../shared/styles/colors.dart';

class UserServicesList extends StatefulWidget {
  final String categoryType;
  const UserServicesList({super.key, required this.categoryType});

  @override
  State<UserServicesList> createState() => _UserServicesListState();
}

class _UserServicesListState extends State<UserServicesList> {

  @override
  void initState() {
    UserCubit.get(context).getUserSpecServices(widget.categoryType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          return BlocBuilder<UserCubit,UserStates>(
            builder: (context, state) {
              UserCubit  userCubit = UserCubit.get(context);
                return state is GetUserSpecServicesLoadingState? const UserServicesShimmer():
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          header(
                              title: 'خدمات ال${widget.categoryType}',
                              isLeading: true,
                              context: context,
                          ),
                          SizedBox(height: 15.h,),
                          userCubit.userSpecServices.isEmpty
                              ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            width: double.infinity,
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.w,
                                  height:100.w,
                                  padding: EdgeInsets.all(15.r),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/services.svg',
                                    color: mainColor,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  'لا توجد خدمات حالياً',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    color: Theme.of(context).textTheme.bodyLarge!.color,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'لا توجد خدمات في قسم  ال${widget.categoryType} في الوقت الحالي.',
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
                          :ListView.separated(
                            itemCount: userCubit.userSpecServices.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsetsDirectional.only(start:15.w,end: 15.w,bottom: 20.h),
                            itemBuilder: (context, index) {
                              var service = userCubit.userSpecServices[index];
                              var providerData = appCubit.allUsers[service['providerId']];
                              return InkWell(
                                onTap: () => move(
                                    context,
                                    UserServiceDetails(
                                      name: service['name'],
                                      image: service['serviceImage'],
                                      category: service['category'],
                                      desc: service['description'],
                                      price: service['price'],
                                      period: service['period'],
                                      rate: service['rate'],
                                      providerName:
                                      providerData['name'],
                                      providerSpec: providerData['specialization'],
                                      reviews: service['reviews'] ?? [],
                                      providerId: providerData['uid'],
                                    )),
                                borderRadius: BorderRadius.circular(25.r),
                                child: Container(
                                  width: 280.w,
                                  decoration: BoxDecoration(
                                      color: appCubit.isDark ? lightDarkColor : Colors.white,
                                      borderRadius: BorderRadius.circular(25.r),
                                      boxShadow: blueShadow
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(25.r),
                                            child: Image.network(
                                              '${service['serviceImage']}',
                                              height: 180.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          PositionedDirectional(
                                            bottom: 12.h,
                                            end: 12.w,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                borderRadius: BorderRadius.circular(15.r),
                                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                                              ),
                                              child: Text(
                                                '${service['price']} $reyalSymbol',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                              ),
                                            ),
                                          ),
                                          PositionedDirectional(
                                            top: 12.h,
                                            start: 12.w,
                                            child: ClipRRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.7),
                                                    borderRadius: BorderRadius.circular(10.r),
                                                  ),
                                                  child: Text(
                                                    '${service['category']}',
                                                    style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 10.sp),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.all(15.r),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service['name'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                                color: appCubit.isDark ? Colors.white : Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              children: [
                                                Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  '${service['rate']}',
                                                  style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w600),
                                                ),
                                                const Spacer(),
                                                Icon(Icons.arrow_forward_ios_rounded, color: mainColor.withOpacity(0.2), size: 14.sp),
                                              ],
                                            ),
                                            SizedBox(height: 12.h),
                                            Container(
                                              padding: EdgeInsets.all(8.r),
                                              decoration: BoxDecoration(
                                                color: mainColor.withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(15.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 16.r,
                                                    backgroundImage: NetworkImage(providerData['profileImage']),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${providerData['name']}',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 11.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: Theme.of(context).textTheme.bodyLarge!.color
                                                          ),
                                                        ),
                                                        Text(
                                                          '${providerData['specialization']}',
                                                          maxLines: 1,
                                                          style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(height: 15.h,),
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
