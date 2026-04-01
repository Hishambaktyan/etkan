import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import '../../shared/styles/colors.dart';
import 'done_booking_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String serciveName;
  final String serciveCategory;
  final String serciveSubCategory;
  final int servicePrice;
  final int servicePeriod;
  const BookingDetailsScreen({super.key, required this.serciveName, required this.serciveCategory, required this.serciveSubCategory, required this.servicePrice, required this.servicePeriod});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();
  bool isLocationSelected = false;
  bool isNotesSelected = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    locationFocusNode.addListener(() {
      setState(() {
        isLocationSelected = locationFocusNode.hasFocus;
      });
    });
    noteFocusNode.addListener(() {
      setState(() {
        isNotesSelected = noteFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    locationFocusNode.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     String serviceName = widget.serciveName;
     String serviceCategory = widget.serciveCategory;
     String serviceSubCategory = widget.serciveSubCategory;
     int servicePrice = widget.servicePrice;
     int servicePeriod = widget.servicePeriod;
    MyCubit cubit = MyCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)
          ),
          title: const Text('تفاصيل الحجز'),
          titleSpacing: 15,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(18.r),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: cubit.isDark? lightDarkColor: Colors.white,
                      boxShadow: [
                        BoxShadow (
                          color: mainColor.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 7.0,
                          offset: const Offset(2, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.r),
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
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: cubit.isDark?mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1)
                              ),
                              child: const Icon(Icons.info_outline_rounded,color: mainColor,)
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'معلومات الخدمة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: cubit.isDark? Colors.white: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.network(
                              'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                              width: 70.w,
                              height: 70.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 70.w,
                                height: 70.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: cubit.isDark? darkBgColor: Colors.white,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '$serviceCategory   >   $serviceSubCategory',
                                  style: TextStyle(
                                    color: cubit.isDark? Colors.white: Colors.grey.shade700,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  serviceName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                    color: cubit.isDark? Colors.white: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Divider(color: cubit.isDark? darkSubTextColor: Colors.grey.shade300, height: 1),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.payments_outlined,
                                  size: 18.r,
                                  color:  cubit.isDark? darkSubTextColor: Colors.grey,                                                  ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('السعر التقديري',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color:  cubit.isDark? darkSubTextColor: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '$servicePrice $reyalSymbol',
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
                            color:  cubit.isDark? darkSubTextColor: Colors.grey.shade300,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 18.r,
                                  color:  cubit.isDark? darkSubTextColor: Colors.grey,
                                ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'المدة المتوقعة',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color:  cubit.isDark? darkSubTextColor: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '$servicePeriod دقيقة',
                                      style: TextStyle(
                                        color: cubit.isDark? Colors.white: Colors.black87,
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
                ),
                SizedBox(height: 15.h,),
                Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                      color: cubit.isDark? lightDarkColor: Colors.white,
                      boxShadow: [
                        BoxShadow (
                          color: mainColor.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 7.0,
                          offset: const Offset(2, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.r),
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
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: cubit.isDark?mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1)
                              ),
                              child: SvgPicture.asset('assets/loc.svg',color: mainColor,)
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'موقعك',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: cubit.isDark? Colors.white: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        height: 90.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.r),
                          border: isLocationSelected
                              ? Border.all(color: mainColor)
                              : null,
                        ),
                        child: TextFormField(
                          focusNode: locationFocusNode,
                          maxLines: 3,
                          style: TextStyle(fontSize: 12.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'ادخل موقعك',
                            hintStyle: TextStyle(fontSize: 12.sp),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: defaultTextButton(onPressed: () {}, text: 'استخدم الموقع الحالي',isLined: false)),
                          defaultTextButton(onPressed: () {}, text: 'حدد بالخريطة',isLined: false)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h,),
                Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                      color: cubit.isDark? lightDarkColor: Colors.white,
                      boxShadow: [
                        BoxShadow (
                          color: mainColor.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 7.0,
                          offset: const Offset(2, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.r),
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
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: cubit.isDark?mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1)
                              ),
                              child: Icon(
                                  Icons.calendar_month_rounded,
                                  size: 22.r,
                                  color: mainColor
                              )
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'الموعد',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: cubit.isDark? Colors.white: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.grey.shade100,
                            border: isNotesSelected
                                ? Border.all(color: mainColor)
                                : null),
                        child: ConditionalBuilder(
                          condition: selectedDate != null || selectedTime != null,
                          builder: (context) => Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            child: const Icon(Icons.calendar_month_rounded,color: mainColor,)
                                        ),
                                        SizedBox(width: 10.w,),
                                        const Text('التاريخ:  '),
                                        Text(
                                          '${selectedDate!.day} - ${selectedDate!.month} - ${selectedDate!.year}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h,),
                                    Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsetsDirectional.all(8),
                                            decoration: BoxDecoration(
                                                color: cubit.isDark? mainColor.withOpacity(0.2): mainColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10.r)
                                            ),
                                            child: const Icon(Icons.timer_outlined,color: mainColor,)
                                        ),
                                        SizedBox(width: 10.w,),
                                        const Text('الوقت:  '),
                                        Text(
                                          '${MaterialLocalizations.of(context).formatTimeOfDay(selectedTime!, alwaysUse24HourFormat: false)}',
                                          style: TextStyle(fontSize: 11.sp),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2060),
                                      cancelText: 'إلغاء',
                                    );

                                    if (selectedDate != null) {
                                      selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.edit,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          fallback: (context) => InkWell(
                            onTap: () async {
                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2060),
                                cancelText: 'إلغاء',
                              );

                              if (selectedDate != null) {
                                selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                              }
                              setState(() {});
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                Text(
                                  'اختر التاريخ والوقت',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h,),
                Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                      color: cubit.isDark? lightDarkColor: Colors.white,
                      boxShadow: [
                        BoxShadow (
                          color: mainColor.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 7.0,
                          offset: const Offset(2, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20.r),
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
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: cubit.isDark?mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1)
                              ),
                              child: Icon(
                                  Icons.notes_rounded,
                                  size: 22.r,
                                  color: mainColor
                              )
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'ملاحظاتك',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: cubit.isDark? Colors.white: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        height: 90.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.grey.shade100,
                            border: isNotesSelected
                                ? Border.all(color: mainColor)
                                : null),
                        child: TextFormField(
                          focusNode: noteFocusNode,
                          maxLines: 3,
                          style: TextStyle(fontSize: 12.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'ادخل ملاحظاتك',
                            hintStyle: TextStyle(fontSize: 12.sp),
                            contentPadding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                defualtButton(
                    onPressed: ()=>moveAndReplace(context, const DoneBookingScreen()),
                    text: 'تأكيد الحجز'),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
