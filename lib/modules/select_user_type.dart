import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/modules/user_screens/user_sign_up.dart';
import 'package:trying_homy/modules/worker_screens/worker_signUp.dart';

class SelectUserType extends StatelessWidget {
  const SelectUserType({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'حدد دورك',
                  style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                Text(
                  'أختر كيف تريد استخدام التطبيق',
                  style: TextStyle(fontSize: 14.sp, color: Colors.black45),
                ),
                SizedBox(height: 24.h),

                Expanded(
                  child: Column(
                    children: [
                      _RoleCard(
                        icon: Icons.person,
                        title: 'مستخدم',
                        subtitle: 'طلب خدمات منزلية وتتبع الخدمات',
                        buttonText: 'الاستمرار كمستخدم',
                        onTap: () {
                         moveAndReplace(context, const UserSIgnUp());
                        },
                      ),
                      SizedBox(height: 20.h),
                      _RoleCard(
                        icon: Icons.handyman,
                        title: 'حرفي',
                        subtitle: 'قبول الوظائف وإدارة جدول عملك',
                        buttonText: 'الاستمرار كحرفي',
                        onTap: () {
                          moveAndReplace(context, const WorkerSignup());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: Colors.blue, size: 28.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // مثال: "زبون" أو "عامل صيانة"
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle, // مثال: "اطلب خدمات الصيانة بسهولة"
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        buttonText, // مثال: "الدخول كزبون"
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


