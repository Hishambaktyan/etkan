import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/user_screens/services_list.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
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
  final List<Map<String, String>> services = [
    {
      "name": "الكهرباء",
      "icon": "assets/SVGs/E.svg",
      "type":"كهرباء"
    },
    {
      "name": "السباكة",
      "icon": "assets/SVGs/P.svg",
      "type":"سباكة"
    },
    {
      "name": "البناء",
      "icon": "assets/SVGs/C.svg",
      "type":"بناء"
    },
    {
      "name": "التكييف",
      "icon": "assets/SVGs/AC.svg",
      "type":"تكييف"
    },
    {
      "name": "الحدادة",
      "icon": "assets/SVGs/A.svg",
      "type":"حدادة"
    },
    {
      "name": "الماء",
      "icon": "assets/SVGs/WT.svg",
      "type":"ماء"
    },
    {
      "name": "النجارة",
      "icon": "assets/SVGs/CA.svg",
      "type":"نجارة"
    },
    {
      "name": "الدهان",
      "icon": "assets/SVGs/PA.svg",
      "type":"دهان"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: 20.h,),
                  GridView.builder(
                    shrinkWrap: true,
                    padding:EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                    physics: const NeverScrollableScrollPhysics(),
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
                ],
              ),
            );
          },
      )
    );
  }
}
