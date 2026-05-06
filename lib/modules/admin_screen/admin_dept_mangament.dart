import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/admin_screen/add_dept.dart';
import 'package:trying_homy/modules/admin_screen/manage_dept.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AdminDeptMangament extends StatefulWidget {
  const AdminDeptMangament({super.key});

  @override
  State<AdminDeptMangament> createState() => _AdminDeptMangamentState();
}

class _AdminDeptMangamentState extends State<AdminDeptMangament> {
 @override
  void initState() {
    AppCubit.get(context).getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
                  onPressed: ()=>Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)
              ),
            title: Text(
                'إدارة الأقسام',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            actions: [
              IconButton(
                  onPressed: ()=>move(context, const AddDept()),
                  icon:  Icon(Icons.add_rounded,color: Colors.white,size: 30.w,)
              ),
              SizedBox(width: 5.w,),
            ],
          ),
          body: BlocBuilder<AppCubit,AppStates>(
              builder: (context, state) {
                AppCubit appCubit = AppCubit.get(context);
                return state is GetCategoryLoadingState? const Center(child: CircularProgressIndicator())
                    :GridView.builder(
                  shrinkWrap: true,
                  padding:EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: appCubit.categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: ()=>print(appCubit.categories),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (){},
                      child: Container(
                        decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(color: mainColor.withOpacity(0.1))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(10),
                                child: Image.file(File('${appCubit.categories[index]['image']}'))
                              ),
                            ),
                            Container(
                              height: 40.h,
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(15.r))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: appCubit.categories[index]['title']!.length > 10
                                        ? SizedBox(
                                      height: 25.h,
                                      child: Marquee(
                                        text: appCubit.categories[index]['title']!,
                                        scrollAxis: Axis.horizontal,
                                        blankSpace: 20.w,
                                        velocity: 30,
                                        pauseAfterRound: const Duration(seconds: 1),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    )
                                        : Text(
                                      appCubit.categories[index]['title']!,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: ()=>move(context, const ManageDept()),
                                      icon: const Icon(Icons.more_horiz_rounded)
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              },
          ),
        )
    );
  }
}
