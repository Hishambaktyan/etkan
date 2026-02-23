import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/layout/user_layout/user_main_screen.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPassword = true;
  String suffixIcon = 'assets/eye.svg';
  var formKey = GlobalKey<FormState>();

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
                          Text(
                            'مرحبا بعودتك!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'سجل دخولك للإستمرار',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 15.sp,
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
                height: 450.h,
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 30.h),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 50.h,
                          child: defaultTextFormfeild(
                              text: 'رقم الهاتف',
                              prefixIcon: 'assets/phone.svg',
                              errorMes: 'رقم الهاتف يجب ان لا يكون فارغ',
                              controller: phoneController,
                              type: TextInputType.number
                          ),
                        ),
                        SizedBox(
                            height: 20.h
                        ),
                        Container(
                          height: 50.h,
                          child: defaultTextFormfeild(
                              text: 'كلمة المرور',
                              prefixIcon: 'assets/lock.svg',
                              errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              isPassword: isPassword,
                              isSuffixIcon: true,
                              suffixIcon: suffixIcon,
                              suffixPressed: (){
                                isPassword =!isPassword;
                                setState(() {
                                  suffixIcon = isPassword? 'assets/eye.svg' : 'assets/eye-slash.svg';
                                });
                              }
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: (){},
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: mainColor
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        defualtButton(
                            onPressed: (){
                              move(context, const UserMainScreen());
                            },
                            text: 'دخول',
                            height: 50.h
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              ),
                            ),
                            defaultTextButton(
                                onPressed: ()=> Navigator.pop(context),
                                text: 'انشئ حساب',
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}