import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/verified_phone.dart';
import 'package:trying_homy/modules/worker_screens/worker_login_screen.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';

class WorkerSignup extends StatefulWidget {
  const WorkerSignup({super.key});

  @override
  State<WorkerSignup> createState() => _WorkerSignupState();
}

class _WorkerSignupState extends State<WorkerSignup> {

  var formKey = GlobalKey<FormState>();
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
              showSnackBar(Colors.green, 'تم إرسال كود التحقق إلى رقمك', context);
              move(context, VerifiedPhone(phone: state.phone, userType: state.userType,),
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
                              ])),
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
                              filter: ImageFilter.blur(
                                  sigmaX: 50,
                                  sigmaY: 50), // تنعيم الألوان لتصبح مثل الضوء
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(top: 100.h),
                              child: Text(
                                'إنشاء حساب\nفني جديد',
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
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'الأسم الكامل',
                                  prefixIcon: 'assets/acc.svg',
                                  errorMes: 'الاسم يجب ان لا يكون فارغ',
                                  controller: authCubit.workerNameController,
                                  type: TextInputType.text,
                                ),
                                SizedBox(height: 15.0.h,),
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'رقم الهاتف',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: 'رقم الهاتف يجب ان لا يكون فارغ',
                                  controller: authCubit.workerPhoneController,
                                  type: TextInputType.phone,
                                ),
                                SizedBox(height: 15.0.h,),
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'كلمة المرور',
                                  prefixIcon: 'assets/lock.svg',
                                  errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
                                  controller:
                                  authCubit.workerPasswordController,
                                  type: TextInputType.visiblePassword,
                                  isPassword: authCubit.isPassword,
                                  isSuffixIcon: true,
                                  suffixIcon: authCubit.suffixIcon,
                                  suffixPressed: () =>
                                      authCubit.changePasswordVisiability(),
                                ),

                                SizedBox(height: 20.h,),
                                 defaultButton(
                                    onPressed: () async {
                                      if(formKey.currentState!.validate()){
                                        authCubit.requestCode(
                                            phone: authCubit.workerPhoneController.text.trim(),
                                            userType: 'provider'
                                        );
                                      }
                                    },
                                    text: 'التالي',
                                    height: 50.h),
                                SizedBox(
                                  height: 10.h,
                                ),
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
                                        onPressed: () => move(
                                            context, const WorkerLoginScreen()),
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