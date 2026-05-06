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
  final List<Map<String, String>> services = [
    {"name": "الكهرباء", "icon": "assets/SVGs/E.svg", "type": "كهرباء"},
    {"name": "السباكة", "icon": "assets/SVGs/P.svg", "type": "سباكة"},
    {"name": "البناء", "icon": "assets/SVGs/C.svg", "type": "بناء"},
    {"name": "التكييف", "icon": "assets/SVGs/AC.svg", "type": "تكييف"},
    {"name": "الحدادة", "icon": "assets/SVGs/A.svg", "type": "حدادة"},
    {"name": "الماء", "icon": "assets/SVGs/WT.svg", "type": "ماء"},
    {"name": "النجارة", "icon": "assets/SVGs/CA.svg", "type": "نجارة"},
    {"name": "الدهان", "icon": "assets/SVGs/PA.svg", "type": "دهان"},
  ];

  @override
  void initState() {
    AppCubit.get(context).getAdminData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              AppCubit appCubit = AppCubit.get(context);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    header(title: 'مرحبا، هشام', context: context),
                    state is GetAdminDataLoadingState? const Center(child: CircularProgressIndicator())
                        : appCubit.users.isEmpty || appCubit.services.isEmpty
                        || appCubit.requests.isEmpty || appCubit.providers.isEmpty ? const Text('لا توجد بيانات للإحصائات')
                        : GridView.builder(
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
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 2.1,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                          onTap: (){},
                          child: Container(
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
                                  child: SvgPicture.asset(
                                    services[index]['icon']!,
                                    // ignore: deprecated_member_use
                                    color: mainColor,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    services[index]['name']!,
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
                      height: 320.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, bottom: 15.h),
                        separatorBuilder: (context, index) => SizedBox(width: 15.w),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 200.w,
                              decoration: BoxDecoration(
                                color: appCubit.isDark ? lightDarkColor : Colors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: appCubit.isDark ? [] : blueShadow,
                                border: appCubit.isDark
                                    ? Border.all(color: const Color(0xFF30363D))
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25.r),
                                        child: Image.network(
                                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
                                          height: 130.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            height: 130.h,
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
                                                children: [
                                                  Icon(Icons.star_rounded, color: mainColor, size: 14.sp),
                                                  SizedBox(width: 2.w),
                                                  Text(
                                                    '4.8',
                                                    style: TextStyle(
                                                      color: mainColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10.sp,
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
                                    padding: EdgeInsetsDirectional.all(12.r),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'عبد الله محمد احمد',
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
                                          'كهربائي',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
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
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              padding: EdgeInsetsDirectional.all(8.r),
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                shape: BoxShape.circle,
                                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/whats.svg',
                                                color: Colors.white,
                                                width: 22.w,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsetsDirectional.all(8.r),
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                shape: BoxShape.circle,
                                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/phone.svg',
                                                color: Colors.white,
                                                width: 22.w,
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
                      height: 320.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w,bottom: 10.h),
                        itemBuilder: (context, index) {
                          // var service = userServicesCubit.userElecServices[index];
                          // var providerData = cubit.allUsers[service['providerId']];
                          return InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 300.w,
                              decoration: BoxDecoration(
                                color: appCubit.isDark ? lightDarkColor : Colors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: appCubit.isDark ? [] : blueShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25.r),
                                        child: Image.network(
                                          'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
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
                                            '25000 $reyalSymbol',
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
                                                'تكييف',
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
                                          'تنظيف تكييف مركزي شمسي',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: appCubit.isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                                            SizedBox(width: 5.w),
                                            Text(
                                              '4.5',
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
                                                backgroundImage: const NetworkImage('https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'هادي محمد',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                                      ),
                                                    ),
                                                    Text(
                                                      'كهربائي',
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
                      height: 370.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          var booking = bookings[index];
                          Color statusColor;
                          String status = booking['status'];
                          switch (status) {
                            case 'مكتمل':
                              statusColor = Colors.green;
                              break;
                            case 'مقبول':
                            case 'في الطريق':
                              statusColor = Colors.blueAccent;
                              break;
                            case 'مرفوض':
                            case 'ملغي':
                              statusColor = Colors.redAccent;
                              break;
                            default:
                              statusColor = Colors.orangeAccent;
                          }

                          return Padding(
                            padding: EdgeInsetsDirectional.only(bottom: 20.h),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {},
                              child: Container(
                                width: 320.w,
                                padding: const EdgeInsetsDirectional.all(10),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          child: Image.network(
                                            booking['image'],
                                            width: 80.w,
                                            height: 80.h,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              width: 80.w,
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      booking['title'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Container(
                                                    height: 30.h,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .symmetric(
                                                                horizontal:
                                                                    7.w),
                                                    decoration: BoxDecoration(
                                                      color: statusColor
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.r),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        status,
                                                        style: TextStyle(
                                                          color: statusColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                '${booking['price']} $reyalSymbol',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Container(
                                      padding:
                                          const EdgeInsetsDirectional.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/loc.svg',
                                                width: 22.w,
                                                color: mainColor,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                'العنوان:',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  booking['address'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    horizontal: 10.w),
                                            child: dashedDivider(Colors.grey),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/timer.svg',
                                                width: 22.w,
                                                color: mainColor,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                'التاريخ والوقت:',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  booking['scheduledAt'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    horizontal: 10.w),
                                            child: dashedDivider(Colors.grey),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/acc.svg',
                                                width: 22.w,
                                                color: mainColor,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                'المستخدم:',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  booking['providerName'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    horizontal: 10.w),
                                            child: dashedDivider(Colors.grey),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/providers.svg',
                                                width: 22.w,
                                                color: mainColor,
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                'الفني:',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  booking['clientName'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
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
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          width: 15.w,
                        ),
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
                      height: 220.h,
                      child: ListView.separated(
                        padding: EdgeInsetsDirectional.only(start: 15.w),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 170.w,
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadiusDirectional.vertical(
                                      top: Radius.circular(20.r)),
                                  child: Image.network(
                                    'https://i.pinimg.com/736x/d1/81/e4/d181e44cf0a7d5f9190bc96939da4164.jpg',
                                    height: 115.h,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                        Container(
                                          height: 115.h,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                              BorderRadius.circular(20.r)),
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.all(15.w),
                                  child: Column(
                                    children: [
                                      Text(
                                        'عبد الله محمد احمد',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10.h,),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 20.r,
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                  'assets/whats.svg',
                                                  color: mainColor,
                                                )),
                                          ),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 20.r,
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                  'assets/phone.svg',
                                                  color: mainColor,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
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
