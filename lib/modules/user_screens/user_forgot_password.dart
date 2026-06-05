import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/user_login.dart';
import 'package:trying_homy/modules/worker_screens/worker_login.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/verified_phone.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';

class UserForgotPassword extends StatefulWidget {
  final String userType;

  const UserForgotPassword({
    super.key,
    this.userType = 'user',
  });

  @override
  State<UserForgotPassword> createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final AuthCubit authCubit = AuthCubit.get(context);

        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is SendPhoneCodeLoadingState) {
              showLoadingDialog(context);
            }

            if (state is SendPhoneCodeSuccessState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.green,
                'تم إرسال رمز التحقق الى رقم الهاتف ',
                context,
              );

              move(
                context,
                VerifiedPhone(
                  phone: state.phone,
                  userType: state.userType,
                  purpose: 'reset_password',
                ),
              );
            }

            if (state is SendPhoneCodeErrorState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.red,
                state.error,
                context,
              );
            }
          },
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Directionality(
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
                                filter:
                                    ImageFilter.blur(sigmaX: 50, sigmaY: 50),
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
                                            color:
                                                Colors.white.withOpacity(0.2),
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
                                            color:
                                                Colors.white.withOpacity(0.4),
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
                                        'أدخل رقم الهاتف المسجل في حسابك وسنرسل لك رمز التحقق',
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
                            color: appCubit.isDark ? darkBgColor : bgColor,
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
                              Form(
                                key: formKey,
                                child: defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'رقم الهاتف',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: 'رقم الهاتف يجب أن لا يكون فارغًا',
                                  controller: phoneController,
                                  type: TextInputType.phone,
                                ),
                              ),
                              SizedBox(height: 25.h),
                              defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    // إغلاق الكيبورد قبل إرسال الطلب
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    authCubit.requestCode(
                                      phone: phoneController.text.trim(),
                                      userType: widget.userType,
                                      purpose: 'reset_password',
                                    );
                                  }
                                },
                                text: 'إرسال رمز التحقق',
                                height: 50.h,
                              ),
                              SizedBox(height: 20.h),
                              TextButton(
                                onPressed: () {
                                  if (widget.userType == 'provider') {
                                    moveAndReplace(
                                      context,
                                      const WorkerLogin(),
                                    );
                                  } else {
                                    moveAndReplace(
                                      context,
                                      const UserLogin(),
                                    );
                                  }
                                },
                                child: Text(
                                  'العودة لتسجيل الدخول',
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
              ),
            );
          },
        );
      },
    );
  }
}
