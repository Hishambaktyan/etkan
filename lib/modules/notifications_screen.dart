import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> statusFilters = [
    'الكل',
    'غير مقروء',
    'الطلبات',
  ];

  List Notifications = [
    {
      'title': "تم قبول طلبك",
      'des': "قبل الفني هشام هاني طلبك لتركيب البانيو. سيصل في الموعد المحدد.",
      'time': "قبل 5 دقائق"
    },
    {
      'title': "رسالة جديدة",
      'des': "أرسل لك هشام هاني رسالة في الدردشة.",
      'time': "قبل 22 دقيقة",
    },
    {
      'title': "عرض خاص",
      'des': "احصل على خصم 20% على باقة الاشتراك الذهبية لمدة محدودة!",
      'time': "قبل ساعتين",
    },
    {
      'title': "تم أكمال الحدمة",
      'des': "تم إكمال خدمة التكييف بنجاح. قيّم تجربتك مع الفني.",
      'time': "أمس 03:14 م",
    },
  ];
  String selectedStatus = 'الكل';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded)),
          title: Text(
            'الإشعارات',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsetsDirectional.only(start: 10.w),
                  itemCount: statusFilters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: index == 6 ? 0 : 15.w,
                      ),
                      child: ChoiceChip(
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: mainColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        label: Text(statusFilters[index]),
                        selected: selectedStatus == statusFilters[index],
                        onSelected: (value) {
                          setState(() {
                            selectedStatus = statusFilters[index];
                          });
                        },
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: selectedStatus == statusFilters[index]
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                child: ListView.builder(
                  itemCount: Notifications.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Container(
                      padding: EdgeInsetsDirectional.all(15.r),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 7.0,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          border: null),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: mainColor.withOpacity(0.1)),
                                child: SvgPicture.asset(
                                  'assets/not.svg',
                                  width: 23.w,
                                  height: 23.h,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                Notifications[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          ReadMoreText(
                            Notifications[index]['des'],
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                height: 1.5),
                            trimLines: 1,
                            colorClickableText: mainColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' عرض المزيد',
                            trimExpandedText: ' عرض أقل',
                            moreStyle:
                                TextStyle(fontSize: 12.sp, color: mainColor),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            Notifications[index]['time'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
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
        ),
      ),
    );
  }
}
