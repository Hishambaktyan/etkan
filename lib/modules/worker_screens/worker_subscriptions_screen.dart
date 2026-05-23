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

  final List<Map<String, dynamic>> plans = [
    {
      'id': 'monthly',
      'title': 'اشتراك شهر واحد',
      'price': '2500',
      'period': 'شهرياً',
      'badge': 'شهر واحد',
      'features': [
        'إضافة عدد غير محدود من الخدمات',
        'استقبال الطلبات الجديدة',
      ],
    },
    {
      'id': 'three_months',
      'title': 'اشتراك 3 شهور',
      'price': '7000',
      'period': 'كل 3 شهور',
      'badge': 'اختيار مناسب',
      'features': [
        'إضافة عدد غير محدود من الخدمات',
        'استقبال الطلبات الجديدة',
      ],
    },
    {
      'id': 'six_months',
      'title': 'اشتراك 6 شهور',
      'price': '13000',
      'period': 'كل 6 شهور',
      'badge': 'وفر أكثر',
      'features': [
        'إضافة عدد غير محدود من الخدمات',
        'استقبال الطلبات الجديدة',
      ],
    },
  ];

  String selectedPaymentMethod = 'bank';

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'bank',
      'title': 'تحويل بنكي',
      'subtitle': 'ارفع صورة سند التحويل بعد الدفع',
      'icon': 'assets/bank.svg',
    },
    {
      'id': 'deposit',
      'title': 'إيداع بنكي',
      'subtitle': 'تفعيل الاشتراك بعد تأكيد العملية',
      'icon': 'assets/wallet.svg',
    },
  ];

  Widget _buildHeaderCard(AppCubit cubit) {
    final uid = CacheHelper.getData(key: 'uid');

    if (uid == null || uid.toString().isEmpty) {
      return _buildSubscriptionHeaderContent(
        cubit: cubit,
        statusText: 'غير معروف',
        packageName: 'تعذر جلب بيانات الفني',
        endDateText: '',
        icon: Icons.error_outline_rounded,
        showEndDate: false,
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSubscriptionHeaderContent(
            cubit: cubit,
            statusText: 'جاري التحميل',
            packageName: 'يتم فحص حالة الاشتراك...',
            endDateText: '',
            icon: Icons.hourglass_top_rounded,
            showEndDate: false,
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildSubscriptionHeaderContent(
            cubit: cubit,
            statusText: 'غير مشترك',
            packageName: 'لا توجد بيانات اشتراك',
            endDateText: '',
            icon: Icons.cancel_outlined,
            showEndDate: false,
          );
        }

        final userData = snapshot.data!.data() ?? {};
        final Map<String, dynamic> subscription =
        Map<String, dynamic>.from(userData['subscription'] ?? {});

        final bool isSubscribed = userData['isSubscribed'] == true;
        final bool isActive = subscription['isActive'] == true;
        final String status = subscription['status']?.toString() ?? '';

        final String packageName =
            subscription['packageName']?.toString() ??
                subscription['planName']?.toString() ??
                subscription['period']?.toString() ??
                'لا توجد باقة حالية';

        final String endDateText = _formatSubscriptionDate(
          subscription['endAt'] ?? subscription['endDate'] ?? subscription['expiresAt'],
        );

        if (isSubscribed || isActive || status == 'active' || status == 'approved') {
          return _buildSubscriptionHeaderContent(
            cubit: cubit,
            statusText: 'نشط',
            packageName: packageName,
            endDateText: endDateText.isEmpty ? 'غير محدد' : endDateText,
            icon: Icons.verified_rounded,
            showEndDate: true,
          );
        }

        if (status == 'pending') {
          return _buildSubscriptionHeaderContent(
            cubit: cubit,
            statusText: 'قيد المراجعة',
            packageName: packageName,
            endDateText: '',
            icon: Icons.access_time_rounded,
            showEndDate: false,
          );
        }

        if (status == 'rejected') {
          return _buildSubscriptionHeaderContent(
            cubit: cubit,
            statusText: 'مرفوض',
            packageName: 'تم رفض طلب الاشتراك',
            endDateText: '',
            icon: Icons.cancel_outlined,
            showEndDate: false,
          );
        }

        return _buildSubscriptionHeaderContent(
          cubit: cubit,
          statusText: 'غير مشترك',
          packageName: 'لا توجد باقة مفعلة حالياً',
          endDateText: '',
          icon: Icons.info_outline_rounded,
          showEndDate: false,
        );
      },
    );
  }

  Widget _buildSubscriptionHeaderContent({
    required AppCubit cubit,
    required String statusText,
    required String packageName,
    required String endDateText,
    required IconData icon,
    required bool showEndDate,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SvgPicture.asset(
                  'assets/subs.svg',
                  color: Colors.white,
                  width: 25.w,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  'اشتراك الفني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 18.r,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Text(
            showEndDate ? 'الباقة الحالية' : 'حالة الاشتراك',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 5.h),

          Text(
            packageName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (showEndDate) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/date.svg',
                  color: Colors.white.withOpacity(0.9),
                  width: 20.w,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'ينتهي الاشتراك في: $endDateText',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
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

  Widget _buildSectionTitle(String title, String icon, AppCubit cubit) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.20)
                : mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SvgPicture.asset(icon,color: mainColor,width: 25.w,)
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge!.color,
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
            width: isSelected ? 1.5 :0,
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
                  '${plan['price']} ﷼',
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
                color: cubit.isDark
                    ? mainColor.withOpacity(0.20)
                    : mainColor.withOpacity(0.10),
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

  Widget _buildSubscribeButton(AppCubit cubit) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 20.w,
        end: 20.w,
        top: 10.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: cubit.isDark ? darkBgColor : Colors.white,
        boxShadow: cubit.isDark
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
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
        text: 'متابعة الإشتراك',
      ),
    );
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

    return DateTime.now().isAfter(dateTime);
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
                    'الاشتراكات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 20.h,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    'اختر الباقة المناسبة',
                    'assets/card.svg',
                    cubit,
                  ),
                  SizedBox(height: 15.h),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                    return _buildPlanCard(plans[index], cubit);
                  },),
                  SizedBox(height: 10.h),
                  _buildSectionTitle(
                    'طريقة الدفع',
                    'assets/money.svg',
                    cubit,
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
                ],
              ),
            ),
            bottomNavigationBar: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(CacheHelper.getData(key: 'uid'))
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildSubscribeButton(cubit);
                }

                final userData = snapshot.data!.data() ?? {};

                final Map<String, dynamic> subscription =
                Map<String, dynamic>.from(userData['subscription'] ?? {});

                final bool isSubscribed = userData['isSubscribed'] == true;
                final bool isActive = subscription['isActive'] == true;
                final String status = subscription['status']?.toString() ?? '';

                final bool isExpired = _isSubscriptionExpired(
                  subscription['endAt'] ?? subscription['endDate'] ?? subscription['expiresAt'],
                );

                final bool showButton =
                    status.isEmpty ||
                        status == 'rejected' ||
                        isExpired ||
                        (!isSubscribed && !isActive && status != 'pending');

                if (!showButton) {
                  return const SizedBox.shrink();
                }

                return _buildSubscribeButton(cubit);
              },
            ),
          ),
        );
      },
    );
  }
}
