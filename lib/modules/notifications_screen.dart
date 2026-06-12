import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/notification_cubit/notification_cubit.dart';
import 'package:Etkan/shared/cubits/notification_cubit/notification_states.dart';
import 'package:Etkan/shared/networks/local/cache_helper.dart';
import 'package:Etkan/shared/styles/colors.dart';

import '../shared/compenents/components.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<String> statusFilters;

  String selectedStatus = 'الكل';

  @override
  void initState() {
    super.initState();

    String? userRole = CacheHelper.getData(key: 'role');
    if (userRole != null) {
      if (userRole == 'user') {
        statusFilters = [
          'الكل',
          'غير مقروء',
          'الحجوزات',
        ];
      } else {
        statusFilters = [
          'الكل',
          'غير مقروء',
          'الحجوزات',
          'الاشتراكات',
          'التوثيق',
        ];
      }
    }
    NotificationCubit.get(context).getUserNotifications();
  }

  List<Map<String, dynamic>> getFilteredNotifications(
    List<Map<String, dynamic>> notifications,
  ) {
    final visibleNotifications = notifications.where((notification) {
      final String type = notification['type']?.toString() ?? '';
      return type != 'new_message';
    }).toList();

    if (selectedStatus == 'الكل') {
      return visibleNotifications;
    }

    if (selectedStatus == 'غير مقروء') {
      return visibleNotifications
          .where((notification) => notification['isRead'] != true)
          .toList();
    }

    return visibleNotifications.where((notification) {
      final String type = notification['type']?.toString() ?? '';
      return getNotificationTypeText(type) == selectedStatus;
    }).toList();
  }

  String getNotificationTypeText(String type) {
    if (type == 'new_booking' || type == 'booking_status') {
      return 'الحجوزات';
    }

    if (type == 'subscription_status' || type == 'subscription_limit') {
      return 'الاشتراكات';
    }

    if (type == 'verification_status') {
      return 'التوثيق';
    }

    return 'عام';
  }

  String getNotificationIcon(String type) {
    if (type == 'new_booking') {
      return 'assets/ticket.svg';
    }

    if (type == 'booking_status') {
      return 'assets/all.svg';
    }

    if (type == 'subscription_status' || type == 'subscription_limit') {
      return 'assets/subs.svg';
    }

    if (type == 'verification_status') {
      return 'assets/doc.svg';
    }

    return 'assets/not.svg';
  }

  String formatNotificationTime(dynamic createdAt) {
    if (createdAt == null || createdAt is! Timestamp) {
      return '';
    }

    final DateTime date = createdAt.toDate();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    }

    if (difference.inMinutes < 60) {
      return 'قبل ${difference.inMinutes} دقيقة';
    }

    if (difference.inHours < 24) {
      return 'قبل ${difference.inHours} ساعة';
    }

    if (difference.inDays == 1) {
      return 'أمس';
    }

    if (difference.inDays < 7) {
      return 'قبل ${difference.inDays} أيام';
    }

    return '${date.year}/${date.month}/${date.day}';
  }

  Widget buildFilterChip({
    required String title,
    required AppCubit cubit,
  }) {
    final bool isSelected = selectedStatus == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedStatus = title;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 9.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? mainColor
              : cubit.isDark
                  ? lightDarkColor
                  : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? mainColor
                : cubit.isDark
                    ? const Color(0xFF30363D)
                    : Colors.grey.shade200,
          ),
          boxShadow: isSelected && !cubit.isDark
              ? [
                  BoxShadow(
                    color: mainColor.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : cubit.isDark
                    ? Colors.white
                    : Colors.black87,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildNotificationCard({
    required Map<String, dynamic> notification,
    required AppCubit appCubit,
    required NotificationCubit notificationCubit,
  }) {
    final bool isRead = notification['isRead'] == true;

    final String title = notification['title']?.toString() ?? 'إشعار';
    final String body = notification['body']?.toString() ?? '';
    final String type = notification['type']?.toString() ?? '';
    final String typeText = getNotificationTypeText(type);
    final String icon = getNotificationIcon(type);
    final String time = formatNotificationTime(notification['createdAt']);
    final String notificationId = notification['notificationId']?.toString() ??
        notification['id']?.toString() ??
        '';

    return InkWell(
      onTap: () async {
        if (type == 'new_message') {
          return;
        }

        if (!isRead) {
          await notificationCubit.markNotificationAsRead(notificationId);
        }

        notificationCubit.handleNotificationData(notification);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25.r),
      child: Container(
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
              color:
                  !isRead ? mainColor.withOpacity(0.35) : Colors.transparent),
          boxShadow: blueShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 5.w,
              height: 145.h,
              decoration: BoxDecoration(
                color: isRead ? Colors.transparent : mainColor,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(25.r),
                  bottomStart: Radius.circular(25.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.all(15.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          padding: EdgeInsetsDirectional.all(12.r),
                          decoration: BoxDecoration(
                            color: appCubit.isDark
                                ? mainColor.withOpacity(0.18)
                                : mainColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: SvgPicture.asset(
                            icon,
                            color: mainColor,
                          ),
                        ),
                        if (!isRead)
                          PositionedDirectional(
                            top: -3.h,
                            start: -3.w,
                            child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: appCubit.isDark
                                      ? lightDarkColor
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
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
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 9.w,
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
                                        ? appCubit.isDark
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
                            body.isEmpty ? 'لا يوجد محتوى لهذا الإشعار' : body,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: appCubit.isDark
                                  ? darkSubTextColor
                                  : Colors.grey.shade700,
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
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 9.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  typeText,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: mainColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                CupertinoIcons.time,
                                color: appCubit.isDark
                                    ? darkSubTextColor
                                    : Colors.grey,
                                size: 14.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  color: appCubit.isDark
                                      ? darkSubTextColor
                                      : Colors.grey,
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
    );
  }

  Widget buildEmptyState(AppCubit cubit) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 95.w,
              height: 95.w,
              padding: EdgeInsetsDirectional.all(22.r),
              decoration: BoxDecoration(
                color: cubit.isDark
                    ? mainColor.withOpacity(0.18)
                    : mainColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/not.svg',
                color: mainColor,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'لا توجد إشعارات',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              selectedStatus == 'الكل'
                  ? 'لا توجد إشعارات حالياً، ستظهر هنا إشعارات الحجوزات والتحديثات المهمة.'
                  : 'لا توجد إشعارات ضمن هذا التصنيف حالياً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade600,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final AppCubit appCubit = AppCubit.get(context);
        return BlocBuilder<NotificationCubit, NotificationStates>(
          builder: (context, state) {
            NotificationCubit notificationCubit =
                NotificationCubit.get(context);

            final notifications = notificationCubit.userNotifications;
            final visibleNotifications = notifications.where((notification) {
              final String type = notification['type']?.toString() ?? '';
              return type != 'new_message';
            }).toList();
            final filteredNotifications =
                getFilteredNotifications(visibleNotifications);
            final int unreadVisibleCount = visibleNotifications
                .where((notification) => notification['isRead'] != true)
                .length;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
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
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          notificationCubit.markAllNotificationsAsRead();
                        },
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Text(
                            '$unreadVisibleCount جديد',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: notificationCubit.isNotificationsLoading ||
                        !notificationCubit.isNotificationsLoaded
                    ? NotificationsScreenShimmer(isDark: appCubit.isDark)
                    : RefreshIndicator(
                        color: mainColor,
                        onRefresh: () =>
                            notificationCubit.getUserNotifications(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 44.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsetsDirectional.only(
                                  start: 10.w,
                                  end: 10.w,
                                ),
                                itemCount: statusFilters.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 10.w),
                                itemBuilder: (context, index) {
                                  return buildFilterChip(
                                    title: statusFilters[index],
                                    cubit: appCubit,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 15.h),
                            filteredNotifications.isEmpty
                                ? Expanded(
                                    child: buildEmptyState(appCubit),
                                  )
                                : Expanded(
                                    child: ListView.separated(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
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
                                          notification:
                                              filteredNotifications[index],
                                          appCubit: appCubit,
                                          notificationCubit: notificationCubit,
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
