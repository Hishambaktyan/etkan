import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final List<Map<String, dynamic>> workers = [
    {
      "name": "محمد علي اليوسفي",
      "price": 5000,
      "image": "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
      "isBusy": false,
      "rating": 4.5,
    },
    {
      "name": "سعيد حسن القحطاني",
      "price": 11200,
      "image": "https://i.pinimg.com/736x/eb/76/a4/eb76a46ab920d056b02d203ca95e9a22.jpg",
      "isBusy": true,
      "rating": 4.0,
    },
    {
      "name": "أحمد خالد الفهد",
      "price": 9000,
      "image": "https://i.pinimg.com/736x/27/90/03/27900371354079f41e16751f2a320fdb.jpg",
      "isBusy": false,
      "rating": 4.2,
    },
    {
      "name": "خالد يوسف العتيبي",
      "price": 1100,
      "image": "https://i.pinimg.com/1200x/65/7c/e1/657ce19e18e65061190c7927400947cf.jpg",
      "isBusy": true,
      "rating": 3.8,
    },
    {
      "name": "سلمان عمر الحربي",
      "price": 9500,
      "image": "https://i.pinimg.com/736x/25/33/8f/25338f488af2c45912c15ebab325e363.jpg",
      "isBusy": false,
      "rating": 4.7,
    },
    {
      "name": "ياسر محمد الدوسري",
      "price": 13000,
      "image": "https://i.pinimg.com/1200x/d8/5a/f1/d85af1b5204c5a8546a7a2e929af45c7.jpg",
      "isBusy": true,
      "rating": 3.9,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 10,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              'الحجوزات',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.sp
              ),
            ),
            actions: [
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
              )
            ],
          ),
          body: Column(
            children: [
              TabBar(
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          'الحجوزات الحالية',
                        style: TextStyle(
                          fontSize: 12.sp
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          'الحجوزات السابقة',
                        style: TextStyle(
                            fontSize: 12.sp
                        ),
                      ),
                    )
                  ],
                splashBorderRadius: BorderRadius.only(topRight: Radius.circular(15.r),topLeft: Radius.circular(15.r),),
              ),
              Expanded(
                child: TabBarView(
                    children:[
                      ListView.separated(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                          itemBuilder: (context, index) => buildBookingItem(workers[index]['name'],
                              workers[index]['price'], workers[index]['rating'], workers[index]['isBusy'],
                              workers[index]['image'], context) ,
                          separatorBuilder: (context, index) => SizedBox(height: 15.h,),
                          itemCount: 2
                      ),
                      ListView.separated(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                          itemBuilder: (context, index) => buildBookingItem(workers[index]['name'],
                              workers[index]['price'], workers[index]['rating'], workers[index]['isBusy'],
                              workers[index]['image'], context) ,
                          separatorBuilder: (context, index) => SizedBox(height: 15.h,),
                          itemCount: 6
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
