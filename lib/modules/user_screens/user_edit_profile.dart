import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/user_cubit/user_cubit.dart';
import 'package:Etkan/shared/cubits/user_cubit/user_states.dart';
import 'package:Etkan/shared/styles/colors.dart';

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      return 'الاسم الرباعي يجب أن لا يكون فارغًا';
    }

    if (nameParts.length != 4) {
      return 'يرجى إدخال الاسم الرباعي المكون من 4 أسماء فقط';
    }

    return null;
  }

  @override
  void initState() {
    nameController.text = widget.user['name']?.toString() ?? '';
    super.initState();
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
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (image != null) {
      setState(() {
        profileImage = image.path;
      });
    }
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

  Widget _buildIntroCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(11.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.manage_accounts_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعديل حسابك',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'حدّث اسمك وصورتك الشخصية حتى تظهر بياناتك بشكل أوضح داخل التطبيق.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 12.sp,
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

  Widget _buildProfileImagePicker(AppCubit cubit) {
    final String oldProfileImage =
        widget.user['profileImage']?.toString() ?? '';
    final bool hasOldImage = oldProfileImage.trim().isNotEmpty;
    final bool hasNewImage = profileImage.trim().isNotEmpty;

    ImageProvider? imageProvider;

    if (hasNewImage) {
      imageProvider = FileImage(File(profileImage));
    } else if (hasOldImage) {
      imageProvider = NetworkImage(oldProfileImage);
    }

    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 112.r,
                height: 112.r,
                padding: EdgeInsetsDirectional.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cubit.isDark ? darkBgColor : Colors.white,
                  boxShadow: blueShadow,
                  border: Border.all(
                    color: imageProvider == null
                        ? mainColor.withOpacity(0.20)
                        : Colors.green.withOpacity(0.60),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 52.r,
                  backgroundColor:
                      cubit.isDark ? darkBgColor : Colors.grey.shade200,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 42.sp,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              InkWell(
                onTap: pickUserProfileImage,
                borderRadius: BorderRadius.circular(20.r),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 18.r,
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
        SizedBox(height: 10.h),
        Text(
          imageProvider == null
              ? 'اضغط على الكاميرا لإضافة صورة شخصية'
              : hasNewImage
                  ? 'تم اختيار صورة شخصية جديدة'
                  : 'الصورة الشخصية الحالية',
          style: TextStyle(
            color: imageProvider == null
                ? (cubit.isDark ? darkSubTextColor : Colors.grey)
                : Colors.green,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.orange.shade800,
            size: 22.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'يمكنك تعديل اسمك وصورة حسابك. تأكد من كتابة الاسم الرباعي بشكل صحيح قبل الحفظ.',
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveUserData(UserCubit userCubit) {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    userCubit.editUserData(
      name: nameController.text.trim(),
      profileImagePath: profileImage,
      oldProfileImage: widget.user['profileImage']?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        UserCubit userCubit = UserCubit.get(context);

        return BlocConsumer<UserCubit, UserStates>(
          listener: (context, state) {
            if (state is EditUserDataLoadingState) {
              showLoadingDialog(context);
            } else if (state is EditUserDataSuccessState) {
              hideLoadingDialog(context);
              userCubit.getAllUsers(forceRefresh: true);
              Navigator.pop(context, true);
              showSnackBar(Colors.green, 'تم تعديل حسابك بنجاح', context);
            } else if (state is EditUserDataErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, userState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: appCubit.isDark ? darkBgColor : bgColor,
                appBar: AppBar(
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
                        'تعديل الملف الشخصي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.only(bottom: 95.h),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(10.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIntroCard(appCubit),
                          SizedBox(height: 20.h),
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
                                _buildProfileImagePicker(appCubit),
                                SizedBox(height: 25.h),
                                defaultTextFormField(
                                  text: 'الاسم الرباعي',
                                  prefixIcon: 'assets/acc.svg',
                                  errorMes:
                                      'الاسم الرباعي يجب أن لا يكون فارغًا',
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
                          _buildNoteCard(appCubit),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsetsDirectional.only(
                    start: 20.w,
                    end: 20.w,
                    top: 10.h,
                    bottom: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: appCubit.isDark ? darkBgColor : Colors.white,
                    boxShadow: blueShadow,
                  ),
                  child: defaultButton(
                    onPressed: () => _saveUserData(userCubit),
                    text: 'حفظ التعديلات',
                    height: 50.h,
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
