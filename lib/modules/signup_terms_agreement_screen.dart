import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/privacy_policy_screen.dart';
import 'package:trying_homy/modules/terms_conditions_screen.dart';
import 'package:trying_homy/modules/verified_phone.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class SignupTermsAgreementScreen extends StatefulWidget {
  final String phone;
  final String userType;

  const SignupTermsAgreementScreen({
    super.key,
    required this.phone,
    required this.userType,
  });

  @override
  State<SignupTermsAgreementScreen> createState() =>
      _SignupTermsAgreementScreenState();
}

class _SignupTermsAgreementScreenState
    extends State<SignupTermsAgreementScreen> {
  bool isAccepted = false;

  String get accountTypeText {
    return widget.userType == 'provider' ? 'فني' : 'مستخدم';
  }

  Widget _buildTopSection() {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 30.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(15.r),
                      onTap: () => Navigator.pop(context),
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
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 21.sp,
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
                color: Colors.white.withOpacity(0.10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.20),
                ),
              ),
              child: Icon(
                Icons.privacy_tip_rounded,
                color: Colors.white,
                size: 52.sp,
              ),
            ),
            SizedBox(height: 25.h),
            Text(
              'الشروط والخصوصية',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 29.sp,
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
              padding: EdgeInsetsDirectional.symmetric(horizontal: 30.w),
              child: Text(
                'اقرأ الشروط والأحكام وسياسة الخصوصية الخاصة بالتطبيق قبل المتابعة في إنشاء حساب $accountTypeText.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required AppCubit cubit,
    required IconData icon,
    required String title,
    required String subtitle,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(22.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.only(bottom: 14.h),
        padding: EdgeInsetsDirectional.all(15.r),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: blueShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: mainColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      fontSize: 11.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: cubit.isDark ? Colors.white54 : Colors.grey,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: isAccepted
            ? mainColor.withOpacity(0.10)
            : cubit.isDark
                ? lightDarkColor
                : Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isAccepted ? mainColor : Colors.transparent,
          width: isAccepted ? 1.3 : 0,
        ),
        boxShadow: blueShadow,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isAccepted = !isAccepted;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isAccepted,
              activeColor: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              onChanged: (value) {
                setState(() {
                  isAccepted = value ?? false;
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(top: 9.h),
                child: Text(
                  'أقر بأنني قرأت الشروط والأحكام وسياسة الخصوصية، وأوافق على استخدامها داخل التطبيق، وأتعهد بإدخال بيانات صحيحة وعدم إساءة استخدام خدمات الصيانة أو الحجوزات.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 12.sp,
                    height: 1.7,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection({
    required AppCubit cubit,
    required AuthCubit authCubit,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 485.h,
        width: double.infinity,
        padding: EdgeInsetsDirectional.only(
          start: 20.w,
          end: 20.w,
          top: 25.h,
          bottom: 20.h,
        ),
        decoration: BoxDecoration(
          color: cubit.isDark ? darkBgColor : bgColor,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'قبل المتابعة',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'راجع الصفحات التالية لمعرفة قواعد استخدام التطبيق وكيفية التعامل مع بياناتك.',
                style: TextStyle(
                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 18.h),
              _buildInfoCard(
                cubit: cubit,
                icon: Icons.description_rounded,
                title: 'الشروط والأحكام',
                subtitle: 'تعرف على قواعد الحجز، الاشتراك، التوثيق، وحقوق العميل والفني.',
                onTap: () => move(context, const TermsConditionsScreen()),
              ),
              _buildInfoCard(
                cubit: cubit,
                icon: Icons.lock_rounded,
                title: 'سياسة الخصوصية',
                subtitle: 'تعرف على البيانات التي يحتاجها التطبيق لتشغيل الحجوزات وحماية الحسابات.',
                onTap: () => move(context, PrivacyPolicyScreen()),
              ),
              SizedBox(height: 4.h),
              _buildAgreementCard(cubit),
              SizedBox(height: 20.h),
              defaultButton(
                onPressed: () {
                  if (!isAccepted) {
                    showSnackBar(
                      Colors.red,
                      'يجب الموافقة على الشروط والأحكام وسياسة الخصوصية قبل المتابعة',
                      context,
                    );
                    return;
                  }

                  authCubit.requestCode(
                    phone: widget.phone.trim(),
                    userType: widget.userType,
                  );
                },
                text: 'أوافق وأتابع',
                height: 50.h,
              ),
            ],
          ),
        ),
      ),
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
            if (state is SendPhoneCodeLoadingState) {
              showLoadingDialog(context);
            }

            if (state is SendPhoneCodeSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(
                Colors.green,
                'تم إرسال كود التحقق إلى رقمك',
                context,
              );
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
                              filter: ImageFilter.blur(
                                sigmaX: 50,
                                sigmaY: 50,
                              ),
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          _buildTopSection(),
                        ],
                      ),
                    ),
                    _buildBottomSection(
                      cubit: appCubit,
                      authCubit: authCubit,
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
