import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_add_service.dart';
import 'package:trying_homy/modules/worker_screens/worker_account_verification.dart';
import 'package:trying_homy/modules/worker_screens/worker_service_details.dart';
import 'package:trying_homy/modules/worker_screens/worker_subscriptions_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';
import '../../shared/networks/local/cache_helper.dart';

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  final List<Map<String, dynamic>> info = [
    {
      'title': 'كل الحجوزات',
      'icon': 'assets/bookings.svg',
    },
    {
      'title': 'الحجوزات المكتملة',
      'icon': 'assets/all.svg',
    },
    {
      'title': 'كل الخدمات',
      'icon': 'assets/services.svg',
    },
    {
      'title': 'التقييم',
      'icon': 'assets/star.svg',
    },
  ];

  Map<String, dynamic> getMapData(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {};
  }

  DateTime? getDateFromFirebase(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  bool isDateExpired(dynamic value) {
    final DateTime? date = getDateFromFirebase(value);

    if (date == null) {
      return false;
    }

    return !date.isAfter(DateTime.now());
  }

  int safeInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String formatDate(dynamic value) {
    final DateTime? date = getDateFromFirebase(value);

    if (date == null) {
      return '';
    }

    final List<String> months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool hasActiveSubscriptionFromUserData(Map<String, dynamic> userData) {
    final Map<String, dynamic> subscription =
        getMapData(userData['subscription']);

    final String status = subscription['status']?.toString() ?? '';

    final dynamic endDate = subscription['endDate'] ??
        subscription['endAt'] ??
        subscription['expiresAt'];

    final bool isExpired = status == 'expired' || isDateExpired(endDate);

    if (isExpired) {
      return false;
    }

    return userData['isSubscribed'] == true ||
        subscription['isActive'] == true ||
        status == 'active' ||
        status == 'approved';
  }

  Widget buildSmallStatusButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildAccountStatusCard({
    required AppCubit appCubit,
    required IconData icon,
    required Color color,
    required String title,
    required String body,
    String? buttonText,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 10.h),
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: color.withOpacity(0.30),
        ),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(9.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  body,
                  style: TextStyle(
                    color: appCubit.isDark
                        ? darkSubTextColor
                        : Colors.grey.shade700,
                    fontSize: 11.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (buttonText != null && onTap != null) ...[
            SizedBox(width: 8.w),
            buildSmallStatusButton(
              text: buttonText,
              color: color,
              onTap: onTap,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildVerificationStatusCard({
    required AppCubit appCubit,
    required Map<String, dynamic> userData,
  }) {
    final Map<String, dynamic> verification =
        getMapData(userData['verification']);

    final String status = verification['status']?.toString() ??
        userData['verificationStatus']?.toString() ??
        'not_submitted';

    final String rejectionReason =
        verification['rejectionReason']?.toString() ?? '';

    final bool isVerified = userData['isVerified'] == true ||
        status == 'approved' ||
        status == 'active';

    if (isVerified) {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.verified_rounded,
        color: Colors.green,
        title: 'حسابك موثق',
        body: 'تم توثيق حسابك بنجاح، ويمكن للعملاء رؤية علامة التوثيق في ملفك.',
      );
    }

    if (status == 'pending') {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.access_time_rounded,
        color: Colors.orangeAccent,
        title: 'طلب التوثيق قيد المراجعة',
        body: 'تم إرسال طلب التوثيق إلى الإدارة، وسيتم إشعارك بعد مراجعته.',
        buttonText: 'عرض',
        onTap: () => move(
          context,
          const WorkerAccountVerification(),
        ),
      );
    }

    if (status == 'rejected') {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.cancel_rounded,
        color: Colors.redAccent,
        title: 'تم رفض طلب التوثيق',
        body: rejectionReason.trim().isNotEmpty
            ? 'سبب الرفض: $rejectionReason'
            : 'يمكنك رفع مستندات أوضح وإرسال طلب التوثيق مرة أخرى.',
        buttonText: 'إعادة التوثيق',
        onTap: () => move(
          context,
          const WorkerAccountVerification(),
        ),
      );
    }

    return buildAccountStatusCard(
      appCubit: appCubit,
      icon: Icons.verified_user_outlined,
      color: mainColor,
      title: 'حسابك غير موثق',
      body: 'وثّق حسابك لزيادة ثقة العملاء وإظهار علامة التوثيق بجانب اسمك.',
      buttonText: 'توثيق الآن',
      onTap: () => move(
        context,
        const WorkerAccountVerification(),
      ),
    );
  }

  Widget buildSubscriptionStatusCard({
    required AppCubit appCubit,
    required Map<String, dynamic> userData,
    required WorkerCubit workerCubit,
  })
  {
    final Map<String, dynamic> subscription = getMapData(userData['subscription']);

    String status = subscription['status']?.toString() ?? 'not_submitted';
    final String requestId = subscription['requestId']?.toString() ?? '';

    if (status == 'pending' && requestId.isEmpty) {
      status = 'not_submitted';
    }

    final dynamic endDate = subscription['endDate'] ?? subscription['endAt'] ?? subscription['expiresAt'];

    final String packageName = subscription['packageName']?.toString() ??
        subscription['planName']?.toString() ??
        'الباقة الحالية';

    final String rejectionReason = subscription['rejectionReason']?.toString() ?? '';

    final String endDateText = formatDate(endDate);
    final bool isExpired = status == 'expired' || isDateExpired(endDate);
    final bool isActive = hasActiveSubscriptionFromUserData(userData);

    const int freeServicesLimit = 5;
    const int freeCompletedBookingsLimit = 5;

    final int servicesCount = safeInt(workerCubit.workerServicesCount);
    final int completedBookingsCount =
        safeInt(workerCubit.workerCompletedRequestsCount);

    final bool hasReachedFreeLimits = servicesCount >= freeServicesLimit &&
        completedBookingsCount >= freeCompletedBookingsLimit;

    if (isActive) {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.workspace_premium_rounded,
        color: Colors.green,
        title: 'اشتراكك نشط',
        body: endDateText.isNotEmpty
            ? 'الباقة: $packageName، وينتهي الاشتراك في $endDateText.'
            : 'الباقة: $packageName. يمكنك إضافة خدمات واستقبال حجوزات بلا حدود.',
        buttonText: 'عرض',
        onTap: () => move(
          context,
          const WorkerSubscriptionsScreen(),
        ),
      );
    }

    if (status == 'pending') {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.access_time_rounded,
        color: Colors.orangeAccent,
        title: 'طلب الاشتراك قيد المراجعة',
        body:
            'تم إرسال طلب الاشتراك إلى الإدارة، وسيتم تفعيل الباقة بعد مراجعة سند الدفع.',
        buttonText: 'عرض',
        onTap: () => move(
          context,
          const WorkerSubscriptionsScreen(),
        ),
      );
    }

    if (isExpired) {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.history_rounded,
        color: Colors.redAccent,
        title: 'انتهى اشتراكك',
        body:
            'جدّد اشتراكك لإضافة خدمات جديدة واستقبال حجوزات جديدة من العملاء.',
        buttonText: 'تجديد',
        onTap: () => move(
          context,
          const WorkerSubscriptionsScreen(),
        ),
      );
    }

    if (status == 'rejected') {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.cancel_rounded,
        color: Colors.redAccent,
        title: 'تم رفض طلب الاشتراك',
        body: rejectionReason.trim().isNotEmpty
            ? 'سبب الرفض: $rejectionReason'
            : 'يمكنك مراجعة بيانات الدفع وإرسال طلب اشتراك جديد.',
        buttonText: 'إعادة الإرسال',
        onTap: () => move(
          context,
          const WorkerSubscriptionsScreen(),
        ),
      );
    }

    if (hasReachedFreeLimits) {
      return buildAccountStatusCard(
        appCubit: appCubit,
        icon: Icons.warning_amber_rounded,
        color: Colors.redAccent,
        title: 'لقد تجاوزت حدود الخطة المجانية',
        body:
            'لقد وصلت إلى الحد المجاني المسموح وهو 5 خدمات و5 حجوزات مكتملة. اشترك الآن لإضافة خدمات واستقبال حجوزات بلا حدود.',
        buttonText: 'اشترك الآن',
        onTap: () => move(
          context,
          const WorkerSubscriptionsScreen(),
        ),
      );
    }

    return buildAccountStatusCard(
      appCubit: appCubit,
      icon: Icons.card_membership_rounded,
      color: mainColor,
      title: 'أنت على الخطة المجانية',
      body: 'يمكنك إضافة 5 خدمات وإكمال 5 حجوزات فقط، وبعدها يجب الاشتراك للاستمرار بلا حدود.',
      buttonText: 'الاشتراك',
      onTap: () => move(
        context,
        const WorkerSubscriptionsScreen(),
      ),
    );
  }

  Widget buildWorkerAccountStatusSection(
      AppCubit appCubit, WorkerCubit workerCubit)
  {
    final uid = CacheHelper.getData(key: 'uid')?.toString() ?? '';

    if (uid.isEmpty) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }
        final Map<String, dynamic> userData = snapshot.data!.data() ?? {};

        return Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              buildVerificationStatusCard(
                appCubit: appCubit,
                userData: userData,
              ),
              buildSubscriptionStatusCard(
                appCubit: appCubit,
                userData: userData,
                workerCubit: workerCubit,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSectionTitle({
    required String title,
    required String icon,
    required AppCubit appCubit,
  }) =>
      Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                icon,
                color: mainColor,
                width: 20.w,
              )),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  bool hasInternet = true;
  bool checkingInternet = true;

  Future<void> checkConnectionAndGetData({bool forceRefresh = false}) async {
    setState(() {
      checkingInternet = true;
    });

    final result = await checkInternet();

    if (!mounted) return;

    setState(() {
      hasInternet = result;
      checkingInternet = false;
    });

    if (result) {
      await WorkerCubit.get(context).getWorkerData(forceRefresh: forceRefresh);
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectionAndGetData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocConsumer<WorkerCubit, WorkerStates>(
          listener: (context, state) {
            if (state is ChangeServiceActivitySuccessState) {
              showSnackBar(Colors.green, 'تم تغيير حالة الخدمة', context);
            }
            if (state is ChangeServiceActivityErrorState) {
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, state) {
            WorkerCubit workerCubit = WorkerCubit.get(context);
            final publishedServices = workerCubit.workerServices
                .where((service) => service['isActive'] == true)
                .toList();
            return ConditionalBuilder(
              condition: checkingInternet || state is GetWorkerDataLoadingState,
              builder: (context) => WorkerHomeShimmer(isDark: appCubit.isDark),
              fallback: (context) => ConditionalBuilder(
                condition: !hasInternet,
                builder: (context) => NoInternet(
                  onRetry: () => checkConnectionAndGetData(forceRefresh: true),
                ),
                fallback: (context) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: RefreshIndicator(
                      onRefresh: () => checkConnectionAndGetData(forceRefresh: true),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header(
                              title: 'مرحبا، ${(workerCubit.workerName ?? '')
                                  .trim().split(RegExp(r'\s+')).where((name) => name.isNotEmpty)
                                  .take(2).join(' ')}',
                              context: context,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            buildWorkerAccountStatusSection(
                                appCubit, workerCubit
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (workerCubit.shouldShowSubscriptionWarning)
                              SizedBox(height: 10.h),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 1.2,
                              ),
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(
                                  end: 10.w, start: 10.w, bottom: 15.w),
                              itemCount: info.length,
                              itemBuilder: (context, index) {
                                var data = info[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow,
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      PositionedDirectional(
                                        bottom: -15.h,
                                        start: -15.w,
                                        child: Transform.rotate(
                                          angle: 0.5,
                                          child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            decoration: BoxDecoration(
                                              color:
                                                  mainColor.withOpacity(0.03),
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              data['icon'],
                                              // ignore: deprecated_member_use
                                              color: mainColor.withOpacity(
                                                  appCubit.isDark ? 0.05 : 0.1),
                                              width: 70.w,
                                              height: 70.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15.r),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10.r),
                                                  decoration: BoxDecoration(
                                                    color: mainColor
                                                        .withOpacity(0.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    data['icon'],
                                                    // ignore: deprecated_member_use
                                                    color: mainColor,
                                                    width: 22.w,
                                                  ),
                                                ),
                                                Text(
                                                  index == 0
                                                      ? '${workerCubit.workerRequestsCount ?? ''}'
                                                      : index == 1
                                                          ? '${workerCubit.workerCompletedRequestsCount ?? ''}'
                                                          : index == 2
                                                              ? '${workerCubit.workerServicesCount ?? ''}'
                                                              : index == 3
                                                                  ? '${workerCubit.workerRating ?? ''}'
                                                                  : '0',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                        : mainColor,
                                                    fontSize: 22.sp,
                                                    letterSpacing: -1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['title'],
                                                  style: TextStyle(
                                                    color: appCubit.isDark
                                                        ? Colors.white
                                                            .withOpacity(0.9)
                                                        : Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Container(
                                                  width: 25.w,
                                                  height: 3.h,
                                                  decoration: BoxDecoration(
                                                    color: mainColor
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
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
                              },
                            ),
                            SizedBox(height: 20.h,),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 10.w,
                                end: 2.w,
                              ),
                              child: buildSectionTitle(
                                title: 'الخدمات المنشورة',
                                icon: 'assets/services.svg',
                                appCubit: appCubit,
                              ),
                            ),
                            publishedServices.isEmpty
                                ? Center(
                              child: Padding(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      height: 100.w,
                                      padding: EdgeInsets.all(18.r),
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.home_repair_service_rounded,
                                        color: mainColor,
                                        size: 48.sp,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      'لا توجد خدمات منشورة',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'عند إضافة خدمة جديدة ستظهر هنا ليتمكن العملاء من حجزها.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        height: 1.6,
                                        color: appCubit.isDark
                                            ? darkSubTextColor
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : GridView.builder(
                                    itemCount: publishedServices.length > 4
                                        ? 4
                                        : publishedServices.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 10.w,
                                      vertical: 10.h,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 250.h,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 15.h,
                                    ),
                                    itemBuilder: (context, index) {
                                      final service = publishedServices[index];

                                      return InkWell(
                                        onTap: () => move(
                                          context,
                                          WorkerServiceDetails(
                                              service: service),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: appCubit.isDark
                                                ? lightDarkColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            boxShadow: blueShadow,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 135.h,
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.r),
                                                      child: Image.network(
                                                        '${service['serviceImage'] ?? ''}',
                                                        height: 120.h,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) =>
                                                            Container(
                                                          height: 120.h,
                                                          color: Colors
                                                              .grey.shade100,
                                                          child: Icon(
                                                            Icons
                                                                .wifi_off_rounded,
                                                            color: Colors
                                                                .grey.shade400,
                                                            size: 30.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    PositionedDirectional(
                                                      bottom: 5.h,
                                                      end: 10.w,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 12.w,
                                                          vertical: 6.h,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: mainColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 8,
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          '${service['price'] ?? ''} ﷼',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 11.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: Colors.amber,
                                                          size: 16.sp,
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          '${service['rate'] ?? ''}',
                                                          style: TextStyle(
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    Text(
                                                      '${service['name'] ?? ''}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 13.sp,
                                                        color: appCubit.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      '${service['description'] ?? ''}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        height: 1.3,
                                                        color: appCubit.isDark
                                                            ? darkSubTextColor
                                                            : Colors
                                                                .grey.shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            SizedBox(height: 20.h,),
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.w),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.vertical(
                                          top: Radius.circular(30.r)),
                                  boxShadow: blueShadow,
                                  gradient: const LinearGradient(
                                    colors: [mainColor, Color(0xFF1A1A2E)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: -15.w,
                                      top: -15.h,
                                      child: Container(
                                        width: 100.r,
                                        height: 100.r,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 40.w,
                                      bottom: -20.h,
                                      child: Transform.rotate(
                                        angle: 0.8,
                                        child: Container(
                                          width: 80.r,
                                          height: 80.r,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.03),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(22.r),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                  ),
                                                  child: Text(
                                                    'فرصة جديدة ✨',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                Text(
                                                  'وسع نطاق عملك',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                SizedBox(height: 6.h),
                                                Text(
                                                  'أضف خدمات جديدة الآن وابدأ باستقبال المزيد من الطلبات',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    fontSize: 12.sp,
                                                    height: 1.3,
                                                  ),
                                                ),
                                                SizedBox(height: 20.h),
                                                InkWell(
                                                  onTap: () {
                                                    final message = workerCubit
                                                        .addServiceRestrictionMessage;

                                                    if (message != null) {
                                                      showSnackBar(
                                                        Colors.orangeAccent,
                                                        message,
                                                        context,
                                                      );
                                                      return;
                                                    }

                                                    move(
                                                      context,
                                                      const WorkerAddService(),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.w,
                                                            vertical: 10.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                              0, 4),
                                                        )
                                                      ],
                                                    ),
                                                    child: Text(
                                                      'إضافة خدمة جديدة',
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 80.r,
                                                height: 80.r,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.08),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Icon(
                                                Icons.add_business_rounded,
                                                size: 50.r,
                                                color: Colors.white
                                                    .withOpacity(0.9),
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
                    ),
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
