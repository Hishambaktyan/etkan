import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:Etkan/modules/admin_screens/admin_provider_info.dart';
import 'package:Etkan/modules/admin_screens/admin_user_info.dart';
import 'package:Etkan/modules/worker_screens/worker_profile.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:Etkan/shared/cubits/admin_cubit/admin_states.dart';

import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class AdminRequestDetails extends StatefulWidget {
  final Map<String, dynamic> request;
  final Map<String, dynamic> providerData;
  final Map<String, dynamic> userData;
  const AdminRequestDetails({
    super.key,
    required this.request,
    required this.providerData,
    required this.userData,
  });

  @override
  State<AdminRequestDetails> createState() => _AdminRequestDetailsState();
}

class _AdminRequestDetailsState extends State<AdminRequestDetails> {
  final List<String> stepperSteps = [
    "قيد الانتظار",
    "مقبول",
    "جاري التنفيذ",
    "مكتمل"
  ];

  final List<String> terminalStates = ["مرفوض", "ملغي"];

  Color cardColor(AppCubit cubit) =>
      cubit.isDark ? lightDarkColor : Colors.white;

  Color primaryTextColor(AppCubit cubit) =>
      cubit.isDark ? Colors.white : Colors.black;

  Color secondaryTextColor(AppCubit cubit) =>
      cubit.isDark ? darkSubTextColor : Colors.grey;

  Color dividerColor(AppCubit cubit) =>
      cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade300;

  Color inactiveStepColor(AppCubit cubit) =>
      cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200;

