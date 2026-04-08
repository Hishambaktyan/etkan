import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/layout/worker_layout/worker_main_screen.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_forgot_password_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_signUp.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../../shared/compenents/components.dart';
import 'worker_email_verfication_screen.dart';

class WorkerLoginScreen extends StatefulWidget {
  const WorkerLoginScreen({super.key});

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<AuthCubit,AuthStates>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              authCubit.workerLoginPhoneController.clear();
              authCubit.workerLoginPasswordController.clear();
              appCubit.workerDataLoaded = false;
              appCubit.getWorkerData();
              var user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  moveAndReplace(context, const WorkerMainScreen());
                } else {
                  showSnackBar(
                      Colors.orange, 'يرجى توثيق البريد الإلكتروني أولاً', context);
                  moveAndReplace(context, const WorkerEmailVerificationScreen());
                }
              }
            }

            if (state is LoginErrorState) {
              showSnackBar(Colors.red, state.error.toString(), context);
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
                              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(top: 70.h),
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
                                        Icons.login_rounded,
                                        size: 50.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
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
                            key: formKey,
                            child: Column(
                              children: [
                                Container(
                                  height: 50.h,
                                  child: defaultTextFormfeild(
                                      cubit: appCubit,
                                      text: 'البريد الألكتروني',
                                      prefixIcon: 'assets/phone.svg',
                                      errorMes:
                                      'البريد الألكتروني يجب ان لا يكون فارغ',
                                      controller: authCubit.workerLoginPhoneController,
                                      type: TextInputType.emailAddress),
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  height: 50.h,
                                  child: defaultTextFormfeild(
                                      cubit: appCubit,
                                      text: 'كلمة المرور',
                                      prefixIcon: 'assets/lock.svg',
                                      errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
                                      controller: authCubit.workerLoginPasswordController,
                                      type: TextInputType.visiblePassword,
                                      isPassword: authCubit.isPassword,
                                      isSuffixIcon: true,
                                      suffixIcon: authCubit.suffixIcon,
                                      suffixPressed: () {
                                        authCubit.changePasswordVisiability();
                                      }),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: TextButton(
                                    onPressed: () {
                                      move(context, const WorkerForgotPasswordScreen());
                                    },
                                    child: Text(
                                      'نسيت كلمة المرور؟',
                                      style: TextStyle(
                                          color: mainColor,
                                          fontSize: 12.sp,
                                          decoration: TextDecoration.underline,
                                          decorationColor: mainColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                authCubit.state is LoginLoadingState
                                    ? const Center(
                                    child: CircularProgressIndicator())
                                    : defualtButton(
                                    onPressed: () async {
                                      if (authCubit.workerLoginPhoneController.text
                                          .isNotEmpty &&
                                          authCubit.workerLoginPasswordController.text
                                              .isNotEmpty) {
                                        await authCubit.loginUser(
                                            authCubit.workerLoginPhoneController.text.trim(),
                                            authCubit.workerLoginPasswordController.text
                                                .trim());
                                      } else {
                                        showSnackBar(Colors.red,
                                            'يرجى تعبة كل الحقول', context);
                                      }
                                    },
                                    text: 'دخول',
                                    height: 50.h),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'ليس لديك حساب؟',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    defaultTextButton(
                                      onPressed: () => moveAndReplace(
                                          context, const WorkerSignup()),
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
          },
        );
      },
    );
  }
}
