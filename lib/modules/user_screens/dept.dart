import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/user_screens/electric_workers.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';

import '../../shared/styles/colors.dart';


class Dept extends StatefulWidget {
  const Dept({super.key});

  @override
  State<Dept> createState() => _DeptState();
}

class _DeptState extends State<Dept> {
  List<Map<String, String>> services = [
    {
      "name": "الكهرباء",
      "icon": "assets/SVGs/E.svg",
    },
    {
      "name": "السباكة",
      "icon": "assets/SVGs/P.svg",
    },
    {
      "name": "البناء",
      "icon": "assets/SVGs/C.svg",
    },
    {
      "name": "التكييف",
      "icon": "assets/SVGs/AC.svg",
    },
    {
      "name": "الحدادة",
      "icon": "assets/SVGs/A.svg",
    },
    {
      "name": "الماء",
      "icon": "assets/SVGs/WT.svg",
      "page": "WaterTanksWorkersPage",
    },
    {
      "name": "النجارة",
      "icon": "assets/SVGs/CA.svg",
      "page": "CarpenterWorkersPage",
    },
    {
      "name": "الدهان",
      "icon": "assets/SVGs/PA.svg",
      "page": "PainterWorkersPage",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
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
              context: context
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
                childAspectRatio: 2.1,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: ()=>move(context, const ElectricServices()),
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(10),
                    decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 55.w,
                          height: 55.h,
                          padding: const EdgeInsetsDirectional.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: SvgPicture.asset(
                            services[index]['icon']!,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          services[index]['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: mainColor,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
