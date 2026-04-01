import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = [
    'تركيب مكيفات سبليت',
    'صيانة تسربات الحمام',
    'دهانات جوتن داخلية',
  ];

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  bool isPrimary = false;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusDirectional.vertical(
                    bottom: Radius.circular(30.r)),
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
                      stops: const [0.0, 0.8],
                    ),
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
                          padding: EdgeInsetsDirectional.only(
                            top: 30.h,
                            start: 10.w,
                            end: 10.w,
                            bottom: 20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/loc.svg',
                                    color: Colors.white,
                                    width: 35.w,
                                    height: 35.h,
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'موقعك',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        'عدن - المنصورة - ريمي',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          height: 1,
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
                                      padding:
                                          const EdgeInsetsDirectional.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                              Container(
                                height: 57.h,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 17),
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
                                      child: TextField(
                                        controller: searchController,
                                        focusNode: searchFocusNode,
                                        autofocus: true,
                                        textInputAction: TextInputAction.search,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'ابحث عن خدمات',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.sp,
                                          ),
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                        ),
                                        onSubmitted: (value) {},
                                      ),
                                    ),
                                  ],
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
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsetsDirectional.only(
                    end: 10.w, start: 10.w, top: 10.h, bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'عمليات البحث الأخيرة',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              recentSearches.clear();
                            });
                          },
                          child: Text(
                            'مسح الكل',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (recentSearches.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentSearches.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade300,
                          height: 1.h,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      recentSearches.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.blueGrey.shade200,
                                    size: 20.w,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    recentSearches[index],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.history,
                                  color: Colors.blueGrey.shade200,
                                  size: 20.w,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          'لا توجد عمليات بحث أخيرة',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    SizedBox(height: 15.h),
                    Text(
                      'الأقسام الشائعة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsetsDirectional.zero,
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
                          borderRadius: BorderRadius.circular(15.r),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsetsDirectional.all(10),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.r)),
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
                    SizedBox(height: 22.h),
                    Text(
                      'خدمات مقترحة لك',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    ListView.separated(
                      padding: EdgeInsetsDirectional.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: mainColor.withOpacity(0.1),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 142.h,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusDirectional.only(
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
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        child: Container(
                                          height: 27.h,
                                          width: 100.w,
                                          alignment: Alignment.center,
                                          margin: EdgeInsetsDirectional.only(
                                              end: 10.w),
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(30.r),
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
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Container(
                                            height: 30.h,
                                            width: 120.w,
                                            alignment: Alignment.center,
                                            margin:
                                                const EdgeInsetsDirectional.all(
                                                    10),
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
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
                                                pauseAfterRound:
                                                    const Duration(seconds: 3),
                                                accelerationDuration:
                                                    const Duration(seconds: 1),
                                                accelerationCurve:
                                                    Curves.linear,
                                                decelerationDuration:
                                                    const Duration(
                                                        milliseconds: 500),
                                                decelerationCurve:
                                                    Curves.easeOut,
                                              ),
                                            )),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            foregroundImage: const NetworkImage(
                                                'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'),
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
                                              style: TextStyle(fontSize: 10.sp),
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
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
