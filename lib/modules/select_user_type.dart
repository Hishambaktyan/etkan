import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/modules/user_screens/user_sign_up.dart';
import 'package:trying_homy/modules/worker_screens/worker_signUp.dart';
import 'package:trying_homy/shared/compenents/components.dart';
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
        body: Padding(
          padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedIndex == 0 ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: selectedIndex == 0 ? const Color(0xFF1976D2) : Colors.transparent,
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
                            backgroundColor: const Color(0xFF1976D2).withOpacity(0.85),
                            child: const Icon(Icons.person_search, color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'أنا عميل',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: selectedIndex == 0 ? Colors.black87 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'أبحث عن خدمات مهنية وأريد توظيف خبراء لمشاريعي القادمة.',
                        style: TextStyle(
                          color: selectedIndex == 0 ? Colors.black54 : Colors.black38,
                          fontSize: 14,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          selectedIndex == 0 ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: selectedIndex == 0 ? const Color(0xFF1976D2) : Colors.black38,
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
                    color: selectedIndex == 1 ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: selectedIndex == 1 ? const Color(0xFF1976D2) : Colors.transparent,
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
                            backgroundColor: const Color(0xFF1976D2).withOpacity(0.85),
                            child: const Icon(Icons.build_circle, color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'أنا عامل',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: selectedIndex == 1 ? Colors.black87 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'أريد تقديم مهاراتي المتخصصة، إيجاد عملاء جدد، وتنمية عملي المهني.',
                        style: TextStyle(
                          color: selectedIndex == 1 ? Colors.black54 : Colors.black38,
                          fontSize: 14,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          selectedIndex == 1 ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: selectedIndex == 1 ? const Color(0xFF1976D2) : Colors.black38,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              defualtButton(
                onPressed: () {
                  if(selectedIndex==0){
                    moveAndReplace(context, const UserSignUp() );
                  }else{
                    moveAndReplace(context, const WorkerSignup() );
                  }
                },
                text: 'متابعة',
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}