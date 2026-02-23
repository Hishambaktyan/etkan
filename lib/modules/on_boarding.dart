import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trying_homy/modules/select_user_type.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import '../main.dart';
import '../shared/styles/colors.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final List<Map<String, String>> walkthroughData = [
    {
      "image": "assets/walk1.png",
      "title": "خدماتك بلمسة زر",
      "text": "انسَ عناء البحث الطويل… كل ما تحتاجه لمنزلك صار بين يديك بثواني"
    },
    {
      "image": "assets/walk2.png",
      "title": "مجالات متنوعة",
      "text": "من السباكة والكهرباء للتكييف والنجارة… كل الخدمات في تطبيق واحد"
    },
    {
      "image": "assets/walk3.png",
      "title": "راحة وتوفير",
      "text": "اطلب الخدمة في أي وقت، استمتع بالسرعة والراحة، ووفر جهدك ومالك"
    },
  ];
  int currentIndex = 0;
  @override
  PageController controller = PageController(viewportFraction: 1);
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemBuilder: (context, index){
                  final walkthrough = walkthroughData[index];
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        walkthrough['image']!,
                        fit: BoxFit.cover,
                        width: 450.w,
                        height: 450.h,
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                        child: Text(
                          walkthrough['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0.sp,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                        child: Text(
                          walkthrough['text']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17.0.sp
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      )
                    ],
                  );
                },
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: 3,

              ),
            ),
            Center(
              child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: mainColor,
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                  )
              ),
            ),
          ],
        ),

      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 30.h),
        child: defualtButton(
            onPressed: (){
              if(currentIndex<2){
                controller.animateToPage(
                    currentIndex+1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease
                );
              }
              else{
                moveAndReplace(context, const SelectUserType());
              }
            },
            background: mainColor,
            text:  currentIndex==2?'ابدأ الآن':'التالي'
        )
      ),
    );
  }
}