  Widget buildHorizontalStepper(
      {required int currentStep, required dynamic cubit}) {
    List<String> steps = [
      'تم الطلب',
      'تم القبول',
      'جاري التنفيذ',
      'تم اكمال الخدمة'
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        bool isDone = index < currentStep;
        bool isActive = index == currentStep;
        bool isLast = index == steps.length - 1;

        return Expanded(
          flex: isLast ? 0 : 1,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22.r,
                    height: 22.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone || isActive
                          ? mainColor
                          : inactiveStepColor(cubit),
                      border: isActive
                          ? Border.all(
                              color: mainColor.withOpacity(0.2), width: 4)
                          : null,
                    ),
                    child: Icon(
                      isDone ? Icons.check : Icons.circle,
                      size: 12.sp,
                      color: isDone || isActive
                          ? Colors.white
                          : secondaryTextColor(cubit),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: isActive || isDone
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive || isDone
                          ? primaryTextColor(cubit)
                          : secondaryTextColor(cubit),
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2.h,
                    margin: EdgeInsets.only(bottom: 20.h),
                    color: isDone ? mainColor : inactiveStepColor(cubit),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  void showFullTrackingSheet(
      BuildContext context, AppCubit cubit, dynamic requestData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cubit.isDark ? darkBgColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsetsDirectional.only(
                start: 20.w, end: 20.w, bottom: 20.h, top: 10.h),
            height: MediaQuery.of(context).size.height * 0.51,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: cubit.isDark ? Colors.white : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'تفاصيل تتبع الحجز',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: cubit.isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 25.h),
                Expanded(
                  child: ListView(
                      children: List.generate(
                    stepperSteps.length,
                    (index) {
                      String currentStatusFromDb = requestData['status'];
                      final Map<String, dynamic> statusHistory =
                          Map<String, dynamic>.from(
                              requestData['statusHistory'] ?? {});
                      Map<int, dynamic> statusTimes = {
                        0: statusHistory['pendingAt'] ??
                            requestData['createdAt'],
                        1: statusHistory['acceptedAt'],
                        2: statusHistory['onWayAt'],
                        3: statusHistory['completedAt'],
                      };
                      String displayTime = formatStatusTime(statusTimes[index]);
                      bool isDone;
                      bool isActive;
                      Color circleColor;
                      int currentStepIndex =
                          stepperSteps.indexOf(currentStatusFromDb);
                      if (terminalStates.contains(currentStatusFromDb)) {
                        isDone = index < stepperSteps.indexOf("مقبول");
                        isActive = false;
                        circleColor = Colors.red;
                      } else {
                        isDone = index < currentStepIndex;
                        isActive = index == currentStepIndex;
                        circleColor = mainColor;
                      }
                      return buildVerticalStep(
                        stepperSteps[index],
                        displayTime,
                        isDone,
                        index != stepperSteps.length - 1,
                        cubit,
                        isActive: isActive,
                      );
                    },
                  )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildVerticalStep(
      String title, String time, bool isDone, bool showLine, dynamic cubit,
      {bool isActive = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isDone || isActive ? mainColor : inactiveStepColor(cubit),
                  border: isActive
                      ? Border.all(color: mainColor.withOpacity(0.1), width: 4)
                      : null,
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.circle,
                  size: 12.sp,
                  color: isDone || isActive
                      ? Colors.white
                      : secondaryTextColor(cubit),
                ),
              ),
              if (showLine)
                Expanded(
                  child: VerticalDivider(
                    color: isDone ? mainColor : inactiveStepColor(cubit),
                    thickness: 2,
                  ),
                ),
            ],
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isDone || isActive
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isDone || isActive
                        ? primaryTextColor(cubit)
                        : secondaryTextColor(cubit),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: secondaryTextColor(cubit),
                  ),
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle({
    required String title,
    required IconData icon,
  }) {
    final AppCubit cubit = AppCubit.get(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.w),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.2)
                : mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 22.r,
            color: mainColor,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: primaryTextColor(cubit),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> request = widget.request;
    final Map<String, dynamic> providerData = widget.providerData;
    final Map<String, dynamic> userData = widget.userData;
    return BlocBuilder<AdminCubit, AdminStates>(
      builder: (context, state) {
        final AppCubit appCubit = context.watch<AppCubit>();

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 420.h,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusDirectional.vertical(
                            bottom: Radius.circular(15.r)),
                        child: Image.network(
                          request['image'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300.h,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 130.h,
                            color: appCubit.isDark
                                ? lightDarkColor
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 30.h, start: 10.w, end: 10.w),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.all(7.w),
                              child: buildButton(
                                context: context,
                                isDark: appCubit.isDark,
                                icon: CupertinoIcons.back,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 15.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsetsDirectional.all(18.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsetsDirectional.all(8.r),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/ticket.svg',
                                            color: mainColor,
                                            width: 22.w,
                                            height: 22.h,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            'تفاصيل الحجز',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  primaryTextColor(appCubit),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(
                                              appCubit.isDark ? 0.18 : 0.1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(7.r),
                                          ),
                                          child: Text(
                                            request['status'] ?? '',
                                            style: TextStyle(
                                              color: appCubit.isDark
                                                  ? Colors.orange.shade300
                                                  : Colors.orange.shade800,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      request['title'] ?? '',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor(appCubit),
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                size: 18.r,
                                                color: secondaryTextColor(
                                                    appCubit),
                                              ),
                                              SizedBox(width: 8.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'التاريخ',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color:
                                                          secondaryTextColor(
                                                              appCubit),
                                                    ),
                                                  ),
                                                  Text(
                                                    dateFormatStatusTime(
                                                        request['scheduledAt'] ??
                                                            ''),
                                                    style: TextStyle(
                                                      color: primaryTextColor(
                                                          appCubit),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 35.h,
                                          width: 1,
                                          color: dividerColor(appCubit),
                                        ),
                                        SizedBox(width: 15.w),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: 18.r,
                                                color: secondaryTextColor(
                                                    appCubit),
                                              ),
                                              SizedBox(width: 8.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'الوقت',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color:
                                                          secondaryTextColor(
                                                              appCubit),
                                                    ),
                                                  ),
                                                  Text(
                                                    timeFormatStatusTime(
                                                        request['scheduledAt'] ??
                                                            ''),
                                                    style: TextStyle(
                                                      color: primaryTextColor(
                                                          appCubit),
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.h),
                                      child: Divider(
                                        color: dividerColor(appCubit),
                                        height: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/money.svg',
                                                color: secondaryTextColor(
                                                    appCubit),
                                                width: 20.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(
                                                      'السعر التقديري',
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color:
                                                            secondaryTextColor(
                                                                appCubit),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${request['price']} $reyalSymbol',
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 30.h,
                                          width: 1,
                                          color: dividerColor(appCubit),
                                        ),
                                        SizedBox(width: 15.w),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/timer.svg',
                                                color: secondaryTextColor(
                                                    appCubit),
                                                width: 20.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'المدة المتوقعة',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color:
                                                          secondaryTextColor(
                                                              appCubit),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${request['duration']} دقيقة',
                                                    style: TextStyle(
                                                      color: primaryTextColor(
                                                          appCubit),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      '* السعر النهائي قد يزيد أو ينقص حسب طبيعة الخدمة الفعلية، وحجم العمل المطلوب، وبعد موقع العميل عن مقدم الخدمة',
                                      style: TextStyle(
                                          color: appCubit.isDark
                                              ? darkSubTextColor
                                              : Colors.grey.shade400,
                                          fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle(
                          title: 'مراحل التنفيذ', icon: Icons.route_outlined),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(15.r),
                        decoration: BoxDecoration(
                          color:
                              appCubit.isDark ? lightDarkColor : Colors.white,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: blueShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildHorizontalStepper(
                                currentStep:
                                    getStepFromStatus(request['status']),
                                cubit: AppCubit.get(context)),
                            SizedBox(height: 10.h),
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  showFullTrackingSheet(context,
                                      AppCubit.get(context), request);
                                },
                                icon: SvgPicture.asset(
                                  'assets/eye.svg',
                                  color: mainColor,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                label: Text(
                                  'عرض التتبع الكامل للحجز',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      buildSectionTitle(
                          title: 'ملاحظات الحجز', icon: Icons.notes_rounded),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.all(15.r),
                        decoration: BoxDecoration(
                            color: appCubit.isDark
                                ? lightDarkColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: blueShadow),
                        child: Column(
                          children: [
                            ReadMoreText(
                              request['description'] ?? '',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: primaryTextColor(appCubit),
                                  height: 1.5),
                              trimLines: 3,
                              colorClickableText: mainColor,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' عرض المزيد',
                              trimExpandedText: ' عرض أقل',
                              moreStyle: TextStyle(
                                  fontSize: 12.sp, color: mainColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      buildSectionTitle(
                          title: 'معلومات الفني',
                          icon: Icons.person_pin_outlined),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(18.r),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: appCubit.isDark
                                ? lightDarkColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: blueShadow),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.r,
                                  backgroundImage: NetworkImage(
                                      providerData['profileImage'] ?? ''),
                                ),
                                SizedBox(width: 12.w),
                                SizedBox(
                                  width: 230.w,
                                  child: Text(
                                    providerData['name'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor(appCubit),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  vertical: 15.h),
                              child: Divider(
                                  color: dividerColor(appCubit), height: 1),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/phone.svg',
                                  color: secondaryTextColor(appCubit),
                                  width: 18.r,
                                  height: 18.r,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  providerData['phone'] ?? '',
                                  style: TextStyle(
                                      color: primaryTextColor(appCubit),
                                      fontSize: 12.sp,
                                      letterSpacing: 7),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            defaultOutlinedButtonWithIcon(
                              onPressed: () => move(
                                context,
                                AdminProviderInfo(provider: providerData),
                              ),
                              text: 'المزيد',
                              fontSize: 13.sp,
                              height: 45.h,
                              textColor: mainColor,
                              border: mainColor,
                              icon: SvgPicture.asset(
                                'assets/acc.svg',
                                color: mainColor,
                                width: 20.r,
                                height: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      buildSectionTitle(
                          title: 'معلومات المستخدم',
                          icon: Icons.person_pin_outlined),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.all(18.r),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: appCubit.isDark
                                ? lightDarkColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: blueShadow),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.r,
                                  backgroundImage: NetworkImage(
                                      userData['profileImage'] ?? ''),
                                ),
                                SizedBox(width: 12.w),
                                SizedBox(
                                  width: 230.w,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    userData['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor(appCubit),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  vertical: 15.h),
                              child: Divider(
                                  color: dividerColor(appCubit), height: 1),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/phone.svg',
                                  color: secondaryTextColor(appCubit),
                                  width: 18.r,
                                  height: 18.r,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  userData['phone'] ?? '',
                                  style: TextStyle(
                                      color: primaryTextColor(appCubit),
                                      fontSize: 12.sp,
                                      letterSpacing: 7),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            defaultOutlinedButtonWithIcon(
                              onPressed: () => move(
                                context,
                                AdminUserInfo(user: userData),
                              ),
                              text: 'المزيد',
                              fontSize: 13.sp,
                              height: 45.h,
                              textColor: mainColor,
                              border: mainColor,
                              icon: SvgPicture.asset(
                                'assets/acc.svg',
                                color: mainColor,
                                width: 20.r,
                                height: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
