import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/modules/user_screens/verified_phone.dart';
import '../../shared/compenents/components.dart';
import '../../main.dart';

class UserSIgnUp extends StatefulWidget {
  const UserSIgnUp({super.key});

  @override
  State<UserSIgnUp> createState() => _UserSIgnUpState();
}

class _UserSIgnUpState extends State<UserSIgnUp> {
  var userPhoneController = TextEditingController();
  var userNameController = TextEditingController();
  var userPasswordController = TextEditingController();
  var cityController = TextEditingController();
  bool isPassword = true;
  var formKey_userSignUp=  GlobalKey<FormState>();
  String suffixIcon = 'assets/eye.svg';
  List<String> imgList = [
    'assets/elec.jpg',
    'assets/plm.jpg',
    'assets/wood.jpg',
    'assets/ac.jpg',
  ];
  bool cubit = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 20.w,start: 20.w,top: 20.h),
              child: Column(
                children: [
                  Text(
                    'مرحبا بك معنا!',
                    style: TextStyle(
                      fontSize: 30.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'انضم الان معنا',
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Form(
                    key: formKey_userSignUp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        defaultTextFormfeild(
                          cubit: cubit,
                          text: 'الاسم الكامل',
                          prefixIcon: 'assets/acc.svg',
                          errorMes: 'الاسم الأول يجب ان لا يكون فارغ',
                          controller: userNameController,
                          type: TextInputType.text,
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        defaultTextFormfeild(
                          cubit: cubit,
                          text: 'رقم الهاتف',
                          prefixIcon: 'assets/phone.svg',
                          errorMes: 'رقم الهاتق يجب ان لا يكون فارغ',
                          controller: userPhoneController,
                          type: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        defaultTextFormfeild(
                            cubit: cubit,
                            text: 'كلمة المرور',
                            prefixIcon: 'assets/lock.svg',
                            errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
                            controller: userPasswordController,
                            type: TextInputType.visiblePassword,
                            isPassword: isPassword,
                            isSuffixIcon: true,
                            suffixIcon: suffixIcon,
                            suffixPressed: (){
                              isPassword =!isPassword;
                              setState(() {
                                suffixIcon = isPassword? 'assets/eye.svg' : 'assets/eye-slash.svg';                          });
                            }
                        ),
                        SizedBox(
                          height: 20.0.h,
                        ),
                        defualtButton(
                          onPressed: (){
                            // if(formKey_signup.currentState!.validate()){
                            move(context, const Verified_phone());
                            //}
                          },
                          text: 'تسجيل',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لدي حساب بالفعل',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]
                              ),
                            ),
                            defaultTextButton(onPressed: ()=>moveAndReplace(context, const LoginScreen()), text:'سجل دخول'),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
