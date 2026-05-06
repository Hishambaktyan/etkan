import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../shared/cubits/app_cubit/app_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController(text: 'عبد الرحمن محمد أحمد');
  final TextEditingController phoneController =
      TextEditingController(text: '770770858');
  final TextEditingController emailController =
      TextEditingController(text: 'hadi@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: '123123');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Text(
            'تعديل الحساب',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          width: 92.w,
                          height: 92.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  'https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: mainColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'عبد الرحمن محمد أحمد',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'سبأك - 770770858',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Column(
                    children: [
                      defaultTextFormfeild(
                        text: "الإسم الكامل",
                        prefixIcon: 'assets/acc.svg',
                        errorMes: 'الأسم يجب ان لا يكون فارغ',
                        controller: nameController,
                        type: TextInputType.name,
                        cubit: AppCubit.get(context),
                      ),
                      SizedBox(height: 24.h),
                      defaultTextFormfeild(
                        text: 'رقم الهاتف',
                        prefixIcon: 'assets/phone.svg',
                        errorMes: 'رقم الهاتف يجب ان لا تكون فارغ',
                        controller: phoneController,
                        type: TextInputType.number,
                        cubit: AppCubit.get(context),
                      ),
                      SizedBox(height: 24.h),
                      defaultTextFormfeild(
                        text: 'البريد الألكتروني',
                        prefixIcon: 'assets/phone.svg',
                        errorMes: 'البريد الألكتروني يجب ان لا يكون فارغ',
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        cubit: AppCubit.get(context),
                      ),
                      SizedBox(height: 24.h),
                      defaultButton(
                          onPressed: () {
                            if (phoneController.text.isNotEmpty &&
                                emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty &&
                                nameController.text.isNotEmpty) {
                              showSnackBar(
                                  Colors.green, 'تم تعديل الحساب', context);
                            } else {
                              showSnackBar(
                                  Colors.red, 'يرجى تعبة كل الحقول', context);
                            }
                          },
                          text: 'تعديل الحساب',
                          height: 50.h),
                      SizedBox(height: 20.h),
                      Text(
                        'آخر تحديث منذ ساعة',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
