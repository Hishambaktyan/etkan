import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';

import '../../shared/styles/colors.dart';
import 'done_booking_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  BookingDetailsScreen({super.key});

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الحجز'),
          titleSpacing: 20,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'موقعك',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
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
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 3,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        hintText: 'ادخل موقعك',
                        hintStyle: TextStyle(fontSize: 12.sp),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      defaultTextButton(
                          onPressed: () {}, text: 'استخدم الموقع الحالي'),
                      Spacer(),
                      defaultTextButton(onPressed: () {}, text: 'حدد بالخريطة')
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'ملاحظاتك',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
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
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 3,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.notes_outlined),
                        hintText: 'ادخل ملاحظاتك',
                        hintStyle: TextStyle(fontSize: 12.sp),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'التاريخ والوقت',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Container(
                    height: 90.h,
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
                                    Text(
                                      'التاريخ: ',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      '${selectedDate!.day} - ${selectedDate!.month} - ${selectedDate!.year}',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'الوقت: ',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
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
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'تفاصيل السعر',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.grey.shade100,
                        border: isNotesSelected
                            ? Border.all(color: mainColor)
                            : null),
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'السعر',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                '7000 ',
                                style: TextStyle(),
                              ),
                              Text(
                                'ريال',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 5.h),
                            child: const Divider(),
                          ),
                          const Row(
                            children: [
                              Text(
                                'الضرائب',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                '1500 ',
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                'ريال',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 5.h),
                            child: const Divider(),
                          ),
                          const Row(
                            children: [
                              Text(
                                'المجموع',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Spacer(),
                              Text(
                                '8500 ',
                                style: TextStyle(color: mainColor),
                              ),
                              Text(
                                'ريال',
                                style: TextStyle(color: mainColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
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
      ),
    );
  }
}
