import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:trying_homy/layout/user_layout/user_main_screen.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';
import '../../shared/cubits/location_cubit/location_states.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';

class UserCompleteRequestInfo extends StatefulWidget {
  final String serciveName;
  final String serciveCategory;
  final String serciveImage;
  final int servicePrice;
  final String servicePeriod;
  final String providerId;

  const UserCompleteRequestInfo({
    super.key,
    required this.serciveName,
    required this.serciveCategory,
    required this.servicePrice,
    required this.servicePeriod,
    required this.serciveImage,
    required this.providerId,
  });

  @override
  State<UserCompleteRequestInfo> createState() =>_UserCompleteRequestInfoState();
}

class _UserCompleteRequestInfoState extends State<UserCompleteRequestInfo> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController noteController = TextEditingController();

  String? selectedAddressId;
  String? selectedAddressText;

  List<Map<String,dynamic>> addresses = [];

  Future<DateTime?> pickDateWithTheme({
    required BuildContext context,
    required AppCubit appCubit,
  })
  {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2060),
      cancelText: 'إلغاء',
      confirmText: 'تم',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: appCubit.isDark
                ? ColorScheme.dark(
              primary: mainColor,
              onPrimary: Colors.white,
              surface: lightDarkColor,
              onSurface: Colors.white,
            )
                : ColorScheme.light(
              primary: mainColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor:
            appCubit.isDark ? lightDarkColor : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Future<TimeOfDay?> pickTimeWithTheme({
    required BuildContext context,
    required AppCubit appCubit,
  })
  {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: 'إلغاء',
      confirmText: 'تم',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: appCubit.isDark
                ? ColorScheme.dark(
              primary: mainColor,
              onPrimary: Colors.white,
              surface: lightDarkColor,
              onSurface: Colors.white,
            )
                : ColorScheme.light(
              primary: mainColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor:
            appCubit.isDark ? lightDarkColor : Colors.white,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: appCubit.isDark ? lightDarkColor : Colors.white,
              hourMinuteTextColor: appCubit.isDark ? Colors.white : Colors.black,
              dayPeriodTextColor: appCubit.isDark ? Colors.white : Colors.black,
              dialHandColor: mainColor,
              dialBackgroundColor:
              appCubit.isDark ? darkBgColor : Colors.grey.shade100,
              entryModeIconColor: appCubit.isDark ? Colors.white : Colors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget buildCard({
    required AppCubit appCubit,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        boxShadow: appCubit.isDark ? [] : blueShadow,
        borderRadius: BorderRadius.circular(20.r),
        border: appCubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : null,
      ),
      child: child,
    );
  }

  Widget buildSectionTitle({
    required AppCubit appCubit,
    required String title,
    required Widget icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: appCubit.isDark
                ? mainColor.withOpacity(0.2)
                : mainColor.withOpacity(0.1),
          ),
          child: icon,
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: appCubit.isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget buildServiceInfoCard({
    required AppCubit appCubit,
    required String serviceName,
    required String serviceCategory,
    required int servicePrice,
    required String servicePeriod,
    required String serviceImage,
  })
  {
    return buildCard(
      appCubit: appCubit,
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(
            appCubit: appCubit,
            title: 'معلومات الخدمة',
            icon: Icon(
              Icons.info_outline_rounded,
              color: mainColor,
              size: 22.r,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.network(
                  serviceImage,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70.w,
                    height: 70.h,
                    color: appCubit.isDark ? darkBgColor : Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                      size: 25.r,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$serviceCategory',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: appCubit.isDark
                            ? darkSubTextColor
                            : Colors.grey.shade700,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      serviceName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                        color: appCubit.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Divider(
            color: appCubit.isDark
                ? const Color(0xFF30363D)
                : Colors.grey.shade300,
            height: 1,
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 18.r,
                      color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                color: appCubit.isDark
                    ? const Color(0xFF30363D)
                    : Colors.grey.shade300,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18.r,
                      color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          '$servicePeriod دقيقة',
                          style: TextStyle(
                            color:
                            appCubit.isDark ? Colors.white : Colors.black87,
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
    );
  }

  Widget buildAddressCard(AppCubit appCubit) {
    return BlocBuilder<LocationCubit, LocationStates>(
      builder: (context, locationState) {
        final locationCubit = LocationCubit.get(context);
        final List<Map<String, dynamic>> addresses = locationCubit.allAddresses;

        return buildCard(
          appCubit: appCubit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle(
                appCubit: appCubit,
                title: 'موقع الخدمة',
                icon: SvgPicture.asset(
                  'assets/loc.svg',
                  color: mainColor,
                  width: 22.w,
                  height: 22.h,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'اختر العنوان الذي تريد تنفيذ الخدمة فيه',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: appCubit.isDark ? darkSubTextColor : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 15.h),

              if (addresses.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: appCubit.isDark ? darkBgColor : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: appCubit.isDark
                          ? const Color(0xFF30363D)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    'لا توجد عناوين محفوظة',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                    ),
                  ),
                )
              else
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: appCubit.isDark ? darkBgColor : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: appCubit.isDark
                          ? const Color(0xFF30363D)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: selectedAddressId,
                      isExpanded: true,
                      isDense: false,
                      itemHeight: 72.h,
                      menuMaxHeight: 320.h,
                      borderRadius: BorderRadius.circular(25.r),
                      dropdownColor: appCubit.isDark ? lightDarkColor : Colors.white,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      hint: Text(
                        'اختر الموقع',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                        ),
                      ),
                      selectedItemBuilder: (context) {
                        return addresses.map((address) {
                          final String label = address['label']?.toString() ?? 'بدون عنوان';
                          final String details = address['addressName']?.toString() ?? '';
                          return Row(
                            children: [
                              SvgPicture.asset(
                                'assets/loc.svg',
                                color: mainColor,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  details.isEmpty ? label : '$label - $details',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                      items: addresses.map((address) {
                        final String id = address['id']?.toString() ?? '';
                        final String label = address['label']?.toString() ?? 'بدون عنوان';
                        final String details = address['addressName']?.toString() ?? '';
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/loc.svg',
                                  color: mainColor,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: appCubit.isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        details.isEmpty
                                            ? 'لا يوجد وصف للموقع'
                                            : details,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: appCubit.isDark
                                              ? darkSubTextColor
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        final selected = addresses.firstWhere(
                              (address) => address['id']?.toString() == value,
                          orElse: () => {},
                        );
                        final String label = selected['label']?.toString() ?? '';
                        final String details = selected['addressName']?.toString() ?? '';
                        setState(() {
                          selectedAddressId = value;
                          selectedAddressText =
                          details.isEmpty ? label : '$label - $details';
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDateTimeCard(AppCubit appCubit) {
    return buildCard(
      appCubit: appCubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(
            appCubit: appCubit,
            title: 'التاريخ والوقت',
            icon: Icon(
              Icons.calendar_month_rounded,
              size: 22.r,
              color: mainColor,
            ),
          ),
          SizedBox(height: 20.h),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(25.r),
              color: appCubit.isDark
                  ? const Color(0xFF30363D)
                  : Colors.grey.shade400,
              dashPattern: const [6, 3],
            ),
            child: Container(
              height: 105.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: appCubit.isDark ? darkBgColor : Colors.grey.shade100,
              ),
              child: ConditionalBuilder(
                condition: selectedDate != null && selectedTime != null,
                builder: (context) => Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.all(8.r),
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? mainColor.withOpacity(0.2)
                                        : mainColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month_rounded,
                                    color: mainColor,
                                    size: 18.r,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'التاريخ:  ',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  '${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.all(8.r),
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? mainColor.withOpacity(0.2)
                                        : mainColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    Icons.timer_outlined,
                                    color: mainColor,
                                    size: 18.r,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'الوقت:  ',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  MaterialLocalizations.of(context)
                                      .formatTimeOfDay(
                                    selectedTime!,
                                    alwaysUse24HourFormat: false,
                                  ),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          selectedDate = await pickDateWithTheme(
                            context: context,
                            appCubit: appCubit,
                          );
                          if (selectedDate != null) {
                            selectedTime = await pickTimeWithTheme(
                              context: context,
                              appCubit: appCubit,
                            );
                          }
                          setState(() {});
                        },
                        icon: SvgPicture.asset(
                          'assets/pen.svg',
                          color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => InkWell(
                  onTap: () async {
                    final pickedDate = await pickDateWithTheme(
                      context: context,
                      appCubit: appCubit,
                    );
                    if (pickedDate == null) return;
                    final pickedTime = await pickTimeWithTheme(
                      context: context,
                      appCubit: appCubit,
                    );
                    if (pickedTime == null) return;
                    setState(() {
                      selectedDate = pickedDate;
                      selectedTime = pickedTime;
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: appCubit.isDark
                            ? darkSubTextColor
                            : Colors.grey.shade500,
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        'اختر التاريخ والوقت',
                        style: TextStyle(
                          color: appCubit.isDark
                              ? darkSubTextColor
                              : Colors.grey.shade500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotesCard(AppCubit appCubit) {
    return buildCard(
      appCubit: appCubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(
            appCubit: appCubit,
            title: 'ملاحظاتك',
            icon: Icon(
              Icons.notes_rounded,
              size: 22.r,
              color: mainColor,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            height: 90.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: appCubit.isDark ? darkBgColor : Colors.grey.shade100,
              border: Border.all(
                color: appCubit.isDark
                    ? const Color(0xFF30363D)
                    : Colors.grey.shade200,
              ),
            ),
            child: TextFormField(
              controller: noteController,
              maxLines: 3,
              style: TextStyle(
                fontSize: 12.sp,
                color: appCubit.isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'ادخل ملاحظاتك',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 15.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    LocationCubit.get(context).getAddresses(CacheHelper.getData(key: 'uid'));
  }

  @override
  Widget build(BuildContext context) {
    String serviceName = widget.serciveName;
    String serviceCategory = widget.serciveCategory;
    int servicePrice = widget.servicePrice;
    String servicePeriod = widget.servicePeriod;
    String serviceImage = widget.serciveImage;
    String providerId = widget.providerId;

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: appCubit.isDark ? darkBgColor : Colors.white,
              scrolledUnderElevation: 0,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: appCubit.isDark ? Colors.white : Colors.black,
                ),
              ),
              title: Text(
                'تفاصيل الحجز',
                style: TextStyle(
                  color: appCubit.isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titleSpacing: 15,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildServiceInfoCard(
                      appCubit: appCubit,
                      serviceName: serviceName,
                      serviceCategory: serviceCategory,
                      servicePrice: servicePrice,
                      servicePeriod: servicePeriod,
                      serviceImage: serviceImage,
                    ),
                    SizedBox(height: 15.h),
                    buildAddressCard(appCubit),
                    SizedBox(height: 15.h),
                    buildDateTimeCard(appCubit),
                    SizedBox(height: 15.h),
                    buildNotesCard(appCubit),
                    SizedBox(height: 20.h),
                    BlocConsumer<UserCubit, UserStates>(
                      listener: (context, state) {
                        if (state is CreateRequestLoadingState) {
                          showLoadingDialog(context);
                        }
                        if (state is CreateRequestSuccessState) {
                          hideLoadingDialog(context);
                          appCubit.changeIndex(0);
                          showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.2),
                            builder: (BuildContext context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Center(
                                      child: AlertDialog(
                                        backgroundColor: appCubit.isDark
                                            ? lightDarkColor
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.r),
                                        ),
                                        contentPadding: EdgeInsets.all(20.r),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Lottie.asset(
                                              'assets/animations/done.json',
                                              width: 130.w,
                                              height: 130.h,
                                            ),
                                            SizedBox(height: 20.h),
                                            Text(
                                              'تم إرسال الطلب بنجاح',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              'تم إرسال طلبك بنجاح، سوف يصلك إشعار عند قبول الفني للطلب',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                height: 1.5,
                                              ),
                                            ),
                                            SizedBox(height: 25.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: defaultButton(
                                                    onPressed: () =>
                                                        moveAndReplace(
                                                          context,
                                                          const UserMainScreen()
                                                        ),
                                                    text: 'العودة إلى الرئيسية',
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
                      },
                      builder: (context, state) {
                        UserCubit userCubit = UserCubit.get(context);
                        return defaultButton(
                          onPressed: () async {
                            if (selectedAddressId == null || selectedAddressText == null) {
                              showSnackBar(
                                Colors.red,
                                'يرجى اختيار موقع الخدمة',
                                context,
                              );
                              return;
                            }
                            if (selectedDate == null || selectedTime == null) {
                              showSnackBar(Colors.red, 'يرجى اختيار التاريخ والوقت', context,);
                              return;
                            }

                            DateTime bookingDateTime = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );

                            var currentUser = appCubit.allUsers[CacheHelper.getData(key: 'uid')];

                            await userCubit.createRequest(
                              category: serviceCategory,
                              customerId: currentUser['uid'],
                              providerId: providerId,
                              address: selectedAddressText!,
                              title: serviceName,
                              description: noteController.text.trim(),
                              image: serviceImage,
                              duration: servicePeriod,
                              price: servicePrice,
                              scheduledAt:
                              Timestamp.fromDate(bookingDateTime),
                            );
                          },
                          text: 'تأكيد الحجز',
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}