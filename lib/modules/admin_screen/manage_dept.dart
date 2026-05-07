import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/compenents/components.dart';
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
  String catImage = '';

  Future<void> pickCategorymage() async {
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
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
    AppCubit appCubit = AppCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is DeleteCategoryLoadingState){
            showLoadingDialog(context);
          }
          if(state is DeleteCategorySuccessState){
            showSnackBar(Colors.green, 'تم حذف القسم بنجاح', context);
            hideLoadingDialog(context);
            Navigator.pop(context);
            appCubit.getCategories();

          }
          if( state is EditCategoryLoadingState){
            showLoadingDialog(context);
          }
          if(state is EditCategorySuccessState){
            showSnackBar(Colors.green, 'تم تعديل القسم بنجاح', context);
            hideLoadingDialog(context);
            appCubit.getCategories();
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
                        appCubit: appCubit,
                        onConfirm: ()=>appCubit.deleteCategory(widget.category['id'])
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
                            color: appCubit.isDark ? lightDarkColor : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: appCubit.isDark ? [] : blueShadow,
                            border: appCubit.isDark
                                ? Border.all(color: const Color(0xFF30363D))
                                : null,
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
                                    child: catImage.isEmpty
                                        ? Padding(
                                      padding: EdgeInsets.all(25.r),
                                      child: SvgPicture.asset(
                                        'assets/SVGs/E.svg',
                                        color: mainColor.withOpacity(0.5),
                                      ),
                                    )
                                        : ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(55.r),
                                      child: Image.file(
                                        File(catImage),
                                        fit: BoxFit.cover,
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
                              defaultTextFormfeild(
                                text: 'الكهرباء',
                                prefixIcon: 'assets/grid.svg',
                                errorMes: 'يرجى تعبئة الحقل',
                                controller: titleController,
                                type: TextInputType.text,
                                cubit: appCubit,
                              ),
                              SizedBox(height: 15.h),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 12.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: appCubit.isDark ? [] : blueShadow,
                                  border: appCubit.isDark
                                      ? Border.all(
                                      color: const Color(0xFF30363D))
                                      : null,
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
                                          color: appCubit.isDark
                                              ? Colors.white
                                              : Colors.black,
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
                            await appCubit.editCategory(
                                docId: widget.category['id'],
                                title: titleController.text.trim(),
                                isActive: isActive,
                                image: catImage
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