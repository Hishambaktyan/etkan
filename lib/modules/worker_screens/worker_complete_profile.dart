import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/worker_screens/worker_account_verification.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_States.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:Etkan/shared/styles/colors.dart';

class WorkerCompleteProfile extends StatefulWidget {
  const WorkerCompleteProfile({super.key});

  @override
  State<WorkerCompleteProfile> createState() => _WorkerCompleteProfileState();
}

class _WorkerCompleteProfileState extends State<WorkerCompleteProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  List<String> experiences = [];
  List<String> previousWorks = [];
  File? profileImageFile;
  List<Map<String, dynamic>> categories = [];
  String? categoriesError;
  bool isCategoriesLoaded = false;
  bool isLoadingDialogShown = false;

  Future<void> getCategories() async {
    try {
      if (!mounted) return;

      isLoadingDialogShown = true;
      showLoadingDialog(context);

      final snapshot = await FirebaseFirestore.instance.collection('categories').get();

      final List<Map<String, dynamic>> loadedCategories = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).where((category) {
        final String title = '${category['title'] ?? ''}'.trim();
        final bool isActive = category['isActive'] != false;
        return title.isNotEmpty && isActive;
      }).toList();

      loadedCategories.sort((a, b) {
        final String first = '${a['title'] ?? ''}'.trim();
        final String second = '${b['title'] ?? ''}'.trim();
        return first.compareTo(second);
      });

      if (!mounted) return;

      setState(() {
        categories = loadedCategories;
        categoriesError = null;
        isCategoriesLoaded = true;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        categoriesError = error.toString();
        isCategoriesLoaded = true;
      });

      showSnackBar(Colors.red, 'تعذر تحميل الأقسام، حاول مرة أخرى', context);
    } finally {
      if (mounted && isLoadingDialogShown) {
        hideLoadingDialog(context);
        isLoadingDialogShown = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategories();
    });
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
      maxHeight: 1200,
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
      maxWidth: 1200,
      maxHeight: 1200,
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
            color: Theme.of(context).textTheme.bodyLarge!.color,
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      validator: validator,
      style: TextStyle(
        color: cubit.isDark ? Colors.white : Colors.black,
        fontSize: 12.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: cubit.isDark ? darkSubTextColor : Colors.grey,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: mainColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(fontSize: 10.sp),
      ),
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
                  'أكمل ملفك المهني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'هذه البيانات تساعد العملاء على معرفة تخصصك وخبرتك قبل حجز الخدمة.',
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
                    color: profileImageFile == null
                        ? mainColor.withOpacity(0.20)
                        : Colors.green.withOpacity(0.60),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 52.r,
                  backgroundColor:
                      cubit.isDark ? darkBgColor : Colors.grey.shade200,
                  backgroundImage: profileImageFile != null
                      ? FileImage(profileImageFile!)
                      : null,
                  child: profileImageFile == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 42.sp,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              InkWell(
                onTap: pickProfileImage,
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
          profileImageFile == null
              ? 'اضغط على الكاميرا لإضافة صورة شخصية'
              : 'تم اختيار الصورة الشخصية',
          style: TextStyle(
            color: profileImageFile == null
                ? (cubit.isDark ? darkSubTextColor : Colors.grey)
                : Colors.green,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryImage(Map<String, dynamic> category) {
    final String image = '${category['image'] ?? ''}'.trim();

    if (image.isEmpty) {
      return Icon(
        Icons.category_rounded,
        color: mainColor,
        size: 22.r,
      );
    }

    return SvgPicture.network(
      image,
      width: 22.w,
      height: 22.h,
      placeholderBuilder: (context) => SizedBox(
        width: 18.w,
        height: 18.h,
        child: const CircularProgressIndicator(
          color: mainColor,
          strokeWidth: 2,
        ),
      ),
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.category_rounded,
        color: mainColor,
        size: 22.r,
      ),
    );
  }

  Widget _buildCategoryDropdown(AppCubit cubit, AuthCubit authCubit) {
    if (!isCategoriesLoaded) {
      return const SizedBox.shrink();
    }

    if (categoriesError != null) {
      return _buildCategoryMessageCard(
        cubit: cubit,
        icon: Icons.error_outline_rounded,
        title: 'تعذر تحميل الأقسام، حاول مرة أخرى',
        color: Colors.red,
      );
    }

    if (categories.isEmpty) {
      return _buildCategoryMessageCard(
        cubit: cubit,
        icon: Icons.info_outline_rounded,
        title: 'لا توجد أقسام مفعلة حاليًا',
        color: Colors.orange,
      );
    }

    final Map<String, dynamic>? currentValue =
    authCubit.selectedCategory == null
        ? null
        : categories.firstWhere(
          (category) =>
      category['id'] == authCubit.selectedCategory!['id'],
      orElse: () => {},
    );

    final value = currentValue != null && currentValue.isNotEmpty
        ? currentValue
        : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<Map<String, dynamic>>(
        dropdownColor: cubit.isDark ? lightDarkColor : Colors.white,
        isExpanded: true,
        value: value,
        style: TextStyle(
            fontSize: 13.sp,
            color: cubit.isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'tajawal'),
        hint: Text(
          'اختر القسم من الأقسام المتاحة',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            color: cubit.isDark ? darkSubTextColor : Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
        borderRadius: BorderRadius.circular(20.r),
        alignment: AlignmentDirectional.centerStart,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: cubit.isDark ? darkSubTextColor : Colors.grey.shade600,
          size: 22.sp,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: cubit.isDark ? darkBgColor : Colors.grey.withOpacity(0.1),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.all(12.r),
            child: SvgPicture.asset(
              'assets/grid.svg',
              width: 15.w,
              height: 15.h,
              color: cubit.isDark ? darkSubTextColor : mainColor,
            ),
          ),
          contentPadding: EdgeInsetsDirectional.symmetric(
            vertical: 14.h,
            horizontal: 10.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color:
                  cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade100,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color:
                  cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade100,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: mainColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(fontSize: 10.sp),
        ),
        selectedItemBuilder: (context) {
          return categories.map((category) {
            final String title = '${category['title'] ?? ''}'.trim();

            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30.r,
                    height: 30.r,
                    padding: EdgeInsetsDirectional.all(6.r),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: _buildCategoryImage(category),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: cubit.isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        items: categories.map((category) {
          final String title = '${category['title'] ?? ''}'.trim();

          return DropdownMenuItem<Map<String, dynamic>>(
            value: category,
            alignment: AlignmentDirectional.centerStart,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 34.r,
                      height: 34.r,
                      padding: EdgeInsetsDirectional.all(7.r),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: _buildCategoryImage(category),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: cubit.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            authCubit.selectedCategory = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'يرجى اختيار القسم';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryMessageCard({
    required AppCubit cubit,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22.r),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: cubit.isDark ? Colors.white : color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(AppCubit cubit, int index) {
    final String experience = experiences[index];

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 10.h),
      child: Container(
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: cubit.isDark
              ? const Color(0xFF0D1117)
              : mainColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
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
                  fontSize: 13.sp,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
            IconButton(
              onPressed: () => setState(() => experiences.removeAt(index)),
              icon: SvgPicture.asset(
                'assets/delete.svg',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousWorks(AppCubit cubit) {
    return SizedBox(
      height: 125.h,
      child: previousWorks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_rounded,
                  color: Colors.grey.shade400,
                  size: 50.w,
                ),
                SizedBox(height: 5.h),
                Text(
                  'لا توجد أعمال مضافة حتى الآن',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: previousWorks.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => Stack(
                children: [
                  Container(
                    width: 125.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: mainColor.withOpacity(0.1),
                      image: DecorationImage(
                        image: FileImage(File(previousWorks[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: InkWell(
                      onTap: () =>
                          setState(() => previousWorks.removeAt(index)),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
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
    );
  }

  void _completeProfile(AuthCubit authCubit) {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (profileImageFile == null) {
      showSnackBar(Colors.red, 'يرجى إضافة صورة شخصية واضحة', context);
      return;
    }

    final selectedCategory = authCubit.selectedCategory;

    if (selectedCategory == null) {
      showSnackBar(Colors.red, 'يرجى اختيار القسم', context);
      return;
    }

    authCubit.setPendingWorkerProfile(
      about: aboutController.text.trim(),
      address: addressController.text.trim(),
      experiences: experiences,
      profileImage: profileImageFile!.path,
      specialization: selectedCategory['title']?.toString() ?? '',
      categoryId: selectedCategory['id']?.toString() ?? '',
      category: selectedCategory['title']?.toString() ?? '',
      previousWorks: previousWorks,
    );

    moveAndReplace(context, const WorkerAccountVerification(isFromOnboarding: true),);
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
            if (state is CompleteWorkerProfileLoadingState) {
              showLoadingDialog(context);
            } else if (state is CompleteWorkerProfileSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.green, 'تم إكمال إعداد حسابك بنجاح', context);
              moveAndReplace(
                context,
                const WorkerAccountVerification(isFromOnboarding: true),
              );
            } else if (state is CompleteWorkerProfileErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error.toString(), context);
            }
          },
          builder: (context, state) {
            AuthCubit authCubit = AuthCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                title: Text(
                  'إكمال الملف الشخصي',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(bottom: 95.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.all(10.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntroCard(appCubit),
                            SizedBox(height: 20.h),
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
                                  _buildProfileImagePicker(appCubit),
                                  SizedBox(height: 25.h),
                                  _buildCategoryDropdown(appCubit, authCubit),
                                  SizedBox(height: 15.h),
                                  defaultTextFormField(
                                    text: 'العنوان',
                                    prefixIcon: 'assets/loc.svg',
                                    errorMes: 'يرجى إدخال العنوان',
                                    controller: addressController,
                                    type: TextInputType.text,
                                    cubit: appCubit,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'يرجى إدخال العنوان';
                                      }
                                      return null;
                                    },
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
                                hint:
                                    'اكتب نبذة مختصرة عن خبرتك ومهاراتك وطريقة عملك',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى كتابة نبذة مختصرة عنك';
                                  }
                                  if (value.trim().length < 20) {
                                    return 'اكتب نبذة أوضح لا تقل عن 20 حرفًا';
                                  }
                                  return null;
                                },
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
                                          validator: (value) => null,
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
                                  if (experiences.isEmpty)
                                    Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsetsDirectional.all(12.r),
                                      decoration: BoxDecoration(
                                        color: appCubit.isDark
                                            ? darkBgColor
                                            : Colors.grey.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                      ),
                                      child: Text(
                                        'يمكنك إضافة خبرات مثل: 5 سنوات في الصيانة المنزلية، تركيب وتمديد كهرباء، إصلاح أعطال السباكة.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          height: 1.6,
                                          color: appCubit.isDark
                                              ? darkSubTextColor
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    )
                                  else
                                    ListView.builder(
                                      itemCount: experiences.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return _buildExperienceItem(
                                          appCubit,
                                          index,
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
                                    text: 'إضافة صورة من أعمالك',
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: mainColor,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  _buildPreviousWorks(appCubit),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  onPressed: () {
                    // إغلاق الكيبورد قبل إرسال الطلب
                    FocusManager.instance.primaryFocus?.unfocus();
                    _completeProfile(authCubit);
                  },
                  text: 'إكمال الملف والمتابعة',
                  height: 50.h,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
