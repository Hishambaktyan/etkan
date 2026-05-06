import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../shared/compenents/components.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mainColor,
                leading: IconButton(
                    onPressed: ()=>Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)
                ),
                title: Text('إضافة مستخدم',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold),),
              ),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            height: 111.h,
                            width: 111.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage('https://i.pinimg.com/736x/d1/81/e4/d181e44cf0a7d5f9190bc96939da4164.jpg')
                                )
                            ),
                          ),
                          CircleAvatar(
                              radius: 16.r,
                              backgroundColor: mainColor,
                              child: IconButton(
                                onPressed: (){},
                                icon: SvgPicture.asset('assets/camera.svg',color: Colors.white,),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 50.h,
                        child: defaultTextFormfeild(
                          cubit: appCubit,
                          text: 'الاسم الكامل',
                          prefixIcon: 'assets/acc.svg',
                          errorMes: 'يجب كتابة الاسم',
                          controller: nameController,
                          type: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 50.h,
                        child: defaultTextFormfeild(
                          cubit: appCubit,
                          text: 'رقم الهاتف',
                          prefixIcon: 'assets/phone.svg',
                          errorMes: 'رقم الهاتف يجب ان لا يكون فارغ',
                          controller: phoneController,
                          type: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 50.h,
                        child: defaultTextFormfeild(
                          cubit: appCubit,
                          text: 'العنوان',
                          prefixIcon: 'assets/loc.svg',
                          errorMes: 'يجب كتابة العنوان',
                          controller: addressController,
                          type: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      defaultButton(
                        onPressed: () {
                          if(nameController.text.isEmpty || phoneController.text.isEmpty){
                            showSnackBar(Colors.red, 'يرجى تعبئة كل الحقول', context);
                          }
                        },
                        text: 'إضافة',
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ),
            )
        );
      },
      listener: (context, state) {},
    );
  }
}
