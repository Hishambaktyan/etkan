import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trying_homy/modules/notifications_screen.dart';
import 'package:trying_homy/modules/search_screen.dart';
import '../../main.dart';
import '../cubits/app_cubit/app_cubit.dart';
import '../styles/colors.dart';

const List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.black12,
    spreadRadius: 1.0,
    blurRadius: 7.0,
    offset: Offset(2, 5),
  ),
];

 List<BoxShadow> blueShadow =  [
  BoxShadow (
    color: mainColor.withOpacity(0.1),
    spreadRadius: 1.0,
    blurRadius: 7.0,
    offset: const Offset(2, 5),
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
        final dashCount =
            (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1, // سمك الخط
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    ),
  );
}

void showSnackBar(Color background, String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: background,
    duration: const Duration(seconds: 2),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13),
    ),
    elevation: 2,
    behavior: SnackBarBehavior.floating,
    width: MediaQuery.of(context).size.width * 0.50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  ));
}

/////////////////////////////////////////////
Widget header({
  double headerHeight = 110,
  required String title,
  required context,
  bool isLeading=false,
  bool isNotif=true,
  bool isAction=false,
  String? actionIcon,
  Function? onActionPresses
}) {
  return ClipRRect(
    borderRadius:
        BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
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
          ])),
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
                  top: 30.h, start: 10.w, end: 10.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      isLeading?IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                            },
                          icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)
                      ):const SizedBox(),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      isNotif ?InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: ()=>move(context, const NotificationsScreen()),
                        child: Container(
                          padding:  EdgeInsetsDirectional.all(9.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/not.svg',
                            width: 23.w,
                            height: 23.h,
                            color: Colors.white,
                          ),
                        ),
                      ):const SizedBox(),
                      isAction? InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: (){onActionPresses!();},
                        child: Container(
                          padding:  EdgeInsetsDirectional.all(9.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                            ),
                          ),
                          child: SvgPicture.asset(
                            actionIcon!,
                            width: 23.w,
                            height: 23.h,
                            color: Colors.white,
                          ),
                        ),
                      ):const SizedBox()
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
Widget headerWithSearch(
    {double headerHeight = 160,
    required String title,
    required List<String> searchKeyWords,
    bool isLeading = false,
    required BuildContext context}) {
  return ClipRRect(
    borderRadius:
        BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
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
          ])),
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
                  top: 30.h, start: 10.w, end: 10.w, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isLeading)
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            )),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          move(context, const NotificationsScreen());
                        },
                        child: Container(
                          padding:  EdgeInsetsDirectional.all(9.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(13.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                            ),
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
                    onTap: () => move(context, const SearchScreen(),),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/search.svg',
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                              child: IgnorePointer(
                                child: SizedBox(
                                  height: 20,
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                    pause: const Duration(
                                        seconds: 2),
                                    animatedTexts: [
                                      TyperAnimatedText(
                                          searchKeyWords[0],
                                          textStyle:
                                          const TextStyle(
                                              color: Colors
                                                  .grey)),
                                      TyperAnimatedText(
                                          searchKeyWords[1],
                                          textStyle:
                                          const TextStyle(
                                              color: Colors
                                                  .grey)),
                                      TyperAnimatedText(
                                          searchKeyWords[2],
                                          textStyle:
                                          const TextStyle(
                                              color: Colors
                                                  .grey)),
                                    ],
                                  ),
                                ),
                              )),
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
Widget defaultButton({
  double height = 50,
  double textSize = 17,
  double width = double.infinity,
  Color background = mainColor,
  required Function? onPressed,
  required String? text,
}) =>
    Container(
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
          style: TextStyle(fontSize: textSize.sp, color: Colors.white),
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultButtonWithIcon(
        {double height = 50,
        double textSize = 17,
        double width = double.infinity,
        Color background = mainColor,
        required Function? onPressed,
        required String? text,
        required Widget icon}) =>
    Container(
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
            SizedBox(width: 7.w,),
            Text(
              text!,
              style: TextStyle(fontSize: textSize.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultOutlinedButton({
  double height = 50,
  Color border = mainColor,
  Color textColor = mainColor,
  Color bgColor = Colors.transparent,
  required Function? onPressed,
  required String? text,
  double fontSize = 15,
}) =>
    Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: border),
        borderRadius: BorderRadiusDirectional.circular(10.r),
      ),
      child: MaterialButton(
        onPressed: () => onPressed!(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          text!,
          style: TextStyle(fontSize: fontSize.sp, color: textColor),
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultOutlinedButtonWithIcon(
        {double height = 50,
        Color border = mainColor,
        Color textColor = mainColor,
        Color bgColor = Colors.transparent,
        required Function? onPressed,
        required String? text,
        double fontSize = 17,
        required Widget icon}) =>
    Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: border),
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
              style: TextStyle(fontSize: fontSize.sp, color: textColor),
            ),
          ],
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultTextFormfeild(
        {required String? text,
        required String? prefixIcon,
        required String? errorMes,
        required TextEditingController? controller,
        bool isPassword = false,
        bool isSuffixIcon = false,
        String? suffixIcon,
        Function? suffixPressed,
        required TextInputType? type,
        double? fontSize,
        required AppCubit cubit,
        bool isCovered = false}) =>
    TextFormField(
      style: TextStyle(
        fontSize: 14.sp,
        color: cubit.isDark ? Colors.white : Colors.black,
      ),
      keyboardType: type,
      textDirection: TextDirection.rtl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMes;
        }
        return null;
      },
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: cubit.isDark ? lightDarkColor : Colors.white,
        labelText: text,
        labelStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.r),
          child: SvgPicture.asset(
            prefixIcon!,
            width: 18.w,
            height: 18.h,
            color: mainColor,
          ),
        ),
        suffixIcon: isSuffixIcon
            ? IconButton(
          onPressed: () {
            suffixPressed!();
          },
          icon: SvgPicture.asset(
            suffixIcon!,
            width: 20.w,
            height: 20.h,
            color: Colors.grey,
          ),
          highlightColor: Colors.transparent,
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade100,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: mainColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
/////////////////////////////////////////////
Widget defaultTextButton({
  required Function onPressed,
  required String text,
  bool isUpperCase = true,
  Color color = mainColor,
  bool isLined = true,
  bool isBold = false,
}) =>
    TextButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            decoration: isLined ? TextDecoration.underline : null,
            decorationColor: mainColor,
          ),
        ));

