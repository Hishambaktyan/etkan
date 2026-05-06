import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/layout/worker_layout/worker_main_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../main.dart';

class WorkerEmailVerificationScreen extends StatefulWidget {
  const WorkerEmailVerificationScreen({super.key});

  @override
  State<WorkerEmailVerificationScreen> createState() => _WorkerEmailVerificationScreenState();
}

class _WorkerEmailVerificationScreenState extends State<WorkerEmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      if (mounted) {
        Future.delayed(const Duration(seconds: 1));
        showSnackBar(Colors.green, 'تم توثيق حسابك', context);
        moveAndReplace(context, const WorkerMainScreen());
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    mainColor.withOpacity(0.9),
                    const Color(0xFF0F0F1E),
                  ],
                  stops: const [0.0, 0.8],
                ),
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
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(top: 140.h),
                      child: Column(
                        children: [
                          Icon(Icons.mark_email_read_outlined, size: 80.r, color: Colors.white),
                          SizedBox(height: 20.h),
                          Text(
                            'تأكيد الحساب',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 400.h,
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 30.w, vertical: 30.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: 30.h),
                    Text(
                      'تم إرسال رابط التوثيق إلى بريدك الإلكتروني',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'يرجى فتح البريد والضغط على الرابط لتفعيل حسابك. سنقوم بتحويلك تلقائياً فور الانتهاء.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    defaultButton(
                      onPressed: () {
                        FirebaseAuth.instance.currentUser?.sendEmailVerification();
                        showSnackBar(Colors.green, 'تم إعادة إرسال الرابط', context);
                      },
                      text: 'إعادة إرسال الرابط',
                      height: 50.h,
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('تسجيل الخروج / العودة'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}