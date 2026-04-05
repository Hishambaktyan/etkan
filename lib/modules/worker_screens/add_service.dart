import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/layout/worker_layout/worker_main_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../main.dart';
import '../images_view.dart';

class AddService extends StatefulWidget {
   const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
   var formKey = GlobalKey<FormState>();

  TextEditingController serviceName = TextEditingController();

  TextEditingController serviceDept = TextEditingController();

  TextEditingController servicePrice = TextEditingController();

  TextEditingController serviceDuration = TextEditingController();

  TextEditingController serviceDesc = TextEditingController();



   void showImageDialog(BuildContext context, AppCubit cubit) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         backgroundColor: cubit.isDark ? const Color(0xFF161B22) : Colors.white,
         surfaceTintColor: Colors.transparent,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15.r),
           side: cubit.isDark
               ? const BorderSide(color: Color(0xFF30363D))
               : BorderSide.none,
         ),
         contentPadding: EdgeInsets.symmetric(vertical: 20.h),
         content: Directionality(
           textDirection: TextDirection.rtl,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 24.w),
                 child: Text(
                   'اختيار طريقة رفع الصورة',
                   style: TextStyle(
                     fontSize: 15.sp,
                     fontWeight: FontWeight.bold,
                     color: cubit.isDark ? Colors.white : Colors.black,
                   ),
                 ),
               ),
               SizedBox(height: 20.h),

               buildDialogOption(
                 context,
                 icon: 'assets/camera.svg',
                 label: 'الكاميرا',
                 cubit: cubit,
                 onTap: () {
                   cubit.getProfileImage(source: ImageSource.camera);
                   Navigator.pop(context);
                 },
               ),

               buildDialogOption(
                 context,
                 icon: 'assets/image.svg',
                 label: 'المعرض',
                 cubit: cubit,
                 onTap: () {
                   cubit.getProfileImage(source: ImageSource.gallery);
                   Navigator.pop(context);
                 },
               ),
             ],
           ),
         ),
       ),
     );
   }

  Widget buildDialogOption(BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
    required AppCubit cubit,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
          icon,
        width: 24.w,
        height: 24.h,
        color: cubit.isDark? Colors.white: Colors.black54,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          color: cubit.isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
    );
  }
   late AppCubit cubit;

   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     cubit = AppCubit.get(context);
   }

  @override
  void dispose() {
     cubit.clearServiceImages();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        if(state is UploadServiceSuccessState){
          showSnackBar(Colors.green, 'تم إضافة الخدمة بنجاح', context);
          cubit.getWorkerData();
          moveAndReplace(context, const WorkerMainScreen());
        }
      },
        builder: (context, state)   {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
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
                          onTap: ()=>moveAndReplace(context, const WorkerMainScreen()),
                          child:  Icon(
                              CupertinoIcons.back,
                              color: Theme.of(context).iconTheme.color
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'إضافة خدمة خديدة',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: Theme.of(context).textTheme.bodyLarge!.color
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                              radius: Radius.circular(15.r),
                            color: cubit.isDark? darkSubTextColor: Colors.grey.withOpacity(0.5),
                            strokeWidth: 1,
                            dashPattern: const [6, 3],
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=>showImageDialog(context, cubit),
                            child: Container(
                              height: 140.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: cubit.isDark? lightDarkColor : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.r),
                                image: cubit.serviceImage!=null? DecorationImage(
                                  fit: BoxFit.cover,
                                    image: FileImage(
                                      cubit.serviceImage!
                                    )
                                ): null
                              ),
                              child: cubit.serviceImage==null?Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/image.svg',
                                    color: cubit.isDark? darkSubTextColor: Colors.grey.withOpacity(0.2),
                                    width: 35.w,
                                    height: 35.h,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    'اضف صور لخدمتك',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: cubit.isDark? darkSubTextColor:Colors.grey.withOpacity(0.4)
                                    ),
                                  ),
                                ],
                              ):const SizedBox(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'ملاحظة: يمكنكك رفع صور بصيغة"jpg."أو "png."أو "jpeg".',
                          style: TextStyle(
                            color: cubit.isDark? darkSubTextColor: Colors.grey.shade400,
                            fontSize: 9.sp
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w,vertical: 20),
                          decoration: BoxDecoration(
                            color: cubit.isDark? lightDarkColor: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15.r)
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                defaultTextFormfeild(
                                  cubit: cubit,
                                  text: 'اسم الخدمة',
                                  prefixIcon: 'assets/pen.svg',
                                  errorMes: 'يرجئ ملى الحقل',
                                  controller: serviceName,
                                  type: TextInputType.text,
                                  isCovered: true
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                defaultTextFormfeild(
                                    cubit: cubit,
                                  text: 'قسم الخدمة',
                                  prefixIcon: 'assets/grid.svg',
                                  errorMes: 'يرجئ ملى الحقل',
                                  controller: serviceDept,
                                  type: TextInputType.text,
                                    isCovered: true
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: defaultTextFormfeild(
                                          cubit: cubit,
                                            text: 'السعر',
                                            prefixIcon: 'assets/money.svg',
                                            errorMes: 'يرجئ ملى الحقل',
                                            controller: servicePrice,
                                            type: TextInputType.number,
                                            isCovered: true
                                        ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Expanded(
                                      child: defaultTextFormfeild(
                                          cubit: cubit,
                                          text: 'المدة',
                                          prefixIcon: 'assets/timer.svg',
                                          errorMes: 'يرجئ ملى الحقل',
                                          controller: serviceDuration,
                                          type: TextInputType.number,
                                          isCovered: true
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                TextFormField(
                                  style: TextStyle(
                                      fontSize: 12.sp
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  textDirection: TextDirection.rtl,
                                  validator: (value) {
                                    if(value == null || value.isEmpty){
                                      return 'يرجى ملئ الحقل';
                                    }
                                    return null;
                                  },
                                  controller: serviceDesc,
                                  maxLines: 6,
                                  decoration:InputDecoration(
                                    alignLabelWithHint: true,
                                    filled: true,
                                    fillColor: cubit.isDark? darkBgColor:Colors.white ,
                                    labelText: 'وصف الخدمة',
                                    labelStyle: TextStyle(
                                        fontSize: 12.sp,
                                      color: cubit.isDark? darkSubTextColor: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: BorderSide.none
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                            color: mainColor
                                        )
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                        borderSide: const BorderSide(
                                            color: Colors.red
                                        )
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
                ),
                bottomNavigationBar: Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.w,end: 20.w,bottom: 15.h),
                  child: state is UploadServiceLoadingState? const Center(child: CircularProgressIndicator())
                    :defualtButtonWithIcon(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          cubit.uploadService(
                              name: serviceName.text.trim(),
                              description: serviceDesc.text.trim(),
                              category: serviceDept.text.trim(),
                              subCategory: 'تركيب بانيو مصري',
                              price: servicePrice.text.trim(),
                              period: serviceDuration.text.trim()
                          );
                        }
                      },
                      text: 'إضافة',
                      icon: const Icon(Icons.add_rounded,color: Colors.white,)
                  ),
                ),
              ),
          );
        },
    );
  }
}
