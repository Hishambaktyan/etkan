import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../shared/compenents/components.dart';

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
    'العروض',
  ];

  List<Map<String, dynamic>> notifications = [
    {
      'title': 'تم قبول طلبك',
      'des': 'قبل الفني هشام هاني طلبك لتركيب البانيو. سيصل في الموعد المحدد.',
      'time': 'قبل 5 دقائق',
      'type': 'الطلبات',
      'isRead': false,
      'icon': 'assets/all.svg',
    },
    {
      'title': 'رسالة جديدة',
      'des': 'أرسل لك هشام هاني رسالة في الدردشة.',
      'time': 'قبل 22 دقيقة',
      'type': 'الطلبات',
      'isRead': false,
      'icon': 'assets/chat.svg',
    },
    {
      'title': 'عرض خاص',
      'des': 'احصل على خصم 20% على باقة الاشتراك الذهبية لمدة محدودة!',
      'time': 'قبل ساعتين',
      'type': 'العروض',
      'isRead': true,
      'icon': 'assets/subs.svg',
    },
    {
      'title': 'تم إكمال الخدمة',
      'des': 'تم إكمال خدمة التكييف بنجاح. قيّم تجربتك مع الفني.',
      'time': 'أمس 03:14 م',
      'type': 'الطلبات',
      'isRead': true,
      'icon': 'assets/star.svg',
    },
  ];

  String selectedStatus = 'الكل';

  List<Map<String, dynamic>> getFilteredNotifications() {
    if (selectedStatus == 'الكل') {
      return notifications;
    }

    if (selectedStatus == 'غير مقروء') {
      return notifications
          .where((notification) => notification['isRead'] == false)
          .toList();
    }

    return notifications
        .where((notification) => notification['type'] == selectedStatus)
        .toList();
  }

  Widget buildFilterChip({
    required String title,
    required AppCubit cubit,
  }) {
    final bool isSelected = selectedStatus == title;

    return ChoiceChip(
      backgroundColor: cubit.isDark ? lightDarkColor : Colors.grey.shade100,
      selectedColor: cubit.isDark
          ? mainColor.withOpacity(0.20)
          : mainColor.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: isSelected
              ? mainColor
              : cubit.isDark
              ? const Color(0xFF30363D)
              : Colors.transparent,
        ),
      ),
      label: Text(title),
      selected: isSelected,
      onSelected: (value) {
        setState(() {
          selectedStatus = title;
        });
      },
      labelStyle: TextStyle(
        color: cubit.isDark
            ? (isSelected ? mainColor : const Color(0xFFC9D1D9))
            : (isSelected ? mainColor : Colors.black87),
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
      showCheckmark: false,
    );
  }

  Widget buildNotificationCard({
    required Map<String, dynamic> notification,
    required AppCubit cubit,
  }) {
    final bool isRead = notification['isRead'] == true;

    return Container(
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: cubit.isDark
              ? const Color(0xFF30363D)
              : isRead
              ? Colors.grey.shade200
              : mainColor.withOpacity(0.18),
        ),
        boxShadow: cubit.isDark ? [] : blueShadow,
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
                  color: cubit.isDark
                      ? mainColor.withOpacity(0.20)
                      : mainColor.withOpacity(0.10),
                ),
                child: SvgPicture.asset(
                  notification['icon'],
                  width: 22.w,
                  height: 22.h,
                  color: mainColor,
                ),
              ),
              if (!isRead)
                PositionedDirectional(
                  top: -2.h,
                  start: -2.w,
                  child: CircleAvatar(
                    radius: 5.r,
                    backgroundColor: Colors.redAccent,
                  ),
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
                      child: Text(
                        notification['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isRead
                            ? Colors.grey.withOpacity(0.10)
                            : mainColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        isRead ? 'مقروء' : 'جديد',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: isRead
                              ? cubit.isDark
                              ? darkSubTextColor
                              : Colors.grey
                              : mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ReadMoreText(
                  notification['des'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                    height: 1.6,
                  ),
                  trimLines: 2,
                  colorClickableText: mainColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' عرض المزيد',
                  trimExpandedText: ' عرض أقل',
                  moreStyle: TextStyle(
                    fontSize: 12.sp,
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 12.sp,
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      size: 15.r,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      notification['type'],
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: mainColor,
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
    );
  }

  Widget buildEmptyState(AppCubit cubit) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 80.h, start: 25.w, end: 25.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(18.r),
            decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.18)
                  : mainColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/not.svg',
              color: mainColor,
              width: 45.w,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'لا توجد إشعارات ضمن هذا التصنيف حالياً.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        final filteredNotifications = getFilteredNotifications();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: cubit.isDark ? darkBgColor : Colors.white,
            appBar: AppBar(
              backgroundColor: cubit.isDark ? darkBgColor : Colors.white,
              scrolledUnderElevation: 0,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 10,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.back,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'الإشعارات',
                    style: TextStyle(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Text(
                      '${notifications.where((item) => item['isRead'] == false).length} جديد',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 10.h),
                SizedBox(
                  height: 42.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w),
                    itemCount: statusFilters.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      return buildFilterChip(
                        title: statusFilters[index],
                        cubit: cubit,
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                Expanded(
                  child: filteredNotifications.isEmpty
                      ? buildEmptyState(cubit)
                      : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      start: 10.w,
                      end: 10.w,
                      bottom: 20.h,
                    ),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 15.h),
                    itemBuilder: (context, index) {
                      return buildNotificationCard(
                        notification: filteredNotifications[index],
                        cubit: cubit,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}