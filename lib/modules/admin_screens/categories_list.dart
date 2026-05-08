import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import 'add_dept.dart';
import 'manage_dept.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {

  @override
  void initState() {
    AdminCubit.get(context).getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocBuilder<AdminCubit, AdminStates>(
            builder: (context, state) {
              AdminCubit adminCubit = AdminCubit.get(context);
              return state is GetCategoryLoadingState
                  ? const AdminCategoriesShimmer()
                  : SingleChildScrollView(
                    child: Column(
                        children: [
                          header(
                              title: 'قائمة الأقسام',
                              context: context,
                              isLeading: true,
                              isNotif: false,
                              isAction: true,
                              actionIcon: 'assets/add_grid.svg',
                              onActionPresses: ()=>move(context, const AddDept())
                          ),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 10.w, vertical: 20.h),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15.h,
                              crossAxisSpacing: 10.w,
                              childAspectRatio: 1.1,
                            ),
                            itemCount: adminCubit.categories.length,
                            itemBuilder: (context, index) {
                              final category = adminCubit.categories[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: mainColor.withOpacity(0.05),
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
                                            ),
                                            padding: EdgeInsetsDirectional.all(15.r),
                                            child: SvgPicture.network(
                                              '${category['image']}',
                                              height: 100.h,
                                              width: 100.w,

                                              errorBuilder: (context, error, stackTrace) => SizedBox(
                                                height: 100.h,
                                                child: Icon(Icons.image_not_supported_outlined,size: 40.w,color: Colors.grey.shade400,),
                                              ),
                                            ),
                                          ),
                                          PositionedDirectional(
                                            top: 10.h,
                                            end: 10.w,
                                            child: InkWell(
                                              onTap: () => move(context,  ManageDept(category: category,)),
                                              child: Container(
                                                padding: EdgeInsetsDirectional.all(5.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.more_horiz_rounded,
                                                  color: mainColor,
                                                  size: 20.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 12.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          category['title']!.length > 10
                                              ? SizedBox(
                                                  height: 22.h,
                                                  child: Marquee(
                                                    text: category['title']!,
                                                    scrollAxis: Axis.horizontal,
                                                    blankSpace: 20.w,
                                                    velocity: 30,
                                                    pauseAfterRound:
                                                        const Duration(
                                                            seconds: 1),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                   category['title']!,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                          SizedBox(height: 5.h),
                                          Container(
                                            width: 20.w,
                                            height: 3.h,
                                            decoration: BoxDecoration(
                                              color: mainColor.withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
