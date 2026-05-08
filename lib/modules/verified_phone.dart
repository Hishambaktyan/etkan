import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';

import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../layout/user_layout/user_main_screen.dart';

class VerifiedPhone extends StatefulWidget {
  final String phone;
  final String userType;

  const VerifiedPhone({
    super.key,
    required this.phone,
    required this.userType,
  });

  @override
  State<VerifiedPhone> createState() => _VerifiedPhoneState();
}

class _VerifiedPhoneState extends State<VerifiedPhone> {
  final int length = 6;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  int resendSeconds = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());
    startTimer();
  }

  void startTimer() {
    resendSeconds = 60;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          resendSeconds--;
        });
      }
    });
  }

  String get code {
    return controllers.map((controller) => controller.text.trim()).join();
  }

  void clearCode() {
    for (final controller in controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(focusNodes.first);
  }

  @override
  void dispose() {
    timer?.cancel();

    for (var controller in controllers) {
      controller.dispose();
    }

    for (var node in focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  Widget _buildHeaderCard({
    required BuildContext context,
    required AppCubit cubit,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: cubit.isDark ? [] : blueShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(15.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: SvgPicture.asset(
              'assets/phone.svg',
              color: Colors.white,
              width: 38.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التحقق من رقم الهاتف',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'أدخل رمز التحقق المرسل إلى واتساب لتأكيد حسابك في Homy.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.90),
                    fontSize: 11.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard({
    required BuildContext context,
    required AppCubit cubit,
    required AuthStates state,
  })
  {
    final bool isLoading = state is CheckPhoneCodeLoadingState ||
        state is UserSignUpLoadingState ||
        state is WorkerSignUpLoadingState;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : blueShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(18.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/whats.svg',
              color: mainColor,
              width: 48.w,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'أدخل رمز التحقق',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'لقد أرسلنا رمزًا مكونًا من 6 أرقام إلى واتساب رقمك:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
              fontSize: 12.sp,
              height: 1.7,
            ),
          ),
          SizedBox(height: 8.h),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: mainColor.withOpacity(0.18)),
              ),
              child: Text(
                widget.phone,
                style: TextStyle(
                  color: mainColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(length, (index) {
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
                  child: Container(
                    width: 43.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: cubit.isDark
                          ? darkBgColor
                          : mainColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: focusNodes[index].hasFocus
                            ? mainColor
                            : cubit.isDark
                                ? const Color(0xFF30363D)
                                : Colors.transparent,
                      ),
                    ),
                    child: TextFormField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      enabled: !isLoading,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      showCursor: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onTap: () {
                        setState(() {});
                      },
                      onChanged: (value) {
                        setState(() {});

                        if (value.isNotEmpty && index < length - 1) {
                          FocusScope.of(context).requestFocus(
                            focusNodes[index + 1],
                          );
                        }

                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(
                            focusNodes[index - 1],
                          );
                        }

                        if (code.length == length) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'لم تستلم الرمز؟',
                style: TextStyle(
                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(width: 6.w),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: resendSeconds == 0 && !isLoading
                    ? () {
                        clearCode();
                        AuthCubit.get(context).sendPhoneCode(
                          phone: widget.phone,
                          userType: widget.userType,
                        );
                        startTimer();
                      }
                    : null,
                child: Text(
                  resendSeconds == 0
                      ? 'إعادة الإرسال'
                      : 'إعادة الإرسال بعد $resendSeconds ث',
                  style: TextStyle(
                    color: resendSeconds == 0 ? mainColor : Colors.grey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    decoration: resendSeconds == 0
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: mainColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : defaultButton(
                  onPressed: () {
                    if (code.length != length) {
                      showSnackBar(
                        Colors.red,
                        'أدخل كود التحقق كامل',
                        context,
                      );
                      return;
                    }

                    AuthCubit.get(context).checkPhoneCode(
                      phone: widget.phone,
                      code: code,
                      userType: widget.userType,
                    );
                  },
                  text: 'تحقق من الحساب',
                  height: 50.h,
                ),
        ],
      ),
    );
  }

  Widget _buildHintCard({
    required BuildContext context,
    required AppCubit cubit,
  })
  {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(8.r),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.info,
              color: Colors.orange,
              size: 20.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'تأكد من أن رقم الهاتف يحتوي على واتساب، وقد يستغرق وصول الرمز بضع ثوانٍ.',
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 11.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, appState) {
        final appCubit = AppCubit.get(context);
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) async {
            final authCubit = AuthCubit.get(context);
            if (state is SendPhoneCodeSuccessState) {
              showSnackBar(Colors.green, 'تم إرسال رمز تحقق جديد', context,);
            }
            if (state is SendPhoneCodeErrorState) {
              showSnackBar(Colors.red, state.error, context,);
            }
            if (state is WorkerSignUpErrorState) {
              showSnackBar(Colors.red, state.error,context,);
            }
            if (state is CheckPhoneCodeSuccessState) {
              if (widget.userType == 'provider') {
                await authCubit.workerSignUpUser(
                  widget.phone,
                  authCubit.workerPasswordController.text.trim(),
                );
              }
              else if (widget.userType == 'admin') {
                await authCubit.adminSignUpUser(
                  widget.phone,
                  authCubit.userPasswordController.text.trim(),
                );
              }
              else {
                await authCubit.signUpUser(
                  widget.phone,
                  authCubit.userPasswordController.text.trim(),
                );
              }
            }
            if (state is UserSignUpSuccessState ||
                state is WorkerSignUpSuccessState)
            {
              authCubit.userPasswordController.clear();
              authCubit.userPhoneController.clear();
              authCubit.userNameController.clear();

              authCubit.workerPasswordController.clear();
              authCubit.workerPhoneController.clear();
              authCubit.workerNameController.clear();
              authCubit.workerAddController.clear();

              showSnackBar(
                Colors.green,
                'تم إنشاء حسابك بنجاح',
                context,
              );

              moveAndReplace(
                context,
                const UserMainScreen(),
              );
            }

            if (state is CheckPhoneCodeErrorState) {
              showSnackBar(Colors.red,state.error, context,);
            }

            if (state is UserSignUpErrorState) {
              showSnackBar(Colors.red, state.error, context,);
            }
          },
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: appCubit.isDark ? darkBgColor : Colors.white,
                appBar: AppBar(
                  backgroundColor: appCubit.isDark ? darkBgColor : Colors.white,
                  titleSpacing: 10,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(7),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            CupertinoIcons.back,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'تأكيد الهاتف',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.sp,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    start: 10.w,
                    end: 10.w,
                    top: 10.h,
                    bottom: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(
                        context: context,
                        cubit: appCubit,
                      ),
                      SizedBox(height: 22.h),
                      _buildVerificationCard(
                        context: context,
                        cubit: appCubit,
                        state: state,
                      ),
                      SizedBox(height: 15.h),
                      _buildHintCard(
                        context: context,
                        cubit: appCubit,
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
