import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../main.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../images_view.dart';

class WorkerOrderDetails extends StatelessWidget {
  const WorkerOrderDetails({super.key});

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

  void showFullTrackingSheet(BuildContext context , dynamic cubit) {
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
            padding: EdgeInsets.all(20.r),
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
                SizedBox(
                    height: 20.h
                ),
                Text(
                  'تفاصيل تتبع الحجز',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    color: cubit.isDark? Colors.white: Colors.black,
                  ),
                ),
                SizedBox(
                    height: 25.h
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildVerticalStep("تم طلب الخدمة", "23 فبراير، 04:12 م", true, true,cubit),
                      _buildVerticalStep("تم قبول الطلب", "23 فبراير، 04:30 م", true, true,cubit),
                      _buildVerticalStep("جاري التنفيذ حالياً", "الآن", false, true, isActive: true,cubit),
                      _buildVerticalStep("تم اكتمال الخدمة", "بانتظار إنهاء العمل", false, false,cubit),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalStep(String title, String time, bool isDone, bool showLine,dynamic cubit, {bool isActive = false}) {
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
                SizedBox(height: 25.h), // مسافة بين الخطوات
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,States>(
      listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 370.h,
                    child: Stack(
                      children: [
                        Image.network(
                          'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300.h,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 20.h,start: 10.w,end: 10.w),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                      child: Container(
                                        height: 70.h,
                                        width: 70.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(12.r),
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg'
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                      child: Container(
                                        height: 70.h,
                                        width: 70.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(12.r),
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    'https://i.pinimg.com/736x/d2/89/9f/d2899f239623e6cb64f1854b469af5b5.jpg'
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                      child: Container(
                                        height: 70.h,
                                        width: 70.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(12.r),
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    'https://i.pinimg.com/736x/6d/66/af/6d66af4d10a9a7d19d1df880b0ce3b23.jpg'
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                      child: Container(
                                        height: 70.h,
                                        width: 70.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(12.r),
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    'https://i.pinimg.com/1200x/9b/9c/93/9b9c93ac5db55031a32139e972ee6da6.jpg'
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.all(18.r),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: cubit.isDark? lightDarkColor: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: cubit.isDark? []: shadow,
                                      border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.r),
                                            decoration: BoxDecoration(
                                              color: cubit.isDark? mainColor.withOpacity(0.2): mainColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/ticket.svg',
                                              color: mainColor,
                                              width: 22.w,
                                              height: 22.h,
                                            ),
                                          ),
                                          SizedBox(
                                              width: 10.w
                                          ),
                                          Text(
                                            'طلب رقم #233',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              color: cubit.isDark? Colors.white: Colors.black
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(7.r),
                                            ),
                                            child: Text(
                                              'قيد الانتظار',
                                              style: TextStyle(
                                                color: Colors.orange.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.h),
                                        child: Divider(color: cubit.isDark? darkSubTextColor: Colors.grey.shade100, height: 1),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                    Icons.payments_outlined,
                                                    size: 18.r,
                                                    color: cubit.isDark? darkSubTextColor: Colors.grey
                                                ),
                                                SizedBox(width: 8.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'السعر التقديري',
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: cubit.isDark? darkSubTextColor: Colors.grey
                                                        )
                                                    ),
                                                    Text(
                                                      '15000 $reyalSymbol',
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.bold
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
                                              color: cubit.isDark? darkSubTextColor: Colors.grey
                                          ),
                                          SizedBox(width: 15.w),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(Icons.timer_outlined, size: 18.r,color: cubit.isDark? darkSubTextColor: Colors.grey),
                                                SizedBox(width: 8.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'المدة المتوقعة',
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: cubit.isDark? darkSubTextColor: Colors.grey
                                                        )
                                                    ),
                                                    Text(
                                                      '45 دقيقة',
                                                      style: TextStyle(
                                                          color: cubit.isDark? Colors.white: Colors.black87,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.bold
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
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
                            boxShadow: cubit.isDark? []: shadow,
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
                              SizedBox(
                                  height: 20.h
                              ),
                              buildHorizontalStepper(currentStep: 1,cubit: cubit),
                              SizedBox(
                                  height: 10.h
                              ),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    showFullTrackingSheet(context,cubit);
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
                        Container(
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                            color: cubit.isDark? lightDarkColor: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: shadow,
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
                                          Icons.build_circle_outlined,
                                          size: 22.r,
                                          color: mainColor
                                      )
                                  ),
                                  SizedBox(
                                      width: 10.w
                                  ),
                                  Text(
                                    'تفاصيل الخدمة',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      color: cubit.isDark? Colors.white: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: 15.h
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.network(
                                      'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                                      width: 100.w,
                                      height: 100.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 100.w,
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 10.w
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'تركيب حوض حمام جداري',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: cubit.isDark? Colors.white: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '12000 $reyalSymbol',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: mainColor,
                                          ),
                                        ),
                                        SizedBox(
                                            height: 10.h
                                        ),
                                        Divider(
                                            color: cubit.isDark? darkSubTextColor: Colors.grey.shade100,
                                            height: 1
                                        ),
                                        SizedBox(
                                            height: 10.h
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                                Icons.calendar_month_outlined,
                                                size: 14.r,
                                                color: cubit.isDark? darkSubTextColor: Colors.grey
                                            ),
                                            SizedBox(
                                                width: 4.w
                                            ),
                                            Text(
                                              '23/02/2026',
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: cubit.isDark? darkSubTextColor: Colors.grey.shade600
                                              ),
                                            ),
                                            const Spacer(),
                                            Icon(
                                                Icons.access_time_rounded,
                                                size: 14.r,
                                                color: cubit.isDark? darkSubTextColor: Colors.grey
                                            ),
                                            SizedBox(
                                                width: 4.w
                                            ),
                                            Text(
                                              '04:12 م',
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: cubit.isDark? darkSubTextColor: Colors.grey.shade600
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(
                            color: cubit.isDark? lightDarkColor: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: shadow,
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
                                    'ملاحظات الطلب',
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
                                'خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات',
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
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          padding: EdgeInsetsDirectional.all(18.r),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cubit.isDark? lightDarkColor: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: shadow,
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
                                    'معلومات العميل',
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
                                  Container(
                                    height: 50.r,
                                    width: 50.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: cubit.isDark? Colors.white: Colors.black, width: 1),
                                      image: const DecorationImage(
                                        image: NetworkImage(
                                          'https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'محمد عبد الله محمد',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark? Colors.white: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                child: Divider(color: cubit.isDark? darkSubTextColor: Colors.grey.shade100, height: 1),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/loc.svg',
                                    color: cubit.isDark? darkSubTextColor: Colors.grey.shade600,
                                    width: 18.r,
                                    height: 18.r,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      'عدن - المنصورة - ريمي',
                                      style: TextStyle(
                                          color: cubit.isDark? Colors.white: Colors.black87,
                                          fontSize: 12.sp
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
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
                                    '770770858',
                                    style: TextStyle(
                                        color: cubit.isDark? Colors.white: Colors.black87,
                                        fontSize: 12.sp
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: defualtButtonWithIcon(
                                      onPressed: () {},
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
            bottomNavigationBar: Container(
              width: double.infinity,
              margin: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: defualtButton(
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  backgroundColor: cubit.isDark? lightDarkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  contentPadding: EdgeInsets.all(20.r),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(15.r),
                                        decoration: BoxDecoration(
                                          color: mainColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: mainColor,
                                          size: 50.r,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        'تأكيد قبول الطلب',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.bodyLarge!.color
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'هل أنت متأكد من رغبتك في قبول هذا الطلب والبدء في التنفيذ؟',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                          height: 1.5,
                                        ),
                                      ),
                                      SizedBox(height: 25.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mainColor,
                                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                'نعم، قبول',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                                side: BorderSide(color: Colors.grey.shade300),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                ),
                                              ),
                                              child: Text(
                                                'تراجع',
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        text: 'قبول',
                      height: 50
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: defualtOutlinedButton(
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  backgroundColor: cubit.isDark? lightDarkColor : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  contentPadding: EdgeInsets.all(20.r),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(15.r),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.block_rounded,
                                          color: Colors.red,
                                          size: 50.r,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        'تأكيد رفض الطلب',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.bodyLarge!.color
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'هل أنت متأكد من رغبتك في رفض هذا الطلب ؟',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Theme.of(context).textTheme.bodyLarge!.color,
                                          height: 1.5,
                                        ),
                                      ),
                                      SizedBox(height: 25.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Text(
                                                'نعم، رفض',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                                side: BorderSide(color: Colors.grey.shade300),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                ),
                                              ),
                                              child: Text(
                                                'تراجع',
                                                style: TextStyle(
                                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        text: 'رفض',
                        border: Colors.red,
                        textColor: Colors.red,
                      height: 50
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
