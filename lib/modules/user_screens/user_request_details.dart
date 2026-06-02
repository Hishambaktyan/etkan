import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/user_screens/user_worker_profile.dart';
import 'package:trying_homy/modules/worker_screens/worker_profile.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/cubits/user_cubit/user_cubit.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';
import '../the_chat.dart';

class UserRequestDetails extends StatefulWidget {
  final Map<String, dynamic> request;
  final Map<String, dynamic> providerData;
  const UserRequestDetails(
      {super.key, required this.request, required this.providerData});

  @override
  State<UserRequestDetails> createState() => _UserRequestDetailsState();
}

class _UserRequestDetailsState extends State<UserRequestDetails> {
  final List<String> stepperSteps = [
    "قيد الانتظار",
    "مقبول",
    "في الطريق",
    "مكتمل"
  ];

  final List<String> terminalStates = ["مرفوض", "ملغي"];

  Widget buildHorizontalStepper(
      {required int currentStep, required dynamic cubit}) {
    List<String> steps = [
      'تم الطلب',
      'تم القبول',
      'في الطريق',
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
                      color:
                          isDone || isActive ? mainColor : Colors.grey.shade200,
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
                          : Colors.grey.shade400,
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
                          ? cubit.isDark
                              ? Colors.white
                              : Colors.black
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2.h,
                    margin: EdgeInsets.only(bottom: 20.h),
                    color: isDone ? mainColor : Colors.grey.shade200,
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
                      Map<int, String> statusTimesKeys = {
                        0: 'createdAt',
                        1: 'acceptedAt',
                        2: 'onWayAt',
                        3: 'completedAt',
                      };
                      String timeKey = statusTimesKeys[index]!;
                      String displayTime =
                          formatStatusTime(requestData[timeKey]);
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
                  color: isDone || isActive ? mainColor : Colors.grey.shade200,
                  border: isActive
                      ? Border.all(color: mainColor.withOpacity(0.1), width: 4)
                      : null,
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.circle,
                  size: 12.sp,
                  color:
                      isDone || isActive ? Colors.white : Colors.grey.shade400,
                ),
              ),
              if (showLine)
                Expanded(
                  child: VerticalDivider(
                    color: isDone ? mainColor : Colors.grey.shade200,
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
                        ? cubit.isDark
                            ? Colors.white
                            : Colors.black87
                        : cubit.isDark
                            ? darkSubTextColor
                            : Colors.grey,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: cubit.isDark ? darkSubTextColor : Colors.grey),
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
    required dynamic cubit,
  }) {
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
            color: cubit.isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  void showBookingOptionsSheet({
    required BuildContext context,
    required AppCubit appCubit,
    required Map<String, dynamic> request,
  }) {
    final String status = (request['status'] ?? '').toString();

    final bool canDelete = status != 'مقبول' && status != 'في الطريق';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: EdgeInsets.all(15.w),
            padding: EdgeInsetsDirectional.only(
              start: 15.w,
              end: 15.w,
              top: 12.h,
              bottom: 15.h,
            ),
            decoration: BoxDecoration(
              color: appCubit.isDark ? lightDarkColor : Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              border: appCubit.isDark
                  ? Border.all(color: const Color(0xFF30363D))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45.w,
                    height: 5.h,
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: appCubit.isDark
                          ? Colors.white.withOpacity(0.25)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  bookingOptionItem(
                    appCubit: appCubit,
                    icon: Icons.delete_outline_rounded,
                    title: 'حذف الحجز',
                    subTitle: canDelete
                        ? 'سيتم حذف الحجز نهائيًا من القائمة'
                        : 'لا يمكن حذف الحجز بعد قبوله أو أثناء التنفيذ',
                    color: canDelete ? Colors.red : Colors.grey,
                    onTap: canDelete
                        ? () {
                            Navigator.pop(sheetContext);
                            confirmDeleteBooking(
                              context: context,
                              appCubit: appCubit,
                              request: request,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bookingOptionItem({
    required AppCubit appCubit,
    required IconData icon,
    required String title,
    required String subTitle,
    required Color color,
    required VoidCallback? onTap,
    bool isMuted = false,
  }) {
    final Color itemColor = isMuted
        ? appCubit.isDark
            ? Colors.grey.shade500
            : Colors.grey.shade500
        : color;

    final Color iconBgColor = isMuted
        ? appCubit.isDark
            ? Colors.grey.withOpacity(0.12)
            : Colors.grey.withOpacity(0.10)
        : color.withOpacity(0.12);

    final Color containerColor = appCubit.isDark
        ? darkBgColor.withOpacity(0.7)
        : isMuted
            ? Colors.grey.withOpacity(0.06)
            : color.withOpacity(0.06);

    final Color borderColor =
        isMuted ? Colors.grey.withOpacity(0.18) : color.withOpacity(0.25);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(13.r),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: SvgPicture.asset(
                'assets/delete.svg',
                color: itemColor,
                width: 22.w,
                height: 22.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: onTap == null
                          ? Colors.grey
                          : isMuted
                              ? itemColor
                              : appCubit.isDark
                                  ? Colors.white
                                  : Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: onTap == null
                          ? Colors.grey
                          : appCubit.isDark
                              ? darkSubTextColor
                              : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15.r,
              color: onTap == null ? Colors.grey : itemColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmDeleteBooking({
    required BuildContext context,
    required AppCubit appCubit,
    required Map<String, dynamic> request,
  })
  async {
    final String requestId = (request['id'] ?? request['requestId'] ?? '').toString();

    if (requestId.isEmpty) {
      showSnackBar(Colors.red, 'رقم الحجز غير صحيح', context);
      return;
    }

    defaultConfirmDialog(
      context: context,
      isDark: appCubit.isDark,
      icon: 'assets/delete.svg',
      iconColor: Colors.red,
      title: 'حذف الحجز',
      body:
          'هل أنت متأكد أنك تريد حذف هذا الحجز؟ لا يمكن التراجع عن هذه العملية.',
      confirmText: 'حذف',
      cancelText: 'تراجع',
      confirmColor: Colors.red,
      onConfirm: () async {
        Navigator.of(context, rootNavigator: true).pop();
        showLoadingDialog(context);
        final bool deleted = await UserCubit.get(context).deleteUserRequest(
          requestId: requestId,
        );

        if (!context.mounted) return;
        hideLoadingDialog(context);
        if (deleted) {
          showSnackBar(Colors.green, 'تم حذف الحجز بنجاح', context);

          // الخروج من صفحة تفاصيل الحجز
          Navigator.pop(context, true);
        } else {
          final state = UserCubit.get(context).state;

          final String error = state is DeleteUserRequestErrorState
              ? state.error
              : 'حدث خطأ أثناء حذف الحجز';

          showSnackBar(Colors.red, error, context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> request = widget.request;
    final Map<String, dynamic> providerData = widget.providerData;
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        Color statusColor;
        switch (request['status']) {
          case 'مكتمل':
            statusColor = Colors.green;
            break;
          case 'مقبول':
            statusColor = Colors.blueAccent;
            break;
          case 'في الطريق':
            statusColor = Colors.blueAccent;
            break;
          case 'مرفوض':
            statusColor = Colors.redAccent;
            break;
          case 'ملغي':
            statusColor = Colors.redAccent;
            break;
          default:
            statusColor = Colors.orangeAccent;
        }
        var userData = appCubit.allUsers[request['customerId']] ?? {};
        final String status = request['status'] ?? '';
        final bool canContact = status == 'مقبول' || status == 'في الطريق' || status == 'مكتمل';

        return BlocConsumer<UserCubit,UserStates>(
          listener: (context, state) {
            if (state is CreateOrGetChatLoadingState) {
              showLoadingDialog(context);
            }
            if (state is CreateOrGetChatSuccessState) {
              hideLoadingDialog(context);
              move(context,
                TheChat(
                  otherUsername: providerData['name'] ?? 'مستخدم',
                  otherUserImage: providerData['profileImage'] ?? '',
                  otherUserId: request['providerId'],
                  myId: request['customerId'],
                  chatId: state.chatId,
                  requestId: request['id'],
                  requestStatus: request['status'] ?? '',
                ),
              );
            }
            if (state is CreateOrGetChatErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context,);
            }
          },
          builder: (context, state) {
            UserCubit userCubit = UserCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
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
                                        color: Colors.grey.shade300,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                    top: 30.h, start: 10.w, end: 10.w),
                                child: Row(
                                  children: [
                                    buildButton(
                                      context: context,
                                      isDark: appCubit.isDark,
                                      icon: CupertinoIcons.back,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Spacer(),
                                    buildButton(
                                      context: context,
                                      isDark: appCubit.isDark,
                                      icon: Icons.more_vert_rounded,
                                      onTap: () {
                                        showBookingOptionsSheet(
                                          context: context,
                                          appCubit: appCubit,
                                          request: request,
                                        );
                                      },
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
                                            boxShadow: blueShadow
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.r),
                                                  decoration: BoxDecoration(
                                                    color: appCubit.isDark
                                                        ? mainColor.withOpacity(0.2)
                                                        : mainColor
                                                        .withOpacity(0.1),
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
                                                      color: appCubit.isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: statusColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                    BorderRadius.circular(7.r),
                                                  ),
                                                  child: Text(
                                                    request['status'] ?? '',
                                                    style: TextStyle(
                                                      color: statusColor,
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
                                                color: appCubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 15.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        size: 18.r,
                                                        color: appCubit.isDark
                                                            ? darkSubTextColor
                                                            : Colors.grey,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'التاريخ',
                                                            style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: appCubit.isDark
                                                                  ? darkSubTextColor
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            dateFormatStatusTime(
                                                                request['scheduledAt'] ??
                                                                    ''),
                                                            style: TextStyle(
                                                              color: appCubit.isDark
                                                                  ? Colors.white
                                                                  : Colors.black87,
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
                                                  color: appCubit.isDark
                                                      ? darkSubTextColor
                                                      : Colors.grey.shade300,
                                                ),
                                                SizedBox(width: 15.w),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.access_time_outlined,
                                                        size: 18.r,
                                                        color: appCubit.isDark
                                                            ? darkSubTextColor
                                                            : Colors.grey,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'الوقت',
                                                            style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: appCubit.isDark
                                                                  ? darkSubTextColor
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            timeFormatStatusTime(
                                                                request['scheduledAt'] ??
                                                                    ''),
                                                            style: TextStyle(
                                                              color: appCubit.isDark
                                                                  ? Colors.white
                                                                  : Colors.black87,
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
                                                color: appCubit.isDark
                                                    ? darkSubTextColor
                                                    : Colors.grey.shade300,
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
                                                        color: Colors.grey,
                                                        width: 20.w,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'السعر التقديري',
                                                            style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: appCubit.isDark
                                                                  ? darkSubTextColor
                                                                  : Colors.grey,
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
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 30.h,
                                                  width: 1,
                                                  color: appCubit.isDark
                                                      ? darkSubTextColor
                                                      : Colors.grey.shade300,
                                                ),
                                                SizedBox(width: 15.w),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/timer.svg',
                                                        color: Colors.grey,
                                                        width: 20.w,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            'المدة المتوقعة',
                                                            style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: appCubit.isDark
                                                                  ? darkSubTextColor
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${request['duration']} دقيقة',
                                                            style: TextStyle(
                                                              color: appCubit.isDark
                                                                  ? Colors.white
                                                                  : Colors.black87,
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
                                                  color: Colors.grey.shade400,
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
                        SizedBox(height: 15.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSectionTitle(
                                  title: 'مراحل التنفيذ',
                                  icon: Icons.route_outlined,
                                  cubit: appCubit),
                              SizedBox(height: 10.h,),
                              Container(
                                padding: EdgeInsetsDirectional.all(15.r),
                                decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildHorizontalStepper(
                                        currentStep:
                                        getStepFromStatus(request['status']),
                                        cubit: appCubit),
                                    SizedBox(height: 10.h),
                                    Center(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          showFullTrackingSheet(
                                              context, appCubit, request);
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
                              SizedBox(height: 20.h,),
                              buildSectionTitle(
                                  title: 'ملاحظات الحجز',
                                  icon: Icons.notes_rounded,
                                  cubit: appCubit),
                              SizedBox(height: 10.h,),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.all(15.r),
                                decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: blueShadow
                                ),
                                child: Column(
                                  children: [
                                    ReadMoreText(
                                      request['description'] ?? '',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: appCubit.isDark
                                              ? Colors.white
                                              : Colors.black,
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
                              SizedBox(height: 20.h,),
                              buildSectionTitle(
                                  title: 'معلومات الفني',
                                  icon: Icons.person_pin_outlined,
                                  cubit: appCubit),
                              SizedBox(height: 10.h,),
                              Container(
                                padding: EdgeInsetsDirectional.all(18.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25.r,
                                          backgroundColor:
                                          mainColor.withOpacity(0.1),
                                          backgroundImage: NetworkImage(
                                            providerData['profileImage'] ?? '',
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              providerData['name'] ?? '',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: appCubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              providerData['specialization'] ?? '',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15.h),
                                      child: Divider(
                                          color: appCubit.isDark
                                              ? darkSubTextColor
                                              : Colors.grey.shade100,
                                          height: 1),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: !canContact,
                                            child: Opacity(
                                              opacity: canContact ? 1.0 : 0.45,
                                              child: defaultButtonWithIcon(
                                                onPressed: () async {
                                                  await userCubit.createOrGetChat(
                                                    customerId: request['customerId'],
                                                    providerId: request['providerId'],
                                                    requestId: request['id'],
                                                    requestTitle: request['title'],
                                                    customerData: userData,
                                                    providerData: providerData,
                                                    requestStatus: request['status']
                                                  );
                                                },
                                                text: 'دردشة',
                                                height: 45.h,
                                                textSize: 13.sp,
                                                background: canContact ? mainColor : Colors.grey,
                                                icon: SvgPicture.asset(
                                                  'assets/chat.svg',
                                                  color: Colors.white,
                                                  width: 20.r,
                                                  height: 20.r,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: defaultOutlinedButtonWithIcon(
                                            onPressed: () {
                                              move(
                                                context,
                                                UserWorkerProfile(
                                                  providerId:
                                                  "${widget.request['providerId'] ?? widget.providerData['uid'] ?? ''}",
                                                  providerData: Map<String, dynamic>.from(
                                                    widget.providerData,
                                                  ),
                                                ),
                                              );
                                            },
                                            text: 'المزيد',
                                            fontSize: 13.sp,
                                            height: 45.h,
                                            textColor:
                                            appCubit.isDark ? Colors.white : mainColor,
                                            border:
                                            appCubit.isDark ? Colors.white : mainColor,
                                            icon: SvgPicture.asset(
                                              'assets/acc.svg',
                                              color:
                                              appCubit.isDark ? Colors.white : mainColor,
                                              width: 20.r,
                                              height: 20.r,
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
                        )
                      ],
                    ),
                  ),
                  bottomNavigationBar: request['status'] == 'قيد الانتظار'
                      ? Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.w, vertical: 10.h),
                    child: defaultButton(
                        onPressed: () {},
                        background: Colors.red,
                        text: 'إلغاء الطلب'),
                  )
                      : null),
            );
          },
        );
      },
    );
  }
}
