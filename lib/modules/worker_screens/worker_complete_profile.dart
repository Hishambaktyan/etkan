import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/layout/worker_layout/worker_main_screen.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerCompleteProfile extends StatefulWidget {
  const WorkerCompleteProfile({super.key});

  @override
  State<WorkerCompleteProfile> createState() => _WorkerCompleteProfileState();
}

class _WorkerCompleteProfileState extends State<WorkerCompleteProfile> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  List<String> experiences = [];
  List<String> previousWorks = [];
  File? profileImageFile;

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        profileImageFile = File(image.path);
      });
    }
  }

  Future<void> pickWorkImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        previousWorks.add(image.path);
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
            color: cubit.isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required AppCubit cubit,
    int maxLines = 1,
    TextInputType type = TextInputType.text,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      style: TextStyle(
        color: cubit.isDark ? Colors.white : Colors.black,
        fontSize: 12.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12.sp,
        ),
        filled: true,
        fillColor: cubit.isDark ? darkBgColor : Colors.grey.withOpacity(0.1),
        contentPadding: EdgeInsets.all(15.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: cubit.isDark
                ? const Color(0xFF30363D)
                : const Color(0xFFEAF4FF),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: cubit.isDark
                ? const Color(0xFF30363D)
                : const Color(0xFFEAF4FF),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    aboutController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            bool isCreatingAccount = false;
            if (state is CompleteWorkerProfileLoadingState) {
              showLoadingDialog(context);
            } else if (state is CompleteWorkerProfileSuccessState &&
                !isCreatingAccount) {
              isCreatingAccount = true;
              showSnackBar(Colors.green, 'تم إكمال إعداد حسابك بنجاح', context);
              hideLoadingDialog(context);
              moveAndReplace(context, const WorkerMainScreen());
            } else if (state is CompleteWorkerProfileErrorState) {
              showSnackBar(Colors.red, state.error.toString(), context);
              hideLoadingDialog(context);
            }
          },
          builder: (context, state) {
            AuthCubit authCubit = AuthCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      header(
                        title: 'إكمال الملف المهني',
                        context: context,
                        isNotif: false,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.all(10.r),
                        child: Column(
                          children: [
                            buildSectionHeader(
                              title: 'المعلومات الأساسية',
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
                                                : Colors.grey.shade200,
                                            backgroundImage: profileImageFile !=
                                                    null
                                                ? FileImage(profileImageFile!)
                                                : null,
                                            child: profileImageFile == null
                                                ? Icon(
                                                    Icons.person,
                                                    size: 40.sp,
                                                    color: Colors.grey,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: pickProfileImage,
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
                                  DropdownButtonFormField<String>(
                                    dropdownColor: appCubit.isDark
                                        ? darkBgColor
                                        : Colors.white,
                                    isExpanded: false,
                                    alignment: AlignmentDirectional.centerStart,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey.shade600,
                                      size: 20.sp,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: SvgPicture.asset(
                                            'assets/work.svg',
                                            width: 12.w,
                                            height: 12.h,
                                            color: appCubit.isDark
                                                ? darkSubTextColor
                                                : mainColor),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.symmetric(
                                              vertical: 14.h, horizontal: 10.w),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade100)),
                                      errorStyle: TextStyle(fontSize: 10.sp),
                                    ),
                                    hint: Text(
                                      'اختر القسم',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: appCubit.isDark
                                              ? darkSubTextColor
                                              : Colors.grey),
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    value: authCubit.selectedCategory,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'كهرباء',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('كهرباء',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'سباكة',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('سباكة',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'الماء',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('الماء',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'التكييف',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('التكييف',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'البناء',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('البناء',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'الحدادة',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('الحدادة',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'النجارة',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('النجارة',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'الدهان',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('الدهان',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                      DropdownMenuItem(
                                        value: 'أخرى',
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text('أخرى',
                                                style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : Colors.black))),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        authCubit.selectedCategory = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى اختيار القسم';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15.h),
                                  defaultTextFormField(
                                    text: 'العنوان',
                                    prefixIcon: 'assets/loc.svg',
                                    errorMes: '',
                                    controller: addressController,
                                    type: TextInputType.text,
                                    cubit: appCubit,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            buildSectionHeader(
                              title: 'نبذة عنك',
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
                              child: buildInputField(
                                controller: aboutController,
                                cubit: appCubit,
                                maxLines: 6,
                                hint: 'اكتب نبذة مختصرة عن خبرتك ومهاراتك',
                              ),
                            ),
                            SizedBox(height: 20.h),
                            buildSectionHeader(
                              title: 'الخبرات',
                              icon: SvgPicture.asset(
                                'assets/subs.svg',
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: defaultTextFormField(
                                          text: 'أضف خبرة',
                                          prefixIcon: 'assets/subs.svg',
                                          errorMes: '',
                                          controller: experienceController,
                                          type: TextInputType.text,
                                          cubit: appCubit,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      IconButton(
                                        onPressed: () {
                                          if (experienceController.text
                                              .trim()
                                              .isNotEmpty) {
                                            setState(() {
                                              experiences.add(
                                                experienceController.text
                                                    .trim(),
                                              );
                                              experienceController.clear();
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.add_box_rounded,
                                          color: mainColor,
                                          size: 35.r,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  ListView.builder(
                                    itemCount: experiences.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final experience = experiences[index];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            bottom: 10.h),
                                        child: Container(
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
                                            horizontal: 10.w,
                                            vertical: 8.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: appCubit.isDark
                                                ? const Color(0xFF0D1117)
                                                : mainColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/all.svg',
                                                color: mainColor,
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: Text(
                                                  experience,
                                                  style: TextStyle(
                                                      fontSize: 13.sp),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => setState(
                                                  () => experiences
                                                      .removeAt(index),
                                                ),
                                                icon: SvgPicture.asset(
                                                  'assets/delete.svg',
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            buildSectionHeader(
                              title: 'الأعمال السابقة',
                              icon: SvgPicture.asset(
                                'assets/image.svg',
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
                                  defaultOutlinedButtonWithIcon(
                                    onPressed: pickWorkImage,
                                    text: 'إضافة عمل جديد',
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: mainColor,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  SizedBox(
                                    height: 120.h,
                                    child: previousWorks.isEmpty
                                        ? Column(
                                            children: [
                                              Icon(
                                                Icons.inbox_rounded,
                                                color: Colors.grey.shade400,
                                                size: 60.w,
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                'لا توجد أعمال مضافة حتى الآن',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.sp,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          )
                                        : ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: previousWorks.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    SizedBox(width: 12.w),
                                            itemBuilder: (context, index) =>
                                                Stack(
                                              children: [
                                                Container(
                                                  width: 120.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                    color: mainColor
                                                        .withOpacity(0.1),
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        File(previousWorks[
                                                            index]),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 5,
                                                  left: 5,
                                                  child: InkWell(
                                                    onTap: () => setState(
                                                      () => previousWorks
                                                          .removeAt(index),
                                                    ),
                                                    child: const CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.h),
                            defaultButton(
                              onPressed: () => authCubit.completeWorkerProfile(
                                  about: aboutController.text.trim(),
                                  address: addressController.text.trim(),
                                  experiences: experiences,
                                  profileImage: profileImageFile!.path,
                                  specialization: authCubit.selectedCategory!,
                                  previousWorks: previousWorks),
                              text: 'إكمال التسجيل',
                              height: 50.h,
                            ),
                          ],
                        ),
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
