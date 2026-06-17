import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/admin_screens/admin_user_info.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_states.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/styles/colors.dart';

class AdminUsersList extends StatefulWidget {
  const AdminUsersList({super.key});

  @override
  State<AdminUsersList> createState() => _AdminUsersListState();
}

class _AdminUsersListState extends State<AdminUsersList> {
  var searchController = TextEditingController();

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
    AdminCubit.get(context).getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppCubit appCubit = context.watch<AppCubit>();

    return Scaffold(
      body: BlocBuilder<AdminCubit, AdminStates>(
        builder: (context, state) {
          AdminCubit adminCubit = AdminCubit.get(context);
          final activeUsers = adminCubit.users
              .where((user) => user['isActive'] == true)
              .length;
          final inactiveUsers = adminCubit.users
              .where((user) => user['isActive'] == false)
              .length;
          return state is GetUsersLoadingState
              ? const AdminUsersShimmer()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      header(
                          title: 'إدارة المستخدمين',
                          context: context,
                          isLeading: true,
                          isNotif: false),
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
                                value: activeUsers.toString(),
                                icon: 'assets/all.svg',
                                appCubit: appCubit),
                            SizedBox(
                              width: 10.w,
                            ),
                            buildStatCard(
                                title: 'الحسابات المعطلة',
                                value: inactiveUsers.toString(),
                                icon: 'assets/dis.svg',
                                appCubit: appCubit),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.h,
                                crossAxisSpacing: 10.w,
                                childAspectRatio: 0.78),
                        padding: EdgeInsetsDirectional.only(
                            start: 10.w, end: 10.w, bottom: 20.h),
                        itemCount: adminCubit.users.length,
                        itemBuilder: (context, index) {
                          final user = adminCubit.users[index];
                          return InkWell(
                            onTap: () =>
                                move(context, AdminUserInfo(user: user)),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 190.w,
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
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(25.r),
                                    child: Image.network(
                                      user['profileImage'] ?? '',
                                      height: 120.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        height: 120.h,
                                        width: double.infinity,
                                        color: appCubit.isDark
                                            ? darkBgColor
                                            : Colors.grey.shade200,
                                        child: Icon(Icons.person,
                                            color: Colors.grey, size: 35.r),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        top: 15.h, start: 10.w, end: 10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['name'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                            color: appCubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsetsDirectional
                                              .symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(
                                                appCubit.isDark
                                                    ? 0.12
                                                    : 0.05),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'عرض الملف الشخصي',
                                                style: TextStyle(
                                                  fontSize: 9.sp,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Icon(
                                                Icons
                                                    .arrow_forward_ios_rounded,
                                                color: mainColor,
                                                size: 10.sp,
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
    );
  }
}
