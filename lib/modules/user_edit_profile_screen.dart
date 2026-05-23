import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class UserEditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserEditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  String profileImage = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.user['name'] ?? '';
    phoneController.text = widget.user['phone'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pickUserProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        profileImage = image.path;
      });
    }
  }

  ImageProvider? getProfileImage() {
    if (profileImage.isNotEmpty) {
      return FileImage(File(profileImage));
    }

    final String oldImage = widget.user['profileImage'] ?? '';

    if (oldImage.isNotEmpty) {
      return NetworkImage(oldImage);
    }

    return null;
  }

  Widget buildWhiteCard({
    required Widget child,
    required AppCubit cubit,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: child,
    );
  }

  Widget buildSectionHeader({
    required String title,
    required Widget icon,
    required AppCubit cubit,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.20)
                : mainColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: icon,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required AppCubit cubit,
    required String hint,
    required String icon,
    required String error,
    TextInputType type = TextInputType.text,
  }) {
    return defaultTextFormField(
      text: hint,
      prefixIcon: icon,
      errorMes: error,
      controller: controller,
      type: type,
      cubit: cubit,
    );
  }

  void saveUserData() {
    if (!formKey.currentState!.validate()) return;

    /*
      هنا اربط دالة تعديل بيانات العميل.

      مثال إذا عملت دالة داخل AppCubit:

      AppCubit.get(context).editUserData(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        profileImagePath: profileImage,
        oldProfileImage: widget.user['profileImage'] ?? '',
      );
    */

    showSnackBar(
      Colors.green,
      'واجهة التعديل جاهزة، اربط دالة الحفظ فقط',
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              title: Text(
                'تعديل حساب',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(10.r),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildSectionHeader(
                      title: 'المعلومات الشخصية',
                      icon: SvgPicture.asset(
                        'assets/contact.svg',
                        color: mainColor,
                        width: 22.w,
                      ),
                      cubit: appCubit,
                    ),
                    SizedBox(height: 10.h),
                    buildWhiteCard(
                      cubit: appCubit,
                      child: Column(
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100.r,
                                  height: 100.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: blueShadow,
                                  ),
                                  child: CircleAvatar(
                                    radius: 48.r,
                                    backgroundColor: appCubit.isDark
                                        ? darkBgColor
                                        : Colors.grey.shade100,
                                    backgroundImage: getProfileImage(),
                                    child: getProfileImage() == null
                                        ? Icon(
                                            Icons.person_rounded,
                                            color: Colors.grey,
                                            size: 45.r,
                                          )
                                        : null,
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: pickUserProfileImage,
                                  child: CircleAvatar(
                                    radius: 16.r,
                                    backgroundColor: mainColor,
                                    child: SvgPicture.asset(
                                      'assets/camera.svg',
                                      color: Colors.white,
                                      width: 18.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.h),
                          buildInputField(
                            hint: 'الاسم الكامل',
                            icon: 'assets/acc.svg',
                            error: 'الاسم يجب أن لا يكون فارغًا',
                            controller: nameController,
                            type: TextInputType.text,
                            cubit: appCubit,
                          ),
                          SizedBox(height: 15.h),
                          buildInputField(
                            hint: 'رقم الهاتف',
                            icon: 'assets/phone.svg',
                            error: 'رقم الهاتف يجب أن لا يكون فارغًا',
                            controller: phoneController,
                            type: TextInputType.phone,
                            cubit: appCubit,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    buildSectionHeader(
                      title: 'ملاحظة',
                      icon: SvgPicture.asset(
                        'assets/info.svg',
                        color: mainColor,
                        width: 22.w,
                      ),
                      cubit: appCubit,
                    ),
                    SizedBox(height: 10.h),
                    buildWhiteCard(
                      cubit: appCubit,
                      child: Text(
                        'يمكنك تعديل اسمك ورقم هاتفك وصورة حسابك. تأكد من صحة البيانات قبل الحفظ.',
                        style: TextStyle(
                          color: appCubit.isDark
                              ? darkSubTextColor
                              : Colors.grey.shade700,
                          fontSize: 13.sp,
                          height: 1.7,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    defaultButton(
                      onPressed: saveUserData,
                      text: 'حفظ التعديلات',
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
