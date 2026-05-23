import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerEditProfileScreen extends StatefulWidget {
  final Map<String,dynamic> worker;
  const WorkerEditProfileScreen({super.key, required this.worker});

  @override
  State<WorkerEditProfileScreen> createState() => _WorkerEditProfileScreenState();
}

class _WorkerEditProfileScreenState extends State<WorkerEditProfileScreen> {
  String profileImage='';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  List<String> experiences = [];
  List<String> previousWorks = [];

  Future<void> pickPreviousWorksImage() async {
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
  Future<void> pickWorkerProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        profileImage=image.path;
      });
    }
  }

  @override
  void initState() {
    nameController.text = widget.worker['name'] ?? '';
    phoneController.text = widget.worker['phone'] ?? '';
    aboutController.text = widget.worker['about'] ?? '';
    experiences = List<String>.from(widget.worker['experiences'] ?? []);
    previousWorks = List<String>.from(widget.worker['previousWorks'] ?? []);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    experienceController.dispose();
    super.dispose();
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
        color: cubit.isDark ? lightDarkColor :  Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow
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
        filled: true,
        fillColor:
        cubit.isDark ? darkBgColor : Colors.grey.withOpacity(0.1),
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
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        WorkerCubit workerCubit = WorkerCubit.get(context);
        return BlocConsumer<WorkerCubit,WorkerStates>(
          listener: (context, state) {
            if(state is EditWorkerDataLoadingState){
              showLoadingDialog(context);
            }
            else if(state is EditWorkerDataSuccessState){
              hideLoadingDialog(context);
              workerCubit.getAllUsers();
              appCubit.changeIndex(0);
              Navigator.pop(context);
              Navigator.pop(context);
              showSnackBar(Colors.green, 'تم تعديل حسابك بنجاح', context);
            }
            else if(state is EditWorkerDataErrorState){
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
              print(state.error);
            }
          },
            builder: (context, state) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(CupertinoIcons.back,color: Theme.of(context).iconTheme.color,),
                    ),
                    title: Text(
                      'تعديل الملف الشخصي',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: 18.sp, fontWeight: FontWeight.bold
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.all(10.r),
                    child: Column(
                      children: [
                        buildSectionHeader(
                          title: 'المعلومات الشخصية',
                          icon: SvgPicture.asset(
                              'assets/contact.svg',
                              color: mainColor, width: 22.w
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
                                          boxShadow: blueShadow
                                      ),
                                      child: CircleAvatar(
                                        radius: 48.r,
                                        backgroundImage: profileImage.isEmpty?NetworkImage('${widget.worker['profileImage'] ?? ''}') as ImageProvider
                                            :FileImage(File(profileImage)) as ImageProvider,
                                        child: widget.worker['profileImage']==null? const Icon(Icons.person_rounded):null,
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () => pickWorkerProfileImage(),
                                      child: CircleAvatar(
                                          radius: 16.r,
                                          backgroundColor: mainColor,
                                          child: SvgPicture.asset('assets/camera.svg',color: Colors.white,width: 18.w,)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.h),
                              defaultTextFormField(
                                  text: 'الأسم',
                                  prefixIcon: 'assets/acc.svg',
                                  errorMes: '',
                                  controller: nameController,
                                  type: TextInputType.text,
                                  cubit: appCubit),
                              SizedBox(height: 15.h),
                              defaultTextFormField(
                                  text: 'رقم الهاتف',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: '',
                                  controller: phoneController,
                                  type: TextInputType.phone,
                                  cubit: appCubit),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'نبذة عنك',
                          icon: SvgPicture.asset(
                              'assets/info.svg',
                              color: mainColor, width: 22.w
                          ),
                          cubit: appCubit,
                        ),
                        SizedBox(height: 10.h),
                        buildWhiteCard(
                          cubit: appCubit,
                          child: buildInputField(
                              controller: aboutController,
                              cubit: appCubit,
                              maxLines: 6
                          ),
                        ),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'الخبرات',
                          icon: SvgPicture.asset(
                              'assets/subs.svg',
                              color: mainColor, width: 22.w
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
                                          text: 'الخبرات',
                                          prefixIcon: 'assets/subs.svg',
                                          errorMes: '',
                                          controller: experienceController,
                                          type: TextInputType.text,
                                          cubit: appCubit
                                      )
                                  ),
                                  SizedBox(width: 10.w),
                                  IconButton(
                                    onPressed: () {
                                      if (experienceController.text.isNotEmpty) {
                                        setState(() {
                                          experiences.add(experienceController.text);
                                          experienceController.clear();
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.add_box_rounded,
                                        color: mainColor, size: 35.r),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              ListView.builder(
                                itemCount: experiences.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final experience = experiences[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(bottom: 10.h),
                                    child: Container(
                                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: appCubit.isDark ? const Color(0xFF0D1117) : mainColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/all.svg',color: mainColor,),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                              child: Text(
                                                  experience,
                                                  style: TextStyle(
                                                      color:Theme.of(context).textTheme.bodyLarge!.color ,
                                                      fontSize: 13.sp
                                                  )
                                              )
                                          ),
                                          IconButton(
                                              onPressed: () => setState(() => experiences.remove(experience)),
                                              icon: SvgPicture.asset('assets/delete.svg',color: Colors.red,)
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
                          icon: SvgPicture.asset('assets/image.svg',
                              color: mainColor, width: 22.w),
                          cubit: appCubit,
                        ),
                        SizedBox(height: 10.h),
                        buildWhiteCard(
                          cubit: appCubit,
                          child: Column(
                            children: [
                              defaultOutlinedButtonWithIcon(
                                  onPressed: ()=>pickPreviousWorksImage(),
                                  text: 'إضافة عمل جديد',
                                  icon: const Icon(Icons.add_rounded,color: mainColor,)
                              ),
                              SizedBox(height: 15.h,),
                              SizedBox(
                                height: 120.h,
                                child: previousWorks.isEmpty? Column(
                                  children: [
                                    Icon(Icons.inbox_rounded,color: Colors.grey.shade400,size: 60.w,),
                                    SizedBox(height: 5.h,),
                                    Text(
                                      'لا توجد أعمال سابقة لك',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                          color: Colors.grey.shade400
                                      ),
                                    ),
                                  ],
                                ):ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: previousWorks.length,
                                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                                  itemBuilder: (context, index) => Stack(
                                    children: [
                                      Container(
                                        width: 120.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.r),
                                          color: mainColor.withOpacity(0.1),
                                          image: DecorationImage(
                                            image: previousWorks[index].startsWith('http')
                                                ? NetworkImage(previousWorks[index]) as ImageProvider
                                                : FileImage(File(previousWorks[index])) as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        left: 5,
                                        child: InkWell(
                                          onTap: () => setState(() => previousWorks.removeAt(index)),
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(Icons.close,
                                                size: 15, color: Colors.white),
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
                          onPressed: ()async{
                            await workerCubit.editWorkerData(
                                name: nameController.text.trim(),
                                phone: phoneController.text.trim(),
                                about: aboutController.text.trim(),
                                profileImagePath: profileImage,
                                oldProfileImage: widget.worker['profileImage'] ?? '',
                                experiences: experiences,
                                previousWorks: previousWorks,
                            );
                          },
                          text: 'حفظ التعديلات',
                          height: 50.h,
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