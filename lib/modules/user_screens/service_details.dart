import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/user_screens/booking_confirm_info_screen.dart';
import 'package:trying_homy/modules/user_screens/user_worker_profile.dart';
import 'package:trying_homy/modules/worker_screens/worker_profile.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class ServiceDetails extends StatefulWidget {
  final String category;
  final String name;
  final String image;
  final int price;
  final String period;
  final String desc;
  final double rate;
  final String providerName;
  final String providerSpec;
  final List<dynamic> reviews;
  final String providerId;

  const ServiceDetails({
    super.key,
    required this.category,
    required this.name,
    required this.price,
    required this.period,
    required this.desc,
    required this.rate,
    required this.providerName,
    required this.providerSpec,
    required this.reviews,
    required this.providerId,
    required this.image,
  });

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final TextEditingController commentController = TextEditingController();
  double userRating = 0;

  Widget buildSectionTitle({
    required String title,
    required IconData icon,
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
          child: Icon(
            icon,
            size: 22.r,
            color: mainColor,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final name = widget.name;
    final price = widget.price;
    final period = widget.period;
    final desc = widget.desc;
    final rate = widget.rate;
    final reviews = widget.reviews;
    final image = widget.image;
    final providerId = widget.providerId;
    AppCubit cubit = AppCubit.get(context);

    final providerData = cubit.allUsers[providerId];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 400.h,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusDirectional.vertical(
                          bottom: Radius.circular(10.r)),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: 20.h, start: 10.w, end: 10.w),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => Navigator.pop(context),
                                child: const Icon(CupertinoIcons.back),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: PopupMenuButton<String>(
                                color: Colors.white,
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                  size: 24.r,
                                ),
                                offset: const Offset(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                onSelected: (String value) {
                                  if (value == 'active') {
                                    /*cubit.isServicesActive=!cubit.isServicesActive;
                                  print(cubit.isServicesActive);*/
                                  } else if (value == 'delete') {}
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'active',
                                    child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: SizedBox(
                                            width: double.infinity,
                                            child:  Text('إبلاغ'))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(18.r),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: cubit.isDark
                                      ? lightDarkColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                  boxShadow: blueShadow
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: cubit.isDark
                                          ? darkBgColor
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      '$category',
                                      style: TextStyle(
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Divider(
                                      color: cubit.isDark
                                          ? darkSubTextColor
                                          : Colors.grey.shade300,
                                      height: 1),
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/money.svg',color: Colors.grey,width: 20.w,),
                                            SizedBox(width: 8.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'السعر التقديري',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: cubit.isDark
                                                        ? darkSubTextColor
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  '$price $reyalSymbol',
                                                  style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 30.h,
                                        width: 1,
                                        color: cubit.isDark
                                            ? darkSubTextColor
                                            : Colors.grey.shade300,
                                      ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset('assets/timer.svg',color: Colors.grey,width: 20.w,),
                                            SizedBox(width: 8.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'المدة المتوقعة',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: cubit.isDark
                                                        ? darkSubTextColor
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  '$period دقيقة',
                                                  style: TextStyle(
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    '* السعر النهائي قد يزيد أو ينقص حسب طبيعة الخدمة الفعلية، وحجم العمل المطلوب، وبعد موقع العميل عن مقدم الخدمة',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 8.sp
                                    ),

                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle(title: 'وصف الخدمة', icon: Icons.notes_rounded, cubit: cubit),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                          color: cubit.isDark ? lightDarkColor : Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: blueShadow
                      ),
                      child: Column(
                        children: [
                          ReadMoreText(
                            desc,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                                height: 1.5),
                            trimLines: 3,
                            colorClickableText: mainColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' عرض المزيد',
                            trimExpandedText: ' عرض أقل',
                            moreStyle:
                                TextStyle(fontSize: 12.sp, color: mainColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    buildSectionTitle(title: 'معلومات الفني', icon: Icons.person_pin_outlined, cubit: cubit),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(18.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: cubit.isDark ? lightDarkColor : Colors.white,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: blueShadow
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: mainColor.withOpacity(0.1),
                                backgroundImage: NetworkImage(
                                  providerData['profileImage']??'',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  providerData['name']??'',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    providerData['specialization']?? '',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Divider(
                                color: cubit.isDark
                                    ? darkSubTextColor
                                    : Colors.grey.shade100,
                                height: 1),
                          ),
                          defaultOutlinedButtonWithIcon(
                            onPressed: () {
                              move(context, const UserWorkerProfile());
                            },
                            text: 'المزيد',
                            fontSize: 13.sp,
                            height: 45.h,
                            textColor:
                            cubit.isDark ? Colors.white : mainColor,
                            border:
                            cubit.isDark ? Colors.white : mainColor,
                            icon: SvgPicture.asset(
                              'assets/acc.svg',
                              color:
                              cubit.isDark ? Colors.white : mainColor,
                              width: 20.r,
                              height: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    buildSectionTitle(title: 'التقييمات والمراجعات', icon: Icons.star_outline_rounded, cubit: cubit),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(18.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cubit.isDark ? lightDarkColor : Colors.white,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: blueShadow
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Colors.orange.withOpacity(0.15),
                              radius: 35.r,
                              child: Text(
                                '$rate',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star_rounded,
                                  size: 18.r,
                                  color: index < rate
                                      ? Colors.orange
                                      : Colors.grey.shade300,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h),
          child: defaultButton(
              onPressed: () => move(
                  context,
                  BookingConfirmInfoScreen(
                    serciveName: name,
                    serciveCategory: category,
                    servicePrice: price,
                    servicePeriod: period,
                    serciveImage: image,
                    providerId: providerId,
                  )),
              text: 'حجز'),
        ),
      ),
    );
  }
}
