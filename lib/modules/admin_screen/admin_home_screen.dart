import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/admin_screen/admin_bookings_management.dart';
import 'package:trying_homy/modules/notifications_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../main.dart';
import 'admin_dept_mangament.dart';
import 'admin_providers_management.dart';
import 'admin_users_managament.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final List<Map<String, dynamic>> adminCards = [
    {
      'icon': 'assets/acc.svg',
      'title': 'المستخدمون',
      'color': mainColor,
    },
    {
      'icon': 'assets/services.svg',
      'title': 'الخدمات',
      'color': Colors.teal,
    },
    {
      'icon': 'assets/bookings.svg',
      'title': 'الطلبات',
      'color': Colors.orange,
    },
    {
      'icon': 'assets/providers.svg',
      'title': 'الفنيّون',
      'color': Colors.red,
    },
  ];
  final List<Map<String, dynamic>> bookings = [
    {
      'title': 'تركيب فيش كهرباء',
      'status': 'قيد الانتظار',
      'price': '23000',
      'image':
          'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'address': 'عدن، المنصورة، شارع التسعين',
      'scheduledAt': '03:18 - 15/04/2026 ص',
      'providerName': 'هشام هاني',
      'clientName': 'هادي محمد',
    },
    {
      'title': 'إصلاح تسريب مياه',
      'status': 'مقبول',
      'price': '15000',
      'image':
          'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg',
      'address': 'صنعاء، شارع الزبيري',
      'scheduledAt': '04:30 - 18/04/2026 م',
      'providerName': 'محمد عبدالله',
      'clientName': 'عبد المجيد نايف',
    },
    {
      'title': 'تنظيف تكييف مركزي',
      'status': 'مكتمل',
      'price': '25000',
      'image':
          'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'address': 'تعز، الحوبان',
      'scheduledAt': '10:00 - 20/04/2026 ص',
      'providerName': 'عبدالله خالد',
      'clientName': 'محمد عبد الرحمن',
    },
  ];

  Widget buildDetailRow(String label, String value, String iconPath,dynamic cubit) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
              color: cubit.isDark? mainColor.withOpacity(0.2): mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r)
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 22.w,
            height: 22.h,
            color: mainColor,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: TextStyle(
              color: cubit.isDark? darkSubTextColor: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: cubit.isDark? darkSubTextColor: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    AppCubit.get(context).getAdminData();
    AppCubit.get(context).getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              return appCubit.isGetAdminDataLoading || appCubit.isGetCategoriesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header(title: 'مرحبا، هشام', context: context),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: adminCards.length,
                      padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 20.h, bottom: 15.h,),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final card = adminCards[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: appCubit.isDark ? lightDarkColor : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            border: appCubit.isDark ? Border.all(color: const Color(0xFF30363D)) : null,
                            boxShadow: appCubit.isDark ? [] : blueShadow,
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
                                      color: card['color'].withOpacity(0.03),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      card['icon'],
                                      color: card['color'].withOpacity(appCubit.isDark ? 0.05 : 0.1),
                                      width: 70.w,
                                      height: 70.h,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.r),
                                          decoration: BoxDecoration(
                                            color: card['color'].withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                          child: SvgPicture.asset(
                                            card['icon'],
                                            color: card['color'],
                                            width: 22.w,
                                          ),
                                        ),
                                        Text(
                                          index==0?'${appCubit.users.length}'
                                              :index==1?'${appCubit.services.length}'
                                              :index==2?'${appCubit.services.length}'
                                              :index==3?'${appCubit.providers.length}':'',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: appCubit.isDark ? Colors.white : card['color'],
                                            fontSize: 22.sp,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card['title'],
                                          style: TextStyle(
                                            color: appCubit.isDark
                                                ? Colors.white.withOpacity(0.9)
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
                                            color: card['color'].withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(10.r),
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
                      padding: EdgeInsetsDirectional.only(start: 15.w),
                      child: Row(
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsetsDirectional.all(8.w),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: SvgPicture.asset(
                              'assets/grid.svg',
                              color: mainColor,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'الأقسام',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          const Spacer(),
                          defaultTextButton(
                              onPressed: () =>
                                  move(context, const AdminDeptMangament()),
                              text: 'عرض الكل',
                              isLined: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 2.1,
                      ),
                      itemCount: appCubit.categories.length > 4 ? 4 : appCubit.categories.length,
                      itemBuilder: (context, index) {
                        final caterory = appCubit.categories[index];
                        return Container(
                          padding: EdgeInsetsDirectional.all(10.w),
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
                                  padding: EdgeInsetsDirectional.all(12.w),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                  child: Image.file(File(caterory['image']),fit: BoxFit.cover,)
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  caterory['title']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: appCubit.isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: mainColor.withOpacity(0.3),
                                size: 12.sp,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 15.w),
                      child: Row(
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsetsDirectional.all(8.w),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: SvgPicture.asset(
                              'assets/providers.svg',
                              color: mainColor,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'الفنييون',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          const Spacer(),
                          defaultTextButton(
                              onPressed: () =>
                                  move(context, const AdminProviderMangament()),
                              text: 'عرض الكل',
                              isLined: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    SizedBox(
                      height: 270.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appCubit.providers.length > 4? 4 : appCubit.providers.length,
                        padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, bottom: 15.h),
                        separatorBuilder: (context, index) => SizedBox(width: 15.w),
                        itemBuilder: (context, index) {
                          final provider = appCubit.providers[index];
                          return InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 190.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                          provider['profileImage'],
                                          height: 130.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 130.h,
                                            width: double.infinity,
                                            color: Colors.grey.shade200,
                                            child: Icon(Icons.person, color: Colors.grey, size: 35.r),
                                          ),
                                        ),
                                      ),
                                      PositionedDirectional(
                                        top: 10.h,
                                        start: 10.w,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.r),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.star_rounded, color: mainColor, size: 14.sp),
                                                  SizedBox(width: 2.w),
                                                  Padding(
                                                    padding:  EdgeInsetsDirectional.only(top: 5.h),
                                                    child: Text(
                                                      '${provider['avgRating']}',
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10.sp,
                                                        height: 1
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.all(10.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: appCubit.isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          provider['specialization'],
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'عرض الملف الشخصي',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: mainColor,
                                                size: 10.sp,
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
                        },
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 15.w),
                      child: Row(
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsetsDirectional.all(10.w),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: SvgPicture.asset(
                              'assets/services.svg',
                              color: mainColor,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'الخدمات الحديثة',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          const Spacer(),
                          defaultTextButton(
                              onPressed: () {},
                              text: 'عرض الكل',
                              isLined: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    SizedBox(
                      height: 310.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appCubit.services.length > 4 ? 4 : appCubit.services.length,
                        padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w,bottom: 10.h),
                        itemBuilder: (context, index) {
                          final service = appCubit.services[index];
                          final providerData = appCubit.providers.firstWhere((element) => element['id']==service['providerId'],);
                          return InkWell(
                            onTap: (){},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 300.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                          service['serviceImage'],
                                          height: 150.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 150.h,
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      PositionedDirectional(
                                        bottom: 12.h,
                                        end: 12.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(15.r),
                                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                                          ),
                                          child: Text(
                                            '${service['price']} $reyalSymbol',
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
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: Text(
                                                service['category'],
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
                                          service['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: appCubit.isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                                            SizedBox(width: 5.w),
                                            Padding(
                                              padding: EdgeInsetsDirectional.only(top: 5.h),
                                              child: Text(
                                                '${service['rate']}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
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
                                        SizedBox(height: 10.h),
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
                                                backgroundImage:  NetworkImage(
                                                    providerData['profileImage']
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      providerData['name'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                                      ),
                                                    ),
                                                    Text(
                                                      providerData['specialization'],
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
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          width: 15.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 15.w),
                      child: Row(
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsetsDirectional.all(10.w),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: SvgPicture.asset(
                              'assets/bookings.svg',
                              color: mainColor,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'الحجوزات الحديثة',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          const Spacer(),
                          defaultTextButton(
                              onPressed: () => move(
                                  context, const AdminBookingsManagement()),
                              text: 'عرض الكل',
                              isLined: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 380.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                        EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                        itemCount: appCubit.requests.length > 4 ? 4 : appCubit.requests.length ,
                        itemBuilder: (context, index) {
                          var request = appCubit.requests[index];
                          final providerData = appCubit.providers.firstWhere((element) => element['id']==request['providerId'],);
                          final userData = appCubit.providers.firstWhere((element) => element['id']==request['providerId'],);
                          Color statusColor;
                          String status = request['status'];

                          switch (status) {
                            case 'مكتمل':statusColor = Colors.green;
                            break;
                            case 'مقبول': case 'في الطريق':statusColor = Colors.blueAccent;
                            break;
                            case 'مرفوض':case 'ملغي':statusColor = Colors.redAccent;
                            break;
                            default:statusColor = Colors.orangeAccent;
                          }

                          return Padding(
                            padding: EdgeInsetsDirectional.only(bottom: 20.h),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: (){print(request);},
                              child: Container(
                                width: 330.w,
                                padding: EdgeInsetsDirectional.all(15.r),
                                decoration: BoxDecoration(
                                  color: appCubit.isDark ? lightDarkColor : Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.r),
                                            border: Border.all(
                                              color: mainColor.withOpacity(0.1),
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18.r),
                                            child: Image.network(
                                              request['image'] ?? '',
                                              width: 70.w,
                                              height: 70.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: 70.w,
                                                height: 70.h,
                                                color: Colors.grey.shade200,
                                                child: Icon(Icons.image_not_supported, color: Colors.grey, size: 20.sp),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      request['title'],
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: appCubit.isDark ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                                    decoration: BoxDecoration(
                                                      color: statusColor.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(30.r),
                                                      border: Border.all(color: statusColor.withOpacity(0.2)),
                                                    ),
                                                    child: Text(
                                                      status,
                                                      style: TextStyle(
                                                        color: statusColor,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                '${request['price']} $reyalSymbol',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.h),
                                    Container(
                                      padding: EdgeInsets.all(12.r),
                                      decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.04),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Column(
                                        children: [
                                          buildDetailRow('العنوان:', request['address'], 'assets/loc.svg', appCubit),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.h),
                                            child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                          ),
                                          buildDetailRow('الموعد:', appCubit.formatStatusTime(request['scheduledAt']), 'assets/timer.svg', appCubit),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.h),
                                            child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                          ),
                                          buildDetailRow('الفني:', providerData['name'], 'assets/providers.svg', appCubit),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.h),
                                            child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
                                          ),
                                          buildDetailRow('المستخدم:', userData['name'], 'assets/acc.svg', appCubit),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 15.w),
                      child: Row(
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            padding: EdgeInsetsDirectional.all(8.w),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: SvgPicture.asset(
                              'assets/acc.svg',
                              color: mainColor,
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Text(
                            'المستخدمون',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                          const Spacer(),
                          defaultTextButton(
                              onPressed: () =>
                                  move(context, const AdminUsersManagament()),
                              text: 'عرض الكل',
                              isLined: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    SizedBox(
                      height: 250.h,
                      child: ListView.separated(
                        padding: EdgeInsetsDirectional.only(start: 15.w,bottom: 10.h),
                        scrollDirection: Axis.horizontal,
                        itemCount: appCubit.users.length > 4 ? 4 : appCubit.users.length,
                        itemBuilder: (context, index) {
                          final user = appCubit.users[index];
                          return InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 190.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: blueShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25.r),
                                    child: Image.network(
                                      user['profileImage'],
                                      height: 140.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 140.h,
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                        child: Icon(Icons.person, color: Colors.grey, size: 35.r),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.all(10.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: appCubit.isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'عرض الملف الشخصي',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: mainColor,
                                                size: 10.sp,
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
                        },
                        separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                      ),
                    ),
                    SizedBox(height: 20.h,),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
