import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trying_homy/modules/search_screen.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import '../../modules/user_screens/booking_details_screen.dart';
import '../../main.dart';
import '../../modules/user_screens/worker_details.dart';
import '../styles/colors.dart';
const List<BoxShadow> shadow =  [
  BoxShadow (
    color: Colors.black12,
    spreadRadius: 1.0,
    blurRadius: 7.0,
    offset: Offset(2, 5),
  ),
];
const String reyalSymbol = '\uFDFC';
Widget dashedDivider(color) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 3.0;
        final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1, // سمك الخط
              child: DecoratedBox(
                decoration: BoxDecoration(color:color),
              ),
            );
          }),
        );
      },
    ),
  );
}
void showSnackBar(Color background,String message,context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: background,
    duration: const Duration(seconds: 2),
    content: Text(message,textAlign: TextAlign.center,style: const TextStyle(fontSize: 13),),
    elevation: 2,
    behavior: SnackBarBehavior.floating,
    width: MediaQuery.of(context).size.width * 0.50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  )
  );
}
/////////////////////////////////////////////
Widget header({
  double headerHeight = 110,
  required String title,
  context
})
{
  return ClipRRect(
  borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
  child: Container(
    height: headerHeight,
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
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
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
              ],
            ),
          ),
        )
      ],
    ),
  ),
);
}
/////////////////////////////////////////////
 Widget headerWithSearch({
  double headerHeight = 160,
  required String title,
   required List<String> searchKeyWords,
   bool isLeading = false,
   required BuildContext context
})
{
  return ClipRRect(
  borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
  child: Container(
    height: headerHeight.h,
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
                    if(isLeading)IconButton(
                        onPressed: ()=>Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
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
                  onTap: ()=>move(context, const SearchScreen()),
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
                                  TyperAnimatedText(searchKeyWords[0],textStyle: const TextStyle(color: Colors.grey)),
                                  TyperAnimatedText(searchKeyWords[1],textStyle: const TextStyle(color: Colors.grey)),
                                  TyperAnimatedText(searchKeyWords[1],textStyle: const TextStyle(color: Colors.grey)),
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
);
}
/////////////////////////////////////////////
Widget defualtButton({
  double height = 50,
  double textSize = 17,
  double width = double.infinity,
  Color background = mainColor,
  required Function? onPressed,
  required String? text,
})
=> Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadiusDirectional.circular(12.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Text(
      text!,
      style: TextStyle(
          fontSize:textSize.sp,
          color: Colors.white
      ),
    ),
  ),
);
////////////////////////////////////////////
Widget defualtButtonWithIcon({
  double height = 50,
  double textSize = 17,
  double width = double.infinity,
  Color background = mainColor,
  required Function? onPressed,
  required String? text,
  required Widget icon
})
=> Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadiusDirectional.circular(12.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(
          width: 7.w,
        ),
        Text(
          text!,
          style: TextStyle(
              fontSize: textSize.sp,
              color: Colors.white
          ),
        ),
      ],
    ),
  ),
);
////////////////////////////////////////////
Widget defualtOutlinedButton({
  double height = 50,
  Color border = mainColor,
  Color textColor = mainColor,
  Color bgColor = Colors.transparent,
  required Function? onPressed,
  required String? text,
  double fontSize = 15,
})
=> Container(
  height: height,
  width: double.infinity,
  decoration: BoxDecoration(
    color: bgColor,
    border: Border.all(
      color: border
    ),
    borderRadius: BorderRadiusDirectional.circular(10.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Text(
      text!,
      style: TextStyle(
          fontSize: fontSize.sp,
          color: textColor
      ),
    ),
  ),
);
////////////////////////////////////////////
Widget defualtOutlinedButtonWithIcon({
  double height = 50,
  Color border = mainColor,
  Color textColor = mainColor,
  Color bgColor = Colors.transparent,
  required Function? onPressed,
  required String? text,
  double fontSize = 17,
  required Widget icon
})
=> Container(
  height: height,
  width: double.infinity,
  decoration: BoxDecoration(
    color: bgColor,
    border: Border.all(
        color: border
    ),
    borderRadius: BorderRadiusDirectional.circular(10.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(
          width: 7.w,
        ),
        Text(
          text!,
          style: TextStyle(
              fontSize: fontSize.sp,
              color: textColor
          ),
        ),
      ],
    ),
  ),
);
////////////////////////////////////////////
Widget defaultTextFormfeild(
    {
      required String? text,
      required String? prefixIcon,
      required String? errorMes,
      required TextEditingController? controller,
      bool isPassword = false,
      bool isSuffixIcon = false,
      String? suffixIcon,
      Function? suffixPressed,
      required TextInputType? type,
      double? fontSize,
      required MyCubit cubit,
      bool isCovered=false
    }
    )
