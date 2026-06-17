import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Etkan/modules/user_screens/user_services_list.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/user_cubit/user_states.dart';

import '../../shared/cubits/user_cubit/user_cubit.dart';
import '../../shared/styles/colors.dart';

class UserCategories extends StatefulWidget {
  const UserCategories({super.key});

  @override
  State<UserCategories> createState() => _UserCategoriesState();
}

class _UserCategoriesState extends State<UserCategories> {
  bool hasInternet = true;
  bool checkingInternet = true;
  Future<void> checkConnectionAndGetData({bool forceRefresh = false}) async {
    if (!mounted) return;

    setState(() {
      checkingInternet = true;
    });

    final result = await checkInternet();

    if (!mounted) return;

    if (!result) {
      setState(() {
        hasInternet = false;
        checkingInternet = false;
      });
      return;
    }

    try {
      final userCubit = UserCubit.get(context);

      userCubit.getCategories(forceRefresh: forceRefresh);

      if (!mounted) return;

      setState(() {
        hasInternet = true;
        checkingInternet = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        hasInternet = true;
        checkingInternet = false;
      });

      debugPrint('Error loading home data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectionAndGetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return BlocBuilder<UserCubit, UserStates>(
            builder: (context, state) {
              final userCubit = UserCubit.get(context);
              final categories = userCubit.categories;
              return ConditionalBuilder(
                condition: checkingInternet || state is GetCategoryLoadingState,
                builder: (context) => UserCategoriesShimmer(
                  isDark: appCubit.isDark,
                ),
                fallback: (context) => ConditionalBuilder(
                  condition: !hasInternet,
                  builder: (context) => NoInternet(
                    onRetry: () =>
                        checkConnectionAndGetData(forceRefresh: true),
                  ),
                  fallback: (context) => RefreshIndicator(
                    color: mainColor,
                    onRefresh: () =>
                        checkConnectionAndGetData(forceRefresh: true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header(
                          title: 'الأقسام',
                          context: context,
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
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
                                    UserServicesList(
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
                                                placeholderBuilder:
                                                    (context) {
                                                  return Shimmer.fromColors(
                                                    baseColor: appCubit.isDark
                                                        ? const Color(
                                                            0xFF2A2A2A)
                                                        : const Color(
                                                            0xFFE3F2FD),
                                                    highlightColor:
                                                        appCubit.isDark
                                                            ? const Color(
                                                                0xFF3A3A3A)
                                                            : const Color(
                                                                0xFFF8FCFF),
                                                    child: Container(
                                                      width: 26.w,
                                                      height: 26.h,
                                                      decoration:
                                                          BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
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
                                          maxLines: 2,
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
