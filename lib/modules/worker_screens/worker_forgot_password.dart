import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/worker_screens/worker_login.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class WorkerForgotPassword extends StatefulWidget {
  const WorkerForgotPassword({super.key});

  @override
  State<WorkerForgotPassword> createState() => _WorkerForgotPasswordState();
}

class _WorkerForgotPasswordState extends State<WorkerForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return Scaffold(
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
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(top: 120.h),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: 50.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          'نسيت كلمة المرور؟',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 30.w),
                          child: Text(
                            'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14.sp,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 350.h,
              width: double.infinity,
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: cubit.isDark ? darkBgColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  defaultTextFormField(
                    cubit: cubit,
                    text: 'البريد الألكتروني',
                    prefixIcon: 'assets/phone.svg',
                    errorMes: 'البريد الألكتروني يجب ان لا يكون فارغ',
                    controller: emailController,
                    type: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 25.h),
                  defaultButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty) {
                        showSnackBar(
                            Colors.green, 'تفقد بريدك الألكتروني', context);
                      } else {
                        showSnackBar(Colors.red, 'يرجى تعبية الحقل', context);
                      }
                    },
                    text: 'إرسال',
                    height: 50.h,
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () => move(context, const WorkerLogin()),
                    child: Text(
                      "العودة لتسجيل الدخول",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