=>TextFormField(
  style: TextStyle(
    fontSize: 12.sp
  ),
  keyboardType: type,
  textDirection: TextDirection.rtl,
  validator: (value) {
    if(value == null || value.isEmpty){
      return errorMes;
    }
    return null;
  },
  controller: controller,
  obscureText: isPassword,
  decoration:InputDecoration(
    filled: true,
    fillColor: cubit.isDark? isCovered? darkBgColor: lightDarkColor : isCovered?Colors.white:Colors.grey.withOpacity(0.1),
    labelText: text,
    labelStyle: TextStyle(
      fontSize: 12.sp,
      color: cubit.isDark? darkSubTextColor: Colors.grey
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(
        prefixIcon!,
        width: 12.w,
        height:12.h,
        color:  cubit.isDark? darkSubTextColor: Colors.grey,
      ),
    ),
    suffixIcon: isSuffixIcon? IconButton(
          onPressed: (){
            suffixPressed!();
          },
          icon: SvgPicture.asset(
            suffixIcon!,
            width:22.w,height:22.h,
            color:  cubit.isDark? darkSubTextColor: Colors.grey,
          ),
      highlightColor: Colors.transparent,
      ) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(
        color: mainColor
    )
),
    errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(
        color: Colors.red
    )
),

  ),
);
/////////////////////////////////////////////
Widget defaultTextButton({
  required Function onPressed,
  required String text,
  bool isUpperCase =true,
  Color color = mainColor,
  bool isLined = true,
  bool isBold = false,
})
=>TextButton(
    onPressed: (){
      onPressed();
    },
    child: Text(
      isUpperCase?text.toUpperCase():text,
      style:TextStyle(
          color: color,
          fontWeight: isBold? FontWeight.bold: FontWeight.normal,
          decoration: isLined?TextDecoration.underline:null,
        decorationColor: mainColor,
      ),
    )
);

class CategoryBuilder extends StatelessWidget {
  final String imagePath;       // مسار الصورة
  final String label;           // النص
  final double iconSize;        // حجم الصورة داخل الـ CircleAvatar
  final double textSize;        // حجم النص
  final double spacing;         // المسافة بين الأيقونة والنص

  const CategoryBuilder({
    Key? key,
    required this.imagePath,
    required this.label,
    this.iconSize = 40,
    this.textSize = 13,
    this.spacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: shadow
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              imagePath,
            ),
          ),
        ),
        SizedBox(height: spacing.h),
        Text(
          label,
          style: TextStyle(fontSize: textSize.sp),
        ),
      ],
    );
  }
}

class ChatShimmerLoading extends StatelessWidget {
  final bool isDark;
  const ChatShimmerLoading({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    Color highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(start: 10.w, top: 20.h, end: 10.w),
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(height: 17.h),
        itemBuilder: (context, index) => Row(
          children: [
            CircleAvatar(
              radius: 23.r,
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 120.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 40.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingShimmerLoading extends StatelessWidget {
  final bool isDark;
  const BookingShimmerLoading({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color baseColor = isDark ? const Color(0xFF161B22) : Colors.grey[300]!;
    Color highlightColor = isDark ? const Color(0xFF30363D) : Colors.grey[100]!;

    Color cardBgColor = isDark ? Colors.white.withOpacity(0.05) : Colors.transparent;

    Color contentColor = isDark ? Colors.white : Colors.grey[400]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: ShimmerDirection.rtl,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 5.h, bottom: 20.h),
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsetsDirectional.only(bottom: 20.h),
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: isDark ? const Color(0xFF30363D) : Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: contentColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 100.w, height: 12.h, decoration: BoxDecoration(color: contentColor, borderRadius: BorderRadius.circular(4.r))),
                              const Spacer(),
                              Container(width: 55.w, height: 28.h, decoration: BoxDecoration(color: contentColor, borderRadius: BorderRadius.circular(6.r))),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(width: 70.w, height: 8.h, decoration: BoxDecoration(color: contentColor, borderRadius: BorderRadius.circular(4.r))),
                          SizedBox(height: 12.h),
                          Container(width: 50.w, height: 14.h, decoration: BoxDecoration(color: contentColor, borderRadius: BorderRadius.circular(4.r))),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: isDark ? const Color(0xFF30363D) : Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      _buildShimmerDetailRow(contentColor),
                      _buildShimmerDivider(isDark),
                      _buildShimmerDetailRow(contentColor),
                      _buildShimmerDivider(isDark),
                      _buildShimmerDetailRow(contentColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerDetailRow(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(width: 10.w),
          Container(width: 40.w, height: 8.h, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4.r))),
          SizedBox(width: 20.w),
          Expanded(child: Container(height: 8.h, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4.r)))),
        ],
      ),
    );
  }

  Widget _buildShimmerDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: Container(
        width: double.infinity,
        height: 1.h,
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!,
      ),
    );
  }
}

class WorkerHomeShimmer extends StatelessWidget {
  final bool isDark;
  const WorkerHomeShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color baseColor = isDark ? const Color(0xFF161B22) : Colors.grey[300]!;
    Color highlightColor = isDark ? const Color(0xFF30363D) : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: ShimmerDirection.rtl,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 340.h,
              child: Stack(
                children: [
                  Container(
                    height: 270.h,
                    padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, top: 35.h),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 23.r, backgroundColor: Colors.white),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: 100.w, height: 15.h, color: Colors.white),
                                SizedBox(height: 5.h),
                                Container(width: 60.w, height: 10.h, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(width: 120.w, height: 30.h, color: Colors.white),
                            SizedBox(height: 10.h),
                            Container(width: 80.w, height: 15.h, color: Colors.white),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 115.h,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsetsDirectional.only(end: 10.w),
                          width: 170.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 110.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Container(width: 120.w, height: 20.h, color: Colors.white),
                  const Spacer(),
                  Container(width: 60.w, height: 15.h, color: Colors.white),
                ],
              ),
            ),
            GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(10.w),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.w,
                mainAxisExtent: 240.h,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 110.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(12.r)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 60.w, height: 10.h, color: Colors.white),
                          SizedBox(height: 10.h),
                          Container(width: double.infinity, height: 12.h, color: Colors.white),
                          SizedBox(height: 5.h),
                          Container(width: 80.w, height: 10.h, color: Colors.white),
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
    );
  }
}


