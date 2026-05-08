import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/admin_screen/admin_user_info.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import '../../shared/styles/colors.dart';

class AdminUsersList extends StatefulWidget {
  const AdminUsersList({super.key});

  @override
  State<AdminUsersList> createState() => _AdminUsersListState();
}

class _AdminUsersListState extends State<AdminUsersList> {

  @override
  void initState() {
    AdminCubit.get(context).getUsers();
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
                child: state is GetUsersLoadingState ? const AdminUsersShimmer(isDark: false)
                    : Column(
                  children: [
                    header(title: 'إدارة المستخدمين', context: context,isLeading: true,isNotif: false),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 0.78
                      ),
                      padding:  EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                      itemCount: adminCubit.users.length,
                      itemBuilder:(context, index) {
                        final user = adminCubit.users[index];
                        return InkWell(
                          onTap: ()=>move(context, AdminUserInfo(user: user)),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                          child: Container(
                            width: 190.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: blueShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25.r),
                                  child: Image.network(
                                    user['profileImage'] ?? '',
                                    height: 120.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 120.h,
                                      width: double.infinity,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.person, color: Colors.grey, size: 35.r),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(top: 15.h,start: 10.w,end: 10.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: mainColor.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'عرض الملف الشخصي',
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
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
        )
    );
  }
}
