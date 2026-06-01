import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:lottie/lottie.dart';
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

List<BoxShadow> blueShadow = [
  BoxShadow(
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

void showSnackBar(
  Color background,
  String message,
  BuildContext context,
) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: background,
        duration: const Duration(seconds: 2),
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsetsDirectional.symmetric(
          horizontal: 40.w,
          vertical: 10.h,
        ),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
}

String formatStatusTime(dynamic timestamp) {
  if (timestamp == null) return "";
  DateTime date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy - hh:mm a')
      .format(date)
      .replaceAll('AM', 'ص')
      .replaceAll('PM', 'م');
}

String dateFormatStatusTime(dynamic timestamp) {
  if (timestamp == null) return "";
  DateTime date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy').format(date);
}

String timeFormatStatusTime(dynamic timestamp) {
  if (timestamp == null) return '';

  DateTime date;

  if (timestamp is Timestamp) {
    date = timestamp.toDate();
  } else if (timestamp is DateTime) {
    date = timestamp;
  } else {
    return '';
  }

  return DateFormat('hh:mm a')
      .format(date)
      .replaceAll('AM', 'ص')
      .replaceAll('PM', 'م');
}

/////////////////////////////////////////////
Widget header(
    {double headerHeight = 110,
    required String title,
    required context,
    bool isLeading = false,
    bool isNotif = true,
    bool isAction = false,
    String? actionIcon,
    Function? onActionPresses}) {
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
                      isLeading ? InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42.w,
                          height: 42.h,
                          margin: EdgeInsetsDirectional.only(end: 10.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      )
                          : const SizedBox(),
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 23.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      isAction
                          ? InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                onActionPresses!();
                              },
                              child: Container(
                                margin: EdgeInsetsDirectional.only(end: 10.w),
                                padding: EdgeInsetsDirectional.all(9.w),
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
                            )
                          : const SizedBox(),
                      isNotif
                          ? InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () =>
                                  move(context, const NotificationsScreen()),
                              child: Container(
                                width: 42.w,
                                height: 42.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.12)),
                                ),
                                child: SvgPicture.asset(
                                  'assets/not.svg',
                                  width: 23.w,
                                  height: 23.h,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox(),
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
    required AppCubit appCubit,
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
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 42.w,
                            height: 42.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.12)),
                            ),
                            child: Icon(
                              CupertinoIcons.back,
                              color: Theme.of(context).iconTheme.color,
                              size: 24.r,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 12.w,
                      ),
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
                          width: 42.w,
                          height: 42.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.12)),
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
                    onTap: () => move(
                      context,
                      const SearchScreen(),
                    ),
                    child: Container(
                      height: 52.h,
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      decoration: BoxDecoration(
                        color: appCubit.isDark ? darkBgColor : Colors.white,
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
                              child: IgnorePointer(
                            child: SizedBox(
                              height: 20,
                              child: AnimatedTextKit(
                                repeatForever: true,
                                pause: const Duration(seconds: 2),
                                animatedTexts: [
                                  TyperAnimatedText(searchKeyWords[0],
                                      textStyle:
                                          const TextStyle(color: Colors.grey)),
                                  TyperAnimatedText(searchKeyWords[1],
                                      textStyle:
                                          const TextStyle(color: Colors.grey)),
                                  TyperAnimatedText(searchKeyWords[2],
                                      textStyle:
                                          const TextStyle(color: Colors.grey)),
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
            SizedBox(
              width: 7.w,
            ),
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
Widget defaultTextFormField(
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
        bool isCovered = false,
        bool isReadOnly = false}) =>
    TextFormField(
      style: TextStyle(
        fontSize: 14.sp,
        color: cubit.isDark ? Colors.white : Colors.black,
      ),
      readOnly: isReadOnly,
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
        labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
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
            color:
                cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade100,
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
/////////////////////////////////////////////
Widget buildHeaderButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    borderRadius: BorderRadius.circular(15.r),
    onTap: onTap,
    child: Container(
      width: 42.w,
      height: 42.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18.sp,
      ),
    ),
  );
}

/////////////////////////////////////////////
Widget buildButton({
  required BuildContext context,
  required bool isDark,
  required IconData icon,
  required VoidCallback onTap,
  Color? iconColor,
  Color? backgroundColor,
}) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark
                ? darkBgColor.withOpacity(0.8)
                : Colors.white.withOpacity(0.8)),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        size: 23.r,
      ),
    ),
  );
}

int getStepFromStatus(String status) {
  switch (status) {
    case "قيد الانتظار":
      return 0; // تم الطلب
    case "مقبول":
      return 1; // تم القبول
    case "في الطريق":
      return 2; // في الطريق
    case "مكتمل":
      return 3; // تم اكمال الخدمة
    default:
      return 0;
  }
}

bool isLoadingDialogShowing = false;

void defaultConfirmDialog({
  required BuildContext context,
  required bool isDark,
  required String icon,
  required Color iconColor,
  required String title,
  required String body,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  Color? confirmColor,
  Color? cancelColor,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.25),
    builder: (BuildContext dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: AlertDialog(
                backgroundColor: isDark ? lightDarkColor : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(22.r),
                ),
                contentPadding: EdgeInsetsDirectional.all(22.r),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: EdgeInsetsDirectional.all(16.r),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          icon,
                          color: iconColor,
                          width: 50.w,
                        )),
                    SizedBox(height: 20.h),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      body,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? darkSubTextColor : Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      children: [
                        Expanded(
                          child: defaultButton(
                            onPressed: onCancel ??
                                () {
                                  Navigator.pop(dialogContext);
                                },
                            text: cancelText,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: defaultOutlinedButton(
                            onPressed: () {
                              onConfirm();
                            },
                            text: confirmText,
                            border: confirmColor ?? iconColor,
                            textColor: confirmColor ?? iconColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showLoadingDialog(BuildContext context) {
  if (isLoadingDialogShowing) return;

  isLoadingDialogShowing = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (dialogContext) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: SpinKitFadingCircle(
              color: mainColor,
              size: 55.w,
            ),
          ),
        ),
      );
    },
  ).then((_) {
    isLoadingDialogShowing = false;
  });
}

