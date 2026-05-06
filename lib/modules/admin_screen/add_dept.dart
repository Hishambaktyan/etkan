import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AddDept extends StatefulWidget {
  const AddDept({super.key});

  @override
  State<AddDept> createState() => _AddDeptState();
}

class _AddDeptState extends State<AddDept> {
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit appCubit = AppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: mainColor,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    onPressed: ()=>Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)
                ),
                title: Text(
                  'إضافة قسم',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 45.r,
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              child: SvgPicture.asset(
                                'assets/SVGs/E.svg',
                                width: 50.w,
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
                        SizedBox(width: 15.w),
                        Expanded(
                            child: defaultTextFormfeild(
                              text: 'الكهرباء',
                              prefixIcon: 'assets/services.svg',
                              errorMes: 'يرجى تعبئة الحقل',
                              controller: titleController ,
                              type: TextInputType.text,
                              cubit: appCubit,
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: 'Active',
                        isExpanded: false,
                        borderRadius: BorderRadius.circular(15.r),
                        decoration: InputDecoration(
                          labelText: 'اختار الحالة',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                          border: InputBorder.none,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Active',
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'مفعلة',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Inactive',
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'غير مفعلة',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(height: 25.h),
                    defaultButton(onPressed: (){}, text: 'حفظ',height: 55.h)
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}
