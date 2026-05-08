import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/admin_cubit/admin_cubit.dart';
import '../../shared/cubits/admin_cubit/admin_states.dart';

class AdminUserInfo extends StatefulWidget {
  final Map<String, dynamic> user;
  const AdminUserInfo({super.key, required this.user});

  @override
  State<AdminUserInfo> createState() => _AdminUserInfoState();
}

class _AdminUserInfoState extends State<AdminUserInfo> {
  TextEditingController userName = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  bool isActive = true;

  @override
  void initState() {
    userName.text = widget.user['name'] ?? '';
    userPhone.text = widget.user['phone'] ?? '';
    isActive = widget.user['isActive'] ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminCubit adminCubit = AdminCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocConsumer<AdminCubit, AdminStates>(
          listener: (context, state) {
            if(state is EditUserLoadingState){
              showLoadingDialog(context);
            }
            if(state is EditUserSuccessState){
              showSnackBar(Colors.green, 'تم تعديل المستخدم', context);
              hideLoadingDialog(context);
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  header(
                    title: 'إدارة المستخدم',
                    context: context,
                    isNotif: false,
                    isLeading: true,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: blueShadow,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 110.r,
                                width: 110.r,
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.05),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: mainColor.withOpacity(0.2),
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        widget.user['profileImage'] ?? ''
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              defaultTextFormfeild(
                                text: 'اسم المستخدم',
                                prefixIcon: 'assets/acc.svg',
                                errorMes: '',
                                controller: userName,
                                type: TextInputType.text,
                                cubit: AppCubit.get(context),
                                isReadOnly: true
                              ),
                              SizedBox(height: 15.h),
                              defaultTextFormfeild(
                                text: 'رقم المستخدم',
                                prefixIcon: 'assets/phone.svg',
                                errorMes: '',
                                controller: userPhone,
                                type: TextInputType.phone,
                                cubit: AppCubit.get(context),
                                  isReadOnly: true
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
                                      child: SvgPicture.asset('assets/power.svg',color: mainColor,)
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        'حالة الحساب (نشط / معطل)',
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
                        SizedBox(height: 30.h),
                        defaultButton(
                          onPressed: () async =>adminCubit.editUser(docId: widget.user['id'], isActive: isActive),
                          text: 'حفظ التعديلات',
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}