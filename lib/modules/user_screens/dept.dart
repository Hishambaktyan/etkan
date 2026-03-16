import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/user_screens/electric_workers.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';


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
      appBar: AppBar(
        titleSpacing: 10,
        automaticallyImplyLeading: false,
        title: Text(
          'الأقسام',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.sp
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset(
                        'assets/search.svg',
                        width: 25.w,
                        height: 25.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                  setState(() {
                  });
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset(
                        'assets/not.svg',
                        width: 25.w,
                        height: 25.h,
                      ),
                      true?Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                      ):SizedBox()
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 10.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  crossAxisSpacing: 20.w,
                  mainAxisSpacing: 20.h
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
                          color: Colors.white,
                          boxShadow: shadow

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              service['icon']!,
                            width: 40.w,
                            height: 40.h,
                          ),
                          SizedBox(
                            height: 5.h,
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
