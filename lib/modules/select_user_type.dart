import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/admin_screens/admin_home_screen.dart';
import 'package:trying_homy/modules/admin_screens/admin_login_screen.dart';
import 'package:trying_homy/modules/user_screens/user_login_screen.dart';
import 'package:trying_homy/modules/worker_screens/worker_login_screen.dart';
import 'package:trying_homy/modules/user_screens/user_sign_up.dart';
import 'package:trying_homy/modules/worker_screens/worker_signUp.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({Key? key}) : super(key: key);

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'كيف ستستخدم البرنامج؟',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: 20.w, end: 20.w, bottom: 20.h, top: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex == 0
                          ? const Color(0xFFE3F2FD)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: selectedIndex == 0
                            ? const Color(0xFF1976D2)
                            : Colors.transparent,
                        width: 2.w,
                      ),
                      boxShadow: selectedIndex == 0
                          ? [
                              BoxShadow(
                                color: const Color(0xFF1976D2).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/client.jpg',
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color(0xFF1976D2).withOpacity(0.85),
                              child: const Icon(Icons.person_search,
                                  color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'أنا عميل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: selectedIndex == 0
                                ? Colors.black87
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'أبحث عن خدمات مهنية وأريد توظيف خبراء لمشاريعي القادمة.',
                          style: TextStyle(
                            color: selectedIndex == 0
                                ? Colors.black54
                                : Colors.black38,
                            fontSize: 14,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            selectedIndex == 0
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedIndex == 0
                                ? const Color(0xFF1976D2)
                                : Colors.black38,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex == 1
                          ? const Color(0xFFE3F2FD)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: selectedIndex == 1
                            ? const Color(0xFF1976D2)
                            : Colors.transparent,
                        width: 2.w,
                      ),
                      boxShadow: selectedIndex == 1
                          ? [
                              BoxShadow(
                                color: const Color(0xFF1976D2).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/provider.jfif',
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color(0xFF1976D2).withOpacity(0.85),
                              child: const Icon(Icons.build_circle,
                                  color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'أنا عامل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: selectedIndex == 1
                                ? Colors.black87
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'أريد تقديم مهاراتي المتخصصة، إيجاد عملاء جدد، وتنمية عملي المهني.',
                          style: TextStyle(
                            color: selectedIndex == 1
                                ? Colors.black54
                                : Colors.black38,
                            fontSize: 14,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            selectedIndex == 1
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedIndex == 1
                                ? const Color(0xFF1976D2)
                                : Colors.black38,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex == 2
                          ? const Color(0xFFE3F2FD)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: selectedIndex == 2
                            ? const Color(0xFF1976D2)
                            : Colors.transparent,
                        width: 2.w,
                      ),
                      boxShadow: selectedIndex == 2
                          ? [
                              BoxShadow(
                                color: const Color(0xFF1976D2).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/admin.jpg',
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  const Color(0xFF1976D2).withOpacity(0.85),
                              child: const Icon(
                                Icons.admin_panel_settings_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'أنا مسؤول',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: selectedIndex == 2
                                ? Colors.black87
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'أريد إدارة المستخدمين، الخدمات، الحجوزات، والاشتراكات داخل النظام.',
                          style: TextStyle(
                            color: selectedIndex == 2
                                ? Colors.black54
                                : Colors.black38,
                            fontSize: 14,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            selectedIndex == 2
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: selectedIndex == 2
                                ? const Color(0xFF1976D2)
                                : Colors.black38,
                            size: 24,
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
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h),
          child: defaultButton(
            onPressed: () {
              if (selectedIndex == 0) {
                CacheHelper.setBoolen(key: 'isWorker', value: false);
                CacheHelper.saveData(key: 'role', value: 'user');

                moveAndReplace(context, const UserLoginScreen());
              } else if (selectedIndex == 1) {
                CacheHelper.setBoolen(key: 'isWorker', value: true);
                CacheHelper.saveData(key: 'role', value: 'provider');

                moveAndReplace(context, const WorkerLoginScreen());
              } else {
                CacheHelper.setBoolen(key: 'isWorker', value: false);
                CacheHelper.saveData(key: 'role', value: 'admin');

                moveAndReplace(context, const AdminLoginScreen());
              }
            },
            text: 'متابعة',
            height: 55,
          ),
        ),
      ),
    );
  }
}
