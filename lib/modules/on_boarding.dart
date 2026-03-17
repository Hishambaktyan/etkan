import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final PageController controller =
  PageController(viewportFraction: 0.65);

  int currentIndex = 0;

  List<Map<String,dynamic>> data=[
    {
      'title': 'خدمتك لحد باب البيت',
      'body': 'في خطوات بسيطة نوصلك بأفضل المتخصصين في منطقتك لتلبية احتياجاتك المنزلية.',
      'image': "assets/walk1.jfif",
    },
    {
      'title': 'تواصل مباشر وآمن',
      'body': 'تحدث مع العامل مباشرة، اتفق على التفاصيل، واحصل على خدمة موثوقة بكل شفافية.',
      'image': "assets/walk2.jfif",
    },
    {
      'title': 'قيّم واختر الأفضل',
      'body': 'اطلع على تقييمات العملاء السابقين واختر العامل الأنسب لاحتياجك بثقة تامة.',
      'image': "assets/walk3.jfif",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          actions: [
            defaultTextButton(
              onPressed: ()=>moveAndReplace(context, const SelectUserType()),
              text: 'تخطي',
              isLined: false,
              isBold: true
            ),
            SizedBox(width: 5.w),
          ],
        ),
        body: Column(
          children: [
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
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      double value = 1.0;
                      if (controller.position.haveDimensions) {
                        double page = controller.page ?? controller.initialPage.toDouble();
                        double difference = (page - index).abs();

                        value = (1 - (difference * 0.35)).clamp(0.75, 1.0);
                      }
                      bool isCenter = index == currentIndex;
                      return Transform.scale(
                        scale: value,
                        child: Padding(
                          padding: isCenter
                              ? EdgeInsets.symmetric(horizontal: 10.w)
                              : EdgeInsets.symmetric(horizontal: 25.w),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 340.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    boxShadow: isCenter
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 30,
                                        offset: const Offset(0, 20),
                                      )
                                    ]
                                        : [],
                                    image: DecorationImage(
                                      image: AssetImage(data[index]['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              data[currentIndex]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:20.sp,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
              child: Text(
                data[currentIndex]['body'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            SmoothPageIndicator(
              controller: controller,
              count: data.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: mainColor,
                dotColor: Colors.grey.shade300,
                expansionFactor: 3,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: 20.w, end: 20.w, bottom: 30.h),
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
    );
  }
}