class ChatShimmerLoading extends StatelessWidget {
  final bool isDark;
  const ChatShimmerLoading({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color baseColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);
    Color highlightColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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

class WorkerHomeShimmer extends StatelessWidget {
  final bool isDark;
  const WorkerHomeShimmer({super.key, required this.isDark});

  Color get baseColor => isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor => isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor => isDark ? const Color(0xFF161B22) : const Color(0xFFF2F9FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            height: 200.h,
            width: double.infinity,
            radius: 30.r,
          ),
          SizedBox(height: 15.h),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _shimmerBox(
              height: 100.h,
              width: double.infinity,
              radius: 25,
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: _shimmerBox(height: 25.h, width: 120.w, radius: 10),
          ),
          SizedBox(height: 10.h),
          _shimmerBox(
            height: 90.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            radius: 25,
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(height: 25.h, width: 120.w, radius: 10),
                _shimmerBox(height: 20.h, width: 60.w, radius: 5),
              ],
            ),
          ),
          GridView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(10.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 250.h,
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 15.h,
            ),
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Column(
                children: [
                  _shimmerBox(
                    height: 120.h,
                    width: double.infinity,
                    radius: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(height: 12.h, width: 40.w),
                        SizedBox(height: 8.h),
                        _shimmerBox(height: 14.h, width: double.infinity),
                        SizedBox(height: 6.h),
                        _shimmerBox(height: 10.h, width: 80.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          _shimmerBox(
            height: 160.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            radius: 30,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    double radius = 12,
    EdgeInsetsDirectional? margin,
  }) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius.r),
          ),
        ),
      ),
    );
  }
}

class UserHomeShimmer extends StatelessWidget {
  final bool isDark;

  const UserHomeShimmer({super.key, required this.isDark});

  Color get baseColor => isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor => isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [

          /// ================= HEADER =================
          _shimmerBox(height: 160.h, width: double.infinity,radius: 30),

          SizedBox(height: 15.h),

          /// ================= BANNER =================
          _shimmerBox(
            height: 140.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            radius: 15,
          ),

          SizedBox(height: 30.h),

          /// ================= TITLE =================
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
              child: _shimmerBox(width: 120.w, height: 18.h),
            ),
          ),

          SizedBox(height: 15.h),

          /// ================= GRID (SIMPLIFIED) =================
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 2.1,
              ),
              itemBuilder: (context, index) {
                return _shimmerBox(height: 80.h);
              },
            ),
          ),

          SizedBox(height: 30.h),

          /// ================= TITLE =================

        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: _shimmerBox(width: 120.w, height: 18.h),
          ),
        ),

        SizedBox(height: 15.h),

          /// ================= HORIZONTAL LIST =================
          SizedBox(
            height: 300.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsetsDirectional.only(start: 10.w),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 10.w),
                  child: _shimmerBox(
                    width: 280.w,
                    height: double.infinity,
                    radius: 15,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// ================= SHIMMER BOX =================
  Widget _shimmerBox({
    required double height,
    double? width,
    double radius = 10,
    EdgeInsetsDirectional? margin,
  }) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius.r),
          ),
        ),
      ),
    );
  }
}

class UserServicesShimmer extends StatelessWidget {
  const UserServicesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = AppCubit.get(context).isDark;

