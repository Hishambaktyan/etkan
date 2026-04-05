  import 'dart:ui';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:trying_homy/main.dart';
  import 'package:trying_homy/modules/worker_screens/worker_login_screen.dart';
  import 'package:trying_homy/shared/styles/colors.dart';
  import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import 'worker_email_verfication_screen.dart';

  class WorkerSignup extends StatefulWidget {
     const WorkerSignup({super.key});

    @override
    State<WorkerSignup> createState() => _WorkerSignupState();
  }

  class _WorkerSignupState extends State<WorkerSignup> {
    @override
    Widget build(BuildContext context) {
      AppCubit cubit = AppCubit.get(context);
      return BlocConsumer<AppCubit,AppStates>(
          listener: (context, state) {
            if(state is WorkerSignUpErrorState){
              showSnackBar(Colors.red,state.error.toString(), context);
            }
            if (state is SendVerficationCodeSuccessState) {
                cubit.workerPasswordController.clear();
                cubit.workerPhoneController.clear();
                cubit.workerNameController.clear();
                cubit.workerAddController.clear();
                cubit.selectedDept=null;
                cubit.workerDataLoaded=false;
                cubit.getWorkerData();
                showSnackBar(Colors.green, 'تم إنشاء حسابك بنجاح', context);
                cubit.currentIndex=0;
                moveAndReplace(context, const WorkerEmailVerificationScreen());
              }
            if(state is SendVerficationCodeErrorState){
                showSnackBar(Colors.red, 'فشل في إرسال بريد التحقق', context);

              }
          },
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                mainColor.withOpacity(0.9),
                                const Color(0xFF0F0F1E),
                              ],
                              stops: const [
                                0.0,
                                0.8,
                              ]
                          )
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -50.h,
                            left: -50.w,
                            child: CircleAvatar(
                              radius: 100.r,
                              backgroundColor: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          Positioned(
                            top: 80.h,
                            right: -60.w,
                            child: Container(
                              width: 250.r,
                              height: 250.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF00F2FF).withOpacity(0.5),
                                    const Color(0xFF00F2FF).withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 200.h,
                            left: -40.w,
                            child: Container(
                              width: 200.r,
                              height: 200.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    mainColor.withOpacity(0.4),
                                    mainColor.withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), // تنعيم الألوان لتصبح مثل الضوء
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(top:100.h),
                              child: Text(
                                'إنشاء حساب\nفني جديد',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 520.h,
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 30.h),
                        decoration: BoxDecoration(
                          color: cubit.isDark? darkBgColor: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 50.h,
                                child: defaultTextFormfeild(
                                  cubit: cubit,
                                    text: 'الأسم الكامل',
                                    prefixIcon: 'assets/acc.svg',
                                    errorMes: 'يجب كتابة الأسم',
                                    controller: cubit.workerNameController,
                                    type: TextInputType.text,
                                ),
                              ),
                              SizedBox(height: 15.h,),
                              Container(
                                height: 50.h,
                                child: defaultTextFormfeild(
                                  cubit: cubit,
                                  text: 'العنوان',
                                  prefixIcon: 'assets/loc.svg',
                                  errorMes: 'العنوان يجب ان لا يكون فارغ',
                                  controller: cubit.workerAddController,
                                  type: TextInputType.text,
                                ),
                              ),
                              SizedBox(height: 15.0.h,),
                              Container(
                                height: 50.h,
                                child: defaultTextFormfeild(
                                  cubit: cubit,
                                  text: 'البريد الألكتروني',
                                  prefixIcon: 'assets/phone.svg',
                                  errorMes: 'البريد يجب ان لا يكون فارغ',
                                  controller: cubit.workerPhoneController,
                                  type: TextInputType.emailAddress,
                                ),
                              ),
                              SizedBox(height: 15.0.h,),
                              Container(
                                height: 50.h,
                                child: defaultTextFormfeild(
                                  cubit: cubit,
                                    text: 'كلمة المرور',
                                    prefixIcon: 'assets/lock.svg',
                                    errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
                                    controller: cubit.workerPasswordController,
                                    type: TextInputType.visiblePassword,
                                    isPassword: cubit.isPassword,
                                    isSuffixIcon: true,
                                    suffixIcon: cubit.suffixIcon,
                                    suffixPressed: ()=>cubit.changePasswordVisiability(),

                                ),
                              ),
                              SizedBox(height: 15.h,),
                              DropdownButtonFormField<String>(
                                dropdownColor: cubit.isDark? darkBgColor: Colors.white,
                                isExpanded: false,
                                alignment: AlignmentDirectional.centerStart,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey.shade600,
                                  size: 20.sp,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SvgPicture.asset(
                                      'assets/work.svg',
                                      width: 12.w,
                                      height:12.h, color: cubit.isDark? darkSubTextColor: Colors.grey.shade600                                     ),
                                  ),
                                  fillColor: Colors.grey.withOpacity(0.06),
                                  contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r), // زوايا أكثر نعومة
                                    borderSide: BorderSide.none,
                                  ),
                                  errorStyle: TextStyle(fontSize: 10.sp),
                                ),
                                hint:  Text(
                                  'اختر القسم',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                    color: cubit.isDark? darkSubTextColor: Colors.grey
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                value: cubit.selectedDept,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'كهرباء',
                                    child: Align(alignment: Alignment.topRight, child: Text('كهرباء')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'سباكة',
                                    child: Align(alignment: Alignment.topRight, child: Text('سباكة')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'الماء',
                                    child: Align(alignment: Alignment.topRight, child: Text('الماء')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'التكييف',
                                    child: Align(alignment: Alignment.topRight, child: Text('التكييف')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'البناء',
                                    child: Align(alignment: Alignment.topRight, child: Text('البناء')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'الحدادة',
                                    child: Align(alignment: Alignment.topRight, child: Text('الحدادة')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'النجارة',
                                    child: Align(alignment: Alignment.topRight, child: Text('النجارة')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'الدهان',
                                    child: Align(alignment: Alignment.topRight, child: Text('الدهان')),
                                  ),
                                  DropdownMenuItem(
                                    value: 'أخرى',
                                    child: Align(alignment: Alignment.topRight, child: Text('أخرى')),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    cubit.selectedDept = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى اختيار القسم';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h,),
                               state is WorkerSignUpLoadingState || state is SendVerficationCodeLoadingState ?const Center(
                                child: CircularProgressIndicator(),
                              )
                                  : defualtButton(
                                  onPressed: ()  async {
                                    if(
                                    cubit.workerNameController.text.isNotEmpty &&
                                        cubit.workerAddController.text.isNotEmpty &&
                                        cubit.workerPhoneController.text.isNotEmpty &&
                                        cubit.workerPasswordController.text.isNotEmpty &&
                                        cubit.selectedDept!=null
                                    ){
                                      await cubit.workerSignUpUser(cubit.workerPhoneController.text.trim(), cubit.workerPasswordController.text.trim());
                                    }else{
                                      showSnackBar(Colors.red, 'يرجى تعبئة واختيار كل الحقول', context);
                                    }
                                  },
                                  text: 'التالي',
                                  height: 50.h
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'لديك حساب بالفعل؟',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey
                                    ),
                                  ),
                                  defaultTextButton(
                                      onPressed: ()=>move(context, const WorkerLoginScreen()),
                                      text: 'سجل دخول'
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
      );
    }
  }
