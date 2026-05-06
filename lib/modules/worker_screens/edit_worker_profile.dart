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

class EditWorkerProfileScreen extends StatefulWidget {
  const EditWorkerProfileScreen({super.key});

  @override
  State<EditWorkerProfileScreen> createState() => _EditWorkerProfileScreenState();
}

class _EditWorkerProfileScreenState extends State<EditWorkerProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  List<String> experiences = [
    'خبرة أكثر من 5 سنوات في الصيانة الكهربائية',
    'تركيب وصيانة لوحات الكهرباء',
    'إصلاح التماس والأعطال المنزلية',
    'تمديدات كهربائية للمنازل والمكاتب',
  ];

  List<String> previousWorks = [];

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

  @override
  void initState() {
    nameController.text = 'هادي محمد';
    phoneController.text = '778830326';
    aboutController.text =
    'فني محترف في أعمال الكهرباء والصيانة المنزلية، أمتلك خبرة واسعة في تركيب الإنارة، إصلاح الأعطال، وتمديدات الكهرباء للمنازل والمحلات، وأهتم بجودة العمل والالتزام بالمواعيد.';
    super.initState();
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
        AppCubit cubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(CupertinoIcons.back),
              ),
              title: Text(
                'تعديل الملف الشخصي',
                style: TextStyle(
                    fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                    cubit: cubit,
                  ),
                  SizedBox(height: 10.h),
                  buildWhiteCard(
                    cubit: cubit,
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
                                  backgroundImage: const NetworkImage(
                                      'https://d26e3f10zvrezp.cloudfront.net/Gallery/d72c67af-9f10-4d9d-b3db-fdc1647e6acc-1024x1024.webp'),
                                ),
                              ),
                              CircleAvatar(
                                radius: 16.r,
                                backgroundColor: mainColor,
                                child: SvgPicture.asset('assets/camera.svg',color: Colors.white,width: 18.w,)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        defaultTextFormfeild(
                            text: 'الأسم',
                            prefixIcon: 'assets/acc.svg',
                            errorMes: '',
                            controller: nameController,
                            type: TextInputType.text,
                            cubit: cubit),
                        SizedBox(height: 15.h),
                        defaultTextFormfeild(
                            text: 'رقم الهاتف',
                            prefixIcon: 'assets/phone.svg',
                            errorMes: '',
                            controller: phoneController,
                            type: TextInputType.phone,
                            cubit: cubit),
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
                    cubit: cubit,
                  ),
                  SizedBox(height: 10.h),
                  buildWhiteCard(
                    cubit: cubit,
                    child: buildInputField(
                        controller: aboutController,
                        cubit: cubit,
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
                    cubit: cubit,
                  ),
                  SizedBox(height: 10.h),
                  buildWhiteCard(
                    cubit: cubit,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: defaultTextFormfeild(
                                    text: 'الخبرات',
                                    prefixIcon: 'assets/subs.svg',
                                    errorMes: '',
                                    controller: experienceController,
                                    type: TextInputType.text,
                                    cubit: cubit
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
                                    color: cubit.isDark ? const Color(0xFF0D1117) : mainColor.withOpacity(0.1),
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
                    cubit: cubit,
                  ),
                  SizedBox(height: 10.h),
                  buildWhiteCard(
                    cubit: cubit,
                    child: Column(
                      children: [
                        defaultOutlinedButtonWithIcon(
                            onPressed: ()=>pickWorkImage(),
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
                                      image: FileImage(
                                          File(previousWorks[index])
                                      ),
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
                    onPressed: () {},
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
  }
}