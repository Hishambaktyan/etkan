import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../shared/cubits/admin_cubit/admin_cubit.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController titleController = TextEditingController();
  bool isActive = true;
  File? catImage;

  Future<void> pickCategorymage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if(image!=null){
      setState(() {
        catImage=File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AdminCubit adminCubit = AdminCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {
          if(state is AddCategoryLoadingState){
            showLoadingDialog(context);
          }
          if (state is AddCategorySuccessState) {
            showSnackBar(Colors.green, 'تم الإضافة بنجاح', context);
            hideLoadingDialog(context);
            Navigator.pop(context);
            adminCubit.getCategories();
          }
          if (state is AddCategoryErrorState) {
            print(state.error);
            hideLoadingDialog(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  header(title: 'إضافة قسم', context: context,isLeading: true,isNotif: false,),
                  Padding(
                    padding: EdgeInsetsDirectional.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow:  blueShadow,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  Container(
                                    width: 110.r,
                                    height: 110.r,
                                    decoration: BoxDecoration(
                                      color: mainColor.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: mainColor.withOpacity(0.2), width: 2),
                                    ),
                                    child: catImage==null
                                        ? Padding(
                                      padding: EdgeInsetsDirectional.all(25.r),
                                      child: SvgPicture.asset(
                                        'assets/SVGs/E.svg',
                                        color: mainColor.withOpacity(0.5),
                                      ),
                                    ) : Padding(
                                      padding:  EdgeInsetsDirectional.all(20.w),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(55.r),
                                        child: SvgPicture.file(
                                          catImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => pickCategorymage(),
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
                              SizedBox(height: 25.h),
                              defaultTextFormField(
                                text: 'اسم القسم (مثلاً: سباكة، كهرباء)',
                                prefixIcon: 'assets/grid.svg',
                                errorMes: 'يرجى تعبئة الحقل',
                                controller: titleController,
                                type: TextInputType.text,
                                cubit: AppCubit.get(context),
                              ),
                              SizedBox(height: 15.h),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: blueShadow,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.r),
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/work.svg',
                                        width: 18.w,
                                        color: mainColor,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        'حالة القسم (مفعل / معطل)',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Switch.adaptive(
                                      value: isActive,
                                      activeColor: mainColor,
                                      activeTrackColor: mainColor.withOpacity(0.3),
                                      onChanged: (value) {
                                        setState(() {
                                          isActive = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        defaultButton(
                          onPressed: () async {
                            if (titleController.text.isEmpty || catImage==null) {
                              showSnackBar(Colors.red, 'يرجى إكمال البيانات واختيار صورة', context);
                            } else {
                              await adminCubit.createCategory(
                                title: titleController.text,
                                imageFile: catImage!,
                                isActive: isActive,
                              );
                            }
                          },
                          text: 'إضافة القسم',
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


