import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Etkan/modules/user_screens/user_login.dart';
import 'package:Etkan/modules/worker_screens/worker_login.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/networks/local/cache_helper.dart';
import 'package:Etkan/shared/styles/colors.dart';

import '../main.dart';
import 'admin_screens/admin_login_screen.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key});

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  int selectedIndex = 0;
  int adminTapCount = 0;

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                adminTapCount++;

                if (adminTapCount >= 5) {
                  adminTapCount = 0;
                  move(context, const AdminLoginScreen());
                }
              },
              child: header(
                title: 'اختر نوع حسابك',
                context: context,
                isLeading: false,
                isNotif: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(10.r),
                  child: Column(
                    children: [
                      buildUserTypeCard(
                        index: 0,
                        title: 'أنا مستخدم',
                        description:
                            'أبحث عن فنيين محترفين لإنجاز خدمات الصيانة والإصلاح بسرعة وكفاءة.',
                        image: 'assets/client.jpg',
                        icon: Icons.person_search_rounded,
                        appCubit: appCubit,
                      ),
                      SizedBox(height: 15.h),
                      buildUserTypeCard(
                        index: 1,
                        title: 'أنا فني',
                        description:
                            'أريد تقديم مهاراتي المتخصصة، إيجاد عملاء جدد، وتنمية عملي المهني.',
                        image: 'assets/provider.jfif',
                        icon: Icons.build_circle_rounded,
                        appCubit: appCubit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsetsDirectional.all(20.w),
          decoration: BoxDecoration(
            color: appCubit.isDark ? lightDarkColor : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: blueShadow,
          ),
          child: defaultButton(
            onPressed: () {
              if (selectedIndex == 0) {
                CacheHelper.saveData(key: 'role', value: 'user');
                move(context, const UserLogin());
              } else if (selectedIndex == 1) {
                CacheHelper.saveData(key: 'role', value: 'provider');
                move(context, const WorkerLogin());
              }
            },
            text: 'متابعة',
            height: 52.h,
          ),
        ),
      ),
    );
  }

  Widget buildUserTypeCard({
    required int index,
    required String title,
    required String description,
    required String image,
    required IconData icon,
    required AppCubit appCubit,
  }) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected ? mainColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Image.asset(
                    image,
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: appCubit.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? mainColor : Colors.grey.shade300,
                  size: 24.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
