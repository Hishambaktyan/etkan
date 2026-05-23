import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/worker_screens/worker_profile.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';

class AdminServiceDetails extends StatefulWidget {
  final Map<String,dynamic> service;
  final List<dynamic> reviews;

  const AdminServiceDetails({
    super.key,
    required this.reviews,
    required this.service,
  });

  @override
  State<AdminServiceDetails> createState() => _AdminServiceDetailsState();
}

class _AdminServiceDetailsState extends State<AdminServiceDetails> {

  bool isActive = true;

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
    final service = widget.service;
    final reviews = widget.reviews;
    AppCubit cubit = AppCubit.get(context);
    final providerData = cubit.allUsers[service['providerId']] ?? {};

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
                        service['serviceImage'] ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 20.h, start: 10.w, end: 10.w),
                      child: Row(
                        children: [
                          Padding(
                            padding:  EdgeInsetsDirectional.all(7.w),
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
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  isActive ? 'نشطة' : 'معطلة',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isActive ? Colors.green : Colors.red,
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                SizedBox(
                                  height: 20.h,
                                  width: 35.w,
                                  child: Switch.adaptive(
                                    value: isActive,
                                    activeColor: Colors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        isActive = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: mainColor.withOpacity(0.2),
                                      spreadRadius: 1.0,
                                      blurRadius: 7.0,
                                      offset: const Offset(2, 5),
                                    ),
                                  ],
                                  border: cubit.isDark
                                      ? Border.all(
                                      color: const Color(0xFF30363D)
                                  ) : null
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
                                      '${service['category'] ?? ''}',
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
                                    '${service['name'] ?? ''}',
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
                                                  '${service['price'] ?? ''} $reyalSymbol',
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
                                                  '${service['period'] ?? ''} دقيقة',
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
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 7.0,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          border: cubit.isDark
                              ? Border.all(color: const Color(0xFF30363D))
                              : null),
                      child: Column(
                        children: [
                          ReadMoreText(
                            '${service['description'] ?? ''}',
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
                          boxShadow: [
                            BoxShadow(
                              color: mainColor.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 7.0,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          border: cubit.isDark
                              ? Border.all(color: const Color(0xFF30363D))
                              : null),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: mainColor.withOpacity(0.1),
                                backgroundImage: NetworkImage(
                                  providerData['profileImage'] ?? '',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    providerData['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    providerData['specialization'] ?? '',
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
                              move(context, const WorkerProfile());
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
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(2, 5),
                          ),
                        ],
                        border: cubit.isDark
                            ? Border.all(color: const Color(0xFF30363D))
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                              Colors.orange.withOpacity(0.15),
                              radius: 35.r,
                              child: Text(
                                '${service['rate'] ?? ''}',
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
                                  color: index < service['rate']
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
      ),
    );
  }
}
