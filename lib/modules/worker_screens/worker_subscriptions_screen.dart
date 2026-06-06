import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_confirm_Subscription.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../shared/networks/local/cache_helper.dart';

class WorkerSubscriptionsScreen extends StatefulWidget {
  const WorkerSubscriptionsScreen({super.key});

  @override
  State<WorkerSubscriptionsScreen> createState() =>
      _WorkerSubscriptionsScreenState();
}

class _WorkerSubscriptionsScreenState extends State<WorkerSubscriptionsScreen> {
  String selectedPlan = 'monthly';
  String selectedPaymentMethod = 'bank';

  final ScrollController _scrollController = ScrollController();
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _userSubscriptionStream;
  String? _uid;

  @override
  void initState() {
    super.initState();

    final String cachedUid =
        CacheHelper.getData(key: 'uid')?.toString().trim() ?? '';

    if (cachedUid.isNotEmpty) {
      _uid = cachedUid;
      _userSubscriptionStream = FirebaseFirestore.instance
          .collection('users')
          .doc(cachedUid)
          .snapshots();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> plans = [
    {
      'id': 'monthly',
      'title': 'اشتراك لمدة شهر',
      'price': '2500',
      'period': 'لمدة شهر',
      'durationMonths': 1,
      'badge': 'شهر واحد',
      'features': [
        'إضافة خدمات غير محدودة',
        'استقبال حجوزات غير محدودة',
      ],
    },
    {
      'id': 'three_months',
      'title': 'اشتراك لمدة 3 أشهر',
      'price': '7000',
      'period': 'لمدة 3 أشهر',
      'durationMonths': 3,
      'badge': 'اختيار مناسب',
      'features': [
        'إضافة خدمات غير محدودة',
        'استقبال حجوزات غير محدودة',
      ],
    },
    {
      'id': 'six_months',
      'title': 'اشتراك لمدة 6 أشهر',
      'price': '13000',
      'period': 'لمدة 6 أشهر',
      'durationMonths': 6,
      'badge': 'توفير أكبر',
      'features': [
        'إضافة خدمات غير محدودة',
        'استقبال حجوزات غير محدودة',
      ],
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'bank',
      'title': 'تحويل بنكي',
      'subtitle': 'ارفع صورة سند الدفع بعد إتمام التحويل',
      'icon': 'assets/bank.svg',
    },
    {
      'id': 'deposit',
      'title': 'إيداع بنكي',
      'subtitle': 'ارفع صورة سند الإيداع بعد إتمام العملية',
      'icon': 'assets/wallet.svg',
    },
  ];

  Map<String, dynamic> _getSubscriptionData(Map<String, dynamic> userData) {
    final dynamic rawSubscription = userData['subscription'];

    if (rawSubscription is Map) {
      return Map<String, dynamic>.from(rawSubscription);
    }

    return {};
  }

  String _getCurrentStatus(
    Map<String, dynamic> userData,
    Map<String, dynamic> subscription,
  ) {
    final bool isSubscribed = userData['isSubscribed'] == true;
    final bool isActive = subscription['isActive'] == true;
    final String savedStatus =
        subscription['status']?.toString() ?? 'not_submitted';
    final String requestId = subscription['requestId']?.toString() ?? '';
    final dynamic endDate = subscription['endDate'] ??
        subscription['endAt'] ??
        subscription['expiresAt'];

    final bool hasActiveSubscription = isSubscribed ||
        isActive ||
        savedStatus == 'active' ||
        savedStatus == 'approved';

    if (hasActiveSubscription && _isSubscriptionExpired(endDate)) {
      return 'expired';
    }

    if (hasActiveSubscription) {
      return 'active';
    }

    if (savedStatus == 'pending' && requestId.isNotEmpty) {
      return 'pending';
    }

    if (savedStatus == 'rejected') {
      return 'rejected';
    }

    if (savedStatus == 'expired') {
      return 'expired';
    }

    return 'not_submitted';
  }

  bool canChooseSubscription(String status) {
    return status != 'active' && status != 'pending';
  }

  String getSubscriptionStatusText(String status) {
    if (status == 'active') {
      return 'الاشتراك نشط';
    } else if (status == 'pending') {
      return 'الطلب قيد المراجعة';
    } else if (status == 'expired') {
      return 'الاشتراك منتهي';
    } else if (status == 'rejected') {
      return 'تم رفض الطلب';
    } else {
      return 'غير مشترك';
    }
  }

  Color getSubscriptionStatusColor(String status) {
    if (status == 'active') {
      return Colors.green;
    } else if (status == 'pending') {
      return Colors.orange;
    } else if (status == 'expired' || status == 'rejected') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  IconData getSubscriptionStatusIcon(String status) {
    if (status == 'active') {
      return Icons.verified_rounded;
    } else if (status == 'pending') {
      return Icons.access_time_rounded;
    } else if (status == 'expired') {
      return Icons.history_rounded;
    } else if (status == 'rejected') {
      return Icons.cancel_rounded;
    } else {
      return Icons.info_outline_rounded;
    }
  }

  Widget _buildStatusCard(
    AppCubit cubit,
    String status,
    Map<String, dynamic> subscription,
  ) {
    final String packageName =
        _getValidText(subscription['packageName'], fallback: '');

    String title = 'فعّل اشتراكك';
    String subtitle =
        'اختر الباقة المناسبة للاستفادة من خدمات وحجوزات غير محدودة.';

    if (status == 'pending') {
      title = 'طلب الاشتراك قيد المراجعة';
      subtitle = packageName.isNotEmpty
          ? 'تم إرسال طلب $packageName، وستقوم الإدارة بمراجعته قريبًا.'
          : 'تم إرسال طلب الاشتراك، وستقوم الإدارة بمراجعته قريبًا.';
    } else if (status == 'active') {
      title = 'اشتراكك نشط';
      subtitle =
          'يمكنك الآن إضافة خدمات واستقبال حجوزات غير محدودة طوال مدة الاشتراك.';
    } else if (status == 'expired') {
      title = 'انتهت مدة اشتراكك';
      subtitle =
          'جدّد اشتراكك للاستمرار في إضافة الخدمات واستقبال الحجوزات الجديدة.';
    } else if (status == 'rejected') {
      title = 'تم رفض طلب الاشتراك';
      subtitle =
          'راجع سبب الرفض ثم اختر الباقة وطريقة الدفع وأرسل الطلب مرة أخرى.';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: SvgPicture.asset(
              'assets/subs.svg',
              color: Colors.white,
              width: 40.w,
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
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 12.sp,
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

  Widget _buildReviewStatus(
    AppCubit cubit,
    String status,
    Map<String, dynamic> subscription,
  ) {
    final Color statusColor = getSubscriptionStatusColor(status);
    final String packageName =
        _getValidText(subscription['packageName'], fallback: '');
    final String endDateText = _formatSubscriptionDate(
      subscription['endDate'] ??
          subscription['endAt'] ??
          subscription['expiresAt'],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/subs.svg',
              color: statusColor,
              width: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getSubscriptionStatusText(status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (packageName.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'الباقة: $packageName',
                    style: TextStyle(
                      color: cubit.isDark
                          ? darkSubTextColor
                          : Colors.grey.shade700,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
                if ((status == 'active' || status == 'expired') &&
                    endDateText.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'قيمة الاشتراك: ${subscription['price'] ?? ''} ريال',
                    style: TextStyle(
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'بداية الاشتراك في: ${_formatSubscriptionDate(subscription['startDate'] ?? subscription['startAt'])}',
                    style: TextStyle(
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    status == 'active'
                        ? 'ينتهي الاشتراك في: $endDateText'
                        : 'انتهى الاشتراك في: $endDateText',
                    style: TextStyle(
                      color: cubit.isDark
                          ? darkSubTextColor
                          : Colors.grey.shade700,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow({
    required AppCubit cubit,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(9.r),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: mainColor,
            size: 20.r,
          ),
        ),
        SizedBox(width: 11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionReasonCard(
    AppCubit cubit,
    Map<String, dynamic> subscription,
  ) {
    final String reason =
        _getValidText(subscription['rejectionReason'], fallback: '');

    if (reason.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.red.withOpacity(0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.red,
            size: 22.r,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'سبب الرفض: $reason',
              style: TextStyle(
                color: cubit.isDark ? Colors.white : Colors.red.shade800,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String icon,
    required AppCubit cubit,
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
            width: 25.w,
          ),
        ),
        SizedBox(width: 10.w),
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
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, AppCubit cubit) {
    final bool isSelected = selectedPlan == plan['id'];
    final List<String> features = List<String>.from(plan['features']);

    return InkWell(
      onTap: () {
        setState(() {
          selectedPlan = plan['id'];
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsetsDirectional.only(bottom: 15.h),
        padding: EdgeInsetsDirectional.all(15.r),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected ? mainColor : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? mainColor : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.r,
                            height: 10.r,
                            decoration: const BoxDecoration(
                              color: mainColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    plan['title'],
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    plan['badge'],
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${plan['price']} ريال',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                    height: 1,
                  ),
                ),
                SizedBox(width: 5.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    plan['period'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Column(
              children: features.map((feature) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                          size: 14.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: cubit.isDark
                                ? darkSubTextColor
                                : Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required Map<String, dynamic> paymentMethod,
    required AppCubit cubit,
  }) {
    final bool isSelected = selectedPaymentMethod == paymentMethod['id'];

    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethod['id'];
        });
      },
      borderRadius: BorderRadius.circular(25.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(15.r),
        margin: EdgeInsetsDirectional.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected
                ? mainColor
                : cubit.isDark
                    ? const Color(0xFF30363D)
                    : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: blueShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SvgPicture.asset(
                paymentMethod['icon'],
                color: mainColor,
                width: 20.w,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod['title'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    paymentMethod['subtitle'],
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cubit.isDark ? darkSubTextColor : Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? mainColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.r,
                        height: 10.r,
                        decoration: const BoxDecoration(
                          color: mainColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.orange.shade800.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: Colors.orange.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/info.svg',
                color: Colors.orange.shade800,
                width: 20.w,
              ),
              SizedBox(width: 10.w),
              Text(
                'ملاحظات مهمة',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildNoteText(
            cubit,
            'يستطيع الفني غير المشترك إضافة 5 خدمات وإكمال 5 حجوزات فقط.',
          ),
          _buildNoteText(
            cubit,
            'يبدأ الاشتراك من تاريخ موافقة الإدارة على طلبك.',
          ),
          _buildNoteText(
            cubit,
            'تأكد من رفع صورة واضحة لسند الدفع لتجنب رفض الطلب.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoteText(AppCubit cubit, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: CircleAvatar(
              radius: 3.r,
              backgroundColor: Colors.orange.shade800,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionForm(AppCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25.h),
        _buildSectionTitle(
          title: 'اختر الباقة المناسبة',
          icon: 'assets/card.svg',
          cubit: cubit,
        ),
        SizedBox(height: 15.h),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plans.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _buildPlanCard(plans[index], cubit);
          },
        ),
        SizedBox(height: 10.h),
        _buildSectionTitle(
          title: 'اختر طريقة الدفع',
          icon: 'assets/money.svg',
          cubit: cubit,
        ),
        SizedBox(height: 15.h),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: paymentMethods.length,
          itemBuilder: (context, index) {
            return _buildPaymentMethod(
              paymentMethod: paymentMethods[index],
              cubit: cubit,
            );
          },
        ),
        SizedBox(height: 10.h),
        _buildNotesCard(cubit),
      ],
    );
  }

  Widget _buildSubscribeButton(AppCubit cubit, String status) {
    String buttonText = 'متابعة الاشتراك';

    if (status == 'expired') {
      buttonText = 'تجديد الاشتراك';
    } else if (status == 'rejected') {
      buttonText = 'إعادة إرسال طلب الاشتراك';
    }

    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: 10.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: cubit.isDark ? darkBgColor : Colors.white,
        boxShadow: blueShadow,
      ),
      child: defaultButton(
        onPressed: () {
          final selectedPlanData = plans.firstWhere(
            (plan) => plan['id'] == selectedPlan,
          );

          final selectedPaymentData = paymentMethods.firstWhere(
            (paymentMethod) => paymentMethod['id'] == selectedPaymentMethod,
          );

          move(
            context,
            WorkerConfirmSubscription(
              plan: selectedPlanData,
              paymentMethod: selectedPaymentData,
            ),
          );
        },
        text: buttonText,
      ),
    );
  }

  String _getValidText(dynamic value, {required String fallback}) {
    if (value == null) return fallback;

    final String text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return fallback;
    }

    return text;
  }

  String _formatSubscriptionDate(dynamic date) {
    if (date == null) return '';

    DateTime? dateTime;

    if (date is Timestamp) {
      dateTime = date.toDate();
    } else if (date is DateTime) {
      dateTime = date;
    } else if (date is String) {
      dateTime = DateTime.tryParse(date);
    }

    if (dateTime == null) return '';

    final months = [
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

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  bool _isSubscriptionExpired(dynamic endDate) {
    if (endDate == null) return false;

    DateTime? dateTime;

    if (endDate is Timestamp) {
      dateTime = endDate.toDate();
    } else if (endDate is DateTime) {
      dateTime = endDate;
    } else if (endDate is String) {
      dateTime = DateTime.tryParse(endDate);
    }

    if (dateTime == null) return false;

    return !dateTime.isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 10,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.back,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'الاشتراك',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _userSubscriptionStream,
              builder: (context, snapshot) {
                if (_uid == null || _uid!.isEmpty) {
                  return Center(
                    child: Text(
                      'تعذر جلب بيانات الحساب',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: mainColor),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'تعذر جلب بيانات الاشتراك',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                Map<String, dynamic> userData = {};

                if (snapshot.hasData && snapshot.data!.exists) {
                  userData = snapshot.data!.data() ?? {};
                }

                final Map<String, dynamic> subscription =
                    _getSubscriptionData(userData);
                final String currentStatus =
                    _getCurrentStatus(userData, subscription);

                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsetsDirectional.only(
                    start: 10.w,
                    end: 10.w,
                    top: 10.h,
                    bottom: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(cubit, currentStatus, subscription),
                      SizedBox(height: 18.h),
                      _buildReviewStatus(cubit, currentStatus, subscription),
                      _buildRejectionReasonCard(cubit, subscription),
                      if (canChooseSubscription(currentStatus))
                        _buildSubscriptionForm(cubit),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar:
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _userSubscriptionStream,
              builder: (context, snapshot) {
                if (_uid == null ||
                    _uid!.isEmpty ||
                    snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return const SizedBox.shrink();
                }

                Map<String, dynamic> userData = {};

                if (snapshot.hasData && snapshot.data!.exists) {
                  userData = snapshot.data!.data() ?? {};
                }

                final Map<String, dynamic> subscription =
                    _getSubscriptionData(userData);
                final String currentStatus =
                    _getCurrentStatus(userData, subscription);

                if (!canChooseSubscription(currentStatus)) {
                  return const SizedBox.shrink();
                }

                return _buildSubscribeButton(cubit, currentStatus);
              },
            ),
          ),
        );
      },
    );
  }
}
