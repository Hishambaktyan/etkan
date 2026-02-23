import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/layout/user_layout/user_main_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';

class DoneBookingScreen extends StatelessWidget {
  const DoneBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
                'assets/animations/done.json',
            ),
            Text(
              'تم ارسال طلبك بنجاح',
              style: TextStyle(
                fontSize: 23.sp
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'رقم حجزك هو: 2546',
              style: TextStyle(
                fontSize: 15.sp
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 20.h),
        child: defualtButton(
            onPressed: ()=>moveAndReplace(context, const UserMainScreen()),
            text: 'العودة إلى الرئيسية'
        ),
      ),
    );
  }
}
