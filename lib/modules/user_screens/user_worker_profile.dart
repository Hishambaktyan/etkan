import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';

import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class UserWorkerProfile extends StatefulWidget {
  final String providerId;
  final Map<String, dynamic>? providerData;

  const UserWorkerProfile({
    super.key,
    required this.providerId,
    this.providerData,
  });

  @override
  State<UserWorkerProfile> createState() => _UserWorkerProfileState();
}

class _UserWorkerProfileState extends State<UserWorkerProfile> {
  bool isLoading = true;
  String errorMessage = '';

  Map<String, dynamic> worker = {};
  int servicesCount = 0;
  int requestsCount = 0;
  int completedJobs = 0;

  Future<void> getWorkerProfileData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final appCubit = AppCubit.get(context);

      String providerId = widget.providerId.trim();

      Map<String, dynamic> data = Map<String, dynamic>.from(
        widget.providerData ?? {},
      );

      if (providerId.isEmpty) {
        providerId = '${data['uid'] ?? ''}'.trim();
      }

      final cachedUser = appCubit.allUsers[providerId];
      if (cachedUser is Map && cachedUser.isNotEmpty) {
        data.addAll(Map<String, dynamic>.from(cachedUser));
      }

      if (data.isEmpty || data['name'] == null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(providerId)
            .get();

        data = userSnapshot.data()!;
      }

      data['uid'] = data['uid'] ?? providerId;

