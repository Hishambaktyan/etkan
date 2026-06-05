import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/select_user_type.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();

  int currentIndex = 0;

  final List<Map<String, dynamic>> data = [
    {
      'title': 'خدمات الصيانة بين يديك',
      'body':
          'اطلب خدمات الصيانة المنزلية بسهولة، واختر الخدمة المناسبة لك من بين عدة تخصصات.',
      'image': 'assets/walk1.jfif',
      'icon': 'assets/services.svg',
    },
    {
      'title': 'تواصل مباشر مع الفني',
      'body':
          'تحدث مع مقدم الخدمة، اتفق على التفاصيل، وتابع حالة الطلب خطوة بخطوة.',
      'image': 'assets/walk2.jfif',
      'icon': 'assets/chat.svg',
    },
    {
      'title': 'اختر بثقة وقيّم الخدمة',
      'body':
          'اطّلع على تقييمات مقدمي الخدمات، وبعد انتهاء العمل شارك تجربتك بكل سهولة.',
      'image': 'assets/walk3.jfif',
      'icon': 'assets/star.svg',
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final AppCubit appCubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: appCubit.isDark ? darkBgColor : Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  /*
                  ==============================
                  الهيدر العلوي
                  ==============================
                  */
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 18.w,
                      end: 10.w,
                      top: 10.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 42.h,
                          width: 42.w,
                          decoration: BoxDecoration(
                            color: appCubit.isDark
                                ? lightDarkColor
                                : mainColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(14.r),
                            border: appCubit.isDark
                                ? Border.all(
                                    color: const Color(0xFF30363D),
                                  )
                                : null,
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/logo.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: appCubit.isDark ? [] : blueShadow,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'هومي',
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        defaultTextButton(
                          onPressed: () {
                            moveAndReplace(
                              context,
                              const SelectUserType(),
                            );
                          },
                          text: 'تخطي',
                          isLined: false,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  /*
                  ==============================
                  صفحات التعريف
                  ==============================
                  */
                  Expanded(
                    child: PageView.builder(
                      controller: controller,
                      itemCount: data.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 22.w,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    /*
                                    الدائرة الزخرفية العلوية
                                    */
                                    PositionedDirectional(
                                      top: 25.h,
                                      start: 10.w,
                                      child: CircleAvatar(
                                        radius: 42.r,
                                        backgroundColor: mainColor.withOpacity(
                                          appCubit.isDark ? 0.14 : 0.08,
                                        ),
                                      ),
                                    ),

                                    /*
                                    الدائرة الزخرفية السفلية
                                    */
                                    PositionedDirectional(
                                      bottom: 45.h,
                                      end: 5.w,
                                      child: CircleAvatar(
                                        radius: 55.r,
                                        backgroundColor: mainColor.withOpacity(
                                          appCubit.isDark ? 0.10 : 0.06,
                                        ),
                                      ),
                                    ),

                                    /*
                                    البطاقة الرئيسية
                                    */
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsetsDirectional.all(
                                        16.r,
                                      ),
                                      decoration: BoxDecoration(
                                        color: appCubit.isDark
                                            ? lightDarkColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                        border: appCubit.isDark
                                            ? Border.all(
                                                color: const Color(
                                                  0xFF30363D,
                                                ),
                                              )
                                            : null,
                                        boxShadow:
                                            appCubit.isDark ? [] : blueShadow,
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                24.r,
                                              ),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Image.asset(
                                                    data[index]['image'],
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),

                                                  /*
                                                  طبقة خفيفة فوق الصورة
                                                  في الوضع الداكن
                                                  */
                                                  if (appCubit.isDark)
                                                    Container(
                                                      color: Colors.black
                                                          .withOpacity(
                                                        0.08,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15.h),

                                          /*
                                          أيقونة الصفحة
                                          */
                                          Container(
                                            height: 58.w,
                                            width: 58.w,
                                            decoration: BoxDecoration(
                                              color: mainColor.withOpacity(
                                                appCubit.isDark ? 0.18 : 0.10,
                                              ),
                                              shape: BoxShape.circle,
                                              border: appCubit.isDark
                                                  ? Border.all(
                                                      color:
                                                          mainColor.withOpacity(
                                                        0.25,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                data[index]['icon'],
                                                width: 28.w,
                                                height: 28.h,
                                                color: mainColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h),

                              /*
                              عنوان الصفحة
                              */
                              Text(
                                data[index]['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              /*
                              وصف الصفحة
                              */
                              Text(
                                data[index]['body'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: appCubit.isDark
                                      ? darkSubTextColor
                                      : Colors.grey.shade700,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 25.h),

                  /*
                  ==============================
                  مؤشر الصفحات
                  ==============================
                  */
                  SmoothPageIndicator(
                    controller: controller,
                    count: data.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      activeDotColor: mainColor,
                      dotColor: appCubit.isDark
                          ? Colors.white.withOpacity(0.18)
                          : Colors.grey.shade300,
                      expansionFactor: 3.5,
                      spacing: 6.w,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  /*
                  ==============================
                  أزرار التنقل
                  ==============================
                  */
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 20.w,
                      end: 20.w,
                      bottom: 28.h,
                    ),
                    child: Row(
                      children: [
                        if (currentIndex != 0)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              controller.previousPage(
                                duration: const Duration(
                                  milliseconds: 300,
                                ),
                                curve: Curves.easeInOut,
                              );
                            },
                            borderRadius: BorderRadius.circular(15.r),
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: appCubit.isDark
                                    ? lightDarkColor
                                    : mainColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                  color: appCubit.isDark
                                      ? const Color(0xFF30363D)
                                      : mainColor.withOpacity(
                                          0.12,
                                        ),
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: mainColor,
                                size: 20.r,
                              ),
                            ),
                          ),
                        if (currentIndex != 0) SizedBox(width: 12.w),
                        Expanded(
                          child: defaultButton(
                            onPressed: () {
                              if (currentIndex == data.length - 1) {
                                moveAndReplace(
                                  context,
                                  const SelectUserType(),
                                );
                              } else {
                                controller.nextPage(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            text: currentIndex == data.length - 1
                                ? 'ابدأ الآن'
                                : 'التالي',
                            height: 55.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
