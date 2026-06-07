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
import 'package:trying_homy/shared/cubits/user_cubit/user_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class UserEditProfile extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserEditProfile({
    super.key,
    required this.user,
  });

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  final formKey = GlobalKey<FormState>();

  String profileImage = '';

  final TextEditingController nameController = TextEditingController();
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
      return 'يرجى إدخال الاسم الرباعي المكون من 4 أسماء فقط';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user['name'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, appState) {
        final AppCubit appCubit = AppCubit.get(context);
        final UserCubit userCubit = UserCubit.get(context);
        return BlocConsumer<UserCubit, UserStates>(
          listener: (context, state) {
            if (state is EditUserDataLoadingState) {
              showLoadingDialog(context);
            } else if (state is EditUserDataSuccessState) {
              hideLoadingDialog(context);

              userCubit.getAllUsers();

              Navigator.pop(context, true);

              showSnackBar(
                Colors.green,
                'تم تعديل حسابك بنجاح',
                context,
              );
            } else if (state is EditUserDataErrorState) {
              hideLoadingDialog(context);

              showSnackBar(
                Colors.red,
                state.error,
                context,
              );
            }
          },
          builder: (context, userState) {
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
                    'تعديل الحساب',
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
                              defaultTextFormField(
                                text: 'الاسم الرباعي',
                                prefixIcon: 'assets/acc.svg',
                                errorMes: 'الاسم الرباعي يجب أن لا يكون فارغًا',
                                controller: nameController,
                                type: TextInputType.name,
                                cubit: appCubit,
                                validator: validateQuadName,
                                onChanged: (value) => limitNameToFourWords(
                                  nameController,
                                  value,
                                ),
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
                            'يمكنك تعديل اسمك وصورة حسابك, تأكد من البيانات قبل الحفظ.',
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
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            FocusScope.of(context).unfocus();

                            UserCubit.get(context).editUserData(
                              name: nameController.text.trim(),
                              profileImagePath: profileImage,
                              oldProfileImage:
                                  widget.user['profileImage'] ?? '',
                            );
                          },
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
      },
    );
  }
}