      final servicesCountFuture = FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: providerId)
          .count()
          .get();

      final requestsCountFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: providerId)
          .count()
          .get();

      final completedJobsFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: providerId)
          .where('status', isEqualTo: 'مكتمل')
          .count()
          .get();

      final results = await Future.wait([
        servicesCountFuture,
        requestsCountFuture,
        completedJobsFuture,
      ]);

      if (!mounted) return;

      setState(() {
        worker = data;
        servicesCount = results[0].count ?? 0;
        requestsCount = results[1].count ?? 0;
        completedJobs = results[2].count ?? 0;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String getText(dynamic value, {String fallback = ''}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty ? fallback : text;
  }

  double getDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse('${value ?? 0}') ?? 0.0;
  }

  List<String> getStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => '$item'.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return [];
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWorkerProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        if (isLoading) {
          return buildLoadingScreen(appCubit);
        }

        if (errorMessage.isNotEmpty) {
          return buildErrorScreen(appCubit);
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: RefreshIndicator(
              color: mainColor,
              onRefresh: getWorkerProfileData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    buildHeader(appCubit: appCubit),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 10.w,
                        end: 10.w,
                        top: 20.h,
                        bottom: 20.h,
                      ),
                      child: Column(
                        children: [
                          buildQuickStats(appCubit),
                          SizedBox(height: 25.h),
                          buildSectionHeader(
                            title: 'نبذة عن الفني',
                            icon: SvgPicture.asset(
                              'assets/info.svg',
                              color: mainColor,
                              width: 25.w,
                            ),
                            cubit: appCubit,
                          ),
                          SizedBox(height: 10.h),
                          buildAboutCard(appCubit),
                          SizedBox(height: 20.h),
                          buildSectionHeader(
                            title: 'الخبرات',
                            icon: SvgPicture.asset(
                              'assets/subs.svg',
                              color: mainColor,
                              width: 25.w,
                            ),
                            cubit: appCubit,
                          ),
                          SizedBox(height: 10.h),
                          buildExperiencesCard(appCubit),
                          SizedBox(height: 20.h),
                          buildSectionHeader(
                            title: 'الأعمال السابقة',
                            icon: SvgPicture.asset(
                              'assets/image.svg',
                              color: mainColor,
                              width: 25.w,
                            ),
                            cubit: appCubit,
                          ),
                          SizedBox(height: 10.h),
                          buildPreviousWorksCard(appCubit),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSectionHeader({
    required String title,
    required Widget icon,
    required AppCubit cubit,
  }) {
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
          child: icon,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }

  Widget buildWhiteCard({
    required Widget child,
    required AppCubit cubit,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: child,
    );
  }

  Widget buildHeaderButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(15.r),
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 42.w,
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(
          CupertinoIcons.back,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget buildHeader({
    required AppCubit appCubit,
  }) {
    final workerName = getText(
      worker['name'],
    );
    final workerSpec = getText(
      worker['specialization'],
    );
    final workerImage = getText(worker['profileImage']);
    final isAvailable = worker['isAvailable'] == true;
    final Map<String, dynamic> verification = worker['verification'] is Map
        ? Map<String, dynamic>.from(worker['verification'])
        : {};
    final bool isVerified = worker['isVerified'] == true ||
        verification['status']?.toString() == 'approved';
    final rating = getDouble(worker['avgRating']);

    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(35.r),
      ),
      child: Container(
        width: double.infinity,
        height: 350.h,
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
            Positioned(
              top: 205.h,
              left: -40.w,
              child: Container(
                width: 200.r,
                height: 200.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      mainColor.withOpacity(0.4),
                      mainColor.withOpacity(0),
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
                      buildHeaderButton(),
                      SizedBox(width: 12.w),
                      Text(
                        'ملف الفني',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 104.r,
                          height: 104.r,
                          padding: EdgeInsets.all(3.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 48.r,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            backgroundImage: workerImage.isNotEmpty
                                ? NetworkImage(workerImage)
                                : null,
                            child: workerImage.isEmpty
                                ? Icon(
                                    Icons.engineering_rounded,
                                    color: Colors.white,
                                    size: 48.r,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          workerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          alignment: WrapAlignment.center,
                          children: [
                            buildHeaderChip(
                              icon: 'assets/acc.svg',
                              title: workerSpec,
                            ),
                            buildHeaderChip(
                              icon: 'assets/star.svg',
                              title: rating.toStringAsFixed(1),
                            ),
                            buildHeaderChip2(
                              icon: isAvailable
                                  ? Icons.check_circle_rounded
                                  : Icons.access_time_filled_rounded,
                              title: isAvailable ? 'متاح الآن' : 'غير متاح',
                              color: isAvailable ? Colors.green : Colors.orange,
                            ),
                            if (isVerified)
                              buildHeaderChip2(
                                icon: Icons.verified_rounded,
                                title: 'حساب موثق',
                                color: Colors.lightBlueAccent,
                              ),
                          ],
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

  Widget buildHeaderChip({
    required String icon,
    required String title,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            color: color ?? Colors.white,
            width: 15.w,
          ),
          SizedBox(width: 5.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderChip2({
    required IconData icon,
    required String title,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color ?? Colors.white,
            size: 15.w,
          ),
          SizedBox(width: 5.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickStats(AppCubit cubit) {
    final rating = getDouble(worker['avgRating']);

    return Row(
      children: [
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/star.svg',
            color: mainColor,
            width: 25.w,
          ),
          value: rating.toStringAsFixed(1),
          title: 'التقييم',
        ),
        SizedBox(width: 10.w),
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/services.svg',
            color: mainColor,
            width: 25.w,
          ),
          value: '$servicesCount',
          title: 'الخدمات',
        ),
        SizedBox(width: 10.w),
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/work.svg',
            color: mainColor,
            width: 25.w,
          ),
          value: '$completedJobs',
          title: 'مكتملة',
        ),
      ],
    );
  }

  Widget buildStatCard({
    required Widget icon,
    required String value,
    required String title,
    required AppCubit cubit,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.all(15.w),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
                icon,
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow({
    required AppCubit cubit,
    required String icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(9.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.18)
                : mainColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: SvgPicture.asset(
            icon,
            color: mainColor,
            width: 20.r,
            height: 20.r,
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 80.w,
          child: Text(
            title,
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade600,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAboutCard(AppCubit cubit) {
    final about = getText(
      worker['about'],
    );

    return buildWhiteCard(
      cubit: cubit,
      child: ReadMoreText(
        about,
        trimLines: 4,
        trimMode: TrimMode.Line,
        trimCollapsedText: ' عرض المزيد',
        trimExpandedText: ' عرض أقل',
        style: TextStyle(
          fontSize: 12.sp,
          color: cubit.isDark ? darkSubTextColor : Colors.black87,
          height: 1.8,
          fontWeight: FontWeight.w500,
        ),
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
    );
  }

  Widget buildExperiencesCard(AppCubit cubit) {
    final experiences = getStringList(worker['experiences']);

    return buildWhiteCard(
      cubit: cubit,
      child: experiences.isEmpty
          ? buildEmptyInsideCard(
              icon: Icons.workspace_premium_outlined,
              title: 'لا توجد خبرات مضافة',
              cubit: cubit,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: experiences.map((exp) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.all(4.r),
                        decoration: BoxDecoration(
                          color: cubit.isDark
                              ? mainColor.withOpacity(0.20)
                              : mainColor.withOpacity(0.10),
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
                            color: cubit.isDark
                                ? darkSubTextColor
                                : Colors.black87,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
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

  Widget buildPreviousWorksCard(AppCubit cubit) {
    final previousWorks = getStringList(worker['previousWorks']);

    return buildWhiteCard(
      cubit: cubit,
      padding: previousWorks.isEmpty
          ? EdgeInsetsDirectional.all(18.r)
          : EdgeInsetsDirectional.only(
              start: 12.w,
              end: 12.w,
              top: 14.h,
              bottom: 14.h,
            ),
      child: previousWorks.isEmpty
          ? buildEmptyInsideCard(
              icon: Icons.image_not_supported_outlined,
              title: 'لا توجد أعمال سابقة',
              cubit: cubit,
            )
          : SizedBox(
              height: 160.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: previousWorks.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final work = previousWorks[index];

                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(18.r),
                    onTap: () => move(
                      context,
                      ImageViewerPage(imageUrl: work),
                    ),
                    child: Container(
                      width: 180.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        color:
                            cubit.isDark ? darkBgColor : Colors.grey.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: Image.network(
                          work,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Container(
                              color: cubit.isDark
                                  ? darkBgColor
                                  : Colors.grey.shade100,
                              child: Center(
                                child: SizedBox(
                                  width: 22.w,
                                  height: 22.h,
                                  child: const CircularProgressIndicator(
                                    color: mainColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: cubit.isDark
                                  ? darkBgColor
                                  : Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: cubit.isDark
                                    ? darkSubTextColor
                                    : Colors.grey,
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
    );
  }

  Widget buildEmptyInsideCard({
    required IconData icon,
    required String title,
    required AppCubit cubit,
  }) {
    return Center(
      child: Column(
        children: [
          Icon(
            icon,
            color: cubit.isDark ? darkSubTextColor : Colors.grey.shade400,
            size: 45.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingScreen(AppCubit appCubit) {
    return UserWorkerProfileShimmer(
      isDark: appCubit.isDark,
    );
  }

  Widget buildErrorScreen(AppCubit appCubit) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusDirectional.vertical(
                bottom: Radius.circular(35.r),
              ),
              child: Container(
                height: 170.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      mainColor.withOpacity(0.9),
                      const Color(0xFF0F0F1E),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 35.h,
                    start: 10.w,
                    end: 18.w,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeaderButton(),
                      SizedBox(width: 12.w),
                      Text(
                        'ملف الفني',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  child: buildWhiteCard(
                    cubit: appCubit,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                          size: 45.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        defaultTextButton(
                          onPressed: getWorkerProfileData,
                          text: 'إعادة المحاولة',
                          isBold: true,
                          isLined: false,
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
    );
  }
}
