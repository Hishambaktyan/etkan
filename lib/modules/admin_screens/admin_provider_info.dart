import 'dart:async';
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
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
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
  late Map<String, dynamic> providerData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      providerDataSubscription;

  String get providerId =>
      providerData['id']?.toString() ?? providerData['uid']?.toString() ?? '';

  bool get isSubscribed =>
      providerData['isSubscribed'] == true ||
      providerData['subscription']?['isActive'] == true;

  Map<String, dynamic> get subscription =>
      providerData['subscription'] is Map<String, dynamic>
          ? providerData['subscription']
          : {};

  List<String> get experiences {
    final value = providerData['experiences'];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> get previousWorks {
    final value = providerData['previousWorks'];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, dynamic> get verification => providerData['verification'] is Map
      ? Map<String, dynamic>.from(providerData['verification'])
      : {};

  bool get isVerified =>
      providerData['isVerified'] == true ||
      verification['status']?.toString() == 'approved';

  String get subscriptionStatus =>
      subscription['status']?.toString() ?? 'not_submitted';

  String get verificationStatus =>
      verification['status']?.toString() ??
      providerData['verificationStatus']?.toString() ??
      'not_submitted';

  bool isActive = true;

  @override
  void initState() {
    super.initState();

    providerData = Map<String, dynamic>.from(widget.provider);
    isActive = providerData['isActive'] != false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || providerId.isEmpty) return;

      AdminCubit.get(context).getProviderReviewRequests(
        providerId: providerId,
      );
    });

    if (providerId.isNotEmpty) {
      providerDataSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(providerId)
          .snapshots()
          .listen((snapshot) {
        if (!mounted || !snapshot.exists || snapshot.data() == null) return;

        setState(() {
          providerData = {
            ...snapshot.data()!,
            'id': snapshot.id,
          };
          isActive = providerData['isActive'] != false;
        });
      });
    }
  }

  @override
  void dispose() {
    providerDataSubscription?.cancel();
    super.dispose();
  }

  AppCubit get appCubit => AppCubit.get(context);

  bool get isDark => appCubit.isDark;

  Color get cardColor => isDark ? lightDarkColor : Colors.white;

  Color get primaryTextColor => isDark ? Colors.white : Colors.black;

  Color get secondaryTextColor => isDark ? darkSubTextColor : Colors.grey;

  List<BoxShadow> get cardShadow => isDark ? [] : blueShadow;

  Widget buildWhiteCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: cardShadow,
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
            color: mainColor.withOpacity(isDark ? 0.20 : 0.10),
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
            color: primaryTextColor,
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
                            backgroundImage:
                                providerData['profileImage'] != null &&
                                        providerData['profileImage']
                                            .toString()
                                            .isNotEmpty
                                    ? NetworkImage(providerData['profileImage'])
                                    : null,
                            child: providerData['profileImage'] == null ||
                                    providerData['profileImage']
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
                          providerData['name'] ?? 'عامل',
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
                            providerData['specialization'] ?? 'غير محدد',
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
          value: '${providerData['avgRating'] ?? 0.0}',
          title: 'التقييم',
        ),
        SizedBox(width: 15.w),
        buildStatCard(
          icon: 'assets/all.svg',
          value: '${providerData['completedJobs'] ?? 0}',
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
          color: cardColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: cardShadow,
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
                    color: primaryTextColor,
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
                color: secondaryTextColor,
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
            value: providerData['phone']?.toString() ?? 'غير محدد',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/loc.svg',
            title: 'العنوان',
            value: providerData['address'] ?? 'غير محدد',
          ),
        ],
      ),
    );
  }

  Widget buildAboutCard() {
    return buildWhiteCard(
      child: Text(
        providerData['about'] ?? 'لا توجد نبذة عن هذا العامل.',
        style: TextStyle(
          fontSize: 12.sp,
          color: isDark ? Colors.white : Colors.black87,
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
                color: secondaryTextColor,
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
                            color: isDark ? Colors.white : Colors.black87,
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
                      color: isDark ? darkSubTextColor : Colors.grey.shade400,
                      size: 55.w,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'لا توجد أعمال سابقة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: isDark ? darkSubTextColor : Colors.grey.shade400,
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
                          color: isDark ? darkBgColor : Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.network(
                            work,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color:
                                    isDark ? darkBgColor : Colors.grey.shade200,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color:
                                      isDark ? darkSubTextColor : Colors.grey,
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

  Color getStatusColor(String status) {
    if (status == 'active' || status == 'approved') {
      return Colors.green;
    }

    if (status == 'pending') {
      return Colors.orange;
    }

    if (status == 'expired') {
      return Colors.deepOrange;
    }

    if (status == 'rejected') {
      return Colors.red;
    }

    return Colors.grey;
  }

  IconData getStatusIcon(String status) {
    if (status == 'active' || status == 'approved') {
      return Icons.verified_rounded;
    }

    if (status == 'pending') {
      return Icons.access_time_filled_rounded;
    }

    if (status == 'expired') {
      return Icons.history_rounded;
    }

    if (status == 'rejected') {
      return Icons.cancel_rounded;
    }

    return Icons.info_outline_rounded;
  }

  String getSubscriptionStatusTitle(String status) {
    if (status == 'active' || status == 'approved') {
      return 'الاشتراك مفعل';
    }

    if (status == 'pending') {
      return 'طلب الاشتراك قيد المراجعة';
    }

    if (status == 'expired') {
      return 'الاشتراك منتهي';
    }

    if (status == 'rejected') {
      return 'تم رفض طلب الاشتراك';
    }

    return 'لم يشترك الفني بعد';
  }

  String getSubscriptionStatusSubtitle(String status) {
    if (status == 'active' || status == 'approved') {
      return 'يستطيع الفني إضافة خدمات واستقبال حجوزات جديدة بلا حدود.';
    }

    if (status == 'pending') {
      return 'أرسل الفني طلب اشتراك وينتظر مراجعته من الإدارة.';
    }

    if (status == 'expired') {
      return 'انتهت الباقة، ويمكن للفني إكمال الحجوزات القديمة فقط حتى يجدد اشتراكه.';
    }

    if (status == 'rejected') {
      final String reason = subscription['rejectionReason']?.toString() ?? '';

      return reason.isEmpty
          ? 'تم رفض آخر طلب اشتراك أرسله الفني.'
          : 'سبب الرفض: $reason';
    }

    return 'يستخدم الفني الخطة المجانية بحد أقصى 5 خدمات و5 حجوزات مكتملة.';
  }

  String getVerificationStatusTitle(String status) {
    if (status == 'approved') {
      return 'الحساب موثق';
    }

    if (status == 'pending') {
      return 'طلب التوثيق قيد المراجعة';
    }

    if (status == 'rejected') {
      return 'تم رفض طلب التوثيق';
    }

    return 'الحساب غير موثق';
  }

  String getVerificationStatusSubtitle(String status) {
    if (status == 'approved') {
      return 'تظهر علامة التوثيق للمستخدمين داخل ملف الفني.';
    }

    if (status == 'pending') {
      return 'رفع الفني مستنداته وينتظر مراجعتها من الإدارة.';
    }

    if (status == 'rejected') {
      final String reason = verification['rejectionReason']?.toString() ?? '';

      return reason.isEmpty
          ? 'تم رفض آخر طلب توثيق أرسله الفني.'
          : 'سبب الرفض: $reason';
    }

    return 'لم يرسل الفني طلب توثيق حتى الآن.';
  }

  Widget buildStatusCard({
    required String status,
    required String title,
    required String subtitle,
  }) {
    final Color statusColor = getStatusColor(status);

    return buildWhiteCard(
      child: Row(
        children: [
          Container(
            width: 58.w,
            height: 58.h,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getStatusIcon(status),
              color: statusColor,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: secondaryTextColor,
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

  Widget buildSubscriptionStatusCard() {
    return buildStatusCard(
      status: subscriptionStatus,
      title: getSubscriptionStatusTitle(subscriptionStatus),
      subtitle: getSubscriptionStatusSubtitle(subscriptionStatus),
    );
  }

  Widget buildVerificationStatusCard() {
    return buildStatusCard(
      status: verificationStatus,
      title: getVerificationStatusTitle(verificationStatus),
      subtitle: getVerificationStatusSubtitle(verificationStatus),
    );
  }

  Widget buildRequestImage({
    required String title,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: imageUrl.isEmpty
          ? null
          : () => move(
                context,
                ImageViewerPage(imageUrl: imageUrl),
              ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 105.w,
        padding: EdgeInsetsDirectional.all(8.r),
        decoration: BoxDecoration(
          color: isDark ? darkBgColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark
                ? darkSubTextColor.withOpacity(0.15)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13.r),
              child: SizedBox(
                width: double.infinity,
                height: 82.h,
                child: imageUrl.isEmpty
                    ? Container(
                        color: isDark ? lightDarkColor : Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: secondaryTextColor,
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color:
                                isDark ? lightDarkColor : Colors.grey.shade200,
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: secondaryTextColor,
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showRejectReasonDialog({
    required String title,
    required void Function(String reason) onConfirm,
  }) async {
    final TextEditingController reasonController = TextEditingController();

    final String? rejectionReason = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext dialogContext) {
        bool showReasonError = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                      backgroundColor: isDark ? lightDarkColor : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(22.r),
                      ),
                      contentPadding: EdgeInsetsDirectional.all(22.r),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.all(16.r),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/info.svg',
                                color: Colors.red,
                                width: 50.w,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(dialogContext)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              controller: reasonController,
                              minLines: 3,
                              maxLines: 5,
                              textInputAction: TextInputAction.newline,
                              style: TextStyle(
                                color: Theme.of(dialogContext)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontSize: 13.sp,
                              ),
                              onChanged: (value) {
                                if (showReasonError &&
                                    value.trim().isNotEmpty) {
                                  setDialogState(() {
                                    showReasonError = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'اكتب سبب الرفض هنا...',
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? darkSubTextColor
                                      : Colors.grey.shade500,
                                  fontSize: 12.sp,
                                ),
                                filled: true,
                                fillColor:
                                    isDark ? darkBgColor : Colors.grey.shade100,
                                contentPadding: EdgeInsetsDirectional.all(15.r),
                                errorText: showReasonError
                                    ? 'يرجى كتابة سبب الرفض'
                                    : null,
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 11.sp,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    color: showReasonError
                                        ? Colors.red
                                        : Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                  borderSide: BorderSide(
                                    color: showReasonError
                                        ? Colors.red
                                        : mainColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Row(
                              children: [
                                Expanded(
                                  child: defaultButton(
                                    onPressed: () {
                                      FocusScope.of(dialogContext).unfocus();

                                      Navigator.of(
                                        dialogContext,
                                        rootNavigator: true,
                                      ).pop();
                                    },
                                    text: 'إلغاء',
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: defaultOutlinedButton(
                                    onPressed: () {
                                      final String reason =
                                          reasonController.text.trim();

                                      if (reason.isEmpty) {
                                        setDialogState(() {
                                          showReasonError = true;
                                        });
                                        return;
                                      }

                                      FocusScope.of(dialogContext).unfocus();

                                      Navigator.of(
                                        dialogContext,
                                        rootNavigator: true,
                                      ).pop(reason);
                                    },
                                    text: 'رفض',
                                    border: Colors.red,
                                    textColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );

    reasonController.dispose();

    if (!mounted || rejectionReason == null || rejectionReason.trim().isEmpty) {
      return;
    }

    // يتم تنفيذ الرفض بعد إغلاق نافذة السبب بالكامل.
    onConfirm(rejectionReason.trim());
  }

  Widget buildSubscriptionDetailsCard() {
    final packageName = subscription['packageName'] ?? 'لا توجد باقة';
    final price = subscription['price']?.toString() ?? '0';
    final durationMonths =
        subscription['durationMonths']?.toString() ?? 'غير محدد';
    final paymentMethod =
        subscription['paymentMethodTitle']?.toString() ?? 'غير محدد';
    final startDate = formatDate(subscription['startDate']);
    final endDate = formatDate(subscription['endDate']);

    return buildWhiteCard(
      child: Column(
        children: [
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'اسم الباقة',
            value: packageName.toString(),
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
            title: 'مدة الباقة',
            value: '$durationMonths شهر',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'طريقة الدفع',
            value: paymentMethod,
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
        ],
      ),
    );
  }

  Widget buildSubscriptionRequestCard(AdminCubit adminCubit) {
    if (adminCubit.isGetProviderReviewRequestsLoading) {
      return buildWhiteCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    final Map<String, dynamic>? request =
        adminCubit.providerSubscriptionRequest;

    if (request == null || request['status']?.toString() != 'pending') {
      return buildWhiteCard(
        child: Row(
          children: [
            Icon(
              Icons.inbox_outlined,
              color: secondaryTextColor,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'لا يوجد طلب اشتراك قيد المراجعة لهذا الفني.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final String requestId =
        request['requestId']?.toString() ?? request['id']?.toString() ?? '';

    final String transferImage = request['transferImage']?.toString() ?? '';

    return buildWhiteCard(
      child: Column(
        children: [
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'الباقة',
            value: request['packageName']?.toString() ?? 'غير محدد',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'السعر',
            value: '${request['price'] ?? 0} $reyalSymbol',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'المدة',
            value: '${request['durationMonths'] ?? 1} شهر',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'طريقة الدفع',
            value: request['paymentMethodTitle']?.toString() ?? 'غير محدد',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/subs.svg',
            title: 'تاريخ الطلب',
            value: formatDate(request['createdAt']),
          ),
          SizedBox(height: 15.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'سند الدفع',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          buildRequestImage(
            title: 'فتح سند الدفع',
            imageUrl: transferImage,
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: defaultButton(
                  onPressed: () {
                    if (requestId.isEmpty) return;

                    adminCubit.approveSubscriptionRequest(
                      requestId: requestId,
                    );
                  },
                  text: 'قبول',
                  height: 48.h,
                  background: Colors.green,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: defaultOutlinedButton(
                  onPressed: () {
                    if (requestId.isEmpty) return;

                    showRejectReasonDialog(
                      title: 'رفض طلب الاشتراك',
                      onConfirm: (reason) {
                        adminCubit.rejectSubscriptionRequest(
                          requestId: requestId,
                          reason: reason,
                        );
                      },
                    );
                  },
                  text: 'رفض الطلب',
                  height: 48.h,
                  border: Colors.red,
                  textColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildVerificationRequestCard(AdminCubit adminCubit) {
    if (adminCubit.isGetProviderReviewRequestsLoading) {
      return buildWhiteCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    final Map<String, dynamic>? request =
        adminCubit.providerVerificationRequest;

    if (request == null || request['status']?.toString() != 'pending') {
      return buildWhiteCard(
        child: Row(
          children: [
            Icon(
              Icons.inbox_outlined,
              color: secondaryTextColor,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'لا يوجد طلب توثيق قيد المراجعة لهذا الفني.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final String requestId =
        request['requestId']?.toString() ?? request['id']?.toString() ?? '';

    return buildWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoRow(
            icon: 'assets/doc.svg',
            title: 'نوع الوثيقة',
            value: request['documentType']?.toString() ?? 'غير محدد',
          ),
          divider(),
          buildInfoRow(
            icon: 'assets/doc.svg',
            title: 'تاريخ الطلب',
            value: formatDate(request['createdAt']),
          ),
          SizedBox(height: 15.h),
          Text(
            'المستندات المرفوعة',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildRequestImage(
                  title: 'الوجه الأمامي',
                  imageUrl: request['frontDocumentImage']?.toString() ?? '',
                ),
                SizedBox(width: 10.w),
                buildRequestImage(
                  title: 'الوجه الخلفي',
                  imageUrl: request['backDocumentImage']?.toString() ?? '',
                ),
                SizedBox(width: 10.w),
                buildRequestImage(
                  title: 'الصورة الشخصية',
                  imageUrl: request['personalImage']?.toString() ?? '',
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: defaultButton(
                  onPressed: () {
                    if (requestId.isEmpty) return;

                    adminCubit.approveVerificationRequest(
                      requestId: requestId,
                    );
                  },
                  text: 'قبول التوثيق',
                  height: 48.h,
                  background: Colors.green,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: defaultOutlinedButton(
                  onPressed: () {
                    if (requestId.isEmpty) return;

                    showRejectReasonDialog(
                      title: 'رفض طلب التوثيق',
                      onConfirm: (reason) {
                        adminCubit.rejectVerificationRequest(
                          requestId: requestId,
                          reason: reason,
                        );
                      },
                    );
                  },
                  text: 'رفض الطلب',
                  height: 48.h,
                  border: Colors.red,
                  textColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildActionsCard(AdminCubit adminCubit) {
    if (!isSubscribed) {
      return buildWhiteCard(
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: secondaryTextColor,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'يتم تفعيل الاشتراك بعد مراجعة طلب الاشتراك المرسل من الفني والموافقة عليه.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return buildWhiteCard(
      child: defaultOutlinedButton(
        onPressed: () {
          defaultConfirmDialog(
            context: context,
            isDark: isDark,
            icon: 'assets/info.svg',
            iconColor: Colors.red,
            title: 'إيقاف الاشتراك',
            body:
                'هل أنت متأكد من إيقاف اشتراك هذا الفني؟ سيتمكن الفني من إكمال الحجوزات الحالية، لكنه لن يستطيع استقبال حجوزات جديدة أو إضافة خدمات جديدة.',
            confirmText: 'إيقاف',
            cancelText: 'إلغاء',
            confirmColor: Colors.red,
            onConfirm: () {
              Navigator.of(context, rootNavigator: true).pop();

              adminCubit.stopProviderSubscription(
                providerId: providerId,
              );
            },
          );
        },
        text: 'إيقاف الاشتراك',
        height: 50.h,
        border: Colors.red,
        textColor: Colors.red,
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
              color: secondaryTextColor,
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
              color: primaryTextColor,
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
        color: isDark
            ? darkSubTextColor.withOpacity(0.18)
            : Colors.grey.withOpacity(0.15),
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
        final bool isActionLoading =
            state is ApproveSubscriptionRequestLoadingState ||
                state is RejectSubscriptionRequestLoadingState ||
                state is StopProviderSubscriptionLoadingState ||
                state is ApproveVerificationRequestLoadingState ||
                state is RejectVerificationRequestLoadingState;

        if (isActionLoading) {
          showLoadingDialog(context);
        }

        if (state is ApproveSubscriptionRequestSuccessState) {
          hideLoadingDialog(context);
          showSnackBar(
            Colors.green,
            'تم قبول طلب الاشتراك وتفعيل الباقة بنجاح',
            context,
          );
        }

        if (state is RejectSubscriptionRequestSuccessState) {
          hideLoadingDialog(context);
          showSnackBar(
            Colors.green,
            'تم رفض طلب الاشتراك وإبلاغ الفني',
            context,
          );
        }

        if (state is StopProviderSubscriptionSuccessState) {
          hideLoadingDialog(context);
          showSnackBar(
            Colors.green,
            'تم إيقاف اشتراك الفني',
            context,
          );
        }

        if (state is ApproveVerificationRequestSuccessState) {
          hideLoadingDialog(context);
          showSnackBar(
            Colors.green,
            'تم قبول طلب التوثيق وتوثيق حساب الفني',
            context,
          );
        }

        if (state is RejectVerificationRequestSuccessState) {
          hideLoadingDialog(context);
          showSnackBar(
            Colors.green,
            'تم رفض طلب التوثيق وإبلاغ الفني',
            context,
          );
        }

        String? error;

        if (state is ApproveSubscriptionRequestErrorState) {
          error = state.error;
        } else if (state is RejectSubscriptionRequestErrorState) {
          error = state.error;
        } else if (state is StopProviderSubscriptionErrorState) {
          error = state.error;
        } else if (state is ApproveVerificationRequestErrorState) {
          error = state.error;
        } else if (state is RejectVerificationRequestErrorState) {
          error = state.error;
        } else if (state is GetProviderReviewRequestsErrorState) {
          error = state.error;
        }

        if (error != null) {
          if (isActionLoading == false &&
              state is! GetProviderReviewRequestsErrorState) {
            hideLoadingDialog(context);
          } else if (state is! GetProviderReviewRequestsErrorState) {
            hideLoadingDialog(context);
          }

          showSnackBar(
            Colors.red,
            error,
            context,
          );
        }
      },
      builder: (context, state) {
        final adminCubit = AdminCubit.get(context);
        final AppCubit appCubit = context.watch<AppCubit>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: appCubit.isDark ? darkBgColor : bgColor,
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
                          title: 'حالة التوثيق',
                          icon: 'assets/doc.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildVerificationStatusCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'مراجعة طلب التوثيق',
                          icon: 'assets/pen.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildVerificationRequestCard(adminCubit),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'حالة الاشتراك',
                          icon: 'assets/subs.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildSubscriptionStatusCard(),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                          title: 'مراجعة طلب الاشتراك',
                          icon: 'assets/pen.svg',
                        ),
                        SizedBox(height: 10.h),
                        buildSubscriptionRequestCard(adminCubit),
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
