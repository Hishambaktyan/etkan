import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/modules/user_screens/faq_Screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_signUp.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/cubit/states.dart';

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
    {
      'title': 'حذف الحساب',
      'icon': 'assets/delete.svg'
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
      body: BlocConsumer<MyCubit,States>(
          listener: (context, state) {
            if(state is LogOutSuccessState){
              moveAndReplace(context, const LoginScreen());
              showSnackBar(Colors.green, 'تم تسجيل خروجك بنجاح', context);
            }
            if(state is LogOutErrorState){
              showSnackBar(Colors.red, state.error, context);
            }

            if(state is DeleteUserAccSuccessState){
              moveAndReplace(context, const WorkerSignup());
            }
            if(state is DeleteUserAccErrorState){
              showSnackBar(Colors.red, state.error, context);
              print(state.error);
            }
          },
          builder: (context, state) {
            MyCubit cubit = MyCubit.get(context);
            return cubit.state is LogOutLoadingState?const Center(child: CircularProgressIndicator())
            :Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsetsDirectional.only(top: 10.h,start: 20.w,end: 20.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                              height: 43.h,
                              child: defualtButton(
                                textSize: 12,
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
                                fontSize: 12,
                                onPressed: (){},
                                text: 'تعديل الحساب',
                                height: 43.h
                            ),
                          )
                        ],
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                          itemBuilder: (context, index){
                            final setting = settingsList[index];
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    setting['icon'],
                                    color: index==4 || index==5?Colors.red:Colors.black,
                                    width: 27.w,
                                    height: 27.h,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    setting['title'],
                                    style: TextStyle(
                                        color: index==4 || index==5? Colors.red:Colors.black,
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
                                    color: index==4|| index==5?Colors.red.withOpacity(0.5):Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              onTap: ()  async {
                                if(index==4){
                                  await cubit.logOutUser();
                                }
                                else if(index==2)
                                  move(context, const FaqScreen());
                                else if(index==5){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          contentPadding: EdgeInsets.all(20.r),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(15.r),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: SvgPicture.asset(
                                                    'assets/delete.svg',
                                                  color: Colors.red,
                                                  width: 50.w,
                                                  height: 50.h,
                                                ),
                                              ),
                                              SizedBox(height: 20.h),
                                              Text(
                                                'تأكيد حذف الحساب',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                'هل أنت متأكد من رغبتك في حذف حسابك، لن تتمكن من العودة مرة أخرى؟',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Colors.grey.shade600,
                                                  height: 1.5,
                                                ),
                                              ),
                                              SizedBox(height: 25.h),
                                              state is DeleteUserAccLoadingState? const Center(child: CircularProgressIndicator(color: Colors.red,))
                                                  :Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        //await cubit.deleteUser();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                        padding: EdgeInsets.symmetric(vertical: 12.h),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12.r),
                                                        ),
                                                        elevation: 0,
                                                      ),
                                                      child: Text(
                                                        'نعم، حذف',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      style: OutlinedButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(vertical: 12.h),
                                                        side: BorderSide(color: Colors.grey.shade300),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12.r),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'تراجع',
                                                        style: TextStyle(
                                                          color: Colors.grey.shade700,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          } ,
                          padding: EdgeInsetsDirectional.symmetric(vertical: 30.h),
                          separatorBuilder: (context, index) => Padding(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 10.h),
                            child: const Divider(),
                          ),
                          itemCount: settingsList.length
                      ),
                    ],
                  ),
                ),
              ),
            );
          },

      )
    );
  }
}