    Color baseColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);
    Color highlightColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);
    Color containerColor = isDark ? lightDarkColor : const Color(0xFFF2F9FF);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Shimmer
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: 200.h,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15.h),

              SizedBox(height: 15.h),
              // Services List Shimmer (Vertical ListView)
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemBuilder: (context, index) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: containerColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Shimmer
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 150.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.r)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _shimmerBox(
                                    150.w, 15.h, baseColor, highlightColor),
                                _shimmerBox(
                                    60.w, 25.h, baseColor, highlightColor,
                                    radius: 30.r),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            _shimmerBox(40.w, 12.h, baseColor, highlightColor),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                Shimmer.fromColors(
                                  baseColor: baseColor,
                                  highlightColor: highlightColor,
                                  child: CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: Colors.white),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _shimmerBox(
                                        120.w, 10.h, baseColor, highlightColor),
                                    SizedBox(height: 5.h),
                                    _shimmerBox(
                                        50.w, 10.h, baseColor, highlightColor),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, Color base, Color highlight,
      {double radius = 5}) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
    );
  }
}

class UserBookingsShimmer extends StatelessWidget {
  final bool isDark;

  const UserBookingsShimmer({super.key, required this.isDark});

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor =>
      isDark ? const Color(0xFF161B22) : const Color(0xFFF2F9FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _shimmerBox(
            height: 55.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.all(10.w),
            radius: 15,
          ),
          SizedBox(height: 15.h),

          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsetsDirectional.only(start: 10.w),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _shimmerBox(
                  width: 90.w,
                  height: 35.h,
                  radius: 25,
                  margin: EdgeInsetsDirectional.only(end: 10.w),
                );
              },
            ),
          ),

          SizedBox(height: 20.h),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h),
                child: Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _shimmerBox(
                            width: 70.w,
                            height: 70.h,
                            radius: 20,
                          ),
                          SizedBox(width: 15.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _shimmerBox(
                                    height: 14.h, width: double.infinity),
                                SizedBox(height: 8.h),
                                _shimmerBox(height: 12.h, width: 100.w),
                              ],
                            ),
                          ),

                          SizedBox(width: 10.w),

                          _shimmerBox(
                            width: 60.w,
                            height: 25.h,
                            radius: 30,
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0D1117)
                              : const Color(0xFFEAF4FF),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            _detailRow(),
                            SizedBox(height: 12.h),
                            _detailRow(),
                            SizedBox(height: 12.h),
                            _detailRow(),
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
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    double radius = 12,
    EdgeInsetsDirectional? margin,
  }) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius.r),
          ),
        ),
      ),
    );
  }

  Widget _detailRow() {
    return Row(
      children: [
        _shimmerBox(width: 30.w, height: 30.h, radius: 10),
        SizedBox(width: 10.w),
        _shimmerBox(width: 70.w, height: 10.h),
        SizedBox(width: 10.w),
        Expanded(
          child: _shimmerBox(height: 10.h, width: double.infinity),
        ),
      ],
    );
  }
}

class AddressManagementShimmer extends StatelessWidget {
  final bool isDark;

  const AddressManagementShimmer({super.key, required this.isDark});

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor =>
      isDark ? const Color(0xFF161B22) : const Color(0xFFF2F9FF);

  Color get innerContainerColor =>
      isDark ? const Color(0xFF0D1117) : const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _shimmerBox(
            height: 120.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.all(10.w),
            radius: 20,
          ),

          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                _shimmerBox(width: 35.w, height: 35.h),
                SizedBox(width: 10.w),
                _shimmerBox(width: 140.w, height: 14.h),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: 20.h),
                child: Container(
                  padding: EdgeInsetsDirectional.all(12.w),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _shimmerBox(width: 45.w, height: 45.h, radius: 12),
                          SizedBox(width: 10.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _shimmerBox(
                                    height: 12.h,
                                    width: double.infinity),
                                SizedBox(height: 8.h),
                                _shimmerBox(
                                    height: 10.h,
                                    width: 120.w),
                              ],
                            ),
                          ),

                          SizedBox(width: 10.w),
                          _shimmerBox(width: 50.w, height: 18.h),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: innerContainerColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            _detailRow(),
                            SizedBox(height: 10.h),
                            _detailRow(),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _shimmerBox(height: 42.h),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _shimmerBox(height: 42.h),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      _shimmerBox(height: 42.h),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 20.h),

          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: _shimmerBox(height: 50.h, radius: 14),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    double? width,
    double radius = 10,
    EdgeInsetsDirectional? margin,
  }) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius.r),
          ),
        ),
      ),
    );
  }

  Widget _detailRow() {
    return Row(
      children: [
        _shimmerBox(width: 25.w, height: 25.h),
        SizedBox(width: 10.w),
        _shimmerBox(width: 80.w, height: 10.h),
        SizedBox(width: 10.w),
        Expanded(
          child: _shimmerBox(height: 10.h),
        ),
      ],
    );
  }
}