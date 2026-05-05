import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/select_user_type.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();

  int currentIndex = 0;

  List<Map<String, dynamic>> data = [
    {
      'title': 'خدمات الصيانة بين يديك',
      'body': 'اطلب خدمات الصيانة المنزلية بسهولة، واختر الخدمة المناسبة لك من بين عدة تخصصات.',
      'image': 'assets/walk1.jfif',
      'icon': 'assets/services.svg',
    },
    {
      'title': 'تواصل مباشر مع الفني',
      'body': 'تحدث مع مقدم الخدمة، اتفق على التفاصيل، وتابع حالة الطلب خطوة بخطوة.',
      'image': 'assets/walk2.jfif',
      'icon': 'assets/chat.svg',
    },
    {
      'title': 'اختر بثقة وقيّم الخدمة',
      'body': 'اطّلع على تقييمات مقدمي الخدمات، وبعد انتهاء العمل شارك تجربتك بكل سهولة.',
      'image': 'assets/walk3.jfif',
      'icon': 'assets/star.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 18.w, end: 18.w, top: 10.h,),
                child: Row(
                  children: [
                    Container(
                      height: 42.h,
                      width: 42.w,
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14.r),
                        image: const DecorationImage(image: AssetImage('assets/logo.jpeg'))
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Homy',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    defaultTextButton(
                      onPressed: () => moveAndReplace(
                        context,
                        const SelectUserType(),
                      ),
                      text: 'تخطي',
                      isLined: false,
                      isBold: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
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
                                PositionedDirectional(
                                  top: 25.h,
                                  start: 10.w,
                                  child: CircleAvatar(
                                    radius: 42.r,
                                    backgroundColor:
                                    mainColor.withOpacity(0.08),
                                  ),
                                ),
                                PositionedDirectional(
                                  bottom: 45.h,
                                  end: 5.w,
                                  child: CircleAvatar(
                                    radius: 55.r,
                                    backgroundColor:
                                    mainColor.withOpacity(0.06),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsetsDirectional.all(16.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.r),
                                    boxShadow: blueShadow,
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(24.r),
                                          child: Image.asset(
                                            data[index]['image'],
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      Container(
                                        height: 58.w,
                                        width: 58.w,
                                        decoration: BoxDecoration(
                                          color: mainColor.withOpacity(0.10),
                                          shape: BoxShape.circle,
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
                          Text(
                            data[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: Colors.black,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            data[index]['body'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade700,
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
              SmoothPageIndicator(
                controller: controller,
                count: data.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  activeDotColor: mainColor,
                  dotColor: Colors.grey.shade300,
                  expansionFactor: 3.5,
                  spacing: 6.w,
                ),
              ),
              SizedBox(height: 25.h),
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
                        onTap: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        borderRadius: BorderRadius.circular(15.r),
                        child: Container(
                          height: 55.h,
                          width: 55.w,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(15.r),
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
                      child: defualtButton(
                        onPressed: () {
                          if (currentIndex == data.length - 1) {
                            moveAndReplace(context, const SelectUserType());
                          } else {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        text: currentIndex == data.length - 1
                            ? 'ابدأ الآن'
                            : 'التالي',
                        height: 55,
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
  }
}