import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = [
    'تركيب مكيفات سبليت',
    'صيانة تسربات الحمام',
    'دهانات جوتن داخلية',
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'كهرباء',
      'icon': Icons.bolt,
      'iconColor': Colors.blue,
      'bgColor': const Color(0xffEEF4FB),
    },
    {
      'title': 'سباكة',
      'icon': Icons.plumbing,
      'iconColor': Colors.orange,
      'bgColor': const Color(0xffFBF3EE),
    },
    {
      'title': 'دهانات',
      'icon': Icons.format_paint,
      'iconColor': Colors.purple,
      'bgColor': const Color(0xffF5EEFB),
    },
    {
      'title': 'تكييف',
      'icon': Icons.ac_unit,
      'iconColor': Colors.green,
      'bgColor': const Color(0xffEEF8F5),
    },
  ];

  final List<Map<String, dynamic>> services = [
    {
      'title': 'فحص شامل للكهرباء',
      'price': 'يبدأ من 150 ريال',
      'rating': '4.9',
      'reviews': '120',
      'image': 'assets/elec.jpg',
    },
    {
      'title': 'كشف تسربات المياه',
      'price': 'يبدأ من 200 ريال',
      'rating': '4.7',
      'reviews': '85',
      'image': 'assets/plm.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          title: Text(
            "البحث عن خدمات",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن كهربائي، سباك، أو نجار...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.sp,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 16.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: SvgPicture.asset(
                        'assets/search.svg',
                        width: 20.w,
                        height: 20.h,
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.mic_none,
                      color: Colors.grey,
                      size: 22.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                height: 45.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip(
                      text: 'تصفية',
                      icon: Icons.tune,
                      isPrimary: true,
                    ),
                    SizedBox(width: 10.w),
                    _buildFilterChip(text: 'قريب مني'),
                    SizedBox(width: 10.w),
                    _buildFilterChip(text: 'الأعلى تقييماً'),
                    SizedBox(width: 10.w),
                    _buildFilterChip(text: 'سعر مناسب'),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عمليات البحث الأخيرة',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                recentSearches.clear();
                              });
                            },
                            child: Text(
                              'مسح الكل',
                              style: TextStyle(
                                color: mainColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      if (recentSearches.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentSearches.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade300,
                            height: 1.h,
                          ),
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: IconButton(
                                onPressed: () {
                                  setState(() {
                                    recentSearches.removeAt(index);
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.blueGrey.shade200,
                                  size: 22.w,
                                ),
                              ),
                              title: Text(
                                recentSearches[index],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                Icons.history,
                                color: Colors.blueGrey.shade200,
                                size: 22.w,
                              ),
                            );
                          },
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            'لا توجد عمليات بحث أخيرة',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      SizedBox(height: 22.h),
                      Text(
                        'الفئات الشائعة',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1.35,
                        ),
                        itemBuilder: (context, index) {
                          final item = categories[index];
                          return _buildCategoryCard(
                            title: item['title'],
                            icon: item['icon'],
                            iconColor: item['iconColor'],
                            bgColor: item['bgColor'],
                          );
                        },
                      ),
                      SizedBox(height: 22.h),
                      Text(
                        'خدمات مقترحة لك',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = services[index];
                            return _buildServiceCard(
                              title: item['title'],
                              price: item['price'],
                              rating: item['rating'],
                              reviews: item['reviews'],
                              image: item['image'],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String text,
    IconData? icon,
    bool isPrimary = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isPrimary ? mainColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isPrimary ? mainColor : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18.w,
              color: isPrimary ? Colors.white : Colors.black87,
            ),
            SizedBox(width: 6.w),
          ],
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black87,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String price,
    required String rating,
    required String reviews,
    required String image,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey.shade400,
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '($reviews تقييم)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      rating,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              image,
              width: 74.w,
              height: 74.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 74.w,
                  height: 74.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
