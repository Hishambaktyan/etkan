import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Etkan/layout/worker_layout/worker_main_screen.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/select_user_type.dart';
import 'package:Etkan/modules/forgot_password_screen.dart';
import 'package:Etkan/modules/worker_screens/worker_signUp.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/styles/colors.dart';
import 'package:Etkan/shared/compenents/components.dart';
import '../../shared/cubits/worker_cubit/worker_cubit.dart';

class WorkerLogin extends StatefulWidget {
  const WorkerLogin({super.key});

  @override
  State<WorkerLogin> createState() => _WorkerLoginState();
}

Widget buildPhoneSuffix(AppCubit appCubit) {
  return Container(
    width: 62.w,
    alignment: Alignment.center,
    margin: EdgeInsetsDirectional.only(end: 5.w),
    child: Text(
      '+967',
      textDirection: TextDirection.ltr,
      style: TextStyle(
        color: mainColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class _WorkerLoginState extends State<WorkerLogin> {
  var formKey = GlobalKey<FormState>();

  String? validateYemeniPhone(String? value) {
    final String phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'رقم الهاتف يجب أن لا يكون فارغ';
    }

    if (!RegExp(r'^7[0-9]{8}$').hasMatch(phone)) {
      return 'أدخل رقم يمني مكون من 9 أرقام ويبدأ بـ 7';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LoginLoadingState) {
              showLoadingDialog(context);
            }
            if (state is LoginSuccessState) {
              hideLoadingDialog(context);
              authCubit.workerLoginPhoneController.clear();
              authCubit.workerLoginPasswordController.clear();
              WorkerCubit.get(context).isWorkerDataLoaded = false;
              moveAndReplace(
                context,
                const WorkerMainScreen(),
              );
            }
            if (state is LoginErrorState) {
              hideLoadingDialog(context);
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
                              padding: EdgeInsetsDirectional.only(top: 30.h),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 10.w, end: 10.w),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            onTap: () => moveAndReplace(context,
                                                const SelectUserType()),
                                            child: Container(
                                              width: 42.w,
                                              height: 42.h,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      end: 10.w),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.16),
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.12)),
                                              ),
                                              child: Icon(
                                                Icons
                                                    .arrow_back_ios_new_rounded,
                                                color: Colors.white,
                                                size: 18.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                    'سجل دخولك للاستمرار',
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
                          physics: const BouncingScrollPhysics(),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'رقم الهاتف',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: 'رقم الهاتف يجب أن لا يكون فارغ',
                                  controller:
                                      authCubit.workerLoginPhoneController,
                                  type: TextInputType.phone,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.right,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(9),
                                  ],
                                  validator: validateYemeniPhone,
                                  suffixWidget: buildPhoneSuffix(appCubit),
                                ),
                                SizedBox(height: 20.h),
                                defaultTextFormField(
                                    cubit: appCubit,
                                    text: 'كلمة المرور',
                                    prefixIcon: 'assets/lock.svg',
                                    errorMes:
                                        'كلمة المرور يجب أن لا تكون فارغة',
                                    controller:
                                        authCubit.workerLoginPasswordController,
                                    type: TextInputType.visiblePassword,
                                    isPassword: authCubit.isPassword,
                                    isSuffixIcon: true,
                                    suffixIcon: authCubit.suffixIcon,
                                    suffixPressed: () {
                                      authCubit.changePasswordVisiability();
                                    }),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: TextButton(
                                    onPressed: () {
                                      move(
                                        context,
                                        const ForgotPasswordScreen(
                                          userType: 'provider',
                                        ),
                                      );
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
                                defaultButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        // إغلاق الكيبورد قبل إرسال الطلب
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        await authCubit.loginUser(
                                            phone: authCubit
                                                .workerLoginPhoneController.text
                                                .trim(),
                                            password: authCubit
                                                .workerLoginPasswordController
                                                .text
                                                .trim(),
                                            requiredRole: 'provider');
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
                                      text: 'أنشئ حساب',
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
