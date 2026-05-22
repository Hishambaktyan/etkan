import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/user_login_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_login_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../shared/cubits/app_cubit/app_cubit.dart';


class UserForgotPasswordScreen extends StatefulWidget {
  const UserForgotPasswordScreen({super.key});

  @override
  State<UserForgotPasswordScreen> createState() => _UserForgotPasswordScreenState();
}

class _UserForgotPasswordScreenState extends State<UserForgotPasswordScreen> {
  final TextEditingController emailController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

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
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 30.w),
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
                      errorMes:
                      'البريد الألكتروني يجب ان لا يكون فارغ',
                      controller: emailController,
                      type: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 25.h),
                    defaultButton(
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          showSnackBar(
                              Colors.green,
                              'تفقد بريدك الألكتروني',
                              context);
                        } else {
                          showSnackBar(
                              Colors.red,
                              'يرجى تعبية الحقل',
                              context);
                        }
                      },
                      text: 'إرسال',
                      height: 50.h,
                    ),
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: () =>
                          move(context, const UserLoginScreen()),
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
      ),
    );
  }
}