import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
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
                        return UserDeptShimmer(
                          isDark: appCubit.isDark,
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
                                              fit: BoxFit.contain,
                                              placeholderBuilder: (context) {
                                                return Shimmer.fromColors(
                                                  baseColor: appCubit.isDark
                                                      ? const Color(0xFF2A2A2A)
                                                      : const Color(0xFFE3F2FD),
                                                  highlightColor: appCubit
                                                          .isDark
                                                      ? const Color(0xFF3A3A3A)
                                                      : const Color(0xFFF8FCFF),
                                                  child: Container(
                                                    width: 26.w,
                                                    height: 26.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
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
