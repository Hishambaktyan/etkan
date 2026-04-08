import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class BookingDetails extends StatefulWidget {
  final Map<String,dynamic> request;
  final Map<String,dynamic> providerData;
  const BookingDetails({super.key, required this.request, required this.providerData});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {

  final List<String> stepperSteps = [
    "قيد الانتظار",
    "مقبول",
    "جاري التنفيذ",
    "مكتمل"
  ];

  final List<String> terminalStates = ["مرفوض", "ملغي"];

  Widget buildHorizontalStepper({required int currentStep,required dynamic cubit}) {

    List<String> steps = ['تم الطلب', 'تم القبول', 'جاري التنفيذ','تم اكمال الخدمة'];

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
            padding: EdgeInsetsDirectional.only(start: 20.w,end: 20.w,bottom: 20.h,top: 10.h),
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
                          2: 'processingAt',
                          3: 'completedAt',
                        };
                        String timeKey = statusTimesKeys[index]!;
                        String displayTime = cubit.formatStatusTime(requestData[timeKey]);
                        bool isDone;
                        bool isActive;
                        Color circleColor;
                        int currentStepIndex = stepperSteps.indexOf(currentStatusFromDb);
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

  Widget buildVerticalStep(String title, String time, bool isDone, bool showLine,dynamic cubit, {bool isActive = false}) {
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

  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> request = widget.request;
    final Map<String,dynamic> providerData = widget.providerData;
    return BlocBuilder<AppCubit,AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
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
                            request['image'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300.h,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 130.h,
                              color: Colors.grey.shade300,
                            ) ,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(7),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: ()=>Navigator.pop(context),
                                    child: const Icon(
                                        CupertinoIcons.back
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
                            padding:EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.all(18.r),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: cubit.isDark ? lightDarkColor : Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: mainColor.withOpacity(0.2),
                                        spreadRadius: 1.0,
                                        blurRadius: 7.0,
                                        offset: const Offset(2, 5),
                                      ),
                                    ],
                                    border: cubit.isDark ? Border.all(color: const Color(0xFF30363D)) : null,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.r),
                                            decoration: BoxDecoration(
                                              color: cubit.isDark ? mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10.r),
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
                                                color: cubit.isDark ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(7.r),
                                            ),
                                            child: Text(
                                              request['status'] ?? '',
                                              style: TextStyle(
                                                color: Colors.orange.shade800,
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
                                          color: cubit.isDark ? Colors.white : Colors.black,
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
                                                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                ),
                                                SizedBox(width: 8.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'التاريخ',
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.dateFormatStatusTime(request['scheduledAt'] ?? ''),
                                                      style: TextStyle(
                                                        color: cubit.isDark ? Colors.white : Colors.black87,
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.w500,
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
                                            color: cubit.isDark ? darkSubTextColor : Colors.grey.shade300,
                                          ),
                                          SizedBox(width: 15.w),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_outlined,
                                                  size: 18.r,
                                                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                ),
                                                SizedBox(width: 8.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'الوقت',
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      cubit.timeFormatStatusTime(request['scheduledAt'] ?? ''),
                                                      style: TextStyle(
                                                        color: cubit.isDark ? Colors.white : Colors.black87,
                                                        fontSize: 13.sp,
                                                        fontWeight: FontWeight.w500,
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
                                        padding: EdgeInsets.symmetric(vertical: 15.h),
                                        child: Divider(
                                          color: cubit.isDark ? darkSubTextColor : Colors.grey.shade300,
                                          height: 1,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.payments_outlined,
                                                  size: 18.r,
                                                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                ),
                                                SizedBox(width: 8.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'السعر التقديري',
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${request['price'] ?? ''} $reyalSymbol',
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
                                            height: 35.h,
                                            width: 1,
                                            color: cubit.isDark ? darkSubTextColor : Colors.grey.shade300,
                                          ),
                                          SizedBox(width: 15.w),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.timer_outlined,
                                                  size: 18.r,
                                                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                ),
                                                SizedBox(width: 8.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'المدة المتوقعة',
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: cubit.isDark ? darkSubTextColor : Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${request['duration'] ?? ''} دقيقة',
                                                      style: TextStyle(
                                                        color: cubit.isDark ? Colors.white : Colors.black87,
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(15.r),
                          decoration: BoxDecoration(
                              color: cubit.isDark? lightDarkColor: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow (
                                  color: mainColor.withOpacity(0.2),
                                  spreadRadius: 1.0,
                                  blurRadius: 7.0,
                                  offset: const Offset(2, 5),
                                ),
                              ],
                              border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsetsDirectional.all(8),
                                    decoration: BoxDecoration(
                                        color: cubit.isDark? mainColor.withOpacity(0.2): mainColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10.r)
                                    ),
                                    child: Icon(
                                        Icons.route_outlined,
                                        size: 22.r,
                                        color: mainColor
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'مراحل التنفيذ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: cubit.isDark? Colors.white:Colors.black
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              buildHorizontalStepper(currentStep: cubit.getStepFromStatus(request['status']),cubit: cubit),
                              SizedBox(height: 10.h),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    showFullTrackingSheet(context,cubit,request);
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
                        SizedBox(height: 15.h,),
                        Container(
                          padding: EdgeInsetsDirectional.all(15.r),
                          decoration: BoxDecoration(
                              color: cubit.isDark? lightDarkColor: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow (
                                  color: mainColor.withOpacity(0.2),
                                  spreadRadius: 1.0,
                                  blurRadius: 7.0,
                                  offset: const Offset(2, 5),
                                ),
                              ],
                              border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null

                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsetsDirectional.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: cubit.isDark?mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1)
                                      ),
                                      child: Icon(
                                          Icons.notes_rounded,
                                          size: 22.r,
                                          color: mainColor
                                      )
                                  ),
                                  SizedBox(
                                      width: 10.w
                                  ),
                                  Text(
                                    'ملاحظات الحجز',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: cubit.isDark? Colors.white: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 10.h
                              ),
                              ReadMoreText(
                                request['description'] ?? '',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color:  cubit.isDark? Colors.white: Colors.black,
                                    height: 1.5
                                ),
                                trimLines: 3,
                                colorClickableText: mainColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: ' عرض المزيد',
                                trimExpandedText: ' عرض أقل',
                                moreStyle: TextStyle(fontSize: 12.sp,color: mainColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h,),
                        Container(
                          padding: EdgeInsetsDirectional.all(18.r),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: cubit.isDark? lightDarkColor: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow (
                                  color: mainColor.withOpacity(0.2),
                                  spreadRadius: 1.0,
                                  blurRadius: 7.0,
                                  offset: const Offset(2, 5),
                                ),
                              ],
                              border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                          ),
                          child: Column(
                            children: [
                              Row (
                                children: [
                                  Container(
                                      padding: const EdgeInsetsDirectional.all(8),
                                      decoration: BoxDecoration(
                                          color: cubit.isDark? mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10.r)
                                      ),
                                      child: Icon(
                                          Icons.person_pin_outlined,
                                          size: 22.r,
                                          color: mainColor
                                      )
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'معلومات الفني',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: cubit.isDark? Colors.white: Colors.black87
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25.r,
                                    backgroundImage: NetworkImage(
                                       providerData['profileImage'] ?? ''
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    providerData['name']?? '',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark? Colors.white: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
                                child: Divider(color: cubit.isDark? darkSubTextColor: Colors.grey.shade300, height: 1),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/phone.svg',
                                    color: cubit.isDark? darkSubTextColor: Colors.grey.shade600,
                                    width: 18.r,
                                    height: 18.r,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    providerData['phone'] ?? '',
                                    style: TextStyle(
                                        color: cubit.isDark? Colors.white: Colors.black87,
                                        fontSize: 12.sp,
                                        letterSpacing: 7
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: defualtButtonWithIcon(
                                      onPressed: (){},
                                      text: 'دردشة',
                                      height: 45.h,
                                      textSize: 13.sp,
                                      icon: SvgPicture.asset(
                                        'assets/chat.svg',
                                        color: Colors.white,
                                        width: 20.r,
                                        height: 20.r,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: defualtOutlinedButtonWithIcon(
                                      onPressed: () {},
                                      text: 'إتصال',
                                      fontSize: 13.sp,
                                      height: 45.h,
                                      textColor: cubit.isDark? Colors.white: mainColor,
                                      border: cubit.isDark? Colors.white: mainColor,
                                      icon: SvgPicture.asset(
                                        'assets/phone.svg',
                                        color: cubit.isDark? Colors.white: mainColor,
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
          ),
        ) ;
      },
    );
  }
}
