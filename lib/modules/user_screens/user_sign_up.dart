import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/user_screens/user_login.dart';
import 'package:trying_homy/modules/verified_phone.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import '../../main.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  bool isPassword = true;
  var userSignupFormKey = GlobalKey<FormState>();
  String suffixIcon = 'assets/eye.svg';

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is SendPhoneCodeLoadingState) {
              showLoadingDialog(context);
            }
            if (state is SendPhoneCodeSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(
                  Colors.green, 'تم إرسال كود التحقق إلى رقمك', context);
              move(
                context,
                VerifiedPhone(
                  phone: state.phone,
                  userType: state.userType,
                ),
              );
            }
            if (state is SendPhoneCodeErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, state) {
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
                          ],
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
                              child: Text(
                                'إنشاء حساب\nمستخدم جديد',
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
                        child: SingleChildScrollView(
                          child: Form(
                            key: userSignupFormKey,
                            child: Column(
                              children: [
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'الاسم الكامل',
                                  prefixIcon: 'assets/acc.svg',
                                  errorMes: 'الاسم يجب ان لا يكون فارغ',
                                  controller: authCubit.userNameController,
                                  type: TextInputType.text,
                                ),
                                SizedBox(height: 15.h),
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'رقم الهاتف',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: 'رقم الهاتف يجب ان لا يكون فارغ',
                                  controller: authCubit.userPhoneController,
                                  type: TextInputType.phone,
                                ),
                                SizedBox(height: 15.h),
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'كلمة المرور',
                                  prefixIcon: 'assets/lock.svg',
                                  errorMes: 'كلمة المرور يجب ان لا تكون فارغة',
                                  controller: authCubit.userPasswordController,
                                  type: TextInputType.visiblePassword,
                                  isPassword: isPassword,
                                  isSuffixIcon: true,
                                  suffixIcon: suffixIcon,
                                  suffixPressed: () {
                                    isPassword = !isPassword;
                                    setState(() {
                                      suffixIcon = isPassword
                                          ? 'assets/eye.svg'
                                          : 'assets/eye-slash.svg';
                                    });
                                  },
                                ),
                                SizedBox(height: 20.h),
                                defaultButton(
                                  onPressed: () async {
                                    if (userSignupFormKey.currentState!
                                        .validate()) {
                                      authCubit.requestCode(
                                          phone: authCubit
                                              .userPhoneController.text
                                              .trim(),
                                          userType: 'user');
                                    }
                                  },
                                  text: 'تسجيل',
                                  height: 50.h,
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'لديك حساب بالفعل؟',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    defaultTextButton(
                                        onPressed: () => moveAndReplace(
                                            context, const UserLogin()),
                                        text: 'سجل دخول')
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
          },
        );
      },
    );
  }
}
