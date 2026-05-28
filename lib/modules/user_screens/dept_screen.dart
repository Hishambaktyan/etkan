import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/user_screens/services_list.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_states.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';

import '../../shared/styles/colors.dart';

class DeptScreen extends StatefulWidget {
  const DeptScreen({super.key});

  @override
  State<DeptScreen> createState() => _DeptScreenState();
}

class _DeptScreenState extends State<DeptScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = UserServicesCubit.get(context);

      if (cubit.categories.isEmpty) {
        cubit.getCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerWithSearch(
                  title: 'الأقسام',
                  searchKeyWords: const [
                    'ابحث في الكهرباء',
                    'ابحث في السباكة',
                    'ابحث في التكييف',
                  ],
                  context: context,
                  appCubit: appCubit,
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: BlocConsumer<UserServicesCubit, UserServicesStates>(
                    listener: (context, state) {
                      if (state is GetCategoryErrorState) {
                        showSnackBar(
                          Colors.red,
                          state.error,
                          context,
                        );
                      }
                    },
                    builder: (context, state) {
                      final userServicesCubit = UserServicesCubit.get(context);
                      final categories = userServicesCubit.categories;

                      if (state is GetCategoryLoadingState &&
                          categories.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        );
                      }

                      if (categories.isEmpty) {
                        return RefreshIndicator(
                          color: mainColor,
                          onRefresh: () async {
                            await userServicesCubit.getCategories();
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 120.h),
                              Icon(
                                Icons.category_outlined,
                                size: 55.sp,
                                color: mainColor,
                              ),
                              SizedBox(height: 15.h),
                              Center(
                                child: Text(
                                  'لا توجد أقسام حالياً',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: mainColor,
                        onRefresh: () async {
                          await userServicesCubit.getCategories();
                        },
                        child: GridView.builder(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.h,
                            crossAxisSpacing: 10.w,
                            childAspectRatio: 2,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            final String categoryTitle =
                                '${category['title'] ?? ''}';

                            final String categoryImage =
                                '${category['image'] ?? ''}';

                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(25.r),
                              onTap: () {
                                move(
                                  context,
                                  ServicesList(
                                    categoryType: categoryTitle,
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.all(10.r),
                                decoration: BoxDecoration(
                                  color: appCubit.isDark
                                      ? lightDarkColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      padding: EdgeInsets.all(12.r),
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                      ),
                                      child: categoryImage.trim().isNotEmpty
                                          ? SvgPicture.network(
                                              categoryImage,
                                              placeholderBuilder: (context) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 18.w,
                                                    height: 18.w,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Icon(
                                              Icons.category_rounded,
                                              color: mainColor,
                                              size: 25.sp,
                                            ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        categoryTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: appCubit.isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: mainColor.withOpacity(0.3),
                                      size: 12.sp,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
=======
      body: BlocBuilder<AppCubit,AppStates>(
          builder: (context, state) {
            AppCubit appCubit = AppCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerWithSearch(
                      title: 'الأقسام',
                      searchKeyWords: [
                        'ابحث في الكهرباء',
                        'ابحث في السباكة',
                        'ابحث في التكييف',
                      ],
                      context: context,
                      appCubit: appCubit
                  ),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding:EdgeInsetsDirectional.symmetric(vertical: 20.h,horizontal: 10.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 2,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                          onTap: () => move(context, ServicesList(categoryType: services[index]['type']!)),
                          child: Container(
                            padding: EdgeInsetsDirectional.all(10.r),
                            decoration: BoxDecoration(
                              color: appCubit.isDark ? lightDarkColor : Colors.white,
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: blueShadow,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                  child: SvgPicture.asset(
                                    services[index]['icon']!,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    services[index]['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      color: appCubit.isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: mainColor.withOpacity(0.3),
                                  size: 12.sp,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
>>>>>>> 06477f1074550386f40830ad2d7bca77cce679dc
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
