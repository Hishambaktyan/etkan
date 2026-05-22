import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class ManageDept extends StatefulWidget {
  final Map<String,dynamic> category;
  const ManageDept({super.key, required this.category});

  @override
  State<ManageDept> createState() => _ManageDeptState();
}

class _ManageDeptState extends State<ManageDept> {
  TextEditingController titleController = TextEditingController();
  bool isActive = true;
  String? catImage;

  Future<void> pickCategoryImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        catImage = image.path;
      });
    }
  }

  void showTheDialog({
    required BuildContext context,
    required AppCubit appCubit,
    required VoidCallback onConfirm,
  })
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: appCubit.isDark ? lightDarkColor : Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            contentPadding: EdgeInsets.all(25.r),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset('assets/delete.svg',color: Colors.red,width: 70.w,),
                ),
                SizedBox(height: 20.h),
                Text(
                  'حذف القسم',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: appCubit.isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'هل أنت متأكد من رغبتك في حذف هذا القسم؟ لا يمكن التراجع عن هذا الإجراء.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Expanded(
                      child: defaultButton(
                        onPressed: onConfirm,
                        text: 'نعم، حذف',
                        textSize: 12.sp,
                        height: 48.h,
                        background: Colors.red
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: defaultOutlinedButton(
                          onPressed: ()=>Navigator.pop(context),
                          text: 'إلغاء',
                          fontSize: 12.sp,
                        border: Colors.red,
                        textColor: Colors.red
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    titleController.text=widget.category['title'];
    isActive= widget.category['isActive'];
    catImage=widget.category['image'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminCubit adminCubit = AdminCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context, state) {
          if(state is DeleteCategoryLoadingState){
            showLoadingDialog(context);
          }
          if(state is DeleteCategorySuccessState){
            showSnackBar(Colors.green, 'تم حذف القسم بنجاح', context);
            hideLoadingDialog(context);
            Navigator.pop(context);
            Navigator.pop(context);
            adminCubit.getCategories();

          }
          if( state is EditCategoryLoadingState){
            showLoadingDialog(context);
          }
          if(state is EditCategorySuccessState){
            showSnackBar(Colors.green, 'تم تعديل القسم بنجاح', context);
            hideLoadingDialog(context);
            adminCubit.getCategories();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  header(
                    title: 'إدارة القسم',
                    context: context,
                    isLeading: true,
                    isNotif: false,
                    isAction: true,
                    actionIcon: 'assets/delete.svg',
                    onActionPresses: ()=>showTheDialog(
                        context: context,
                        appCubit: AppCubit.get(context),
                        onConfirm: ()=>adminCubit.deleteCategory(widget.category['id'])
                    )
                  ),
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
                            boxShadow: blueShadow,
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
                                      border: Border.all(
                                          color: mainColor.withOpacity(0.2),
                                          width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(55.r),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.all(25),
                                        child: SvgPicture.network(
                                          catImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => pickCategoryImage(),
                                    child: CircleAvatar(
                                      radius: 18.r,
                                      backgroundColor: mainColor,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.all(8.0),
                                        child: SvgPicture.asset(
                                          'assets/camera.svg',
                                          color: Colors.white,
                                          width: 18.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.h),
                              defaultTextFormField(
                                text: 'الكهرباء',
                                prefixIcon: 'assets/grid.svg',
                                errorMes: 'يرجى تعبئة الحقل',
                                controller: titleController,
                                type: TextInputType.text,
                                cubit: AppCubit.get(context),
                              ),
                              SizedBox(height: 15.h),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 12.w, vertical: 5.h),
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
                                        borderRadius:
                                        BorderRadius.circular(10.r),
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
                                      activeTrackColor:
                                      mainColor.withOpacity(0.3),
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
                            await adminCubit.editCategory(
                                docId: widget.category['id'],
                                title: titleController.text.trim(),
                                isActive: isActive,
                                imageFile: File(catImage!)
                            );
                          },
                          text: 'حفظ التغييرات',
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