import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';
import '../worker_screens/add_service.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> services = [
    {
      'iconPath': 'assets/SVGs/E.svg',
      'label': 'كهرباء',
    },
    {
      'iconPath': 'assets/SVGs/P.svg',
      'label': 'سباكة',
    },
    {
      'iconPath': 'assets/SVGs/AC.svg',
      'label': 'تكييف',
    },
    {
      'iconPath': 'assets/SVGs/PA.svg',
      'label': 'دهان',
    },
    {
      'iconPath': 'assets/SVGs/C.svg',
      'label': 'بناء',
    },
    {
      'iconPath': 'assets/SVGs/WT.svg',
      'label': 'ماء',
    },
  ];
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,States>(
      listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
            return Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 40.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: Colors.white,
                              foregroundImage: const NetworkImage(
                                  'https://i.pinimg.com/1200x/63/f3/a0/63f3a0fe0c318b623d9a431e2817b515.jpg'
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'صباح الخير 👋',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  'هشام هاني أحمد',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsetsDirectional.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                ),
                                child: SvgPicture.asset(
                                  'assets/not.svg',
                                  width: 23.w,
                                  height: 23.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15.r),
                          onTap: () {},
                          child: Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/loc.svg',
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10.w),
                                const Expanded(
                                  child: Text(
                                    "ابحث هنا...",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  mainColor,
                                  mainColor.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'اطلب خدمتك بسهولة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'اختر الخدمة التي تحتاجها وسيصلك أفضل العمال بسرعة',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                        child: const Text('تصفح الخدمات'),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Container(
                                  height: 90.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Icon(
                                    Icons.home_repair_service_rounded,
                                    size: 50.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'الأقسام',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: (){
                              },
                              child: const Text(
                                  'عرض الكل'
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsetsDirectional.only(bottom: 5.w),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.h,
                            crossAxisSpacing: 10.w,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(15.r),
                                  onTap: () {},
                                  child: Container(
                                    width: 70.w,
                                    height: 70.h,
                                    padding: const EdgeInsetsDirectional.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    ),
                                    child: SvgPicture.asset(
                                      services[index]['iconPath'],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  services[index]['label'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              'الخدمات الرائجة',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            const Spacer(),
                            defaultTextButton(
                                onPressed: (){},
                                text: 'عرض الكل',
                                isLined: false)
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.w,
                              mainAxisExtent: 250.h,
                              crossAxisSpacing: 10.w,
                              mainAxisSpacing: 10.h
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: cubit.isDark ? lightDarkColor : Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 142.h,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadiusDirectional.only(
                                              topStart: Radius.circular(12.r),
                                              topEnd: Radius.circular(12.r),
                                            ),
                                            child: Image.network(
                                              'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                                              height: 130.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.bottomEnd,
                                            child: Container(
                                              height: 27.h,
                                              width: 100.w,
                                              alignment: Alignment.center,
                                              margin: EdgeInsetsDirectional.only(end: 10.w),
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                border: Border.all(color: Colors.white),
                                                borderRadius: BorderRadius.circular(30.r),
                                              ),
                                              child: Text(
                                                '10000 $reyalSymbol',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.topStart,
                                            child: Container(
                                              height: 30.h,
                                              width: 120.w,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsetsDirectional.all(10),
                                              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.9),
                                                borderRadius: BorderRadius.circular(30.r),
                                              ),
                                              child: SizedBox(
                                                height: 30.h,
                                                child: Marquee(
                                                  text: 'تركيب احواض في الحمام',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 11.sp,
                                                  ),
                                                  scrollAxis: Axis.horizontal,
                                                  blankSpace: 40.0,
                                                  velocity: 30.0,
                                                  pauseAfterRound: const Duration(seconds: 3),
                                                  accelerationDuration: const Duration(seconds: 1),
                                                  accelerationCurve: Curves.linear,
                                                  decelerationDuration: const Duration(milliseconds: 500),
                                                  decelerationCurve: Curves.easeOut,
                                                ),
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 10.w,
                                        vertical: 5.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: List.generate(
                                              5,
                                                  (i) => Icon(
                                                Icons.star_rounded,
                                                size: 16.r,
                                                color: i < 4
                                                    ? Colors.orange
                                                    : Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            'تركيب بانيو مصري',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: cubit.isDark ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                foregroundImage: const NetworkImage(
                                                  'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'
                                                ),
                                                radius: 15.r,
                                              ),
                                              SizedBox(
                                                width: 7.w,
                                              ),
                                              SizedBox(
                                                width: 90.w,
                                                child: Text(
                                                  'عبد الله عبد الرحمن',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 10.sp
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  mainColor,
                                  mainColor.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                Positioned(
                                  left: 30,
                                  bottom: -30,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20.r),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'لم تجد الخدمة المناسبة؟',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              'يمكنك نشر إعلان لخدمتك الآن لتصل إلى العمال المهتمين',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            SizedBox(height: 15.h),
                                            ElevatedButton(
                                              onPressed: () => move(context, const AddService()),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: mainColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.r),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: const Text('نشر إعلان الخدمة'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.campaign_rounded,
                                        size: 70.r,
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
    );
  }
}