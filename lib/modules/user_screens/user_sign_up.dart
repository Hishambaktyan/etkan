import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/user_screens/user_login_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_login_screen.dart';
import 'package:trying_homy/modules/user_screens/user_email_verification.dart';
import 'package:trying_homy/modules/user_screens/verified_phone.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import '../../main.dart';
import '../worker_screens/worker_email_verfication_screen.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  bool isPassword = true;
  var formKey_userSignUp = GlobalKey<FormState>();
  String suffixIcon = 'assets/eye.svg';

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<AuthCubit,AuthStates>(
          listener: (context, state) {
            if(state is UserSignUpErrorState){
              showSnackBar(Colors.red,state.error.toString(), context);
            }
            if (state is SendVerficationCodeSuccessState) {
              authCubit.userPasswordController.clear();
              authCubit.userPhoneController.clear();
              authCubit.userNameController.clear();
              showSnackBar(Colors.green, 'تم إنشاء حسابك بنجاح', context);
              appCubit.changeIndex(0);
              moveAndReplace(context, const UserVerificationScreen());
            }
            if(state is SendVerficationCodeErrorState){
              showSnackBar(Colors.red, 'فشل في إرسال بريد التحقق', context);

            }
          },
          builder: (context, state) {
            return  Directionality(
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
                          color: appCubit.isDark ? darkBgColor : Colors.white,
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
                            key: formKey_userSignUp,
                            child: Column(
                              children: [
                                Container(
                                  height: 50.h,
                                  child: defaultTextFormfeild(
                                    cubit: appCubit,
                                    text: 'الاسم الكامل',
                                    prefixIcon: 'assets/acc.svg',
                                    errorMes: 'يجب كتابة الاسم',
                                    controller: authCubit.userNameController,
                                    type: TextInputType.text,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Container(
                                  height: 50.h,
                                  child: defaultTextFormfeild(
                                    cubit: appCubit,
                                    text: 'رقم الهاتف',
                                    prefixIcon: 'assets/phone.svg',
                                    errorMes: 'رقم الهاتف يجب ان لا يكون فارغ',
                                    controller: authCubit.userPhoneController,
                                    type: TextInputType.text,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Container(
                                  height: 50.h,
                                  child: defaultTextFormfeild(
                                    cubit: appCubit,
                                    text: 'كلمة المرور',
                                    prefixIcon: 'assets/lock.svg',
                                    errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
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
                                ),
                                SizedBox(height: 20.h),
                                state is UserSignUpLoadingState || state is SendVerficationCodeLoadingState? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                    : defaultButton(
                                  onPressed: () async {
                                    if(
                                    authCubit.userNameController.text.isNotEmpty &&
                                        authCubit.userPhoneController.text.isNotEmpty &&
                                        authCubit.userPasswordController.text.isNotEmpty
                                    ){
                                      await authCubit.signUpUser(
                                          authCubit.userPhoneController.text.trim(),
                                          authCubit.userPasswordController.text.trim()
                                      );
                                    }else{
                                      showSnackBar(Colors.red, 'يرجى تعبئة كل الحقول', context);
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
                                            context, const UserLoginScreen()),
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