  import 'dart:ui';

  import 'package:animated_text_kit/animated_text_kit.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:marquee/marquee.dart';
  import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trying_homy/modules/user_screens/electric_workers.dart';
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
                          child: Container(
                            height: 160.h,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      mainColor.withOpacity(0.9),
                                      const Color(0xFF0F0F1E),
                                    ],
                                    stops: const [
                                      0.0,
                                      0.8,
                                    ]
                                )
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -50.h,
                                  left: -50.w,
                                  child: CircleAvatar(
                                    radius: 100.r,
                                    backgroundColor: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                                Positioned(
                                  top: 80.h,
                                  right: -60.w,
                                  child: Container(
                                    width: 250.r,
                                    height: 250.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          const Color(0xFF00F2FF).withOpacity(0.5),
                                          const Color(0xFF00F2FF).withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 200.h,
                                  left: -40.w,
                                  child: Container(
                                    width: 200.r,
                                    height: 200.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          mainColor.withOpacity(0.4),
                                          mainColor.withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                                      child: Container(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w,bottom: 20.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/loc.svg'
                                              ,color: Colors.white,
                                              width: 35.w,
                                              height: 35.h,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'موقعك',
                                                  style:  TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13.sp,
                                                      color: Colors.white,
                                                      height: 1
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  'عدن - المنصورة - ريمي',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.white,
                                                      height: 1
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
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(10.r),
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/not.svg',
                                                  width: 23.w,
                                                  height: 23.h,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          borderRadius: BorderRadius.circular(15.r),
                                          onTap: () {},
                                          child: Container(
                                            height: 50,
                                            padding: const EdgeInsets.symmetric(horizontal: 17),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30.r),
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/search.svg',
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                    child: SizedBox(
                                                      height: 20,
                                                      child: AnimatedTextKit(
                                                        repeatForever: true,
                                                        pause: const Duration(seconds: 2),
                                                        animatedTexts: [
                                                          TyperAnimatedText("ابحث عن خدمات",textStyle: const TextStyle(color: Colors.grey)),
                                                          TyperAnimatedText("ابحث عن أقسام",textStyle: const TextStyle(color: Colors.grey)),
                                                          TyperAnimatedText("ابحث عن فني تكييف",textStyle: const TextStyle(color: Colors.grey)),
                                                          TyperAnimatedText("ابحث عن كهربائي",textStyle: const TextStyle(color: Colors.grey)),
                                                          TyperAnimatedText("ابحث عن سبّاك",textStyle: const TextStyle(color: Colors.grey)),
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        Column(
                          children: [
                            /*بانر ترحيبي*/
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Container(
                                  height: 140.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        mainColor,
                                        mainColor.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: -25,
                                        top: -25,
                                        child: CircleAvatar(
                                          radius: 45.r,
                                          backgroundColor: Colors.white.withOpacity(0.12),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        bottom: -25,
                                        child: CircleAvatar(
                                          radius: 30.r,
                                          backgroundColor: Colors.white.withOpacity(0.10),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'أهلا بك 👋',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    'ابحث عن أفضل العمال والخدمات',
                                                    style: TextStyle(
                                                      color: Colors.white.withOpacity(0.9),
                                                      fontSize: 13.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 40.r,
                                              backgroundColor: Colors.white.withOpacity(0.2),
                                              child: Transform.rotate(
                                                angle: -0.2,
                                                child: SvgPicture.asset(
                                                  'assets/ticket_bold.svg',
                                                  color: Colors.white,
                                                  width: 50.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            /*الأقسام*/
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                              child: Column(
                                children: [
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
                                        onPressed: ()=>cubit.changeIndex(1),
                                        child: const Text(
                                            'عرض الكل'
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h,),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    padding:EdgeInsetsDirectional.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10.h,
                                      crossAxisSpacing: 10.w,
                                      childAspectRatio: 2.1,
                                    ),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(15.r),
                                        onTap: ()=>move(context, const ElectricServices()),
                                        child: Container(
                                          padding: const EdgeInsetsDirectional.all(10),
                                          decoration: BoxDecoration(
                                              color: mainColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(15.r)
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 55.w,
                                                height: 55.h,
                                                padding: const EdgeInsetsDirectional.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15.r),
                                                ),
                                                child: SvgPicture.asset(
                                                  services[index]['iconPath'],
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                services[index]['label'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: mainColor,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            /*الخدمات الرائجة*/
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                                  child: Row(
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
                                ),
                                SizedBox(height: 5.h,),
                                SizedBox(
                                  height: 320.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsetsDirectional.only(start:15.w),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsetsDirectional.only(start: index==0?0:15.w,end: index==3?15.w:0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          borderRadius: BorderRadius.circular(12.r),
                                          onTap: () {},
                                          child: Container(
                                            width: 300.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.r),
                                              color: cubit.isDark ? lightDarkColor : mainColor.withOpacity(0.1),
                                            ),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadiusDirectional.only(
                                                        topStart: Radius.circular(15.r),
                                                        topEnd: Radius.circular(15.r),
                                                      ),
                                                      child: Image.network(
                                                        'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                                                        height: 150.h,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) => Container(
                                                          height: 150.h,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadiusDirectional.only(
                                                                topStart: Radius.circular(15.r),
                                                                topEnd: Radius.circular(15.r),
                                                              ),
                                                              color: Colors.grey.shade200
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: AlignmentDirectional.topStart,
                                                      child: Container(
                                                        width: 90.w,
                                                        alignment: Alignment.center,
                                                        margin: EdgeInsetsDirectional.only(top: 10.h,start: 10.w),
                                                        padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 5.w),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white.withOpacity(0.5),
                                                          border: Border.all(color: Colors.white),
                                                          borderRadius: BorderRadius.circular(30.r),
                                                        ),
                                                        child: Text(
                                                          'السباكة',
                                                          style: TextStyle(
                                                            color:mainColor,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20.h,),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.only(start: 10.w,end: 10.w),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'تركيب بانيو مصري مصري مصري',
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14.sp,
                                                                color: cubit.isDark ? Colors.white : Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 7.w),
                                                            decoration: BoxDecoration(
                                                              color: mainColor,
                                                              border: Border.all(color: Colors.white),
                                                              borderRadius: BorderRadius.circular(30.r),
                                                            ),
                                                            child: Text(
                                                              '100000 $reyalSymbol',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 13.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h,),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.star_rounded,color: Colors.orange,
                                                          ),
                                                          SizedBox(width: 5.w,),
                                                          const Text(
                                                            '3.8',
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.h,),
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            foregroundImage: const NetworkImage(
                                                                'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'
                                                            ),
                                                            radius: 20.r,
                                                          ),
                                                          SizedBox(width: 10.w,),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: 200.w,
                                                                child: Text(
                                                                  'عبد الله عبد الرحمن ناصر ناصر',
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize: 12.sp
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                'سباك',
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: 12.sp,
                                                                  color: Colors.grey
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ],
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
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h,),
                            /*اعلان نشر حدمة*/
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                              child: ClipRRect(
                                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(15.r),topEnd:Radius.circular(15.r) ),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              );
            },
      );
    }
  }