import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/select_user_type.dart';
import 'package:Etkan/modules/user_screens/user_login.dart';
import 'package:Etkan/modules/worker_screens/worker_login.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class ResetPassword extends StatefulWidget {
  final String phone;
  final String userType;

  const ResetPassword({
    super.key,
    required this.phone,
    required this.userType,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void saveNewPassword(AuthCubit authCubit) {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final String newPassword = newPasswordController.text.trim();

    final String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      showSnackBar(
        Colors.red,
        'كلمة المرور يجب أن تحتوي على 6 أحرف أو أرقام على الأقل',
        context,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      showSnackBar(
        Colors.red,
        'كلمتا المرور غير متطابقتين',
        context,
      );
      return;
    }

    authCubit.resetPassword(
      phone: widget.phone,
      userType: widget.userType,
      newPassword: newPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, appState) {
        final AppCubit appCubit = AppCubit.get(context);
        final AuthCubit authCubit = AuthCubit.get(context);

        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is ResetPasswordLoadingState) {
              showLoadingDialog(context);
            }

            if (state is ResetPasswordSuccessState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.green,
                'تم تغيير كلمة المرور بنجاح',
                context,
              );

              newPasswordController.clear();
              confirmPasswordController.clear();

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
            }

            if (state is ResetPasswordErrorState) {
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
                            filter: ImageFilter.blur(
                              sigmaX: 50,
                              sigmaY: 50,
                            ),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: 30.h,
                            ),
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
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
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
                                                  BorderRadius.circular(
                                                15.r,
                                              ),
                                              border: Border.all(
                                                color:
                                                    Colors.white.withOpacity(
                                                  0.12,
                                                ),
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
                                Container(
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
                                SizedBox(height: 30.h),
                                Text(
                                  'كلمة مرور جديدة',
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
                                    'أنشئ كلمة مرور قوية وجديدة لحماية حسابك',
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
                        ),
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
                              Container(
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 15.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: Border.all(
                                    color: mainColor.withOpacity(0.18),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.r),
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.verified_rounded,
                                        color: mainColor,
                                        size: 22.sp,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'تم التحقق من رقم الهاتف',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.color,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              widget.phone,
                                              style: TextStyle(
                                                color: mainColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              defaultTextFormField(
                                cubit: appCubit,
                                text: 'كلمة المرور الجديدة',
                                prefixIcon: 'assets/lock.svg',
                                errorMes:
                                    'كلمة المرور الجديدة يجب أن لا تكون فارغة',
                                controller: newPasswordController,
                                type: TextInputType.visiblePassword,
                                isPassword: hideNewPassword,
                                isSuffixIcon: true,
                                suffixIcon: hideNewPassword
                                    ? 'assets/eye.svg'
                                    : 'assets/eye-slash.svg',
                                suffixPressed: () {
                                  setState(() {
                                    hideNewPassword = !hideNewPassword;
                                  });
                                },
                              ),
                              SizedBox(height: 15.h),
                              defaultTextFormField(
                                cubit: appCubit,
                                text: 'تأكيد كلمة المرور',
                                prefixIcon: 'assets/lock.svg',
                                errorMes:
                                    'تأكيد كلمة المرور يجب أن لا يكون فارغًا',
                                controller: confirmPasswordController,
                                type: TextInputType.visiblePassword,
                                isPassword: hideConfirmPassword,
                                isSuffixIcon: true,
                                suffixIcon: hideConfirmPassword
                                    ? 'assets/eye.svg'
                                    : 'assets/eye-slash.svg',
                                suffixPressed: () {
                                  setState(() {
                                    hideConfirmPassword =
                                        !hideConfirmPassword;
                                  });
                                },
                              ),
                              SizedBox(height: 25.h),
                              defaultButton(
                                onPressed: () {
                                  // إغلاق الكيبورد قبل إرسال الطلب
                                  FocusManager.instance.primaryFocus
                                      ?.unfocus();
                                  saveNewPassword(authCubit);
                                },
                                text: 'حفظ كلمة المرور',
                                height: 50.h,
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
