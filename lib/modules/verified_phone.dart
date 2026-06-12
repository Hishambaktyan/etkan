import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/reset_password_screen.dart';
import 'package:Etkan/modules/user_screens/user_add_address.dart';
import 'package:Etkan/modules/worker_screens/worker_complete_profile.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class VerifiedPhone extends StatefulWidget {
  final String phone;
  final String userType;
  final String purpose;

  const VerifiedPhone({
    super.key,
    required this.phone,
    required this.userType,
    this.purpose = 'signup',
  });

  @override
  State<VerifiedPhone> createState() => _VerifiedPhoneState();
}

class _VerifiedPhoneState extends State<VerifiedPhone> {
  final int codeLength = 6;

  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  int resendSeconds = 60;
  Timer? timer;

  bool get isResetPassword => widget.purpose == 'reset_password';

  String get verificationCode {
    return controllers.map((controller) => controller.text.trim()).join();
  }

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      codeLength,
      (_) => TextEditingController(),
    );

    focusNodes = List.generate(
      codeLength,
      (_) => FocusNode(),
    );

    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      resendSeconds = 60;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (currentTimer) {
        if (!mounted) {
          currentTimer.cancel();
          return;
        }

        if (resendSeconds <= 0) {
          currentTimer.cancel();
          return;
        }

        setState(() {
          resendSeconds--;
        });
      },
    );
  }

  void clearCode() {
    for (final controller in controllers) {
      controller.clear();
    }

    if (mounted) {
      FocusScope.of(context).requestFocus(focusNodes.first);
      setState(() {});
    }
  }

  void verifyCode(AuthCubit authCubit) {
    if (verificationCode.length != codeLength) {
      showSnackBar(
        Colors.red,
        'أدخل رمز التحقق كاملًا',
        context,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    authCubit.checkCode(
      phone: widget.phone,
      code: verificationCode,
      userType: widget.userType,
      purpose: widget.purpose,
    );
  }

  void resendCode(AuthCubit authCubit) {
    clearCode();

    authCubit.requestCode(
      phone: widget.phone,
      userType: widget.userType,
      purpose: widget.purpose,
    );

    startTimer();
  }

  Widget buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        child: Container(
          width: 42.w,
          height: 42.h,
          margin: EdgeInsetsDirectional.only(end: 10.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget buildTopSection() {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 30.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 10.w,
              ),
              child: Row(
                children: [
                  buildBackButton(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.20),
                ),
              ),
              child: SvgPicture.asset(
                'assets/phone.svg',
                width: 50.w,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'تأكيد رقم الهاتف',
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
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 30.w,
              ),
              child: Text(
                isResetPassword
                    ? 'أدخل الرمز المرسل إلى رقمك للمتابعة وتعيين كلمة مرور جديدة'
                    : 'أدخل الرمز المرسل إلى رقمك لتأكيد وإنشاء حسابك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCodeInput({
    required int index,
    required AppCubit appCubit,
    required bool isLoading,
  }) {
    final bool hasFocus = focusNodes[index].hasFocus;
    final bool hasValue = controllers[index].text.isNotEmpty;

    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 3.w,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52.h,
          decoration: BoxDecoration(
            color:
                appCubit.isDark ? lightDarkColor : mainColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              width: hasFocus ? 1.5 : 1,
              color: hasFocus || hasValue
                  ? mainColor
                  : appCubit.isDark
                      ? const Color(0xFF30363D)
                      : mainColor.withOpacity(0.10),
            ),
          ),
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            enabled: !isLoading,
            keyboardType: TextInputType.number,
            textInputAction: index == codeLength - 1
                ? TextInputAction.done
                : TextInputAction.next,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            maxLength: 1,
            showCursor: false,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
            ),
            onTap: () {
              setState(() {});
            },
            onChanged: (value) {
              setState(() {});

              if (value.isNotEmpty && index < codeLength - 1) {
                FocusScope.of(context).requestFocus(
                  focusNodes[index + 1],
                );
              }

              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(
                  focusNodes[index - 1],
                );
              }

              if (verificationCode.length == codeLength) {
                FocusScope.of(context).unfocus();
              }
            },
            onFieldSubmitted: (_) {
              if (index == codeLength - 1) {
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildPhoneContainer({
    required AppCubit appCubit,
  }) {
    return Container(
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
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/phone.svg',
              width: 21.w,
              color: mainColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تم إرسال رمز التحقق إلى الرقم',
                  style: TextStyle(
                    color: appCubit.isDark
                        ? darkSubTextColor
                        : Colors.grey.shade700,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    widget.phone,
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified_rounded,
            color: mainColor,
            size: 24.sp,
          ),
        ],
      ),
    );
  }

  Widget buildHintContainer({
    required AppCubit appCubit,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(12.r),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: Colors.orange.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Colors.orange,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'تأكد من إدخال الرمز قبل انتهاء صلاحيته، وقد يستغرق وصوله بضع ثوانٍ.',
              style: TextStyle(
                color:
                    appCubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 11.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomSection({
    required AppCubit appCubit,
    required AuthCubit authCubit,
    required AuthStates state,
  }) {
    final bool isLoading = state is CheckPhoneCodeLoadingState ||
        state is SendPhoneCodeLoadingState ||
        state is UserSignUpLoadingState ||
        state is WorkerSignUpLoadingState;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 460.h,
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 20.w,
          vertical: 25.h,
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
          child: Column(
            children: [
              Text(
                'أدخل الرمز المكون من ستة أرقام في الحقول التالية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      appCubit.isDark ? darkSubTextColor : Colors.grey.shade600,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 10.h),
              buildPhoneContainer(
                appCubit: appCubit,
              ),
              SizedBox(height: 20.h),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: List.generate(
                    codeLength,
                    (index) => buildCodeInput(
                      index: index,
                      appCubit: appCubit,
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم تستلم الرمز؟',
                    style: TextStyle(
                      color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: resendSeconds == 0 && !isLoading
                        ? () => resendCode(authCubit)
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
              SizedBox(height: 18.h),
              buildHintContainer(
                appCubit: appCubit,
              ),
              SizedBox(height: 22.h),
              defaultButton(
                onPressed: isLoading ? () {} : () => verifyCode(authCubit),
                text: isResetPassword
                    ? 'متابعة لتغيير كلمة المرور'
                    : 'تأكيد الحساب',
                height: 50.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    for (final controller in controllers) {
      controller.dispose();
    }

    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, appState) {
        final AppCubit appCubit = AppCubit.get(context);
        final AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) async {
            if (state is CheckPhoneCodeLoadingState ||
                state is SendPhoneCodeLoadingState) {
              showLoadingDialog(context);
            }

            if (state is SendPhoneCodeSuccessState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.green,
                'تم إرسال رمز تحقق جديد',
                context,
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

            if (state is CheckPhoneCodeSuccessState) {
              hideLoadingDialog(context);

              if (isResetPassword) {
                moveAndReplace(
                  context,
                  ResetPasswordScreen(
                    phone: widget.phone,
                    userType: widget.userType,
                  ),
                );

                return;
              }

              if (widget.userType == 'provider') {
                moveAndReplace(
                  context,
                  const WorkerCompleteProfile(),
                );
              } else {
                moveAndReplace(
                  context,
                  const UserAddAddress(isOnboarding: true),
                );
              }
            }

            if (state is CheckPhoneCodeErrorState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.red,
                state.error,
                context,
              );
            }

            if (state is UserSignUpSuccessState) {
              hideLoadingDialog(context);

              authCubit.userNameController.clear();
              authCubit.userPhoneController.clear();
              authCubit.userPasswordController.clear();

              showSnackBar(
                Colors.green,
                'تم إنشاء الحساب بنجاح، أضف عنوانك لإكمال الإعداد',
                context,
              );

              moveAndReplace(
                context,
                const UserAddAddress(isOnboarding: true),
              );
            }

            if (state is UserSignUpErrorState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.red,
                state.error,
                context,
              );
            }

            if (state is WorkerSignUpSuccessState) {
              hideLoadingDialog(context);

              authCubit.workerNameController.clear();
              authCubit.workerPhoneController.clear();
              authCubit.workerPasswordController.clear();

              showSnackBar(
                Colors.green,
                'تم إنشاء حسابك بنجاح',
                context,
              );

              moveAndReplace(
                context,
                const WorkerCompleteProfile(),
              );
            }

            if (state is WorkerSignUpErrorState) {
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
                              filter: ImageFilter.blur(
                                sigmaX: 50,
                                sigmaY: 50,
                              ),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          buildTopSection(),
                        ],
                      ),
                    ),
                    buildBottomSection(
                      appCubit: appCubit,
                      authCubit: authCubit,
                      state: state,
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
