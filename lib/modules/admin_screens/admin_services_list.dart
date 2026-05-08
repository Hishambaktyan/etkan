import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/admin_screens/admin_provider_info.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/admin_cubit/admin_cubit.dart';
import '../../shared/cubits/admin_cubit/admin_states.dart';
import '../../shared/styles/colors.dart';

class AdminServicesList extends StatefulWidget {
  const AdminServicesList({super.key});

  @override
  State<AdminServicesList> createState() => _AdminServicesListState();
}

class _AdminServicesListState extends State<AdminServicesList> {

  @override
  void initState() {
    AdminCubit.get(context).getServices();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocBuilder<AdminCubit,AdminStates>(
            builder: (context, state) {
              AdminCubit adminCubit = AdminCubit.get(context);
              return SingleChildScrollView(
                child: state is GetServicesLoadingState ? const AdminServicesShimmer()
                      : Column(
                  children: [
                    header(title: 'قائمة الخدمات', context: context,isNotif: false,isLeading: true),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:  EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                      itemCount: adminCubit.services.length,
                      itemBuilder:(context, index) {
                        final service = adminCubit.services[index];
                        final providerData = adminCubit.providers.firstWhere((element) => element['id']==service['providerId'],);
                        return InkWell(
                          onTap: (){},
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                          child: Container(
                            width: 300.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: blueShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25.r),
                                      child: Image.network(
                                        service['serviceImage'],
                                        height: 150.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 150.h,
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                                          ),
                                        ),
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    PositionedDirectional(
                                      top: 12.h,
                                      start: 12.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.r),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Text(
                                              service['category'],
                                              style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10.sp,
                                              ),
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
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                                          SizedBox(width: 5.w),
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(top: 5.h),
                                            child: Text(
                                              '${service['rate']}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: mainColor.withOpacity(0.2),
                                            size: 14.sp,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
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
                                              backgroundImage:  NetworkImage(
                                                  providerData['profileImage']
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    providerData['name'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                                    ),
                                                  ),
                                                  Text(
                                                    providerData['specialization'],
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.grey,
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
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 15.h,),
                    ),
                  ],
                ),
              );
            },
          ),
        )
    );
  }
}
