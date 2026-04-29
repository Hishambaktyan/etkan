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
      'value': '23',
      'color': mainColor,
    },
    {
      'icon': 'assets/services.svg',
      'title': 'الخدمات',
      'value': '102',
      'color': Colors.teal,
    },
    {
      'icon': 'assets/bookings.svg',
      'title': 'الطلبات',
      'value': '42',
      'color': Colors.orange,
    },
    {
      'icon': 'assets/reports.svg',
      'title': 'البلاغات',
      'value': '8',
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
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 15,
            backgroundColor: mainColor,
            title: Text(
              'لوحة التحكم',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () => move(context, const NotificationsScreen()),
                  icon: SvgPicture.asset(
                    'assets/not.svg',
                    color: Colors.white,
                    width: 30.w,
                  )),
              SizedBox(
                width: 5.w,
              )
            ],
          ),
          body: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              AppCubit appCubit = AppCubit.get(context);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      padding: EdgeInsetsDirectional.only(
                          start: 10.w, end: 10.w, top: 20.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 1.3),
                      itemBuilder: (context, index) {
                        final card = adminCards[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: blueShadow),
                          padding: const EdgeInsetsDirectional.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        card['color'].withOpacity(0.1),
                                    radius: 25.r,
                                    child: SvgPicture.asset(
                                      card['icon'],
                                      color: card['color'],
                                      width: 28.w,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    card['value'],
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold,
                                        color: card['color']),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                card['title'],
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.h,
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
                    SizedBox(
                      height: 10.h,
                    ),
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
                          borderRadius: BorderRadius.circular(15.r),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsetsDirectional.all(10),
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.r)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 55.w,
                                  height: 55.h,
                                  padding: const EdgeInsetsDirectional.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: SvgPicture.asset(
                                    services[index]['icon']!,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  services[index]['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: mainColor,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.h,
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
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 250.h,
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
                                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
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
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        'كهربائي',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
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
                        separatorBuilder: (context, index) => SizedBox(
                          width: 15.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 300.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        padding:
                            EdgeInsetsDirectional.only(start: 15.w, end: 15.w),
                        itemBuilder: (context, index) {
                          // var service = userServicesCubit.userElecServices[index];
                          // var providerData = cubit.allUsers[service['providerId']];
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {},
                            /*move(context, ServiceDetails(
                            category: service['category'] ,
                            subCategory: service['subCategory'],
                            name: service['name'],
                            image: service['serviceImage'],
                            price: service['price'],
                            period: service['period'],
                            desc: service['description'],
                            rate: service['rate'],
                            providerName: providerData['name'],
                            providerSpec: providerData['specialization'],
                            reviews: service['reviews'],
                            providerId: service['providerId'],
                          )
                          )*/
                            child: Container(
                              width: 300.w,
                              padding: EdgeInsetsDirectional.only(bottom: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: appCubit.isDark
                                    ? lightDarkColor
                                    : mainColor.withOpacity(0.1),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(15.r),
                                      topEnd: Radius.circular(15.r),
                                    ),
                                    child: Image.network(
                                      'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                                      height: 150.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        height: 150.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                              topStart: Radius.circular(15.r),
                                              topEnd: Radius.circular(15.r),
                                            ),
                                            color: Colors.grey.shade200),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 10.w, end: 10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'تنظيف تكييف مركزي شمسي',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                  color: appCubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsetsDirectional
                                                  .symmetric(
                                                      vertical: 3.h,
                                                      horizontal: 7.w),
                                              decoration: BoxDecoration(
                                                color: mainColor,
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(30.r),
                                              ),
                                              child: Text(
                                                '${25000} $reyalSymbol',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.orange,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              '${3.8}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              foregroundImage: const NetworkImage(
                                                  'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'),
                                              radius: 20.r,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 200.w,
                                                  child: Text(
                                                    '${'عبد الله عبد الفتاح'}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12.sp),
                                                  ),
                                                ),
                                                Text(
                                                  '${'فني تكييف'}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey),
                                                ),
                                              ],
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
                        separatorBuilder: (context, index) => SizedBox(
                          width: 15.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
                    SizedBox(
                      height: 10.h,
                    ),
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
                  ],
                ),
              );
            },
          ),
        ));
  }
}
