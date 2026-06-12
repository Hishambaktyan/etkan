import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/admin_screens/admin_provider_info.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_states.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class AdminProvidersList extends StatefulWidget {
  const AdminProvidersList({super.key});

  @override
  State<AdminProvidersList> createState() => _AdminProvidersListState();
}

class _AdminProvidersListState extends State<AdminProvidersList> {
  Widget buildStatCard({
    required String title,
    required String value,
    required String icon,
    required AppCubit appCubit,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SvgPicture.asset(
                    icon,
                    width: 22.w,
                    color: mainColor,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: appCubit.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: appCubit.isDark ? darkSubTextColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    AdminCubit.get(context).getProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppCubit appCubit = context.watch<AppCubit>();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocBuilder<AdminCubit, AdminStates>(
            builder: (context, state) {
              AdminCubit adminCubit = AdminCubit.get(context);
              final activeProviders = adminCubit.providers
                  .where(
                    (element) => element['isActive'] == true,
                  )
                  .length;
              final inactiveProviders = adminCubit.providers
                  .where(
                    (element) => element['isActive'] == false,
                  )
                  .length;
              return SingleChildScrollView(
                child: state is GetProvidersLoadingState
                    ? const AdminProvidersShimmer()
                    : Column(
                        children: [
                          header(
                              title: 'قائمة الفنيين',
                              context: context,
                              isNotif: false,
                              isLeading: true),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 10.w),
                            child: Row(
                              children: [
                                buildStatCard(
                                    title: 'الحسابات المفعلة',
                                    value: activeProviders.toString(),
                                    icon: 'assets/all.svg',
                                    appCubit: appCubit),
                                SizedBox(
                                  width: 10.w,
                                ),
                                buildStatCard(
                                    title: 'الحسابات المعطلة',
                                    value: inactiveProviders.toString(),
                                    icon: 'assets/dis.svg',
                                    appCubit: appCubit),
                              ],
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15.h,
                                    crossAxisSpacing: 10.w,
                                    childAspectRatio: 0.7),
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 10.w, vertical: 20.h),
                            itemCount: adminCubit.providers.length,
                            itemBuilder: (context, index) {
                              final provider = adminCubit.providers[index];
                              return InkWell(
                                onTap: () => move(context,
                                    AdminProviderInfo(provider: provider)),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(25.r),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            child: Image.network(
                                              provider['profileImage'],
                                              height: 120.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                height: 120.h,
                                                width: double.infinity,
                                                color: appCubit.isDark
                                                    ? darkBgColor
                                                    : Colors.grey.shade200,
                                                child: Icon(Icons.person,
                                                    color: Colors.grey,
                                                    size: 35.r),
                                              ),
                                            ),
                                          ),
                                          PositionedDirectional(
                                            top: 10.h,
                                            start: 10.w,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 5, sigmaY: 5),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: appCubit.isDark
                                                        ? darkBgColor
                                                            .withOpacity(0.85)
                                                        : Colors.white
                                                            .withOpacity(0.7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.star_rounded,
                                                          color: mainColor,
                                                          size: 14.sp),
                                                      SizedBox(width: 2.w),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(top: 5.h),
                                                        child: Text(
                                                          '${provider['avgRating']}',
                                                          style: TextStyle(
                                                              color: mainColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10.sp,
                                                              height: 1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.all(10.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              provider['name'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                                color: appCubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              provider['specialization'],
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: appCubit.isDark
                                                    ? darkSubTextColor
                                                    : Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsetsDirectional
                                                  .symmetric(
                                                horizontal: 4.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: mainColor.withOpacity(
                                                    appCubit.isDark
                                                        ? 0.12
                                                        : 0.05),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      'عرض الملف الشخصي',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: mainColor,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: mainColor,
                                                    size: 9.sp,
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
                          ),
                        ],
                      ),
              );
            },
          ),
        ));
  }
}
