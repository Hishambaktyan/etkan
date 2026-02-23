import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/modules/user_screens/faq_Screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_signUp.dart';
import 'package:trying_homy/shared/compenents/components.dart';

import '../../shared/styles/colors.dart';

class WorkerAccountScreeen extends StatefulWidget {
  const WorkerAccountScreeen({super.key});

  @override
  State<WorkerAccountScreeen> createState() => _WorkerAccountScreeenState();
}

class _WorkerAccountScreeenState extends State<WorkerAccountScreeen> {
  List<Map<String, dynamic>> settingsList = [
     {
       'title': 'مشاركة التطبيق',
       'icon': 'assets/share.svg',
     },
     {
      'title': 'تواصل معنا',
      'icon': 'assets/chat.svg',
    },
    {
      'title': 'الأسئلة الشائعة',
      'icon': 'assets/ques.svg',
    },
    {
      'title': 'الوضع المظلم',
      'icon': 'assets/moon.svg',
    },
     {
      'title': 'تسجيل خروج',
      'icon': 'assets/login.svg'
    },
  ];
   bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'الحساب',
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
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: 10.h,start: 20.w,end: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.1),
                radius: 50.r,
                backgroundImage: const NetworkImage(
                    'https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg'
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'عبد الرحمن محمد أحمد',
                style: TextStyle(
                    fontSize: 18.sp,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
               Text(
                '770770858',
                style: TextStyle(
                    color: Colors.grey,
                  fontSize: 18.sp
                ),
              ),
              SizedBox(
                height: 5.w,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45.h,
                      child: defualtButton(
                        textSize: 13,
                          onPressed: (){},
                          text: 'عرض الحساب',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: defualtOutlinedButton(
                      fontSize: 13,
                        onPressed: (){},
                        text: 'تعديل الحساب',
                      height: 45.h
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      final setting = settingsList[index];
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              setting['icon'],
                              color: index==4?Colors.red:Colors.black,
                              width: 27.w,
                              height: 27.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              setting['title'],
                              style: TextStyle(
                                  color: index==4? Colors.red:Colors.black,
                                fontSize: 15.sp
                              ),
                            ),
                            Spacer(),
                            index==3?Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: isDark,
                                onChanged:(value){
                                  setState(() {
                                    isDark=value;
                                  });
                                },
                                activeColor: mainColor,

                              ),
                            ):SizedBox(),
                            index==3?SizedBox():Icon(
                              Icons.navigate_next_rounded,
                              color: index==5?Colors.red.withOpacity(0.5):Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                        onTap: (){
                          if(index==4){
                            moveAndReplace(context, const WorkerSignup());
                          }
                          else if(index==2)
                            move(context, const FaqScreen());
                        },
                      );
                    } ,
                    padding: EdgeInsetsDirectional.symmetric(vertical: 20.h),
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 10.h),
                      child: const Divider(),
                    ),
                    itemCount: settingsList.length
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}