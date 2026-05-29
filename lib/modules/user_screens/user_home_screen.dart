import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trying_homy/modules/user_screens/services_list.dart';
import 'package:trying_homy/modules/user_screens/service_details.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_states.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  Widget buildSectionTitle({
    required String title,
    required String icon,
    required dynamic cubit,
  }) {
    return Row(
      children: [
        Container(
            padding: EdgeInsetsDirectional.all(8.w),
            decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.2)
                  : mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: mainColor,
              width: 25.w,
            )),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: cubit.isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  bool hasInternet = true;
  bool checkingInternet = true;

  Future<void> checkConnectionAndGetData() async {
    if (!mounted) return;

    setState(() {
      checkingInternet = true;
    });

    final result = await checkInternet();

    if (!mounted) return;

    if (!result) {
      setState(() {
        hasInternet = false;
        checkingInternet = false;
      });
      return;
    }

    try {
      final userServicesCubit = UserServicesCubit.get(context);

      await Future.wait([
        userServicesCubit.getUserServices(),
        userServicesCubit.getAllUsers(),
        userServicesCubit.getCategories(),
      ]);

      if (!mounted) return;

      setState(() {
        hasInternet = true;
        checkingInternet = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        hasInternet = true;
        checkingInternet = false;
      });

      debugPrint('Error loading home data: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkConnectionAndGetData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
            body: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<UserServicesCubit, UserServicesStates>(
            builder: (context, state) {
              UserServicesCubit userServicesCubit =
                  UserServicesCubit.get(context);
              return ConditionalBuilder(
                condition: checkingInternet,
                builder: (context) => UserHomeShimmer(isDark: appCubit.isDark),
                fallback: (context) => ConditionalBuilder(
                  condition: !hasInternet,
                  builder: (context) => NoInternet(
                    onRetry: () => checkConnectionAndGetData(),
                  ),
                  fallback: (context) => ConditionalBuilder(
                    condition: state is GetUserAllServicesLoadingState,
                    builder: (context) =>
                        UserHomeShimmer(isDark: appCubit.isDark),
                    fallback: (context) => RefreshIndicator(
                      onRefresh: () => checkConnectionAndGetData(),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headerWithSearch(
                                title: 'الصفحة الرئيسية',
                                searchKeyWords: [
                                  "ابحث عن خدمات",
                                  "ابحث عن أقسام",
                                  "ابحث عن كهربائي",
                                ],
                                context: context,
                                appCubit: appCubit),
                            SizedBox(
                              height: 20.h,
                            ),
                            Column(
                              children: [
                                /*بانر ترحيبي*/
                                Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 10.w),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      boxShadow: blueShadow,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          mainColor,
                                          Color(0xFF0F0F1E),
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: -20.w,
                                          top: -10.h,
                                          child: Transform.rotate(
                                            angle: 0.5,
                                            child: Container(
                                              width: 120.w,
                                              height: 120.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.05),
                                                borderRadius:
                                                    BorderRadius.circular(35.r),
                                              ),
                                            ),
                                          ),
                                        ),
                                        PositionedDirectional(
                                          end: -10.w,
                                          bottom: -10.h,
                                          child: Container(
                                            width: 150.r,
                                            height: 150.r,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                colors: [
                                                  mainColor.withOpacity(0.3),
                                                  mainColor.withOpacity(0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.all(20.r),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 4.h),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                      ),
                                                      child: Text(
                                                        'مرحباً بك في هومي',
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                      'أهلاً بك، ${appCubit.allUsers[CacheHelper.getData(key: 'uid')]['name']} 👋',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                      'ما هي الخدمة التي تحتاجها اليوم؟',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    width: 75.r,
                                                    height: 75.r,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.2)),
                                                    ),
                                                  ),
                                                  Transform.rotate(
                                                    angle: -0.15,
                                                    child: SvgPicture.asset(
                                                      'assets/ticket_bold.svg',
                                                      color: Colors.white,
                                                      width: 45.w,
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
                                SizedBox(
                                  height: 20.h,
                                ),
                                /*الأقسام*/
                                Padding(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 10.w),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          buildSectionTitle(
                                            title: 'الأقسام',
                                            icon: 'assets/grid.svg',
                                            cubit: appCubit,
                                          ),
                                          const Spacer(),
                                          defaultTextButton(
                                            onPressed: () =>
                                                appCubit.changeIndex(2),
                                            text: 'عرض الكل',
                                            isLined: false,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      if (userServicesCubit.categories.isEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20.r),
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
                                              Icon(
                                                Icons.category_outlined,
                                                color: mainColor,
                                                size: 40.sp,
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                'لا توجد أقسام حالياً',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: appCubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        GridView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsetsDirectional.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10.h,
                                            crossAxisSpacing: 10.w,
                                            childAspectRatio: 2.1,
                                          ),
                                          itemCount: userServicesCubit
                                                      .categories.length >
                                                  4
                                              ? 4
                                              : userServicesCubit
                                                  .categories.length,
                                          itemBuilder: (context, index) {
                                            final category = userServicesCubit
                                                .categories[index];

                                            final String categoryTitle =
                                                '${category['title'] ?? ''}';
                                            final String categoryImage =
                                                '${category['image'] ?? ''}';

                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(25.r),
                                              onTap: () {
                                                move(
                                                  context,
                                                  ServicesList(
                                                    categoryType: categoryTitle,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.all(
                                                        10.r),
                                                decoration: BoxDecoration(
                                                  color: appCubit.isDark
                                                      ? lightDarkColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r),
                                                  boxShadow: blueShadow,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 50.w,
                                                      height: 50.h,
                                                      padding:
                                                          EdgeInsets.all(12.r),
                                                      decoration: BoxDecoration(
                                                        color: mainColor
                                                            .withOpacity(0.08),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.r),
                                                      ),
                                                      child: categoryImage
                                                              .trim()
                                                              .isNotEmpty
                                                          ? SvgPicture.network(
                                                              categoryImage,
                                                              fit: BoxFit
                                                                  .contain,
                                                              placeholderBuilder:
                                                                  (context) {
                                                                return Shimmer
                                                                    .fromColors(
                                                                  baseColor: appCubit
                                                                          .isDark
                                                                      ? const Color(
                                                                          0xFF2A2A2A)
                                                                      : const Color(
                                                                          0xFFE3F2FD),
                                                                  highlightColor: appCubit
                                                                          .isDark
                                                                      ? const Color(
                                                                          0xFF3A3A3A)
                                                                      : const Color(
                                                                          0xFFF8FCFF),
                                                                  child:
                                                                      Container(
                                                                    width: 26.w,
                                                                    height:
                                                                        26.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.r),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .category_rounded,
                                                              color: mainColor,
                                                              size: 25.sp,
                                                            ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Text(
                                                        categoryTitle,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.sp,
                                                          color: appCubit.isDark
                                                              ? Colors.white
                                                              : Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: mainColor
                                                          .withOpacity(0.3),
                                                      size: 12.sp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                /*الخدمات الرائجة*/
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 10.w),
                                      child: buildSectionTitle(
                                        title: 'الخدمات الرائجة',
                                        icon: 'assets/services.svg',
                                        cubit: appCubit,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    if (userServicesCubit.userServices.isEmpty)
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.symmetric(
                                                horizontal: 10.w),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20.r),
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
                                              Icon(
                                                Icons
                                                    .home_repair_service_rounded,
                                                color: mainColor,
                                                size: 45.sp,
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                'لا توجد خدمات رائجة حالياً',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: appCubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      SizedBox(
                                        height: 350.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsetsDirectional.only(
                                            start: 15.w,
                                            bottom: 10.h,
                                          ),
                                          itemCount: userServicesCubit
                                                      .userServices.length >
                                                  4
                                              ? 4
                                              : userServicesCubit
                                                  .userServices.length,
                                          itemBuilder: (context, index) {
                                            var service = userServicesCubit
                                                .userServices[index];

                                            Map<String, dynamic> providerData =
                                                Map<String, dynamic>.from(
                                              userServicesCubit.allUsers[
                                                      service['providerId']] ??
                                                  {},
                                            );

                                            String serviceImage =
                                                '${service['serviceImage'] ?? ''}';
                                            String providerImage =
                                                '${providerData['profileImage'] ?? ''}';

                                            return Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                start: index == 0 ? 0 : 15.w,
                                                end: index == 3 ? 15.w : 0,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  move(
                                                    context,
                                                    ServiceDetails(
                                                      name:
                                                          service['name'] ?? '',
                                                      image: service[
                                                              'serviceImage'] ??
                                                          '',
                                                      category:
                                                          service['category'] ??
                                                              '',
                                                      desc: service[
                                                              'description'] ??
                                                          '',
                                                      price:
                                                          service['price'] ?? 0,
                                                      period:
                                                          service['period'] ??
                                                              '',
                                                      rate:
                                                          service['rate'] ?? 0,
                                                      providerName:
                                                          providerData[
                                                                  'name'] ??
                                                              'فني غير معروف',
                                                      providerSpec: providerData[
                                                              'specialization'] ??
                                                          '',
                                                      reviews:
                                                          service['reviews'] ??
                                                              [],
                                                      providerId: providerData[
                                                              'uid'] ??
                                                          service[
                                                              'providerId'] ??
                                                          '',
                                                    ),
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(25.r),
                                                child: Container(
                                                  width: 280.w,
                                                  decoration: BoxDecoration(
                                                    color: appCubit.isDark
                                                        ? lightDarkColor
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.r),
                                                    boxShadow: blueShadow,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.r),
                                                            child:
                                                                Image.network(
                                                              serviceImage,
                                                              height: 180.h,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Container(
                                                                  height: 180.h,
                                                                  width: double
                                                                      .infinity,
                                                                  color: mainColor
                                                                      .withOpacity(
                                                                          0.08),
                                                                  child: Icon(
                                                                    Icons
                                                                        .image_not_supported_rounded,
                                                                    color:
                                                                        mainColor,
                                                                    size: 40.sp,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          PositionedDirectional(
                                                            bottom: 12.h,
                                                            end: 12.w,
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    12.w,
                                                                vertical: 6.h,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    mainColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.r),
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    blurRadius:
                                                                        8,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Text(
                                                                '${service['price'] ?? ''} $reyalSymbol',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      13.sp,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          PositionedDirectional(
                                                            top: 12.h,
                                                            start: 12.w,
                                                            child: ClipRRect(
                                                              child:
                                                                  BackdropFilter(
                                                                filter:
                                                                    ImageFilter
                                                                        .blur(
                                                                  sigmaX: 5,
                                                                  sigmaY: 5,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10.w,
                                                                    vertical:
                                                                        4.h,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.7),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.r),
                                                                  ),
                                                                  child: Text(
                                                                    '${service['category'] ?? ''}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          mainColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          10.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .all(15.r),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              service['name'] ??
                                                                  '',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.sp,
                                                                color: appCubit
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 8.h),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .star_rounded,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 18.sp,
                                                                ),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                Text(
                                                                  '${service['rate'] ?? 0}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_rounded,
                                                                  color: mainColor
                                                                      .withOpacity(
                                                                          0.2),
                                                                  size: 14.sp,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 12.h),
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.r),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: mainColor
                                                                    .withOpacity(
                                                                        0.05),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.r),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius:
                                                                        16.r,
                                                                    backgroundImage: providerImage
                                                                            .trim()
                                                                            .isNotEmpty
                                                                        ? NetworkImage(
                                                                            providerImage)
                                                                        : null,
                                                                    child: providerImage
                                                                            .trim()
                                                                            .isEmpty
                                                                        ? Icon(
                                                                            Icons.person,
                                                                            size:
                                                                                18.sp,
                                                                            color:
                                                                                mainColor,
                                                                          )
                                                                        : null,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          8.w),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          '${providerData['name'] ?? 'فني غير معروف'}',
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyLarge!.color,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '${providerData['specialization'] ?? ''}',
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                9.sp,
                                                                            color:
                                                                                Colors.grey,
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
      },
    );
  }
}
