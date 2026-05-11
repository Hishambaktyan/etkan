import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:trying_homy/modules/worker_screens/worker_services.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../main.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  var formKey = GlobalKey<FormState>();
  File? serviceImage;
  var picker = ImagePicker();

  Future<void> getServiceImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        serviceImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    serviceImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<WorkerCubit, WorkerStates>(
      listener: (context, state) {
        if (state is UploadServiceSuccessState) {
          showSnackBar(Colors.green, 'تم إضافة الخدمة بنجاح', context);
          moveAndReplace(context,  WorkerServices());
        }
      },
      builder: (context, state) {
        WorkerCubit workerCubit = WorkerCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: appCubit.isDark ? darkBgColor : bgColor,
            body: Column(
              children: [
                header(
                  title: 'إضافة خدمة جديدة',
                  context: context,
                  isNotif: false,
                  isLeading: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: mainColor.withOpacity(0.3),
                              strokeWidth: 2,
                              dashPattern: const [8, 4],
                              radius: Radius.circular(25.r),
                            ),
                            child: InkWell(
                              onTap: () => getServiceImage(),
                              borderRadius: BorderRadius.circular(25.r),
                              child: Container(
                                height: 160.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: appCubit.isDark ? lightDarkColor : Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  image: serviceImage != null
                                      ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(serviceImage!),
                                  )
                                      : null,
                                ),
                                child: serviceImage == null
                                    ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12.r),
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/image.svg',
                                        color: mainColor,
                                        width: 30.w,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'اضغط لرفع صورة الخدمة',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: appCubit.isDark ? lightDarkColor : Colors.white,
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: appCubit.isDark ? [] : blueShadow,
                              border: appCubit.isDark
                                  ? Border.all(color: const Color(0xFF30363D))
                                  : null,
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  defaultTextFormfeild(
                                    cubit: appCubit,
                                    text: 'اسم الخدمة',
                                    prefixIcon: 'assets/pen.svg',
                                    errorMes: 'يرجى إدخال اسم الخدمة',
                                    controller: workerCubit.serviceName,
                                    type: TextInputType.text,
                                  ),
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: defaultTextFormfeild(
                                          cubit: appCubit,
                                          text: 'السعر',
                                          prefixIcon: 'assets/money.svg',
                                          errorMes: 'مطلوب',
                                          controller: workerCubit.servicePrice,
                                          type: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: defaultTextFormfeild(
                                          cubit: appCubit,
                                          text: 'المدة (دقيقة)',
                                          prefixIcon: 'assets/timer.svg',
                                          errorMes: 'مطلوب',
                                          controller: workerCubit.serviceDuration,
                                          type: TextInputType.number,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: appCubit.isDark ? Colors.white : Colors.black,
                                    ),
                                    maxLines: 5,
                                    controller: workerCubit.serviceDesc,
                                    validator: (value) => value!.isEmpty ? 'يرجى إدخال الوصف' : null,
                                    decoration: InputDecoration(
                                      hintText: 'وصف الخدمة بالتفصيل...',
                                      hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                      filled: true,
                                      fillColor: appCubit.isDark ? darkBgColor : bgColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.r),
                                        borderSide: BorderSide(
                                          color: appCubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade100,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.r),
                                        borderSide: const BorderSide(color: mainColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            '* ملاحظة: الصور تساعد العملاء على فهم جودة خدمتك بشكل أفضل.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: appCubit.isDark ? lightDarkColor : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                boxShadow: appCubit.isDark ? [] : blueShadow,
              ),
              child: state is UploadServiceLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : defaultButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (serviceImage == null) {
                      showSnackBar(Colors.red, 'يرجى اختيار صورة للخدمة', context);
                    } else {
                      workerCubit.uploadService(
                        name: workerCubit.serviceName.text.trim(),
                        description: workerCubit.serviceDesc.text.trim(),
                        category: workerCubit.serviceDept.text.trim(),
                        price: workerCubit.servicePrice.text.trim(),
                        period: workerCubit.serviceDuration.text.trim(),
                      );
                    }
                  }
                },
                text: 'إضافة الخدمة الآن',
                height: 52.h,
              ),
            ),
          ),
        );
      },
    );
  }
}