import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController(text: 'hadi@gmail.com');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsetsDirectional.only(top: 90, start: 20.w, end: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: mainColor,
                    maxRadius: 55,
                    child: Icon(
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 70.sp,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "نسيت كلمة المرور؟",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "أدخل بريدك الألكتروني المرتبط بحسابك وسنرسل لك رمزاً لإعادة تعيين كلمة المرور",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  defaultTextFormfeild(
                    text: 'البريد الألكتروني',
                    prefixIcon: 'assets/phone.svg',
                    errorMes: 'البريد الألكتروني يجب ان لا يكون فارغ',
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    cubit: MyCubit.get(context),
                  ),
                  SizedBox(height: 24.h),
                  defualtButton(
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          showSnackBar(
                              Colors.green, 'تفقد بريدك الألكتروني', context);
                        } else {
                          showSnackBar(Colors.red, 'يرجى تعبية الحقل', context);
                        }
                      },
                      text: 'إرسال',
                      height: 50.h),
                  SizedBox(height: 30.h),
                  TextButton(
                    onPressed: () => move(context, const LoginScreen()),
                    child: Text(
                      "العودة لتسجيل الدخول",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        decoration: TextDecoration.underline,
                        decorationColor: mainColor,
                      ),
                    ),
                  ),
                  Text(
                    "_____ أو _____",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "إتصل بالدعم الفني",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 65, 65, 65),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
