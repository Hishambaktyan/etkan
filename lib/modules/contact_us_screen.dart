import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../shared/cubits/app_cubit/app_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController problem = TextEditingController();
  TextEditingController problemdescription = TextEditingController();

  Future<void> openWhatsApp() async {
    final Uri uri = Uri.parse("https://wa.me/967770770858");

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception("WhatsApp not available");
      }
    } catch (e) {}
  }

  Future<void> openEmail() async {
    final Uri uri = Uri.parse(
      "mailto:aboalkrm2004@gmail.com?subject=استفسار&body=مرحبًا، أحتاج مساعدة بخصوص...",
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception("Email app not available");
      }
    } catch (e) {
      // ممكن تضيف fallback أو رسالة خطأ
    }
  }

  @override
  void dispose() {
    problem.dispose();
    problemdescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                title: Text(
                  'تواصل معنا',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(top: 10.h, start: 10.w, end: 10.w, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'دعنا نساعدك',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      Text(
                        'نحن هنا لمساعدتك والرد على جميع استفساراتك وحل مشاكلك. لا تتردد في مراسلتنا، يسعدنا تواصلك معنا.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                            color: cubit.isDark
                                ? const Color(0xFF161B22)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: blueShadow
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'معلومات التواصل',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            InkWell(
                              onTap: () => openWhatsApp(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: mainColor.withOpacity(0.1),
                                    radius: 23.r,
                                    child: SvgPicture.asset(
                                      'assets/whats.svg',
                                      color: mainColor,
                                      width: 25.w,
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'واتساب',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          '967770770858+',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              height: 1.4,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                              letterSpacing: 5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            InkWell(
                              onTap: () => openEmail(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          mainColor.withOpacity(0.1),
                                      radius: 23.r,
                                      child: const Icon(
                                        Icons.alternate_email_rounded,
                                        color: mainColor,
                                      )),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'البريد الالكتروني',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          'aboalkrm000@gmail.com',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            height: 1.4,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          color: cubit.isDark
                              ? const Color(0xFF161B22)
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 7.0,
                              offset: const Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الموضوع',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            defaultTextFormField(
                              text: ' ماهي مشكلتك؟',
                              prefixIcon: 'assets/ques.svg',
                              errorMes: 'يجب ان لا يكون فارغ',
                              controller: problem,
                              type: TextInputType.text,
                              cubit: AppCubit.get(context),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'التفاصيل',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              maxLines: 5,
                              minLines: 5,
                              controller: problemdescription,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: 'يرجى شرح المشكلة بالتفصيل...',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                              ),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(height: 30.h),
                            defaultButton(
                                onPressed: () {
                                  if (problem.text.isNotEmpty &&
                                      problemdescription.text.isNotEmpty) {
                                    showSnackBar(Colors.green,
                                        'تم إرسال التذكرة', context);
                                  } else {
                                    showSnackBar(Colors.red,
                                        'يرجى تعبة كل الحقول', context);
                                  }
                                },
                                text: 'إرسال المشكلة',
                                textSize: 15.sp,
                                height: 50.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          ' © 2026 حقوق النشر لفريق هومي',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
