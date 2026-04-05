import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/user_screens/booking_confirm_info_screen.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class ServiceDetails extends StatefulWidget {
  final String category;
  final String subCategory;
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
    super.key, required this.category,
    required this.subCategory,
    required this.name,
    required this.price,
    required this.period,
    required this.desc,
    required this.rate,
    required this.providerName,
    required this.providerSpec, required this.reviews, required this.providerId, required this.image,
  });

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final TextEditingController commentController = TextEditingController();
  double userRating = 0;
  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final subCategory = widget.subCategory;
    final name = widget.name;
    final price = widget.price;
    final period = widget.period;
    final desc = widget.desc;
    final rate = widget.rate;
    final providerName = widget.providerName;
    final providerSpec = widget.providerSpec;
    final reviews = widget.reviews;
    final image = widget.image;
    final providerId = widget.providerId;
    AppCubit cubit = AppCubit.get(context);
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
                      borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(10.r)),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 20.h,start: 10.w,end: 10.w),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: ()=>Navigator.pop(context),
                                child: const Icon(
                                    CupertinoIcons.back
                                ),
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
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                onSelected: (String value) {
                                  if (value == 'active') {
                                    /*cubit.isServicesActive=!cubit.isServicesActive;
                                  print(cubit.isServicesActive);*/
                                  } else if (value == 'delete') {
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'active',
                                    child: Directionality(
                                        textDirection:TextDirection.rtl,
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: cubit.isServicesActive?Text('إلغاء التفعيل'):Text('تفعيل')
                                        )
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Directionality(
                                        textDirection:TextDirection.rtl,
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Text('تعديل')
                                        )
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Directionality(
                                        textDirection:TextDirection.rtl,
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Text('حذف')
                                        )
                                    ),
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
                        padding:EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(18.r),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: cubit.isDark? lightDarkColor: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow (
                                      color: mainColor.withOpacity(0.2),
                                      spreadRadius: 1.0,
                                      blurRadius: 7.0,
                                      offset: const Offset(2, 5),
                                    ),
                                  ],
                                  border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: cubit.isDark? darkBgColor: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      '$category  >  $subCategory',
                                      style: TextStyle(
                                        color: cubit.isDark? Colors.white: Colors.grey.shade700,
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
                                      color: cubit.isDark? Colors.white: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Divider(color: cubit.isDark? darkSubTextColor: Colors.grey.shade300, height: 1),
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.payments_outlined,
                                              size: 18.r,
                                              color:  cubit.isDark? darkSubTextColor: Colors.grey,                                                  ),
                                            SizedBox(width: 8.w),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('السعر التقديري',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color:  cubit.isDark? darkSubTextColor: Colors.grey,
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
                                        color:  cubit.isDark? darkSubTextColor: Colors.grey.shade300,
                                      ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                              size: 18.r,
                                              color:  cubit.isDark? darkSubTextColor: Colors.grey,
                                            ),
                                            SizedBox(width: 8.w),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'المدة المتوقعة',
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color:  cubit.isDark? darkSubTextColor: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  '$period دقيقة',
                                                  style: TextStyle(
                                                    color: cubit.isDark? Colors.white: Colors.black87,
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
                    Container(
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                          color: cubit.isDark? lightDarkColor: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow (
                              color: mainColor.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 7.0,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsetsDirectional.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: cubit.isDark?mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1)
                                  ),
                                  child: Icon(
                                      Icons.notes_rounded,
                                      size: 22.r,
                                      color: mainColor
                                  )
                              ),
                              SizedBox(
                                  width: 10.w
                              ),
                              Text(
                                'وصف الخدمة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: cubit.isDark? Colors.white: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 10.h
                          ),
                          ReadMoreText(
                          desc,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color:  cubit.isDark? Colors.white: Colors.black,
                                height: 1.5
                            ),
                            trimLines: 3,
                            colorClickableText: mainColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' عرض المزيد',
                            trimExpandedText: ' عرض أقل',
                            moreStyle: TextStyle(fontSize: 12.sp,color: mainColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(18.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: cubit.isDark? lightDarkColor: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow (
                              color: mainColor.withOpacity(0.2),
                              spreadRadius: 1.0,
                              blurRadius: 7.0,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          border: cubit.isDark? Border.all(color: const Color(0xFF30363D)): null
                      ),
                      child: Column(
                        children: [
                          Row (
                            children: [
                              Container(
                                  padding: const EdgeInsetsDirectional.all(8),
                                  decoration: BoxDecoration(
                                      color: cubit.isDark? mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  child: Icon(
                                      Icons.person_pin_outlined,
                                      size: 22.r,
                                      color: mainColor
                                  )
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'معلومات الفني',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: cubit.isDark? Colors.white: Colors.black87
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: mainColor.withOpacity(0.1),
                                backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/736x/0d/bc/a7/0dbca7e372766da7842528c87f693c01.jpg',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    providerName,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark? Colors.white: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    providerSpec,
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
                            child: Divider(color: cubit.isDark? darkSubTextColor: Colors.grey.shade100, height: 1),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/phone.svg',
                                color: cubit.isDark? darkSubTextColor: Colors.grey.shade600,
                                width: 18.r,
                                height: 18.r,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '770770858',
                                style: TextStyle(
                                    color: cubit.isDark? Colors.white: Colors.black87,
                                    fontSize: 12.sp,
                                    letterSpacing: 7
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: defualtButtonWithIcon(
                                  onPressed: () {},
                                  text: 'دردشة',
                                  height: 45.h,
                                  textSize: 13.sp,
                                  icon: SvgPicture.asset(
                                    'assets/chat.svg',
                                    color: Colors.white,
                                    width: 20.r,
                                    height: 20.r,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: defualtOutlinedButtonWithIcon(
                                  onPressed: () {},
                                  text: 'إتصال',
                                  fontSize: 13.sp,
                                  height: 45.h,
                                  textColor: cubit.isDark? Colors.white: mainColor,
                                  border: cubit.isDark? Colors.white: mainColor,
                                  icon: SvgPicture.asset(
                                    'assets/phone.svg',
                                    color: cubit.isDark? Colors.white: mainColor,
                                    width: 20.r,
                                    height: 20.r,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(18.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cubit.isDark ? lightDarkColor : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: cubit.isDark
                                      ? mainColor.withOpacity(0.2)
                                      : mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.star_outline_rounded,
                                  size: 22.r,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'التقييمات والمراجعات',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: cubit.isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.orange.withOpacity(0.15),
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
                                      color: index < rate ? Colors.orange : Colors.grey.shade300,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Divider(color: Colors.grey.shade300),
                          SizedBox(height: 15.h),
                          Text(
                            'أضف مراجعتك',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      userRating = index + 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.star_rounded,
                                    color: index < userRating
                                        ? Colors.orange
                                        : Colors.grey.shade300,
                                    size: 30,
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: commentController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'اكتب تعليقك هنا...',
                              filled: true,
                              fillColor: cubit.isDark
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.grey.shade50,
                              contentPadding: EdgeInsets.all(12.r),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: SizedBox(
                              width: 100.w,
                              child: defaultTextButton(
                                onPressed: () {
                                  if (commentController.text.isNotEmpty &&
                                      userRating > 0) {
                                    /*commentController.clear();
                                    userRating = 0;*/
                                  }
                                },
                                text: 'نشر',
                                isLined: false,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ListView.separated(
                            padding: EdgeInsetsDirectional.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade300),
                            itemBuilder: (context, index) {
                              var review = reviews[index];
                              Timestamp? createdAt = review['createdAt'];
                              DateTime? date = createdAt?.toDate();
                              String reviewDate = date != null
                                  ? DateFormat('yyyy/MM/dd').format(date)
                                  : '';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: cubit.isDark
                                            ? darkSubTextColor
                                            : Colors.blueGrey.shade50,
                                        child: Icon(
                                          Icons.person_outline,
                                          size: 20.r,
                                          color: cubit.isDark
                                              ? Colors.white
                                              : Colors.blueGrey,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review['userName'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              reviewDate,
                                              style: TextStyle(
                                                color: cubit.isDark
                                                    ? darkSubTextColor
                                                    : Colors.grey,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(5, (i) {
                                          double rating =
                                          (review['rating'] ?? 0)
                                              .toDouble();
                                          return Icon(
                                            Icons.star_rounded,
                                            size: 16.r,
                                            color: i < rating
                                                ? Colors.orange
                                                : Colors.grey.shade300,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    review['comment'],
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 10.h),
          child: defualtButton(
              onPressed: ()=>move(context, BookingConfirmInfoScreen(
                serciveName: name,
                serciveCategory: category,
                serciveSubCategory: subCategory,
                servicePrice: price,
                servicePeriod: period,
                serciveImage:image,
                providerId: providerId,
              )
              ),
              text: 'حجز'
          ),
        ),
      ),
    );
  }
}
