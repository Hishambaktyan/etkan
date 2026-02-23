import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trying_homy/modules/user_screens/worker_details.dart';

import '../../shared/compenents/components.dart';
import '../../main.dart';

class Electric_workers extends StatefulWidget {
  const Electric_workers({super.key});

  @override
  State<Electric_workers> createState() => _Electric_workersState();
}

class _Electric_workersState extends State<Electric_workers> {
  bool isAvail = false;
  int initprice  = 50000;
  final List<Map<String, dynamic>> workers = [
    {
      "name": "محمد علي اليوسفي",
      "price": 100,
      "image": "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
      "isBusy": false,
      "rating": 4.5,
    },
    {
      "name": "سعيد حسن القحطاني",
      "price": 120,
      "image": "https://i.pinimg.com/736x/eb/76/a4/eb76a46ab920d056b02d203ca95e9a22.jpg",
      "isBusy": true,
      "rating": 4.0,
    },
    {
      "name": "أحمد خالد الفهد",
      "price": 90,
      "image": "https://i.pinimg.com/736x/27/90/03/27900371354079f41e16751f2a320fdb.jpg",
      "isBusy": false,
      "rating": 4.2,
    },
    {
      "name": "خالد يوسف العتيبي",
      "price": 110,
      "image": "https://i.pinimg.com/1200x/65/7c/e1/657ce19e18e65061190c7927400947cf.jpg",
      "isBusy": true,
      "rating": 3.8,
    },
    {
      "name": "سلمان عمر الحربي",
      "price": 95,
      "image": "https://i.pinimg.com/736x/25/33/8f/25338f488af2c45912c15ebab325e363.jpg",
      "isBusy": false,
      "rating": 4.7,
    },
    {
      "name": "ياسر محمد الدوسري",
      "price": 130,
      "image": "https://i.pinimg.com/1200x/d8/5a/f1/d85af1b5204c5a8546a7a2e929af45c7.jpg",
      "isBusy": true,
      "rating": 3.9,
    },
    {
      "name": "علي ناصر القيسي",
      "price": 105,
      "image": "https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg",
      "isBusy": false,
      "rating": 4.1,
    },
    {
      "name": "فهد حسن المطيري",
      "price": 115,
      "image": "https://i.pinimg.com/1200x/63/f3/a0/63f3a0fe0c318b623d9a431e2817b515.jpg",
      "isBusy": true,
      "rating": 4.3,
    },
    {
      "name": "عبدالله سالم السبيعي",
      "price": 100,
      "image": "https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg",
      "isBusy": false,
      "rating": 4.0,
    },
    {
      "name": "حسين محمود العلي",
      "price": 90,
      "image": "https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg",
      "isBusy": true,
      "rating": 3.7,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 10,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'فنيون الكهرباء',
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
        body: ListView.separated(
            padding: EdgeInsetsDirectional.only(start:10.w,end: 10.w,top: 20.w,bottom: 10.h),
            itemBuilder: (context, index) {
              final worker = workers[index] ;
              return buildWorkerItem(
                worker['name'],
                worker['price'],
                worker['rating'],
                worker['isBusy'],
                worker['image'],
                context
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 20.h,
            ),
            itemCount: workers.length
        ),
      ),
    );
  }


}
