import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../main.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../the_chat.dart';

class WorkerRequestDetails extends StatelessWidget {
  final Map<String,dynamic> request;
   WorkerRequestDetails({super.key, required this.request});

  final List<String> stepperSteps = [
    "قيد الانتظار",
    "مقبول",
    "في الطريق",
    "مكتمل"
  ];

  final List<String> terminalStates = ["مرفوض", "ملغي"];

  Widget buildHorizontalStepper({required int currentStep,required dynamic cubit}) {

    List<String> steps = ['تم الطلب', 'تم القبول', 'في الطريق','تم اكمال الخدمة'];

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
                      color: isDone || isActive ? mainColor : Colors.grey.shade200,
                      border: isActive ? Border.all(color: mainColor.withOpacity(0.2), width: 4) : null,
                    ),
                    child: Icon(
                      isDone ? Icons.check : Icons.circle,
                      size: 12.sp,
                      color: isDone || isActive ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
                      color: isActive || isDone ? cubit.isDark? Colors.white: Colors.black : Colors.grey,
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

  void showFullTrackingSheet(BuildContext context , AppCubit cubit,dynamic requestData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cubit.isDark? darkBgColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsetsDirectional.all(20.r),
            height: MediaQuery.of(context).size.height * 0.51,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: cubit.isDark? Colors.white: Colors.grey.shade300,
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
                    color: cubit.isDark? Colors.white: Colors.black,
                  ),
                ),
                SizedBox(height: 25.h),
                Expanded(
                  child: ListView(
                    children: List.generate(stepperSteps.length, (index) {
                      String currentStatusFromDb = requestData['status'];
                      Map<int, String> statusTimesKeys = {
                        0: 'createdAt',
                        1: 'acceptedAt',
                        2: 'onWayAt',
                        3: 'completedAt',
                      };
                      String timeKey = statusTimesKeys[index]!;
                      String displayTime = formatStatusTime(requestData[timeKey]);
                      bool isDone;
                      bool isActive;
                      int currentStepIndex = stepperSteps.indexOf(currentStatusFromDb);
                      if (terminalStates.contains(currentStatusFromDb)) {
                        isDone = index < stepperSteps.indexOf("مقبول");
                        isActive = false;
                      } else {
                        isDone = index < currentStepIndex;
                        isActive = index == currentStepIndex;
                      }
                      return buildVerticalStep(
                        stepperSteps[index],
                        displayTime,
                        isDone,
                        index != stepperSteps.length - 1,
                        cubit,
                        isActive: isActive,
                      );
                    },)
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildVerticalStep(
      String title,
      String time,
      bool isDone,
      bool showLine,
      dynamic cubit,
      {bool isActive = false}
      ) {
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
                  border: isActive ? Border.all(color: mainColor.withOpacity(0.1), width: 4) : null,
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.circle,
                  size: 12.sp,
                  color: isDone || isActive ? Colors.white : Colors.grey.shade400,
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
                    fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
                    color: isDone || isActive ?
                    cubit.isDark? Colors.white: Colors.black87 : cubit.isDark? darkSubTextColor
                        : Colors.grey,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: cubit.isDark? darkSubTextColor:Colors.grey
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

  Widget buildBottomActions({
    required BuildContext context,
    required AppCubit appCubit,
    required WorkerCubit workerCubit,
  })
  {
    final String status = request['status'] ?? '';
    if (status == 'قيد الانتظار') {
      return Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h,),
        child: Row(
          children: [
            Expanded(
              //قلبت زر القبول عشان اشل الزر المعبا لون مش الي بالبوردر
            child: defaultButton(
                onPressed: () {
                  defaultConfirmDialog(
                    context: context,
                    isDark: appCubit.isDark,
                    icon: 'assets/all.svg',
                    iconColor: mainColor,
                    title: 'تأكيد قبول الحجز',
                    body: 'هل أنت متأكد من رغبتك في قبول هذا الحجز؟',
                    confirmText: 'إلغاء',
                    cancelText: 'قبول',
                    onConfirm: () => Navigator.pop(context),
                    onCancel: () async {
                      Navigator.pop(context);
                      await workerCubit.updateRequestStatus(
                        requestId: request['id'],
                        status: 'مقبول',
                      );
                    },
                  );
                },
                text: 'قبول',
                height: 50,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: defaultOutlinedButton(
                onPressed: () {
                  defaultConfirmDialog(
                    context: context,
                    isDark: appCubit.isDark,
                    icon: 'assets/x.svg',
                    iconColor: Colors.red,
                    title: 'تأكيد رفض الحجز',
                    body: 'هل أنت متأكد من رغبتك في رفض هذا الحجز؟',
                    confirmText: 'رفض',
                    cancelText: 'إلغاء',
                    onConfirm: () async {
                      Navigator.pop(context);
                      await workerCubit.updateRequestStatus(
                        requestId: request['id'],
                        status: 'مرفوض',
                      );
                    },
                  );
                },
                text: 'رفض',
                border: Colors.red,
                textColor: Colors.red,
                height: 50,
              ),
            ),
          ],
        ),
      );
    }
    if (status == 'مقبول') {
      return Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        child: defaultButton(
          onPressed: () {
            defaultConfirmDialog(
              context: context,
              isDark: appCubit.isDark,
              icon: 'assets/all.svg',
              iconColor: mainColor,
              title: 'تحديث حالة الحجز',
              body: 'هل تريد تحديث حالة الحجز إلى "في الطريق"؟',
              confirmText: 'إلغاء',
              cancelText: 'تحديث',
              onConfirm: () => Navigator.pop(context),
              onCancel: () async {
                Navigator.pop(context);
                await workerCubit.updateRequestStatus(
                  requestId: request['id'],
                  status: 'في الطريق',
                );
              },
            );
          },
          text: 'أنا في الطريق',
          height: 50,
        ),
      );
    }
    if (status == 'في الطريق') {
      return Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h,),
        child: defaultButton(
          onPressed: () {
            defaultConfirmDialog(
              context: context,
              isDark: appCubit.isDark,
              icon: 'assets/all.svg',
              iconColor: Colors.green,
              title: 'إكمال الحجز',
              body: 'هل أنت متأكد أن الخدمة اكتملت؟',
              confirmText: 'إلغاء',
              cancelText: 'مكتمل',
              cancelColor: mainColor,
              confirmColor: Colors.green,
              onConfirm: () => Navigator.pop(context),
              onCancel: () async {
                Navigator.pop(context);
                await workerCubit.updateRequestStatus(
                  requestId: request['id'],
                  status: 'مكتمل',
                );
              },
            );
          },
          text: 'إكمال الحجز',
          height: 50,
        ),
      );
    }
    return const SizedBox.shrink();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        var userData = appCubit.allUsers[request['customerId']] ?? {};
        var providerData = appCubit.allUsers[request['providerId']] ?? {};
        WorkerCubit workerCubit = WorkerCubit.get(context);
        return BlocConsumer<WorkerCubit,WorkerStates>(
          listener: (context, state) async {
            if (state is UpdateRequestStatusLoadingState) {
              showLoadingDialog(context);
            }
            if (state is UpdateRequestStatusSuccessState) {
              hideLoadingDialog(context);
              Navigator.pop(context);
              workerCubit.getWorkerRequests(forceRefresh: true);
              showSnackBar(Colors.green, 'تم تحديث حالة الحجز بنجاح', context);
            }
            if (state is UpdateRequestStatusErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }

            if (state is CreateOrGetChatLoadingState) {
              showLoadingDialog(context);
            }
            if (state is CreateOrGetChatSuccessState) {
              hideLoadingDialog(context);
              move(context,
                TheChat(
                  otherUsername: userData['name'] ?? 'مستخدم',
                  otherUserImage: userData['profileImage'] ?? '',
                  otherUserId: request['customerId'],
                  myId: request['providerId'],
                  chatId: state.chatId,
                  requestId: request['id'],
                ),
              );
            }
            if (state is CreateOrGetChatErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context,);
            }
          },
          builder: (context, state) {
            Color statusColor;
            switch (request['status']) {
              case 'مكتمل':statusColor = Colors.green;
                break;
              case 'مقبول':statusColor = Colors.blueAccent;
                break;
              case 'في الطريق':statusColor = Colors.blueAccent;
                break;
              case 'مرفوض':statusColor = Colors.redAccent;
                break;
              case 'ملغي':statusColor = Colors.redAccent;
                break;
              default:statusColor = Colors.orangeAccent;
            }
            final String status = request['status'] ?? '';

            final bool canContact = status == 'مقبول' || status == 'في الطريق' || status == 'مكتمل';

            final requestId = request['id'];

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
                                borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(15.r)),
                                child: Image.network(
                                  request['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.all(7.w),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 42.r,
                                          height: 42.r,
                                          decoration: BoxDecoration(
                                            color: appCubit.isDark
                                                ? darkBgColor.withOpacity(0.8)
                                                : Colors.white.withOpacity(0.8),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.6),
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            CupertinoIcons.back,
                                            color: Theme.of(context).iconTheme.color,
                                            size: 24.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
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
                                          boxShadow: blueShadow,
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
                                                        : mainColor.withOpacity(0.1),
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
                                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 5.h),
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
                                                        Icons.calendar_today_outlined,
                                                        size: 18.r,
                                                        color: appCubit.isDark
                                                            ? darkSubTextColor
                                                            : Colors.grey,
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
                                                              color: appCubit.isDark
                                                                  ? darkSubTextColor
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            dateFormatStatusTime(request['scheduledAt'] ?? ''),
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
                                                        CrossAxisAlignment.start,
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
                                                            timeFormatStatusTime(request['scheduledAt'] ?? ''),
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
                                                      SvgPicture.asset('assets/money.svg',color: Colors.grey,width: 20.w,),
                                                      SizedBox(width: 8.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
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
                                                              fontWeight: FontWeight.bold,
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
                                                      SvgPicture.asset('assets/timer.svg',color: Colors.grey,width: 20.w,),
                                                      SizedBox(width: 8.w),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
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
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h,),
                                            Text(
                                              '* السعر النهائي قد يزيد أو ينقص حسب طبيعة الخدمة الفعلية، وحجم العمل المطلوب، وبعد موقع العميل عن مقدم الخدمة',
                                              style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 8.sp
                                              ),

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
                        SizedBox(height: 10.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSectionTitle(title: 'مراحل التنفيذ', icon: Icons.route_outlined, cubit: appCubit),
                              SizedBox(height: 10.h,),
                              Container(
                                padding: EdgeInsetsDirectional.all(15.r),
                                decoration: BoxDecoration(
                                  color: appCubit.isDark? lightDarkColor: Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildHorizontalStepper(currentStep: getStepFromStatus(request['status']),cubit: appCubit),
                                    SizedBox(
                                        height: 10.h
                                    ),
                                    Center(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          showFullTrackingSheet(context,appCubit,request);
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
                              buildSectionTitle(title: 'ملاحظات الحجز', icon: Icons.notes_rounded, cubit: appCubit),
                              SizedBox(height: 10.h,),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsetsDirectional.all(15.r),
                                decoration: BoxDecoration(
                                  color: appCubit.isDark? lightDarkColor: Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow,
                                ),
                                child: ReadMoreText(
                                  textAlign: TextAlign.center,
                                  request['description'],
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color:  appCubit.isDark? Colors.white: Colors.black,
                                      height: 1.5
                                  ),
                                  trimLines: 3,
                                  colorClickableText: mainColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' عرض المزيد',
                                  trimExpandedText: ' عرض أقل',
                                  moreStyle: TextStyle(fontSize: 12.sp,color: mainColor),
                                ),
                              ),
                              SizedBox(height: 20.h,),
                              buildSectionTitle(title: 'معلومات العميل', icon: Icons.person_pin_outlined, cubit: appCubit),
                              SizedBox(height: 10.h,),
                              Container(
                                padding: EdgeInsetsDirectional.all(15.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: appCubit.isDark? lightDarkColor: Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 50.r,
                                          width: 50.r,
                                          padding: const EdgeInsetsDirectional.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey, width: 1),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      userData['profileImage'] ?? ''
                                                  )
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          userData['name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: appCubit.isDark? Colors.white: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
                                      child: Divider(color: appCubit.isDark? darkSubTextColor: Colors.grey.shade100, height: 1),
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
                                                  await workerCubit.createOrGetChat(
                                                    customerId: request['customerId'],
                                                    providerId: request['providerId'],
                                                    requestId: request['id'],
                                                    requestTitle: request['title'],
                                                    customerData: userData,
                                                    providerData: providerData,
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
                                          child: AbsorbPointer(
                                            absorbing: !canContact,
                                            child: Opacity(
                                              opacity: canContact ? 1.0 : 0.45,
                                              child: defaultOutlinedButtonWithIcon(
                                                onPressed: (){},
                                                text: 'إتصال',
                                                fontSize: 13.sp,
                                                height: 45.h,
                                                textColor: canContact
                                                    ? appCubit.isDark
                                                    ? Colors.white
                                                    : mainColor
                                                    : Colors.grey,
                                                border: canContact
                                                    ? appCubit.isDark
                                                    ? Colors.white
                                                    : mainColor
                                                    : Colors.grey,
                                                icon: SvgPicture.asset(
                                                  'assets/phone.svg',
                                                  color: canContact
                                                      ? appCubit.isDark
                                                      ? Colors.white
                                                      : mainColor
                                                      : Colors.grey,
                                                  width: 20.r,
                                                  height: 20.r,
                                                ),
                                              ),
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
                  bottomNavigationBar: buildBottomActions(
                    context: context,
                    appCubit: appCubit,
                    workerCubit: workerCubit,
                  ),
                ),
              );
            },
        );
      },
    );
  }
}
