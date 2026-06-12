import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Etkan/modules/user_screens/user_request_details.dart';
import 'package:Etkan/modules/user_screens/user_service_details.dart';
import 'package:Etkan/modules/user_screens/user_services_list.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/user_cubit/user_cubit.dart';
import 'package:Etkan/shared/cubits/user_cubit/user_states.dart';
import 'package:Etkan/shared/networks/local/cache_helper.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/styles/colors.dart';

import '../main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = [
    'تركيب مكيفات سبليت',
    'حجوزات قيد الانتظار',
    'حجوزات مقبولة',
    'صيانة تسربات الحمام',
    'دهانات جوتن داخلية',
  ];

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? searchDebounce;
  String selectedSearchFilter = 'الكل';

  final List<Map<String, String>> servicesCategories = [
    {'name': 'الكهرباء', 'icon': 'assets/SVGs/E.svg', 'type': 'كهرباء'},
    {'name': 'السباكة', 'icon': 'assets/SVGs/P.svg', 'type': 'سباكة'},
    {'name': 'البناء', 'icon': 'assets/SVGs/C.svg', 'type': 'بناء'},
    {'name': 'التكييف', 'icon': 'assets/SVGs/AC.svg', 'type': 'تكييف'},
    {'name': 'الحدادة', 'icon': 'assets/SVGs/A.svg', 'type': 'حدادة'},
    {'name': 'الماء', 'icon': 'assets/SVGs/WT.svg', 'type': 'ماء'},
    {'name': 'النجارة', 'icon': 'assets/SVGs/CA.svg', 'type': 'نجارة'},
    {'name': 'الدهان', 'icon': 'assets/SVGs/PA.svg', 'type': 'دهان'},
  ];

  @override
  void initState() {
    super.initState();
    loadRecentSearches();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      searchFocusNode.requestFocus();

      final userServicesCubit = UserCubit.get(context);

      if (userServicesCubit.categories.isEmpty) {
        userServicesCubit.getCategories();
      }

      final bookingCubit = UserCubit.get(context);
      if (bookingCubit.userRequests.isEmpty) {
        bookingCubit.getUserRequests();
      }
    });
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocBuilder<UserCubit, UserStates>(
              builder: (context, userServicesState) {
                if (userServicesState is GetUserAllServicesLoadingState) {
                  return SearchScreenShimmer(isDark: appCubit.isDark);
                }
                return BlocBuilder<UserCubit, UserStates>(
                  builder: (context, bookingState) {
                    final userServicesCubit = UserCubit.get(context);
                    final bookingCubit = UserCubit.get(context);
                    final services = List<Map<String, dynamic>>.from(
                      userServicesCubit.userServices,
                    );
                    final bookings = List<Map<String, dynamic>>.from(
                      bookingCubit.userRequests,
                    );
                    final allUsers = <dynamic, dynamic>{};
                    allUsers.addAll(userServicesCubit.allUsers);
                    allUsers.addAll(appCubit.allUsers);
                    final suggestedServices = services.take(4).toList();
                    final categories = List<Map<String, dynamic>>.from(
                      userServicesCubit.categories,
                    );
                    final filteredDepartments = getFilteredDepartments(
                      categories: categories,
                    );
                    final filteredServices = getFilteredServices(
                      services: services,
                      providers: allUsers,
                    );
                    final filteredBookings = getFilteredBookings(
                      bookings: bookings,
                      providers: allUsers,
                    );
                    final filteredWorkers = getFilteredWorkers(
                      providers: allUsers,
                      services: services,
                      bookings: bookings,
                    );

                    final hasQuery = searchController.text.trim().isNotEmpty;
                    final isBookingLoading = bookingState
                        .toString()
                        .toLowerCase()
                        .contains('loading');

                    return SingleChildScrollView(
                      padding: EdgeInsetsDirectional.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSearchHeader(appCubit),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10.w,
                            ),
                            child: hasQuery
                                ? buildSearchResults(
                                    appCubit: appCubit,
                                    departments: filteredDepartments,
                                    services: filteredServices,
                                    bookings: filteredBookings,
                                    workers: filteredWorkers,
                                    allUsers: allUsers,
                                    isBookingLoading: isBookingLoading,
                                  )
                                : buildDefaultSearchContent(
                                    appCubit: appCubit,
                                    suggestedServices: suggestedServices,
                                    allUsers: allUsers,
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void loadRecentSearches() {
    final savedSearches = CacheHelper.getData(key: 'recentSearches');

    if (savedSearches == null) return;

    try {
      final decoded = jsonDecode('$savedSearches');

      if (decoded is List) {
        recentSearches
          ..clear()
          ..addAll(
            decoded
                .map((item) => '$item'.trim())
                .where((item) => item.isNotEmpty)
                .take(5),
          );
      }
    } catch (_) {}
  }

  void saveRecentSearches() {
    CacheHelper.saveData(
      key: 'recentSearches',
      value: jsonEncode(recentSearches),
    );
  }

  void onSearchChanged(String value) {
    searchDebounce?.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;

      setState(() {
        selectedSearchFilter = 'الكل';
      });
    });
  }

  String normalizeText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll(RegExp(r'[\u064B-\u0652]'), '');
  }

  bool containsQuery(List<dynamic> values) {
    final query = normalizeText(searchController.text);
    if (query.isEmpty) return false;

    final combined = normalizeText(values.join(' '));
    final words = query.split(RegExp(r'\s+')).where((word) => word.isNotEmpty);

    return combined.contains(query) ||
        words.every((word) => combined.contains(word));
  }

  void addRecentSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > 5) {
        recentSearches.removeRange(5, recentSearches.length);
      }
      saveRecentSearches();
    });
  }

  int calculateSearchScore({
    required List<dynamic> highPriority,
    List<dynamic> mediumPriority = const [],
    List<dynamic> lowPriority = const [],
  }) {
    final query = normalizeText(searchController.text);
    if (query.isEmpty) return 0;

    int scoreList(List<dynamic> values, int weight) {
      int bestScore = 0;

      for (final value in values) {
        final field = normalizeText('$value');
        if (field.isEmpty) continue;

        final words = query
            .split(RegExp(r'\s+'))
            .where((word) => word.trim().isNotEmpty)
            .toList();

        if (field == query) {
          bestScore = bestScore < weight * 5 ? weight * 5 : bestScore;
        } else if (field.startsWith(query)) {
          bestScore = bestScore < weight * 4 ? weight * 4 : bestScore;
        } else if (field.contains(query)) {
          bestScore = bestScore < weight * 3 ? weight * 3 : bestScore;
        } else if (words.isNotEmpty &&
            words.every((word) => field.contains(word))) {
          bestScore = bestScore < weight * 2 ? weight * 2 : bestScore;
        }
      }

      return bestScore;
    }

    return scoreList(highPriority, 10) +
        scoreList(mediumPriority, 6) +
        scoreList(lowPriority, 3);
  }

  int getDepartmentSearchScore(Map<String, dynamic> dept) {
    final title = '${dept['title'] ?? dept['name'] ?? ''}';

    return calculateSearchScore(
      highPriority: [
        title,
      ],
      mediumPriority: [
        'قسم $title',
        'خدمات $title',
        'فني $title',
        'عامل $title',
      ],
      lowPriority: [
        'قسم',
        'اقسام',
        'الأقسام',
        'الخدمات',
      ],
    );
  }

  int getServiceSearchScore(
    Map<String, dynamic> service,
    Map<dynamic, dynamic> providers,
  ) {
    final providerData = providers[service['providerId']] ?? {};

    return calculateSearchScore(
      highPriority: [
        service['name'],
        service['category'],
        service['subCategory'],
      ],
      mediumPriority: [
        providerData['name'],
        providerData['specialization'],
        service['description'],
      ],
      lowPriority: [
        service['price'],
        service['period'],
        'خدمة',
        'خدمات',
        'فني',
        'فنيين',
        'عامل',
        'عمال',
        'مقدم خدمة',
      ],
    );
  }

  int getBookingSearchScore(
    Map<String, dynamic> booking,
    Map<dynamic, dynamic> providers,
  ) {
    final providerData = providers[booking['providerId']] ?? {};
    final status = '${booking['status'] ?? ''}';

    return calculateSearchScore(
      highPriority: [
        booking['title'],
        status,
        ...getStatusAliases(status),
      ],
      mediumPriority: [
        booking['category'],
        booking['subCategory'],
        providerData['name'],
        providerData['specialization'],
      ],
      lowPriority: [
        booking['description'],
        booking['address'],
        booking['duration'],
        booking['price'],
        'حجز',
        'حجوزات',
        'طلب',
        'طلبات',
        'فني',
        'فنيين',
        'عامل',
        'عمال',
        'مقدم خدمة',
      ],
    );
  }

  int getWorkerSearchScore(Map<String, dynamic> worker) {
    return calculateSearchScore(
      highPriority: [
        worker['name'],
        worker['specialization'],
      ],
      mediumPriority: [
        'فني ${worker['name']}',
        'عامل ${worker['name']}',
        'فني ${worker['specialization']}',
        'عامل ${worker['specialization']}',
      ],
      lowPriority: [
        'فني',
        'فنيين',
        'عامل',
        'عمال',
        'مقدم خدمة',
      ],
    );
  }

  List<String> getStatusAliases(String status) {
    switch (status) {
      case 'قيد الانتظار':
        return [
          'قيد الانتظار',
          'قيد الأنتظار',
          'انتظار',
          'منتظر',
          'بانتظار',
          'حجوزات قيد الانتظار',
          'حجز قيد الانتظار',
          'طلبات قيد الانتظار',
        ];
      case 'مقبول':
        return [
          'مقبول',
          'مقبولة',
          'مقبوله',
          'تم القبول',
          'حجوزات مقبولة',
          'حجوزات مقبوله',
          'حجز مقبول',
        ];
      case 'في الطريق':
        return [
          'في الطريق',
          'بالطريق',
          'جاري الوصول',
          'حجوزات في الطريق',
          'حجز في الطريق',
        ];
      case 'مكتمل':
        return [
          'مكتمل',
          'مكتملة',
          'مكتمله',
          'تم اكمال الخدمة',
          'تم إكمال الخدمة',
          'حجوزات مكتملة',
          'حجوزات مكتمله',
        ];
      case 'مرفوض':
        return [
          'مرفوض',
          'مرفوضة',
          'مرفوضه',
          'حجوزات مرفوضة',
          'حجوزات مرفوضه',
        ];
      case 'ملغي':
        return [
          'ملغي',
          'ملغية',
          'ملغيه',
          'حجوزات ملغية',
          'حجوزات ملغيه',
        ];
      default:
        return [status];
    }
  }

  List<Map<String, dynamic>> getFilteredDepartments({
    required List<Map<String, dynamic>> categories,
  }) {
    final query = normalizeText(searchController.text);
    if (query.isEmpty) return [];

    final isDepartmentQuery = [
      'قسم',
      'اقسام',
      'الاقسام',
      'الأقسام',
      'خدمات',
      'الخدمات',
    ].contains(query);

    final results = categories.where((category) {
      final title = '${category['title'] ?? category['name'] ?? ''}';

      if (title.trim().isEmpty) return false;

      if (isDepartmentQuery) return true;

      return containsQuery([
        title,
        'قسم',
        'اقسام',
        'الأقسام',
        'الخدمات',
        'خدمات $title',
        'قسم $title',
        'فني $title',
        'عامل $title',
      ]);
    }).toList();

    results.sort(
      (a, b) => getDepartmentSearchScore(b).compareTo(
        getDepartmentSearchScore(a),
      ),
    );

    return results;
  }

  List<Map<String, dynamic>> getFilteredServices({
    required List<Map<String, dynamic>> services,
    required Map<dynamic, dynamic> providers,
  }) {
    final query = normalizeText(searchController.text);
    if (query.isEmpty) return [];

    final results = services.where((service) {
      final providerData = providers[service['providerId']] ?? {};

      return containsQuery([
        service['name'],
        service['category'],
        service['subCategory'],
        service['description'],
        service['price'],
        service['period'],
        providerData['name'],
        providerData['specialization'],
        'خدمة',
        'خدمات',
        'فني',
        'فنيين',
        'عامل',
        'عمال',
        'مقدم خدمة',
      ]);
    }).toList();

    results.sort(
      (a, b) => getServiceSearchScore(b, providers).compareTo(
        getServiceSearchScore(a, providers),
      ),
    );

    return results;
  }

  List<Map<String, dynamic>> getFilteredBookings({
    required List<Map<String, dynamic>> bookings,
    required Map<dynamic, dynamic> providers,
  }) {
    final query = normalizeText(searchController.text);
    if (query.isEmpty) return [];

    final results = bookings.where((booking) {
      final providerData = providers[booking['providerId']] ?? {};
      final status = '${booking['status'] ?? ''}';

      return containsQuery([
        booking['title'],
        booking['category'],
        booking['subCategory'],
        booking['description'],
        booking['address'],
        booking['duration'],
        booking['price'],
        status,
        ...getStatusAliases(status),
        providerData['name'],
        providerData['specialization'],
        'حجز',
        'حجوزات',
        'طلب',
        'طلبات',
        'فني',
        'فنيين',
        'عامل',
        'عمال',
        'مقدم خدمة',
      ]);
    }).toList();

    results.sort(
      (a, b) => getBookingSearchScore(b, providers).compareTo(
        getBookingSearchScore(a, providers),
      ),
    );

    return results;
  }

  List<Map<String, dynamic>> getFilteredWorkers({
    required Map<dynamic, dynamic> providers,
    required List<Map<String, dynamic>> services,
    required List<Map<String, dynamic>> bookings,
  }) {
    final query = normalizeText(searchController.text);
    if (query.isEmpty) return [];

    final providerIds = <dynamic>{};

    for (final service in services) {
      if (service['providerId'] != null) {
        providerIds.add(service['providerId']);
      }
    }

    for (final booking in bookings) {
      if (booking['providerId'] != null) {
        providerIds.add(booking['providerId']);
      }
    }

    final workers = <Map<String, dynamic>>[];

    for (final providerId in providerIds) {
      final providerData = providers[providerId];
      if (providerData == null) continue;

      final worker = Map<String, dynamic>.from(providerData);
      worker['uid'] = worker['uid'] ?? providerId;
      worker['servicesCount'] = services
          .where((service) => service['providerId'] == providerId)
          .length;
      worker['bookingsCount'] = bookings
          .where((booking) => booking['providerId'] == providerId)
          .length;

      final matches = containsQuery([
        worker['name'],
        worker['specialization'],
        'فني',
        'فنيين',
        'عامل',
        'عمال',
        'مقدم خدمة',
        'خدمات ${worker['name']}',
        'حجوزات ${worker['name']}',
      ]);

      if (matches) {
        workers.add(worker);
      }
    }

    workers.sort(
      (a, b) => getWorkerSearchScore(b).compareTo(getWorkerSearchScore(a)),
    );

    return workers;
  }

  Widget buildSearchHeader(AppCubit appCubit) {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(30.r),
      ),
      child: Container(
        height: 175.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              mainColor,
              Color(0xFF0F0F1E),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -45.h,
              left: -40.w,
              child: CircleAvatar(
                radius: 95.r,
                backgroundColor: Colors.white.withOpacity(0.12),
              ),
            ),
            Positioned(
              bottom: -90.h,
              right: -60.w,
              child: Container(
                width: 230.r,
                height: 230.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00F2FF).withOpacity(0.35),
                      const Color(0xFF00F2FF).withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 35.h,
                start: 15.w,
                end: 15.w,
                bottom: 18.h,
              ),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'البحث',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'ابحث عن خدمة أو قسم أو حجز أو فني',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12.sp,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  buildSearchField(appCubit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchField(AppCubit appCubit) {
    return Container(
      height: 52.h,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: appCubit.isDark ? darkBgColor : Colors.white,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            controller: searchController,
            cursorColor: mainColor,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: addRecentSearch,
            onChanged: onSearchChanged,
            style: TextStyle(
              color: appCubit.isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsetsDirectional.only(
                start: searchController.text.isEmpty ? 55.w : 90.w,
                end: 18.w,
                top: 15.h,
                bottom: 15.h,
              ),
            ),
          ),
          PositionedDirectional(
            start: 18.w,
            child: SvgPicture.asset(
              'assets/search.svg',
              color: Colors.grey,
              width: 22.w,
            ),
          ),
          if (searchController.text.isNotEmpty)
            PositionedDirectional(
              start: 50.w,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  searchController.clear();
                  searchDebounce?.cancel();
                  setState(() {
                    selectedSearchFilter = 'الكل';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.grey,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          if (searchController.text.isEmpty)
            PositionedDirectional(
              start: 55.w,
              end: 18.w,
              child: IgnorePointer(
                child: SizedBox(
                  height: 20.h,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    pause: const Duration(seconds: 2),
                    animatedTexts: [
                      TyperAnimatedText(
                        'ابحث عن خدمات',
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                      TyperAnimatedText(
                        'ابحث عن أقسام',
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                      TyperAnimatedText(
                        'ابحث عن حجوزات قيد الانتظار',
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                      TyperAnimatedText(
                        'ابحث عن حجوزات مقبولة',
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                      TyperAnimatedText(
                        'ابحث باسم الفني',
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDefaultSearchContent({
    required AppCubit appCubit,
    required List<Map<String, dynamic>> suggestedServices,
    required Map<dynamic, dynamic> allUsers,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          title: 'سجل البحث',
          icon: 'assets/update.svg',
          cubit: appCubit,
          trailing: defaultTextButton(
            onPressed: () {
              setState(() {
                recentSearches.clear();
                saveRecentSearches();
              });
            },
            text: 'مسح الكل',
            isBold: true,
            isLined: false,
          ),
        ),
        SizedBox(height: 12.h),
        buildRecentSearches(appCubit),
        SizedBox(height: 25.h),
        buildSectionTitle(
          title: 'اقتراحات شائعة',
          icon: 'assets/search.svg',
          cubit: appCubit,
        ),
        SizedBox(height: 12.h),
        buildSmartSuggestions(appCubit),
        SizedBox(height: 25.h),
        buildSectionTitle(
          title: 'الأقسام الشائعة',
          icon: 'assets/grid.svg',
          cubit: appCubit,
        ),
        SizedBox(height: 12.h),
        buildPopularDepartments(appCubit),
        SizedBox(height: 25.h),
        buildSectionTitle(
          title: 'خدمات مقترحة لك',
          icon: 'assets/services.svg',
          cubit: appCubit,
        ),
        SizedBox(height: 10.h),
        suggestedServices.isEmpty
            ? buildEmptyState(
                appCubit: appCubit,
                icon: Icons.home_repair_service_outlined,
                title: 'لا توجد خدمات مقترحة حاليًا',
              )
            : SizedBox(
                height: 350.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsetsDirectional.only(
                    start: 5.w,
                    bottom: 10.h,
                  ),
                  itemCount: suggestedServices.length > 4
                      ? 4
                      : suggestedServices.length,
                  itemBuilder: (context, index) {
                    final service = suggestedServices[index];
                    final providerData = Map<String, dynamic>.from(
                      allUsers[service['providerId']] ?? {},
                    );

                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: index == 0 ? 0 : 15.w,
                        end: index == suggestedServices.length - 1 ? 5.w : 0,
                      ),
                      child: buildSuggestedServiceCard(
                        appCubit: appCubit,
                        service: service,
                        providerData: providerData,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget buildSearchResults({
    required AppCubit appCubit,
    required List<Map<String, dynamic>> departments,
    required List<Map<String, dynamic>> services,
    required List<Map<String, dynamic>> bookings,
    required List<Map<String, dynamic>> workers,
    required Map<dynamic, dynamic> allUsers,
    required bool isBookingLoading,
  }) {
    final totalCount =
        departments.length + services.length + bookings.length + workers.length;

    final showAll = selectedSearchFilter == 'الكل';
    final showDepartments = showAll || selectedSearchFilter == 'الأقسام';
    final showServices = showAll || selectedSearchFilter == 'الخدمات';
    final showBookings = showAll || selectedSearchFilter == 'الحجوزات';
    final showWorkers = showAll || selectedSearchFilter == 'الفنيون';

    final visibleCount = (showDepartments ? departments.length : 0) +
        (showServices ? services.length : 0) +
        (showBookings ? bookings.length : 0) +
        (showWorkers ? workers.length : 0);

    final isEmpty = totalCount == 0;
    final isSelectedFilterEmpty = totalCount > 0 && visibleCount == 0;

    if (isEmpty) {
      return buildEmptyState(
        appCubit: appCubit,
        icon: Icons.search_off_rounded,
        title: 'لا توجد نتائج مطابقة',
        subTitle: 'جرّب البحث باسم الخدمة أو القسم أو حالة الحجز أو اسم الفني',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          title: 'نتائج البحث ($totalCount)',
          icon: 'assets/search.svg',
          cubit: appCubit,
        ),
        SizedBox(height: 12.h),
        buildSearchTabs(
          appCubit: appCubit,
          allCount: totalCount,
          departmentsCount: departments.length,
          servicesCount: services.length,
          bookingsCount: bookings.length,
          workersCount: workers.length,
        ),
        SizedBox(height: 15.h),
        if (isSelectedFilterEmpty)
          buildEmptyState(
            appCubit: appCubit,
            icon: Icons.filter_alt_off_rounded,
            title: 'لا توجد نتائج في هذا التصنيف',
            subTitle: 'اختر تصنيفًا آخر أو غيّر كلمة البحث',
          ),
        if (showDepartments && departments.isNotEmpty) ...[
          buildMiniSectionTitle(
            appCubit: appCubit,
            title: 'الأقسام (${departments.length})',
            icon: 'assets/grid.svg',
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: departments.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return buildResultDepartmentCard(
                appCubit: appCubit,
                dept: departments[index],
              );
            },
          ),
          SizedBox(height: 22.h),
        ],
        if (showWorkers && workers.isNotEmpty) ...[
          buildMiniSectionTitle(
            appCubit: appCubit,
            title: 'الفنيون (${workers.length})',
            icon: 'assets/providers.svg',
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workers.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return buildResultWorkerCard(
                appCubit: appCubit,
                worker: workers[index],
              );
            },
          ),
          SizedBox(height: 22.h),
        ],
        if (showServices && services.isNotEmpty) ...[
          buildMiniSectionTitle(
            appCubit: appCubit,
            title: 'الخدمات (${services.length})',
            icon: 'assets/services.svg',
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            itemBuilder: (context, index) {
              final service = services[index];
              final providerData = Map<String, dynamic>.from(
                allUsers[service['providerId']] ?? {},
              );

              return buildResultServiceCard(
                appCubit: appCubit,
                service: service,
                providerData: providerData,
              );
            },
          ),
          SizedBox(height: 22.h),
        ],
        if (showBookings && isBookingLoading) ...[
          buildBookingsLoadingCard(appCubit),
          SizedBox(height: 15.h),
        ],
        if (showBookings && bookings.isNotEmpty) ...[
          buildMiniSectionTitle(
            appCubit: appCubit,
            title: 'الحجوزات (${bookings.length})',
            icon: 'assets/bookings.svg',
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.only(bottom: 10.h),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final providerData = Map<String, dynamic>.from(
                allUsers[booking['providerId']] ?? {},
              );

              return buildResultBookingCard(
                appCubit: appCubit,
                booking: booking,
                providerData: providerData,
              );
            },
          ),
        ],
      ],
    );
  }

  Widget buildSearchTabs({
    required AppCubit appCubit,
    required int allCount,
    required int departmentsCount,
    required int servicesCount,
    required int bookingsCount,
    required int workersCount,
  }) {
    final tabs = [
      {'title': 'الكل', 'count': allCount},
      {'title': 'الأقسام', 'count': departmentsCount},
      {'title': 'الفنيون', 'count': workersCount},
      {'title': 'الخدمات', 'count': servicesCount},
      {'title': 'الحجوزات', 'count': bookingsCount},
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final title = '${tabs[index]['title']}';
          final count = tabs[index]['count'] as int;
          final isSelected = selectedSearchFilter == title;

          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            onTap: () {
              setState(() {
                selectedSearchFilter = title;
              });
            },
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 14.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? mainColor
                    : appCubit.isDark
                        ? lightDarkColor
                        : Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: isSelected ? mainColor : mainColor.withOpacity(0.08),
                ),
                boxShadow: blueShadow,
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : appCubit.isDark
                              ? Colors.white
                              : Colors.black87,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.18)
                          : mainColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: isSelected ? Colors.white : mainColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSmartSuggestions(AppCubit appCubit) {
    final suggestions = [
      'كهرباء',
      'سباكة',
      'تكييف',
      'حجوزات قيد الانتظار',
      'حجوزات مقبولة',
      'فني تكييف',
      'عامل سباكة',
    ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: suggestions.map((suggestion) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
          onTap: () {
            searchController.text = suggestion;
            searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: searchController.text.length),
            );
            addRecentSearch(suggestion);
            setState(() {
              selectedSearchFilter = 'الكل';
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: appCubit.isDark ? lightDarkColor : Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: mainColor.withOpacity(0.08)),
              boxShadow: blueShadow,
            ),
            child: Text(
              suggestion,
              style: TextStyle(
                color: appCubit.isDark ? Colors.white : Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildBookingsLoadingCard(AppCubit appCubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22.w,
            height: 22.h,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12.w),
          Text(
            'جاري تحميل الحجوزات...',
            style: TextStyle(
              color: appCubit.isDark ? Colors.white : Colors.black87,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHighlightedText({
    required String text,
    required TextStyle style,
    int maxLines = 1,
  }) {
    final textStyle = style.copyWith(fontFamily: 'Tajawal');
    final query = searchController.text.trim();

    if (query.isEmpty || text.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      );
    }

    final searchableWords = query
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().length > 1)
        .toList();

    String matchedWord = '';

    for (final word in searchableWords) {
      if (text.toLowerCase().contains(word.toLowerCase())) {
        matchedWord = word;
        break;
      }
    }

    if (matchedWord.isEmpty &&
        text.toLowerCase().contains(query.toLowerCase())) {
      matchedWord = query;
    }

    if (matchedWord.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerMatch = matchedWord.toLowerCase();
    final startIndex = lowerText.indexOf(lowerMatch);

    if (startIndex < 0) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      );
    }

    final endIndex = startIndex + matchedWord.length;

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: textStyle,
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: textStyle.copyWith(
              color: mainColor,
              fontWeight: FontWeight.w900,
              fontFamily: 'Tajawal',
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: textStyle,
          ),
        ],
      ),
    );
  }

  Widget buildResultWorkerCard({
    required AppCubit appCubit,
    required Map<String, dynamic> worker,
  }) {
    final workerImage = '${worker['image'] ?? worker['profileImage'] ?? ''}';
    final workerName = '${worker['name'] ?? 'فني غير معروف'}';
    final workerSpec = '${worker['specialization'] ?? ''}';

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25.r),
      onTap: () {
        searchController.text = workerName;
        searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchController.text.length),
        );
        addRecentSearch(workerName);
        setState(() {
          selectedSearchFilter = 'الخدمات';
        });
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(12.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: mainColor.withOpacity(0.08),
              foregroundImage: workerImage.trim().isNotEmpty
                  ? NetworkImage(workerImage)
                  : null,
              child: workerImage.trim().isEmpty
                  ? Icon(
                      Icons.engineering_rounded,
                      color: mainColor,
                      size: 27.sp,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHighlightedText(
                    text: workerName,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: appCubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  buildHighlightedText(
                    text: workerSpec,
                    maxLines: 1,
                    style: TextStyle(
                      color: appCubit.isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/work.svg',
                        color: mainColor,
                        width: 15.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${worker['servicesCount'] ?? 0} خدمات',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      SvgPicture.asset(
                        'assets/bookings.svg',
                        color: mainColor,
                        width: 15.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${worker['bookingsCount'] ?? 0} حجوزات',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: mainColor.withOpacity(0.30),
              size: 13.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle({
    required String title,
    required String icon,
    required dynamic cubit,
    Widget? trailing,
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
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: cubit.isDark ? Colors.white : Colors.black,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          trailing,
        ],
      ],
    );
  }

  Widget buildMiniSectionTitle({
    required AppCubit appCubit,
    required String title,
    required String icon,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          color: mainColor,
          width: 25.w,
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            color: appCubit.isDark ? Colors.white : Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildRecentSearches(AppCubit appCubit) {
    if (recentSearches.isEmpty) {
      return buildEmptyState(
        appCubit: appCubit,
        icon: Icons.history_toggle_off_rounded,
        title: 'لا توجد عمليات بحث أخيرة',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 8.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentSearches.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.withOpacity(0.12),
          height: 1.h,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              searchController.text = recentSearches[index];
              searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length),
              );
              addRecentSearch(searchController.text);
              setState(() {
                selectedSearchFilter = 'الكل';
              });
            },
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/update.svg',
                    color: mainColor,
                    width: 20.w,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      recentSearches[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: appCubit.isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        recentSearches.removeAt(index);
                        saveRecentSearches();
                      });
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPopularDepartments(AppCubit appCubit) {
    final userServicesCubit = UserCubit.get(context);

    final categories = List<Map<String, dynamic>>.from(
      userServicesCubit.categories,
    );

    if (categories.isEmpty) {
      return buildEmptyState(
        appCubit: appCubit,
        icon: Icons.category_outlined,
        title: 'لا توجد أقسام حالياً',
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsetsDirectional.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2,
      ),
      itemCount: categories.length > 4 ? 4 : categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        final categoryTitle = '${category['title'] ?? category['name'] ?? ''}';

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
          onTap: () {
            addRecentSearch(categoryTitle);

            move(
              context,
              UserServicesList(
                categoryType: categoryTitle,
              ),
            );
          },
          child: buildDepartmentContent(
            appCubit: appCubit,
            dept: category,
          ),
        );
      },
    );
  }

  Widget buildDepartmentContent({
    required AppCubit appCubit,
    required Map<String, dynamic> dept,
  }) {
    final String categoryTitle = '${dept['title'] ?? dept['name'] ?? ''}';
    final String categoryImage = '${dept['image'] ?? dept['icon'] ?? ''}';

    return Container(
      padding: EdgeInsetsDirectional.all(10.r),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: buildCategoryImage(
              image: categoryImage,
              isDark: appCubit.isDark,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: buildHighlightedText(
              text: categoryTitle,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: appCubit.isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: mainColor.withOpacity(0.30),
            size: 12.sp,
          ),
        ],
      ),
    );
  }

  Widget buildResultDepartmentCard({
    required AppCubit appCubit,
    required Map<String, dynamic> dept,
  }) {
    final String categoryTitle = '${dept['title'] ?? dept['name'] ?? ''}';

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25.r),
      onTap: () {
        addRecentSearch(
          searchController.text.trim().isNotEmpty
              ? searchController.text
              : categoryTitle,
        );

        move(
          context,
          UserServicesList(
            categoryType: categoryTitle,
          ),
        );
      },
      child: buildDepartmentContent(
        appCubit: appCubit,
        dept: dept,
      ),
    );
  }

  Widget buildSuggestedServiceCard({
    required AppCubit appCubit,
    required Map<String, dynamic> service,
    required Map<String, dynamic> providerData,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25.r),
      onTap: () => openServiceDetails(service, providerData),
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: Image.network(
                    '${service['serviceImage'] ?? ''}',
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180.h,
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey.shade400,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 12.h,
                  end: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8)
                      ],
                    ),
                    child: Text(
                      '${service['price'] ?? ''} $reyalSymbol',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 12.h,
                  start: 12.w,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '${service['category'] ?? ''}',
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${service['name'] ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: appCubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 18.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        '${service['rate'] ?? ''}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: mainColor.withOpacity(0.2),
                        size: 14.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: mainColor.withOpacity(0.10),
                          backgroundImage:
                              '${providerData['profileImage'] ?? providerData['image'] ?? ''}'
                                      .trim()
                                      .isNotEmpty
                                  ? NetworkImage(
                                      '${providerData['profileImage'] ?? providerData['image'] ?? ''}',
                                    )
                                  : null,
                          child:
                              '${providerData['profileImage'] ?? providerData['image'] ?? ''}'
                                      .trim()
                                      .isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      color: mainColor,
                                      size: 17.sp,
                                    )
                                  : null,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${providerData['name'] ?? 'فني غير معروف'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  providerData['isVerified'] ?? false
                                      ? SvgPicture.asset(
                                          'assets/verf_bold.svg',
                                          color: Colors.blue,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              Text(
                                '${providerData['specialization'] ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.grey,
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
    );
  }

  Widget buildResultServiceCard({
    required AppCubit appCubit,
    required Map<String, dynamic> service,
    required Map<String, dynamic> providerData,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25.r),
      onTap: () {
        addRecentSearch(searchController.text);
        openServiceDetails(service, providerData);
      },
      child: Container(
        padding: EdgeInsetsDirectional.all(12.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: Image.network(
                '${service['serviceImage'] ?? ''}',
                width: 92.w,
                height: 92.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 92.w,
                  height: 92.h,
                  color: Colors.grey.shade100,
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey.shade400,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildHighlightedText(
                          text: '${service['name'] ?? ''}',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color:
                                appCubit.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          '${service['category'] ?? ''}',
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  buildHighlightedText(
                    text: '${service['description'] ?? ''}',
                    maxLines: 2,
                    style: TextStyle(
                      height: 1.3,
                      fontSize: 11.sp,
                      color: appCubit.isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/star.svg',
                        color: mainColor,
                        width: 15.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${service['rate'] ?? '0'}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11.sp,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${service['price'] ?? ''} $reyalSymbol',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/acc.svg',
                        color: mainColor,
                        width: 15.w,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${providerData['name'] ?? 'فني غير معروف'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appCubit.isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
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
    );
  }

  Widget buildResultBookingCard({
    required AppCubit appCubit,
    required Map<String, dynamic> booking,
    required Map<String, dynamic> providerData,
  }) {
    final status = '${booking['status'] ?? 'قيد الانتظار'}';
    final statusColor = getStatusColor(status);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25.r),
      onTap: () => openBookingDetails(booking, providerData),
      child: Container(
        padding: EdgeInsetsDirectional.all(12.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 92.w,
              height: 92.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: mainColor.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23.r),
                child: Image.network(
                  '${booking['image'] ?? ''}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade100,
                    child: Icon(
                      Icons.assignment_rounded,
                      color: Colors.grey.shade400,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildHighlightedText(
                          text: '${booking['title'] ?? ''}',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color:
                                appCubit.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: statusColor.withOpacity(0.20),
                          ),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  buildHighlightedText(
                    text: '${booking['description'] ?? ''}',
                    maxLines: 2,
                    style: TextStyle(
                      height: 1.3,
                      fontSize: 11.sp,
                      color: appCubit.isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/acc.svg',
                        color: mainColor,
                        width: 16.w,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          '${providerData['name'] ?? 'فني غير معروف'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appCubit.isDark
                                ? Colors.grey.shade300
                                : Colors.black87,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${booking['price'] ?? ''} $reyalSymbol',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/loc.svg',
                        color: Colors.grey,
                        width: 15.w,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${booking['address'] ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                          ),
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
    );
  }

  Widget buildServiceImage({
    required Map<String, dynamic> service,
    required double height,
    required double borderRadius,
    bool showPrice = false,
  }) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(
              '${service['serviceImage'] ?? ''}',
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: height,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.grey.shade400,
                  size: 32.sp,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 12.h,
            start: 12.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${service['category'] ?? ''}',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showPrice)
            PositionedDirectional(
              bottom: 12.h,
              end: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8)
                  ],
                ),
                child: Text(
                  '${service['price'] ?? ''} $reyalSymbol',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildEmptyState({
    required AppCubit appCubit,
    required IconData icon,
    required String title,
    String? subTitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
                appCubit.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
            size: 55.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color:
                  appCubit.isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          if (subTitle != null) ...[
            SizedBox(height: 5.h),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return Colors.green;
      case 'مقبول':
      case 'في الطريق':
        return Colors.blueAccent;
      case 'مرفوض':
      case 'ملغي':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  void openServiceDetails(
    Map<String, dynamic> service,
    Map<String, dynamic> providerData,
  ) {
    move(
      context,
      UserServiceDetails(
        name: '${service['name'] ?? ''}',
        image: '${service['serviceImage'] ?? ''}',
        category: '${service['category'] ?? ''}',
        desc: '${service['description'] ?? ''}',
        price: service['price'] ?? 0,
        period: '${service['period'] ?? ''}',
        providerName: '${providerData['name'] ?? 'فني غير معروف'}',
        providerSpec:
            '${providerData['specialization'] ?? service['category'] ?? ''}',
        reviews: service['reviews'] ?? [],
        providerId: '${providerData['uid'] ?? service['providerId'] ?? ''}',
        serviceId: service['id'],
      ),
    );
  }

  void openBookingDetails(
    Map<String, dynamic> booking,
    Map<String, dynamic> providerData,
  ) {
    addRecentSearch(searchController.text);

    move(
      context,
      UserRequestDetails(
        request: booking,
        providerData: providerData,
      ),
    );
  }

  Widget buildCategoryImage({
    required String image,
    required bool isDark,
  }) {
    if (image.trim().isEmpty) {
      return Icon(
        Icons.category_rounded,
        color: mainColor,
        size: 25.sp,
      );
    }

    final bool isSvg = image.toLowerCase().contains('.svg');

    if (isSvg) {
      return SvgPicture.network(
        image,
        fit: BoxFit.contain,
        placeholderBuilder: (context) {
          return _categoryImageShimmer(isDark);
        },
      );
    }

    return Image.network(
      image,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _categoryImageShimmer(isDark);
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.category_rounded,
          color: mainColor,
          size: 25.sp,
        );
      },
    );
  }

  Widget _categoryImageShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE3F2FD),
      highlightColor:
          isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8FCFF),
      child: Container(
        width: 26.w,
        height: 26.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
