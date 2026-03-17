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
      "page": "ElectricWorkersPage",
    },
    {
      "name": "السباكة",
      "icon": "assets/SVGs/P.svg",
      "page": "PlumberWorkersPage",
    },
    {
      "name": "البناء",
      "icon": "assets/SVGs/C.svg",
      "page": "BuilderWorkersPage",
    },
    {
      "name": "التكييف",
      "icon": "assets/SVGs/AC.svg",
      "page": "AirCondWorkersPage",
    },
    {
      "name": "الحدادة",
      "icon": "assets/SVGs/A.svg",
      "page": "BlackSmithWorkersPage",
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
            ClipRRect(
              borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
              child: Container(
                height: 160.h,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          mainColor.withOpacity(0.9),
                          const Color(0xFF0F0F1E),
                        ],
                        stops: const [
                          0.0,
                          0.8,
                        ]
                    )
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50.h,
                      left: -50.w,
                      child: CircleAvatar(
                        radius: 100.r,
                        backgroundColor: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    Positioned(
                      top: 80.h,
                      right: -60.w,
                      child: Container(
                        width: 250.r,
                        height: 250.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00F2FF).withOpacity(0.5),
                              const Color(0xFF00F2FF).withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200.h,
                      left: -40.w,
                      child: Container(
                        width: 200.r,
                        height: 200.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              mainColor.withOpacity(0.4),
                              mainColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w,bottom: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'الأقسام',
                                  style: TextStyle(
                                    fontSize: 23.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsetsDirectional.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/not.svg',
                                      width: 23.w,
                                      height: 23.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(15.r),
                              onTap: () {},
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 17),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/search.svg',
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                        child: SizedBox(
                                          height: 20,
                                          child: AnimatedTextKit(
                                            repeatForever: true,
                                            pause: const Duration(seconds: 2),
                                            animatedTexts: [
                                              TyperAnimatedText("ابحث في الكهرباء",textStyle: const TextStyle(color: Colors.grey)),
                                              TyperAnimatedText("ابحث في السباكة",textStyle: const TextStyle(color: Colors.grey)),
                                              TyperAnimatedText("ابحث عن في التكييف",textStyle: const TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w,vertical: 15.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h
                  ),

                  itemBuilder: (context, index){
                  final service = services[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: ()=>move(context, const Electric_workers()),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: mainColor.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              service['icon']!,
                            width: 60.w,
                            height: 60.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            service['name']!,
                            style: TextStyle(
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  },
                itemCount: services.length,
              )
            ),
          ],
        ),
      ),
    );
  }
}