void hideLoadingDialog(BuildContext context) {
  if (isLoadingDialogShowing) {
    Navigator.of(context, rootNavigator: true).pop();
    isLoadingDialogShowing = false;
  }
}

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

class NoInternet extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternet({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/noCon.json',
              width: 220.w,
              height: 220.h,
              fit: BoxFit.contain,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(['**', 'Fill 1'], value: mainColor),
                  ValueDelegate.color(['**', 'Fill 2'],
                      value: mainColor.withOpacity(0.7)),
                  ValueDelegate.color(['**', 'Fill 3'],
                      value: mainColor.withOpacity(0.5)),
                  ValueDelegate.opacity(['LOST CONNECTION Outlines', '**'],
                      value: 0),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'لا يوجد اتصال بالإنترنت، يرجى المحاولة مرة أخرى',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 50.w),
              child: defaultOutlinedButton(
                  onPressed: () {
                    onRetry();
                  },
                  text: 'إعادة المحاولة',
                  border: mainColor,
                  textColor: mainColor),
            )
          ],
        ),
      ),
    );
  }
}

class ChatShimmerLoading extends StatelessWidget {
  final bool isDark;

  const ChatShimmerLoading({super.key, required this.isDark});

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          _shimmerBox(
            height: 110.h,
            width: double.infinity,
            radius: 30,
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsetsDirectional.only(
                start: 10.w,
                top: 20.h,
                bottom: 20.h,
                end: 10.w,
              ),
              itemCount: 8,
              separatorBuilder: (context, index) => SizedBox(height: 17.h),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          _shimmerBox(
                            width: 50.r,
                            height: 50.r,
                            radius: 100,
                          ),
                          if (index == 0 || index == 2)
                            Container(
                              height: 18.h,
                              width: 18.w,
                              decoration: BoxDecoration(
                                color: innerContainerColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: containerColor,
                                  width: 2,
                                ),
                              ),
                              child: _shimmerBox(
                                width: 10.w,
                                height: 10.h,
                                radius: 100,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _shimmerBox(
                                    height: 14.h,
                                    width: double.infinity,
                                    radius: 8,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                _shimmerBox(
                                  height: 9.h,
                                  width: 38.w,
                                  radius: 8,
                                ),
                              ],
                            ),
                            SizedBox(height: 7.h),
                            _shimmerBox(
                              height: 22.h,
                              width: 130.w,
                              radius: 20,
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                if (index == 1 || index == 3) ...[
                                  _shimmerBox(
                                    height: 14.h,
                                    width: 14.w,
                                    radius: 5,
                                  ),
                                  SizedBox(width: 5.w),
                                ],
                                Expanded(
                                  child: _shimmerBox(
                                    height: 11.h,
                                    width: double.infinity,
                                    radius: 8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
}

class WorkerHomeShimmer extends StatelessWidget {
  final bool isDark;

  const WorkerHomeShimmer({super.key, required this.isDark});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            height: 160.h,
            width: double.infinity,
            radius: 30,
          ),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.25,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(
                        height: 35.h,
                        width: 35.w,
                        radius: 12,
                      ),
                      const Spacer(),
                      _shimmerBox(
                        height: 12.h,
                        width: 80.w,
                      ),
                      SizedBox(height: 8.h),
                      _shimmerBox(
                        height: 18.h,
                        width: 55.w,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
            child: _shimmerBox(
              height: 25.h,
              width: 130.w,
              radius: 10,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: Container(
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  _shimmerBox(
                    width: 55.w,
                    height: 55.h,
                    radius: 18,
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(
                          height: 14.h,
                          width: double.infinity,
                        ),
                        SizedBox(height: 8.h),
                        _shimmerBox(
                          height: 12.h,
                          width: 120.w,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _shimmerBox(
                    width: 65.w,
                    height: 30.h,
                    radius: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(
                  height: 25.h,
                  width: 130.w,
                  radius: 10,
                ),
                _shimmerBox(
                  height: 20.h,
                  width: 60.w,
                  radius: 8,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 290.h,
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 15.h,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            _shimmerBox(
                              height: 12.h,
                              width: 45.w,
                            ),
                            SizedBox(height: 8.h),
                            _shimmerBox(
                              height: 14.h,
                              width: double.infinity,
                            ),
                            SizedBox(height: 8.h),
                            _shimmerBox(
                              height: 12.h,
                              width: 85.w,
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: innerContainerColor,
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              child: Column(
                                children: [
                                  _smallDetailRow(),
                                  SizedBox(height: 10.h),
                                  _smallDetailRow(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            child: Container(
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _shimmerBox(
                        height: 45.h,
                        width: 45.w,
                        radius: 15,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(
                              height: 14.h,
                              width: double.infinity,
                            ),
                            SizedBox(height: 8.h),
                            _shimmerBox(
                              height: 12.h,
                              width: 130.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  _detailRow(),
                  SizedBox(height: 12.h),
                  _detailRow(),
                ],
              ),
            ),
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

  Widget _detailRow() {
    return Row(
      children: [
        _shimmerBox(
          width: 30.w,
          height: 30.h,
          radius: 10,
        ),
        SizedBox(width: 10.w),
        _shimmerBox(
          width: 70.w,
          height: 10.h,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _shimmerBox(
            height: 10.h,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget _smallDetailRow() {
    return Row(
      children: [
        _shimmerBox(
          width: 22.w,
          height: 22.h,
          radius: 8,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _shimmerBox(
            height: 9.h,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}

class WorkerServicesShimmer extends StatelessWidget {
  final bool isDark;

  const WorkerServicesShimmer({super.key, required this.isDark});

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor => isDark ? lightDarkColor : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? darkBgColor : bgColor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Shimmer
              _shimmerBox(
                height: 110.h,
                width: double.infinity,
                radius: 30,
              ),

              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10.w, vertical: 10.h),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 230.h,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 15.h),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: isDark ? [] : blueShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Area Shimmer
                          Stack(
                            children: [
                              _shimmerBox(
                                height: 120.h,
                                width: double.infinity,
                                radius: 25,
                              ),
                              // Price Badge Shimmer
                              PositionedDirectional(
                                bottom: 5.h,
                                end: 10.w,
                                child: _shimmerBox(
                                  width: 50.w,
                                  height: 25.h,
                                  radius: 15,
                                ),
                              ),
                              // Power Icon Shimmer
                              PositionedDirectional(
                                top: 10.h,
                                start: 10.w,
                                child: _shimmerBox(
                                  width: 35.r,
                                  height: 35.r,
                                  radius: 50,
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Rating Shimmer
                                Row(
                                  children: [
                                    _shimmerBox(
                                        width: 15.r, height: 15.r, radius: 4),
                                    SizedBox(width: 5.w),
                                    _shimmerBox(width: 30.w, height: 10.h),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                // Title Shimmer
                                _shimmerBox(height: 14.h, width: 100.w),
                                SizedBox(height: 8.h),
                                // Description Shimmer
                                _shimmerBox(
                                    height: 8.h, width: double.infinity),
                                SizedBox(height: 4.h),
                                _shimmerBox(height: 8.h, width: 80.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // FAB Shimmer
        floatingActionButton: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: 50.h,
            width: 130.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBox(
              height: 160.h,
              width: double.infinity,
              radius: 30,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
              child: _welcomeBannerShimmer(),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  _sectionTitleShimmer(showButton: true),
                  SizedBox(height: 10.h),
                  _categoriesGridShimmer(),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
              child: _sectionTitleShimmer(showButton: false),
            ),
            SizedBox(height: 10.h),
            _trendingServicesShimmer(),
            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }

  Widget _welcomeBannerShimmer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  height: 22.h,
                  width: 100.w,
                  radius: 10,
                ),
                SizedBox(height: 12.h),
                _shimmerBox(
                  height: 18.h,
                  width: double.infinity,
                  radius: 10,
                ),
                SizedBox(height: 8.h),
                _shimmerBox(
                  height: 12.h,
                  width: 150.w,
                  radius: 10,
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          _shimmerBox(
            width: 75.r,
            height: 75.r,
            radius: 100,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitleShimmer({required bool showButton}) {
    return Row(
      children: [
        _shimmerBox(
          width: 42.w,
          height: 42.h,
          radius: 10,
        ),
        SizedBox(width: 8.w),
        _shimmerBox(
          width: 90.w,
          height: 16.h,
          radius: 8,
        ),
        const Spacer(),
        if (showButton)
          _shimmerBox(
            width: 65.w,
            height: 28.h,
            radius: 20,
          ),
      ],
    );
  }

  Widget _categoriesGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsetsDirectional.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsetsDirectional.all(10.r),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: innerContainerColor,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: _shimmerBox(
                  width: 26.w,
                  height: 26.h,
                  radius: 8,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _shimmerBox(
                  height: 12.h,
                  width: double.infinity,
                  radius: 8,
                ),
              ),
              SizedBox(width: 8.w),
              _shimmerBox(
                width: 12.w,
                height: 12.h,
                radius: 6,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _trendingServicesShimmer() {
    return SizedBox(
      height: 350.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(
          start: 15.w,
          bottom: 10.h,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: index == 0 ? 0 : 15.w,
              end: index == 3 ? 15.w : 0,
            ),
            child: Container(
              width: 280.w,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      _shimmerBox(
                        height: 180.h,
                        width: double.infinity,
                        radius: 25,
                      ),
                      PositionedDirectional(
                        top: 12.h,
                        start: 12.w,
                        child: _shimmerBox(
                          width: 70.w,
                          height: 24.h,
                          radius: 10,
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 12.h,
                        end: 12.w,
                        child: _shimmerBox(
                          width: 75.w,
                          height: 30.h,
                          radius: 15,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.all(15.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(
                          height: 16.h,
                          width: double.infinity,
                          radius: 8,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            _shimmerBox(
                              width: 18.w,
                              height: 18.h,
                              radius: 6,
                            ),
                            SizedBox(width: 6.w),
                            _shimmerBox(
                              width: 35.w,
                              height: 12.h,
                              radius: 8,
                            ),
                            const Spacer(),
                            _shimmerBox(
                              width: 14.w,
                              height: 14.h,
                              radius: 6,
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: innerContainerColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            children: [
                              _shimmerBox(
                                width: 32.r,
                                height: 32.r,
                                radius: 100,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _shimmerBox(
                                      height: 11.h,
                                      width: double.infinity,
                                      radius: 8,
                                    ),
                                    SizedBox(height: 6.h),
                                    _shimmerBox(
                                      height: 9.h,
                                      width: 80.w,
                                      radius: 8,
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
                ],
              ),
            ),
          );
        },
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

class UserServicesShimmer extends StatelessWidget {
  const UserServicesShimmer({super.key});

  Color _baseColor(bool isDark) =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color _highlightColor(bool isDark) =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color _containerColor(bool isDark) =>
      isDark ? const Color(0xFF161B22) : const Color(0xFFF2F9FF);

  Color _innerContainerColor(bool isDark) =>
      isDark ? const Color(0xFF0D1117) : const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.get(context);
    final isDark = appCubit.isDark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(
                isDark: isDark,
                height: 160.h,
                width: double.infinity,
                radius: 30,
              ),
              SizedBox(height: 15.h),
              ListView.separated(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.only(
                  start: 15.w,
                  end: 15.w,
                  bottom: 20.h,
                ),
                itemBuilder: (context, index) {
                  return _serviceCardShimmer(isDark);
                },
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceCardShimmer(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _containerColor(isDark),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _shimmerBox(
                isDark: isDark,
                height: 180.h,
                width: double.infinity,
                radius: 25,
              ),
              PositionedDirectional(
                top: 12.h,
                start: 12.w,
                child: _shimmerBox(
                  isDark: isDark,
                  width: 75.w,
                  height: 24.h,
                  radius: 10,
                ),
              ),
              PositionedDirectional(
                bottom: 12.h,
                end: 12.w,
                child: _shimmerBox(
                  isDark: isDark,
                  width: 80.w,
                  height: 30.h,
                  radius: 15,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  isDark: isDark,
                  height: 16.h,
                  width: double.infinity,
                  radius: 8,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _shimmerBox(
                      isDark: isDark,
                      width: 18.w,
                      height: 18.h,
                      radius: 6,
                    ),
                    SizedBox(width: 6.w),
                    _shimmerBox(
                      isDark: isDark,
                      width: 35.w,
                      height: 12.h,
                      radius: 8,
                    ),
                    const Spacer(),
                    _shimmerBox(
                      isDark: isDark,
                      width: 14.w,
                      height: 14.h,
                      radius: 6,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: _innerContainerColor(isDark),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      _shimmerBox(
                        isDark: isDark,
                        width: 32.r,
                        height: 32.r,
                        radius: 100,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(
                              isDark: isDark,
                              height: 11.h,
                              width: double.infinity,
                              radius: 8,
                            ),
                            SizedBox(height: 6.h),
                            _shimmerBox(
                              isDark: isDark,
                              height: 9.h,
                              width: 90.w,
                              radius: 8,
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
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required bool isDark,
    required double height,
    required double width,
    double radius = 12,
    EdgeInsetsDirectional? margin,
  }) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: _baseColor(isDark),
        highlightColor: _highlightColor(isDark),
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
            height: 110.h,
            width: double.infinity,
            radius: 30,
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

  const AddressManagementShimmer({
    super.key,
    required this.isDark,
  });

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor =>
      isDark ? const Color(0xFF161B22) : const Color(0xFFF2F9FF);

  Color get innerContainerColor =>
      isDark ? const Color(0xFF0D1117) : const Color(0xFFEAF4FF);

  Color get borderColor =>
      isDark ? const Color(0xFF30363D) : const Color(0xFFE6EEF8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerCardShimmer(),
        SizedBox(height: 25.h),
        _sectionTitleShimmer(),
        SizedBox(height: 15.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _addressCardShimmer(index);
          },
        ),
      ],
    );
  }

  Widget _headerCardShimmer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(15.r),
            decoration: BoxDecoration(
              color: innerContainerColor,
              borderRadius: BorderRadiusDirectional.circular(16.r),
            ),
            child: _shimmerBox(
              width: 40.w,
              height: 40.w,
              radius: 12,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  width: 130.w,
                  height: 18.h,
                  radius: 8,
                ),
                SizedBox(height: 10.h),
                _shimmerBox(
                  width: double.infinity,
                  height: 12.h,
                  radius: 8,
                ),
                SizedBox(height: 7.h),
                _shimmerBox(
                  width: 190.w,
                  height: 12.h,
                  radius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitleShimmer() {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(10.r),
          decoration: BoxDecoration(
            color: innerContainerColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: _shimmerBox(
            width: 20.w,
            height: 20.w,
            radius: 6,
          ),
        ),
        SizedBox(width: 8.w),
        _shimmerBox(
          width: 130.w,
          height: 16.h,
          radius: 8,
        ),
      ],
    );
  }

  Widget _addressCardShimmer(int index) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 15.h),
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(10.r),
                decoration: BoxDecoration(
                  color: innerContainerColor,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: _shimmerBox(
                  width: 25.w,
                  height: 25.w,
                  radius: 8,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Row(
                  children: [
                    _shimmerBox(
                      width: 90.w,
                      height: 15.h,
                      radius: 8,
                    ),
                    if (index == 0) ...[
                      SizedBox(width: 8.w),
                      _shimmerBox(
                        width: 58.w,
                        height: 24.h,
                        radius: 30,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              color: borderColor,
              height: 1,
            ),
          ),
          SizedBox(height: 10.h),
          _infoRowShimmer(),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: _smallButtonShimmer(),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _smallButtonShimmer(),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _smallButtonShimmer(),
        ],
      ),
    );
  }

  Widget _infoRowShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _shimmerBox(
          width: 22.w,
          height: 22.w,
          radius: 6,
        ),
        SizedBox(width: 10.w),
        _shimmerBox(
          width: 55.w,
          height: 12.h,
          radius: 8,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(
                width: double.infinity,
                height: 12.h,
                radius: 8,
              ),
              SizedBox(height: 7.h),
              _shimmerBox(
                width: 160.w,
                height: 12.h,
                radius: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _smallButtonShimmer() {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: innerContainerColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _shimmerBox(
              width: 18.w,
              height: 18.w,
              radius: 5,
            ),
            SizedBox(width: 6.w),
            _shimmerBox(
              width: 55.w,
              height: 12.h,
              radius: 8,
            ),
          ],
        ),
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

class AdminHomeShimmer extends StatelessWidget {
  const AdminHomeShimmer({super.key});

  Color get baseColor => const Color(0xFFE3F2FD);

  Color get highlightColor => const Color(0xFFF8FCFF);

  Color get containerColor => const Color(0xFFF2F9FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _shimmerBox(
            height: 110.h,
            width: double.infinity,
            radius: 25,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            padding: EdgeInsetsDirectional.only(
              start: 10.w,
              end: 10.w,
              top: 20.h,
              bottom: 15.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _shimmerBox(width: 45.w, height: 45.h, radius: 15),
                        _shimmerBox(width: 40.w, height: 22.h, radius: 8),
                      ],
                    ),
                    const Spacer(),
                    _shimmerBox(width: 90.w, height: 14.h, radius: 8),
                    SizedBox(height: 8.h),
                    _shimmerBox(width: 30.w, height: 4.h, radius: 10),
                  ],
                ),
              );
            },
          ),
          _sectionTitleShimmer(),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 2.1,
            ),
            itemBuilder: (context, index) {
              return _smallCategoryCard();
            },
          ),
          SizedBox(height: 20.h),
          _sectionTitleShimmer(),
          SizedBox(
            height: 270.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              padding: EdgeInsetsDirectional.only(
                start: 15.w,
                end: 15.w,
                bottom: 15.h,
              ),
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                return _personCardShimmer(height: 270.h);
              },
            ),
          ),
          SizedBox(height: 20.h),
          _sectionTitleShimmer(),
          SizedBox(
            height: 310.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              padding: EdgeInsetsDirectional.only(
                start: 15.w,
                end: 15.w,
                bottom: 10.h,
              ),
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                return _serviceCardShimmer();
              },
            ),
          ),
          SizedBox(height: 20.h),
          _sectionTitleShimmer(),
          SizedBox(
            height: 380.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              padding: EdgeInsetsDirectional.only(
                start: 15.w,
                end: 15.w,
              ),
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                return _requestCardShimmer();
              },
            ),
          ),
          SizedBox(height: 20.h),
          _sectionTitleShimmer(),
          SizedBox(
            height: 250.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              padding: EdgeInsetsDirectional.only(
                start: 15.w,
                bottom: 10.h,
              ),
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                return _personCardShimmer(height: 250.h);
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _sectionTitleShimmer() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, bottom: 10.h),
      child: Row(
        children: [
          _shimmerBox(width: 45.w, height: 45.h, radius: 10),
          SizedBox(width: 10.w),
          _shimmerBox(width: 100.w, height: 18.h, radius: 8),
          const Spacer(),
          _shimmerBox(width: 60.w, height: 18.h, radius: 8),
        ],
      ),
    );
  }

  Widget _smallCategoryCard() {
    return Container(
      padding: EdgeInsetsDirectional.all(10.w),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          _shimmerBox(width: 50.w, height: 50.h, radius: 18),
          SizedBox(width: 10.w),
          Expanded(
            child: _shimmerBox(
              width: double.infinity,
              height: 12.h,
              radius: 8,
            ),
          ),
          SizedBox(width: 10.w),
          _shimmerBox(width: 15.w, height: 15.h, radius: 5),
        ],
      ),
    );
  }

  Widget _personCardShimmer({required double height}) {
    return Container(
      width: 190.w,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: double.infinity,
            height: height == 250.h ? 140.h : 130.h,
            radius: 25,
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 120.w, height: 14.h, radius: 8),
                SizedBox(height: 8.h),
                _shimmerBox(width: 80.w, height: 11.h, radius: 8),
                SizedBox(height: 14.h),
                _shimmerBox(width: double.infinity, height: 32.h, radius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCardShimmer() {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(width: double.infinity, height: 150.h, radius: 25),
          Padding(
            padding: EdgeInsetsDirectional.all(15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 170.w, height: 15.h, radius: 8),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _shimmerBox(width: 70.w, height: 12.h, radius: 8),
                    const Spacer(),
                    _shimmerBox(width: 16.w, height: 16.h, radius: 5),
                  ],
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      _shimmerBox(width: 32.w, height: 32.h, radius: 50),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(
                              width: double.infinity,
                              height: 11.h,
                              radius: 8,
                            ),
                            SizedBox(height: 6.h),
                            _shimmerBox(width: 80.w, height: 9.h, radius: 8),
                          ],
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
    );
  }

  Widget _requestCardShimmer() {
    return Container(
      width: 330.w,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _shimmerBox(width: 70.w, height: 70.h, radius: 18),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      width: double.infinity,
                      height: 14.h,
                      radius: 8,
                    ),
                    SizedBox(height: 8.h),
                    _shimmerBox(width: 90.w, height: 14.h, radius: 8),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _shimmerBox(width: 55.w, height: 25.h, radius: 30),
            ],
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                _detailRow(),
                SizedBox(height: 12.h),
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
    );
  }

  Widget _detailRow() {
    return Row(
      children: [
        _shimmerBox(width: 35.w, height: 35.h, radius: 10),
        SizedBox(width: 10.w),
        _shimmerBox(width: 65.w, height: 10.h, radius: 8),
        SizedBox(width: 10.w),
        Expanded(
          child: _shimmerBox(
            width: double.infinity,
            height: 10.h,
            radius: 8,
          ),
        ),
      ],
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

class AdminCategoriesShimmer extends StatelessWidget {
  const AdminCategoriesShimmer({super.key});

  Color get baseColor => const Color(0xFFE3F2FD);

  Color get highlightColor => const Color(0xFFF8FCFF);

  Color get containerColor => const Color(0xFFF2F9FF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _shimmerBox(
          height: 80.h,
          width: double.infinity,
          margin: EdgeInsetsDirectional.all(10.w),
          radius: 20,
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.w,
              vertical: 20.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 1.1,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsetsDirectional.all(15.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF4FF),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.r),
                              ),
                            ),
                            child: Center(
                              child: _shimmerBox(
                                width: 85.w,
                                height: 85.h,
                                radius: 20,
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            top: 10.h,
                            end: 10.w,
                            child: _shimmerBox(
                              width: 32.w,
                              height: 32.h,
                              radius: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            width: 100.w,
                            height: 14.h,
                            radius: 8,
                          ),
                          SizedBox(height: 8.h),
                          _shimmerBox(
                            width: 25.w,
                            height: 3.h,
                            radius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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

class AdminUsersShimmer extends StatelessWidget {
  final bool isDark;

  const AdminUsersShimmer({super.key, required this.isDark});

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
            margin: EdgeInsetsDirectional.all(15.w),
            radius: 15,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.w,
              vertical: 20.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 0.78,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      height: 120.h,
                      width: double.infinity,
                      radius: 25,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 15.h,
                        start: 10.w,
                        end: 10.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            height: 12.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 12.h),
                          _shimmerBox(
                            height: 35.h,
                            width: double.infinity,
                            radius: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
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
}

class AdminServicesShimmer extends StatelessWidget {
  const AdminServicesShimmer({super.key});

  Color get baseColor => const Color(0xFFE3F2FD);

  Color get highlightColor => const Color(0xFFF8FCFF);

  Color get containerColor => const Color(0xFFF2F9FF);

  Color get innerContainerColor => const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _shimmerBox(
            height: 55.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.all(15.w),
            radius: 15,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.w,
              vertical: 20.h,
            ),
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        _shimmerBox(
                          height: 150.h,
                          width: double.infinity,
                          radius: 25,
                        ),
                        PositionedDirectional(
                          bottom: 12.h,
                          end: 12.w,
                          child: _shimmerBox(
                            width: 70.w,
                            height: 28.h,
                            radius: 15,
                          ),
                        ),
                        PositionedDirectional(
                          top: 12.h,
                          start: 12.w,
                          child: _shimmerBox(
                            width: 80.w,
                            height: 25.h,
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.all(15.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            height: 14.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              _shimmerBox(
                                width: 70.w,
                                height: 12.h,
                              ),
                              const Spacer(),
                              _shimmerBox(
                                width: 15.w,
                                height: 15.h,
                                radius: 20,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: innerContainerColor,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Row(
                              children: [
                                _shimmerBox(
                                  width: 35.w,
                                  height: 35.h,
                                  radius: 30,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _shimmerBox(
                                        height: 10.h,
                                        width: double.infinity,
                                      ),
                                      SizedBox(height: 6.h),
                                      _shimmerBox(
                                        height: 8.h,
                                        width: 100.w,
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
                  ],
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
}

class AdminRequestsShimmer extends StatelessWidget {
  const AdminRequestsShimmer({super.key});

  Color get baseColor => const Color(0xFFE3F2FD);

  Color get highlightColor => const Color(0xFFF8FCFF);

  Color get containerColor => const Color(0xFFF2F9FF);

  Color get innerContainerColor => const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _shimmerBox(
            height: 55.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.all(15.w),
            radius: 15,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsetsDirectional.only(
                start: 15.w,
                end: 15.w,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 10.w),
                  child: _shimmerBox(
                    width: 90.w,
                    height: 40.h,
                    radius: 15,
                  ),
                );
              },
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              start: 20.w,
              end: 20.w,
              top: 20.h,
            ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: _shimmerBox(
                                        height: 14.h,
                                        width: double.infinity,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    _shimmerBox(
                                      width: 65.w,
                                      height: 24.h,
                                      radius: 30,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                _shimmerBox(
                                  width: 80.w,
                                  height: 12.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: innerContainerColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            _detailRow(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            _detailRow(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            _detailRow(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                              child: Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
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
        _shimmerBox(
          width: 35.w,
          height: 35.h,
          radius: 12,
        ),
        SizedBox(width: 10.w),
        _shimmerBox(
          width: 80.w,
          height: 10.h,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _shimmerBox(
            height: 10.h,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}

class AdminProvidersShimmer extends StatelessWidget {
  const AdminProvidersShimmer({super.key});

  Color get baseColor => const Color(0xFFE3F2FD);

  Color get highlightColor => const Color(0xFFF8FCFF);

  Color get containerColor => const Color(0xFFF2F9FF);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _shimmerBox(
            height: 55.h,
            width: double.infinity,
            margin: EdgeInsetsDirectional.all(15.w),
            radius: 15,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.w,
              vertical: 20.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 0.7,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        _shimmerBox(
                          height: 120.h,
                          width: double.infinity,
                          radius: 25,
                        ),
                        PositionedDirectional(
                          top: 10.h,
                          start: 10.w,
                          child: _shimmerBox(
                            width: 50.w,
                            height: 24.h,
                            radius: 8,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            height: 14.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 8.h),
                          _shimmerBox(
                            height: 10.h,
                            width: 90.w,
                          ),
                          SizedBox(height: 15.h),
                          _shimmerBox(
                            height: 35.h,
                            width: double.infinity,
                            radius: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
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
}

class SearchScreenShimmer extends StatelessWidget {
  final bool isDark;

  const SearchScreenShimmer({super.key, required this.isDark});

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor => isDark ? lightDarkColor : Colors.white;

  Color get innerContainerColor =>
      isDark ? const Color(0xFF0D1117) : const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            _searchHeaderShimmer(),

            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ================= سجل البحث =================
                  _sectionTitleShimmer(),
                  SizedBox(height: 12.h),
                  _recentSearchesShimmer(),

                  SizedBox(height: 25.h),

                  /// ================= اقتراحات شائعة =================
                  _sectionTitleShimmer(),
                  SizedBox(height: 12.h),
                  _suggestionsShimmer(),

                  SizedBox(height: 25.h),

                  /// ================= الأقسام الشائعة =================
                  _sectionTitleShimmer(),
                  SizedBox(height: 12.h),
                  _departmentsGridShimmer(),

                  SizedBox(height: 25.h),

                  /// ================= خدمات مقترحة لك =================
                  _sectionTitleShimmer(),
                  SizedBox(height: 10.h),
                  _suggestedServicesShimmer(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchHeaderShimmer() {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(30.r),
      ),
      child: Container(
        height: 175.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              mainColor,
              Color(0xFF0F0F1E),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -45.h,
              left: -40.w,
              child: CircleAvatar(
                radius: 95.r,
                backgroundColor: Colors.white.withOpacity(0.12),
              ),
            ),
            Positioned(
              bottom: -90.h,
              right: -60.w,
              child: Container(
                width: 230.r,
                height: 230.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00F2FF).withOpacity(0.35),
                      const Color(0xFF00F2FF).withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 35.h,
                start: 15.w,
                end: 15.w,
                bottom: 18.h,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _glassShimmerBox(
                        width: 42.w,
                        height: 42.h,
                        radius: 15,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _glassShimmerBox(
                              width: 75.w,
                              height: 18.h,
                              radius: 8,
                            ),
                            SizedBox(height: 8.h),
                            _glassShimmerBox(
                              width: 180.w,
                              height: 10.h,
                              radius: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 52.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? lightDarkColor : Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: blueShadow,
                    ),
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w),
                    child: Row(
                      children: [
                        _shimmerBox(
                          width: 22.w,
                          height: 22.h,
                          radius: 8,
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: _shimmerBox(
                            height: 12.h,
                            width: double.infinity,
                            radius: 8,
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
    );
  }

  Widget _sectionTitleShimmer() {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.w),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: _shimmerBox(
            width: 25.w,
            height: 25.h,
            radius: 8,
          ),
        ),
        SizedBox(width: 8.w),
        _shimmerBox(
          width: 125.w,
          height: 16.h,
          radius: 8,
        ),
        const Spacer(),
        _shimmerBox(
          width: 55.w,
          height: 14.h,
          radius: 8,
        ),
      ],
    );
  }

  Widget _recentSearchesShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 15.w,
          vertical: 8.h,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.withOpacity(0.12),
          height: 1.h,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 12.h),
            child: Row(
              children: [
                _shimmerBox(
                  width: 20.w,
                  height: 20.h,
                  radius: 7,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _shimmerBox(
                    height: 12.h,
                    width: double.infinity,
                    radius: 8,
                  ),
                ),
                SizedBox(width: 40.w),
                _shimmerBox(
                  width: 18.w,
                  height: 18.h,
                  radius: 50,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _suggestionsShimmer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: List.generate(7, (index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: mainColor.withOpacity(0.08)),
            boxShadow: blueShadow,
          ),
          child: _shimmerBox(
            width: index % 2 == 0 ? 65.w : 105.w,
            height: 12.h,
            radius: 8,
          ),
        );
      }),
    );
  }

  Widget _departmentsGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsetsDirectional.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsetsDirectional.all(10.r),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: blueShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: _shimmerBox(
                  width: 25.w,
                  height: 25.h,
                  radius: 8,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _shimmerBox(
                  height: 12.h,
                  width: double.infinity,
                  radius: 8,
                ),
              ),
              SizedBox(width: 10.w),
              _shimmerBox(
                width: 12.w,
                height: 12.h,
                radius: 4,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _suggestedServicesShimmer() {
    return SizedBox(
      height: 350.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: 5.w,
          bottom: 10.h,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: index == 0 ? 0 : 15.w,
              end: index == 3 ? 5.w : 0,
            ),
            child: Container(
              width: 280.w,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: blueShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      _shimmerBox(
                        height: 180.h,
                        width: double.infinity,
                        radius: 25,
                      ),
                      PositionedDirectional(
                        bottom: 12.h,
                        end: 12.w,
                        child: _shimmerBox(
                          width: 70.w,
                          height: 28.h,
                          radius: 15,
                        ),
                      ),
                      PositionedDirectional(
                        top: 12.h,
                        start: 12.w,
                        child: _shimmerBox(
                          width: 55.w,
                          height: 24.h,
                          radius: 10,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.all(15.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(
                          width: 160.w,
                          height: 15.h,
                          radius: 8,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            _shimmerBox(
                              width: 18.w,
                              height: 18.h,
                              radius: 5,
                            ),
                            SizedBox(width: 5.w),
                            _shimmerBox(
                              width: 35.w,
                              height: 11.h,
                              radius: 8,
                            ),
                            const Spacer(),
                            _shimmerBox(
                              width: 14.w,
                              height: 14.h,
                              radius: 5,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            children: [
                              _shimmerBox(
                                width: 32.w,
                                height: 32.h,
                                radius: 50,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _shimmerBox(
                                      height: 10.h,
                                      width: double.infinity,
                                      radius: 8,
                                    ),
                                    SizedBox(height: 6.h),
                                    _shimmerBox(
                                      height: 8.h,
                                      width: 80.w,
                                      radius: 8,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _glassShimmerBox({
    required double width,
    required double height,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.22),
      highlightColor: Colors.white.withOpacity(0.45),
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

  Widget _shimmerBox({
    required double height,
    double? width,
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

class UserCategoriesShimmer extends StatelessWidget {
  final bool isDark;

  const UserCategoriesShimmer({super.key, required this.isDark});

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          _shimmerBox(
            height: 110.h,
            width: double.infinity,
            radius: 30,
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                return _categoryShimmerCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryShimmerCard() {
    return Container(
      padding: EdgeInsetsDirectional.all(10.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: innerContainerColor,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: _shimmerBox(
              width: 26.w,
              height: 26.h,
              radius: 8,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  height: 12.h,
                  width: double.infinity,
                  radius: 8,
                ),
                SizedBox(height: 8.h),
                _shimmerBox(
                  height: 10.h,
                  width: 55.w,
                  radius: 8,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _shimmerBox(
            width: 12.w,
            height: 12.h,
            radius: 6,
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
}

class UserWorkerProfileShimmer extends StatelessWidget {
  final bool isDark;

  const UserWorkerProfileShimmer({
    super.key,
    required this.isDark,
  });

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor => isDark ? lightDarkColor : Colors.white;

  Color get innerContainerColor =>
      isDark ? const Color(0xFF0D1117) : const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _headerShimmer(),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 10.w,
                  end: 10.w,
                  top: 20.h,
                  bottom: 20.h,
                ),
                child: Column(
                  children: [
                    _statsShimmer(),
                    SizedBox(height: 25.h),
                    _sectionTitleShimmer(width: 110.w),
                    SizedBox(height: 10.h),
                    _aboutCardShimmer(),
                    SizedBox(height: 20.h),
                    _sectionTitleShimmer(width: 75.w),
                    SizedBox(height: 10.h),
                    _experiencesCardShimmer(),
                    SizedBox(height: 20.h),
                    _sectionTitleShimmer(width: 125.w),
                    SizedBox(height: 10.h),
                    _previousWorksCardShimmer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerShimmer() {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(35.r),
      ),
      child: Container(
        width: double.infinity,
        height: 325.h,
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
              top: 205.h,
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
                  filter: ImageFilter.blur(
                    sigmaX: 40,
                    sigmaY: 40,
                  ),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 35.h,
                start: 10.w,
                end: 18.w,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: _glassShimmerBox(
                          width: 20.w,
                          height: 20.h,
                          radius: 6,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _glassShimmerBox(
                        width: 85.w,
                        height: 24.h,
                        radius: 8,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 104.r,
                          height: 104.r,
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: _glassShimmerBox(
                            width: 98.r,
                            height: 98.r,
                            radius: 100,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _glassShimmerBox(
                          width: 135.w,
                          height: 20.h,
                          radius: 8,
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          alignment: WrapAlignment.center,
                          children: [
                            _headerChipShimmer(width: 85.w),
                            _headerChipShimmer(width: 62.w),
                            _headerChipShimmer(width: 88.w),
                          ],
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
    );
  }

  Widget _headerChipShimmer({
    required double width,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: _glassShimmerBox(
        width: width,
        height: 14.h,
        radius: 8,
      ),
    );
  }

  Widget _statsShimmer() {
    return Row(
      children: [
        _statCardShimmer(),
        SizedBox(width: 10.w),
        _statCardShimmer(),
        SizedBox(width: 10.w),
        _statCardShimmer(),
      ],
    );
  }

  Widget _statCardShimmer() {
    return Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.all(12.w),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(22.r),
          border: isDark ? Border.all(color: const Color(0xFF30363D)) : null,
          boxShadow: isDark ? [] : blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 18.h,
                    radius: 8,
                  ),
                ),
                SizedBox(width: 8.w),
                _shimmerBox(
                  width: 25.w,
                  height: 25.h,
                  radius: 8,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _shimmerBox(
              width: 55.w,
              height: 11.h,
              radius: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitleShimmer({
    required double width,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(isDark ? 0.20 : 0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: _shimmerBox(
            width: 25.w,
            height: 25.h,
            radius: 8,
          ),
        ),
        SizedBox(width: 8.w),
        _shimmerBox(
          width: width,
          height: 17.h,
          radius: 8,
        ),
      ],
    );
  }

  Widget _aboutCardShimmer() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: double.infinity,
            height: 12.h,
            radius: 8,
          ),
          SizedBox(height: 10.h),
          _shimmerBox(
            width: double.infinity,
            height: 12.h,
            radius: 8,
          ),
          SizedBox(height: 10.h),
          _shimmerBox(
            width: 230.w,
            height: 12.h,
            radius: 8,
          ),
          SizedBox(height: 10.h),
          _shimmerBox(
            width: 150.w,
            height: 12.h,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _experiencesCardShimmer() {
    return _whiteCard(
      child: Column(
        children: List.generate(4, (index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: index == 3 ? 0 : 12.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(
                  width: 22.w,
                  height: 22.h,
                  radius: 50,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 13.h,
                    radius: 8,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _previousWorksCardShimmer() {
    return _whiteCard(
      padding: EdgeInsetsDirectional.only(
        start: 12.w,
        end: 12.w,
        top: 14.h,
        bottom: 14.h,
      ),
      child: SizedBox(
        height: 160.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            return _shimmerBox(
              width: 180.w,
              height: 160.h,
              radius: 18,
            );
          },
        ),
      ),
    );
  }

  Widget _whiteCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
        border: isDark ? Border.all(color: const Color(0xFF30363D)) : null,
        boxShadow: isDark ? [] : blueShadow,
      ),
      child: child,
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
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

  Widget _glassShimmerBox({
    required double width,
    required double height,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.20),
      highlightColor: Colors.white.withOpacity(0.55),
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

class NotificationsScreenShimmer extends StatelessWidget {
  final bool isDark;

  const NotificationsScreenShimmer({
    super.key,
    required this.isDark,
  });

  Color get baseColor =>
      isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD);

  Color get highlightColor =>
      isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF);

  Color get containerColor =>
      isDark ? const Color(0xFF161B22) : const Color(0xFFF2F9FF);

  Color get iconContainerColor =>
      isDark ? const Color(0xFF0D1117) : const Color(0xFFEAF4FF);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          SizedBox(height: 10.h),
          SizedBox(
            height: 42.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
              itemCount: 4,
              separatorBuilder: (context, index) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                return _shimmerBox(
                  height: 38.h,
                  width: index == 0 ? 70.w : 85.w,
                  radius: 12,
                );
              },
            ),
          ),
          SizedBox(height: 15.h),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 10.w,
                end: 10.w,
                bottom: 20.h,
              ),
              itemCount: 7,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                return _notificationCardShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCardShimmer() {
    return Container(
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: iconContainerColor,
                ),
                child: _shimmerBox(
                  width: 22.w,
                  height: 22.h,
                  radius: 8,
                ),
              ),
              PositionedDirectional(
                top: -2.h,
                start: -2.w,
                child: _shimmerCircle(radius: 5.r),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _shimmerBox(
                        height: 14.h,
                        width: double.infinity,
                        radius: 8,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _shimmerBox(
                      height: 24.h,
                      width: 50.w,
                      radius: 20,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _shimmerBox(
                  height: 11.h,
                  width: double.infinity,
                  radius: 8,
                ),
                SizedBox(height: 7.h),
                _shimmerBox(
                  height: 11.h,
                  width: 180.w,
                  radius: 8,
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    _shimmerBox(
                      height: 15.h,
                      width: 15.w,
                      radius: 6,
                    ),
                    SizedBox(width: 5.w),
                    _shimmerBox(
                      height: 10.h,
                      width: 75.w,
                      radius: 8,
                    ),
                    const Spacer(),
                    _shimmerBox(
                      height: 10.h,
                      width: 55.w,
                      radius: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    required double width,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
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
    );
  }

  Widget _shimmerCircle({
    required double radius,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
      ),
    );
  }
}
