import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/user_screens/user_login.dart';
import 'package:Etkan/modules/verified_phone.dart';
import 'package:Etkan/modules/worker_screens/worker_login.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class ForgotPassword extends StatefulWidget {
  final String userType;

  const ForgotPassword({
    super.key,
    this.userType = 'user',
  });

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  String get accountTypeText {
    return widget.userType == 'provider' ? 'الفني' : 'المستخدم';
  }

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

  Future<bool> isPhoneRegisteredForCurrentType(String phone) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone)
            .limit(5)
            .get();

    if (querySnapshot.docs.isEmpty) {
      final QuerySnapshot<Map<String, dynamic>> fullPhoneQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: '+967$phone')
              .limit(5)
              .get();

      return fullPhoneQuery.docs.any(
        (doc) => doc.data()['role']?.toString() == widget.userType,
      );
    }

    return querySnapshot.docs.any(
      (doc) => doc.data()['role']?.toString() == widget.userType,
    );
  }

  Future<void> sendResetPasswordCode(AuthCubit authCubit) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final String phone = phoneController.text.trim();

    showLoadingDialog(context);

    try {
      final bool isRegistered = await isPhoneRegisteredForCurrentType(phone);

      if (!mounted) return;

      hideLoadingDialog(context);

      if (!isRegistered) {
        showSnackBar(
          Colors.red,
          'لا يوجد حساب $accountTypeText مسجل بهذا الرقم',
          context,
        );
        return;
      }

      await authCubit.requestCode(
        phone: phone,
        userType: widget.userType,
        purpose: 'reset_password',
      );
    } catch (error) {
      if (!mounted) return;

      hideLoadingDialog(context);

      showSnackBar(
        Colors.red,
        'حدث خطأ أثناء التحقق من الرقم، حاول مرة أخرى',
        context,
      );
    }
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
                'تم إرسال رمز التحقق إلى رقم الهاتف',
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
                            filter: ImageFilter.blur(
                              sigmaX: 50,
                              sigmaY: 50,
                            ),
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
                                    start: 10.w,
                                    end: 10.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          onTap: () {
                                            if (widget.userType ==
                                                'provider') {
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
                                          child: Container(
                                            width: 42.w,
                                            height: 42.h,
                                            margin:
                                                EdgeInsetsDirectional.only(
                                              end: 10.w,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.16),
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.12),
                                              ),
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
                                      Icons.lock_reset_rounded,
                                      size: 50.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.h),
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
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 30.w,
                                  ),
                                  child: Text(
                                    'أدخل رقم الهاتف المسجل في حسابك لإرسال رمز التحقق',
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
                      height: 450.h,
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 20.w,
                        vertical: 30.h,
                      ),
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
                              SizedBox(height: 20.h),
                              defaultTextFormField(
                                cubit: appCubit,
                                text: 'رقم الهاتف',
                                prefixIcon: 'assets/phone.svg',
                                errorMes: 'رقم الهاتف يجب أن لا يكون فارغًا',
                                controller: phoneController,
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
                              SizedBox(height: 25.h),
                              defaultButton(
                                onPressed: () {
                                  sendResetPasswordCode(authCubit);
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
                                    decorationColor: mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
