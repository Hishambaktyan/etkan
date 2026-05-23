import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_services_list.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerEditService extends StatefulWidget {
  final Map<String, dynamic> service;
  const WorkerEditService({super.key, required this.service,});

  @override
  State<WorkerEditService> createState() => _WorkerEditServiceState();
}

class _WorkerEditServiceState extends State<WorkerEditService> {
  var formKey = GlobalKey<FormState>();

  File? serviceImage;
  final picker = ImagePicker();

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDurationController = TextEditingController();
  final TextEditingController serviceDescController = TextEditingController();

  Future<void> getServiceImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        serviceImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    serviceNameController.text = widget.service['name'] ?? '';
    servicePriceController.text = '${widget.service['price'] ?? ''}';
    serviceDurationController.text = '${widget.service['period'] ?? ''}';
    serviceDescController.text = widget.service['description'] ?? '';
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    servicePriceController.dispose();
    serviceDurationController.dispose();
    serviceDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<WorkerCubit, WorkerStates>(
      listener: (context, state) {
        if (state is EditServiceLoadingState) {
          showLoadingDialog(context);
        }
        if (state is EditServiceSuccessState) {
          hideLoadingDialog(context);
          showSnackBar(Colors.green, 'تم تعديل الخدمة بنجاح', context);
          moveAndReplace(context, const WorkerServicesList());
        }
        if (state is EditServiceErrorState) {
          hideLoadingDialog(context);
          showSnackBar(Colors.red, state.error, context);
        }
      },
      builder: (context, state) {
        WorkerCubit workerCubit = WorkerCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: (){Navigator.pop(context);},
                  icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).iconTheme.color,)
              ),
              title: Text(
                  'تعديل الخدمة',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
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
                            color: appCubit.isDark
                                ? lightDarkColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: serviceImage != null
                                  ? FileImage(serviceImage!) as ImageProvider
                                  : NetworkImage(
                                widget.service['serviceImage'] ?? '',
                              ) as ImageProvider,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              color: Colors.black.withOpacity(0.15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color:appCubit.isDark? lightDarkColor.withOpacity(0.9): Colors.white.withOpacity(0.9),
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
                                  'اضغط لتغيير صورة الخدمة',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(20.r),
                      decoration: BoxDecoration(
                        color: appCubit.isDark
                            ? lightDarkColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: blueShadow,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            defaultTextFormField(
                              cubit: appCubit,
                              text: 'اسم الخدمة',
                              prefixIcon: 'assets/pen.svg',
                              errorMes: 'يرجى إدخال اسم الخدمة',
                              controller: serviceNameController,
                              type: TextInputType.text,
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                Expanded(
                                  child: defaultTextFormField(
                                    cubit: appCubit,
                                    text: 'السعر',
                                    prefixIcon: 'assets/money.svg',
                                    errorMes: 'مطلوب',
                                    controller: servicePriceController,
                                    type: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: defaultTextFormField(
                                    cubit: appCubit,
                                    text: 'المدة (دقيقة)',
                                    prefixIcon: 'assets/timer.svg',
                                    errorMes: 'مطلوب',
                                    controller: serviceDurationController,
                                    type: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            TextFormField(
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              maxLines: 5,
                              controller: serviceDescController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى إدخال الوصف';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'وصف الخدمة بالتفصيل...',
                                hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    color: appCubit.isDark
                                        ? const Color(0xFF30363D)
                                        : Colors.grey.shade100,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.r),
                                  borderSide:
                                  const BorderSide(color: mainColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      '* يمكنك تعديل بيانات الخدمة أو تغيير الصورة عند الحاجة.',
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
            bottomNavigationBar: Container(
              padding: EdgeInsetsDirectional.all(20.r),
              decoration: BoxDecoration(
                color: appCubit.isDark ? lightDarkColor : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.r),
                ),
                boxShadow:  blueShadow,
              ),
              child: defaultButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    workerCubit.editService(
                      serviceId: widget.service['id'],
                      serviceName: serviceNameController.text.trim(),
                      serviceDescription: serviceDescController.text.trim(),
                      servicePrice: servicePriceController.text.trim(),
                      servicePeriod: serviceDurationController.text.trim(),
                      newServiceImagePath: serviceImage?.path,
                      oldServiceImageUrl: widget.service['serviceImage'] ?? '',
                    );
                  }
                },
                text: 'حفظ التعديلات',
                height: 52.h,
              ),
            ),
          ),
        );
      },
    );
  }
}