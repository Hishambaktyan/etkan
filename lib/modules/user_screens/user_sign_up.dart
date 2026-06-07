import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/signup_terms_agreement_screen.dart';
import 'package:trying_homy/modules/user_screens/user_login.dart';
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

  List<String> getNameParts(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.trim().isNotEmpty)
        .toList();
  }

  void limitNameToFourWords(TextEditingController controller, String value) {
    final List<String> nameParts = getNameParts(value);

    if (nameParts.length > 4) {
      final String newValue = nameParts.take(4).join(' ');

      controller.value = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );
    }
  }

  String? validateQuadName(String? value) {
    final List<String> nameParts = getNameParts(value ?? '');

    if (nameParts.isEmpty) {
      return 'الاسم الرباعي يجب أن لا يكون فارغ';
    }

    if (nameParts.length != 4) {
      return 'أدخل اسمًا رباعيًا فقط';
    }

    return null;
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

  Future<bool> isPhoneAlreadyRegistered(String phone) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> goToTermsAfterPhoneCheck(AuthCubit authCubit) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!userSignupFormKey.currentState!.validate()) {
      return;
    }

    final String phone = authCubit.userPhoneController.text.trim();

    showLoadingDialog(context);

    try {
      final bool phoneExists = await isPhoneAlreadyRegistered(phone);

      if (!mounted) return;

      hideLoadingDialog(context);

      if (phoneExists) {
        showSnackBar(
          Colors.red,
          'رقم الهاتف مسجل بالفعل، يرجى تسجيل الدخول أو استخدام رقم آخر',
          context,
        );
        return;
      }

      move(
        context,
        SignupTermsAgreementScreen(
          phone: phone,
          userType: 'user',
        ),
      );
    } catch (error) {
      if (!mounted) return;

      hideLoadingDialog(context);

      showSnackBar(
        Colors.red,
        'تعذر التحقق من رقم الهاتف، حاول مرة أخرى',
        context,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocBuilder<AuthCubit, AuthStates>(
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
                      child: Stack(children: [
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
                                child: Column(children: [
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
                                            onTap: () => moveAndReplace(
                                                context, const UserLogin()),
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
                                    child: Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(top: 50.h),
                                      child: Text(
                                        'إنشاء حساب\nمستخدم جديد',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              blurRadius: 20,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ])))
                      ]),
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
                                  text: 'الاسم الرباعي',
                                  prefixIcon: 'assets/acc.svg',
                                  errorMes:
                                      'الاسم الرباعي يجب أن لا يكون فارغًا',
                                  controller: authCubit.userNameController,
                                  type: TextInputType.name,
                                  validator: validateQuadName,
                                  onChanged: (value) => limitNameToFourWords(
                                    authCubit.userNameController,
                                    value,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'رقم الهاتف',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: 'رقم الهاتف يجب أن لا يكون فارغ',
                                  controller: authCubit.userPhoneController,
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
                                SizedBox(height: 15.h),
                                defaultTextFormField(
                                  cubit: appCubit,
                                  text: 'كلمة المرور',
                                  prefixIcon: 'assets/lock.svg',
                                  errorMes: 'كلمة المرور يجب أن لا تكون فارغة',
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
                                    await goToTermsAfterPhoneCheck(authCubit);
                                  },
                                  text: 'التالي',
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
