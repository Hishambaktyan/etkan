import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

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
      'title': 'الباقة الشهرية',
      'price': '2500',
      'period': 'شهرياً',
      'badge': 'الأكثر استخداماً',
      'features': [
        'إضافة عدد غير محدود من الخدمات',
        'ظهور خدماتك للعملاء',
        'استقبال الطلبات الجديدة',
        'إدارة الحجوزات والدردشة',
      ],
    },
    {
      'id': 'yearly',
      'title': 'الباقة السنوية',
      'price': '25000',
      'period': 'سنوياً',
      'badge': 'وفر أكثر',
      'features': [
        'كل مميزات الباقة الشهرية',
        'أولوية ظهور أعلى في البحث',
        'توفير شهرين من قيمة الاشتراك',
        'دعم أسرع لحساب العامل',
      ],
    },
  ];

  Widget _buildHeaderCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: cubit.isDark
            ? []
            : [
                BoxShadow(
                  color: mainColor.withOpacity(0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 26.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'اشتراك العامل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.white.withOpacity(0.35)),
                ),
                child: Text(
                  'نشط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            'الباقة الحالية',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'الباقة الشهرية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 18.r,
              ),
              SizedBox(width: 6.w),
              Text(
                'ينتهي الاشتراك في: 20 مايو 2026',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, AppCubit cubit) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.20)
                : mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: mainColor,
            size: 20.r,
          ),
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
      borderRadius: BorderRadius.circular(18.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? mainColor
                : cubit.isDark
                    ? const Color(0xFF30363D)
                    : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: cubit.isDark ? [] : shadow,
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
    required String title,
    required String subtitle,
    required IconData icon,
    required AppCubit cubit,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.20)
                  : mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: mainColor,
              size: 23.r,
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: cubit.isDark ? darkSubTextColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.navigate_next_rounded,
            color: cubit.isDark
                ? Colors.white.withOpacity(0.5)
                : Colors.grey.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
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
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    'اختر الباقة المناسبة',
                    Icons.card_membership_rounded,
                    cubit,
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: plans
                        .map((plan) => _buildPlanCard(plan, cubit))
                        .toList(),
                  ),
                  SizedBox(height: 10.h),
                  _buildSectionTitle(
                    'طريقة الدفع',
                    Icons.payments_outlined,
                    cubit,
                  ),
                  SizedBox(height: 15.h),
                  _buildPaymentMethod(
                    title: 'تحويل بنكي',
                    subtitle: 'ارفع صورة سند التحويل بعد الدفع',
                    icon: Icons.account_balance_rounded,
                    cubit: cubit,
                  ),
                  _buildPaymentMethod(
                    title: 'دفع وديعة',
                    subtitle: 'تفعيل الاشتراك بعد تأكيد العملية',
                    icon: Icons.wallet_rounded,
                    cubit: cubit,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
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
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'متابعة الاشتراك',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
