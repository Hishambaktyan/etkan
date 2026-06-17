import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Etkan/layout/user_layout/user_main_screen.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class UserAddProfileImage extends StatefulWidget {
  const UserAddProfileImage({super.key});

  @override
  State<UserAddProfileImage> createState() => _UserAddProfileImageState();
}

class _UserAddProfileImageState extends State<UserAddProfileImage> {
  String profileImage = '';

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
            child: SvgPicture.asset(
              'assets/camera.svg',
              color: Colors.white,
              width: 40.w,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أضف صورة شخصية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'الصورة الشخصية اختيارية، وسيتم إنشاء حسابك بعد حفظ الصورة أو تخطي هذه الخطوة.',
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
    final bool hasNewImage = profileImage.trim().isNotEmpty;
    final ImageProvider? imageProvider =
        hasNewImage ? FileImage(File(profileImage)) : null;

    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 122.r,
                height: 122.r,
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
                  radius: 56.r,
                  backgroundColor:
                      cubit.isDark ? darkBgColor : Colors.grey.shade200,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 48.sp,
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
                  radius: 19.r,
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
        SizedBox(height: 12.h),
        Text(
          hasNewImage
              ? 'تم اختيار الصورة الشخصية'
              : 'اضغط على الكاميرا لاختيار صورة من المعرض',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: hasNewImage
                ? Colors.green
                : (cubit.isDark ? darkSubTextColor : Colors.grey),
            fontSize: 12.sp,
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
              'يمكنك تخطي هذه الخطوة الآن وإضافة الصورة لاحقًا من صفحة تعديل الحساب.',
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

  void _createAccount(AuthCubit authCubit, {bool withImage = true}) {
    if (withImage && profileImage.trim().isEmpty) {
      showSnackBar(
        Colors.red,
        'يرجى اختيار صورة شخصية أو اضغط تخطي الآن',
        context,
      );
      return;
    }

    authCubit.userSignUp(
      profileImagePath: withImage ? profileImage : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, appState) {
        final AppCubit appCubit = AppCubit.get(context);

        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is UserSignUpLoadingState) {
              showLoadingDialog(context);
            } else if (state is UserSignUpSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.green, 'تم إنشاء الحساب بنجاح', context);
              moveAndReplace(context, const UserMainScreen());
            } else if (state is UserSignUpErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, userState) {
            final AuthCubit authCubit = AuthCubit.get(context);

            return PopScope(
              canPop: false,
              child: Scaffold(
                appBar: AppBar(
                  titleSpacing: 10,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      SizedBox(width: 10.w),
                      Text(
                        'الصورة الشخصية',
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
                  padding: EdgeInsetsDirectional.only(
                    start: 10.w,
                    end: 10.w,
                    top: 10.h,
                    bottom: 120.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroCard(appCubit),
                      SizedBox(height: 20.h),
                      buildSectionHeader(
                        title: 'اختيار الصورة',
                        icon: SvgPicture.asset(
                          'assets/camera.svg',
                          color: mainColor,
                          width: 22.w,
                        ),
                        cubit: appCubit,
                      ),
                      SizedBox(height: 10.h),
                      buildWhiteCard(
                        cubit: appCubit,
                        child: _buildProfileImagePicker(appCubit),
                      ),
                      SizedBox(height: 18.h),
                      _buildNoteCard(appCubit),
                    ],
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultButton(
                        onPressed: () => _createAccount(authCubit),
                        text: 'حفظ الصورة وإنشاء الحساب',
                        height: 50.h,
                      ),
                      SizedBox(height: 10.h),
                      defaultOutlinedButton(
                        onPressed: () => _createAccount(
                          authCubit,
                          withImage: false,
                        ),
                        text: 'تخطي الآن وإنشاء الحساب',
                        textColor: mainColor,
                        border: mainColor,
                        bgColor:
                            appCubit.isDark ? lightDarkColor : Colors.white,
                        fontSize: 14,
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
