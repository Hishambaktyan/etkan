import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/images_view.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AdminProviderInfo extends StatefulWidget {
  final Map<String, dynamic> provider;

  const AdminProviderInfo({
    super.key,
    required this.provider,
  });

  @override
  State<AdminProviderInfo> createState() => _AdminProviderInfoState();
}

class _AdminProviderInfoState extends State<AdminProviderInfo> {
  bool get isSubscribed =>
      widget.provider['isSubscribed'] == true ||
      widget.provider['subscription']?['isActive'] == true;

  Map<String, dynamic> get subscription =>
      widget.provider['subscription'] is Map<String, dynamic>
          ? widget.provider['subscription']
          : {};

  List<String> get experiences {
    final value = widget.provider['experiences'];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get previousWorks {
    final value = widget.provider['previousWorks'];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  bool isActive = true;

  Widget buildWhiteCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: child,
    );
  }

  Widget buildSectionHeader({
    required String title,
    required String icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SvgPicture.asset(
            icon,
            color: mainColor,
            width: 24.w,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(35.r),
      ),
      child: Container(
        width: double.infinity,
        height: 340.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              mainColor.withOpacity(0.9),
              const Color(0xFF0F0F1E),
            ],
            stops: const [0.0, 0.8],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50.h,
              left: -50.w,
              child: CircleAvatar(
                radius: 100.r,
                backgroundColor: Colors.white.withOpacity(0.15),
              ),
            ),
            Positioned(
              top: 80.h,
              right: -60.w,
              child: Container(
                width: 250.r,
                height: 250.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00F2FF).withOpacity(0.5),
                      const Color(0xFF00F2FF).withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 30.h, start: 10.w, end: 10.w, bottom: 20.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(15.r),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42.w,
                          height: 42.h,
                          margin: EdgeInsetsDirectional.only(end: 10.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'حساب الفني',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                isActive ? 'نشط' : 'معطل',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                height: 20.h,
                                width: 30.w,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch.adaptive(
                                    value: isActive,
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        isActive = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 98.r,
                          height: 98.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 48.r,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            backgroundImage: widget.provider['profileImage'] !=
                                        null &&
                                    widget.provider['profileImage']
                                        .toString()
                                        .isNotEmpty
                                ? NetworkImage(widget.provider['profileImage'])
                                : null,
                            child: widget.provider['profileImage'] == null ||
                                    widget.provider['profileImage']
                                        .toString()
                                        .isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 48.r,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          widget.provider['name'] ?? 'عامل',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Container(
                          padding: EdgeInsetsDirectional.only(
                            start: 12.w,
                            end: 15.w,
                            top: 5.h,
                            bottom: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            widget.provider['specialization'] ?? 'غير محدد',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSubscribed
                                ? Colors.green.withOpacity(0.18)
                                : Colors.red.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: isSubscribed
                                  ? Colors.green.withOpacity(0.4)
                                  : Colors.red.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            isSubscribed ? 'مشترك حاليًا' : 'غير مشترك',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickStats() {
    return Row(
      children: [
        buildStatCard(
          icon: 'assets/star.svg',
          value: '${widget.provider['avgRating'] ?? 0.0}',
          title: 'التقييم',
        ),
        SizedBox(width: 15.w),
        buildStatCard(
          icon: 'assets/all.svg',
          value: '${widget.provider['completedJobs'] ?? 0}',
          title: 'عمل مكتمل',
        ),
      ],
    );
  }

  Widget buildStatCard({
    required String icon,
    required String value,
    required String title,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SvgPicture.asset(
                    icon,
                    color: mainColor,
                    width: 24.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactCard() {
    return buildWhiteCard(
      child: Column(
        children: [
          buildInfoRow(
            icon: 'assets/phone.svg',
            title: 'رقم الهاتف',
            value: widget.provider['phone']?.toString() ?? 'غير محدد',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/loc.svg',
            title: 'العنوان',
            value: widget.provider['address'] ?? 'غير محدد',
          ),
        ],
      ),
    );
  }

  Widget buildAboutCard() {
    return buildWhiteCard(
      child: Text(
        widget.provider['about'] ?? 'لا توجد نبذة عن هذا العامل.',
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.black87,
          height: 1.8,
        ),
      ),
    );
  }

  Widget buildExperiencesCard() {
    return buildWhiteCard(
      child: experiences.isEmpty
          ? Text(
              'لا توجد خبرات مضافة.',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            )
          : Column(
              children: experiences.map((exp) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(3.r),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: mainColor,
                          size: 14.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          exp,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget buildPreviousWorksCard() {
    return buildWhiteCard(
      padding: EdgeInsetsDirectional.only(bottom: 10.r),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 10.w,
          end: 18.w,
          top: 18.h,
          bottom: 14.h,
        ),
        child: SizedBox(
          height: 155.h,
          child: previousWorks.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      color: Colors.grey.shade400,
                      size: 55.w,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'لا توجد أعمال سابقة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: previousWorks.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final work = previousWorks[index];

                    return InkWell(
                      onTap: () => move(
                        context,
                        ImageViewerPage(imageUrl: work),
                      ),
                      child: Container(
                        width: 175.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.network(
                            work,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                  size: 35.r,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget buildSubscriptionStatusCard() {
    return buildWhiteCard(
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.h,
            decoration: BoxDecoration(
              color: isSubscribed
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSubscribed ? Icons.verified_rounded : Icons.cancel_rounded,
              color: isSubscribed ? Colors.green : Colors.red,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSubscribed ? 'الاشتراك مفعل' : 'الاشتراك متوقف',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  isSubscribed
                      ? 'هذا العامل لديه اشتراك نشط ويمكنه استقبال الطلبات.'
                      : 'هذا العامل لا يمتلك اشتراكًا نشطًا حاليًا.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubscriptionDetailsCard() {
    final packageName = subscription['packageName'] ?? 'لا توجد باقة';
    final price = subscription['price']?.toString() ?? '0';
    final startDate = formatDate(subscription['startDate']);
    final endDate = formatDate(subscription['endDate']);
    final requestsLimit =
        subscription['requestsLimit']?.toString() ?? 'غير محدد';

    return buildWhiteCard(
      child: Column(
        children: [
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'اسم الباقة',
            value: packageName,
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'السعر',
            value: '$price $reyalSymbol',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'تاريخ البداية',
            value: startDate,
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'تاريخ الانتهاء',
            value: endDate,
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'عدد الطلبات',
            value: requestsLimit,
          ),
        ],
      ),
    );
  }

  Widget buildActionsCard(AdminCubit adminCubit) {
    return buildWhiteCard(
      child: Column(
        children: [
          defaultButton(
            onPressed: () {
              /*adminCubit.activateWorkerSubscription(
                workerId: widget.provider['id'],
                packageName: 'الباقة الشهرية',
                price: 5000,
                requestsLimit: 30,
                startDate: DateTime.now(),
                endDate: DateTime.now().add(const Duration(days: 30)),
              );*/
            },
            text: 'تفعيل الاشتراك',
            height: 50.h,
            background: Colors.green,
          ),
          SizedBox(height: 12.h),
          defaultOutlinedButton(
            onPressed: () {
              /*adminCubit.stopWorkerSubscription(
                workerId: widget.provider['id'],
              );*/
            },
            text: 'إيقاف الاشتراك',
            height: 50.h,
            border: Colors.red,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required String icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
            width: 38.w,
            height: 38.h,
            padding: EdgeInsetsDirectional.all(7.w),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: mainColor,
              width: 20.w,
            )),
        SizedBox(width: 10.w),
        SizedBox(
          width: 95.w,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        height: 1,
        color: Colors.grey.withOpacity(0.15),
      ),
    );
  }

  String formatDate(dynamic date) {
    if (date == null) return 'غير محدد';

    DateTime? dateTime;

    if (date is Timestamp) {
      dateTime = date.toDate();
    } else if (date is DateTime) {
      dateTime = date;
    } else {
      return date.toString();
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {
        /*if (state is UpdateWorkerSubscriptionSuccessState) {
          showSnackBar(
            Colors.green,
            'تم تحديث اشتراك العامل بنجاح',
            context,
          );
        }

        if (state is UpdateWorkerSubscriptionErrorState) {
          showSnackBar(
            Colors.red,
            state.error,
            context,
          );
        }*/
      },
      builder: (context, state) {
        final adminCubit = AdminCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader(),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 10.w,
                      end: 10.w,
                      top: 20.h,
                      bottom: 20.h,
                    ),
                    child: Column(
                      children: [
                        buildQuickStats(),
                        SizedBox(height: 25.h),
                        buildSectionHeader(
                          title: 'معلومات التواصل',
                          icon: 'assets/contact.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildContactCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'نبذة عن العامل',
                          icon: 'assets/info.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildAboutCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'الخبرات',
                          icon: 'assets/subs.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildExperiencesCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'الأعمال السابقة',
                          icon: 'assets/image.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildPreviousWorksCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'حالة الاشتراك',
                          icon: 'assets/subs.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildSubscriptionStatusCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'تفاصيل الاشتراك',
                          icon: 'assets/info.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildSubscriptionDetailsCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'إدارة الاشتراك',
                          icon: 'assets/pen.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildActionsCard(adminCubit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
