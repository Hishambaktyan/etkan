import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/user_screens/booking_details_screen.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';

import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final Map<String, dynamic> service = {
    'category': 'تنظيف',
    'subCategory': 'تنظيف منازل',
    'name': 'تنظيف شامل للمنزل وترتيب وتنظيف سامان',
    'price': 25000,
    'period': 90,
    'description': 'خدمة تنظيف متكاملة تشمل الأرضيات، النوافذ، والأثاث باستخدام مواد آمنة وعالية الجودة. يتم التنفيذ بواسطة فريق محترف لضمان أفضل نتيجة ممكنة.',
    'rate': 4.5,
  };
  final List<Map<String, dynamic>> review = [
    {
      'userName': 'أحمد',
      'rating': 5,
      'comment': 'خدمة ممتازة وسريعة جدًا',
      'createdAt': Timestamp.fromDate(DateTime(2024, 5, 10)),
    },
    {
      'userName': 'سارة',
      'rating': 4,
      'comment': 'شغل نظيف لكن تأخروا شوي',
      'createdAt': Timestamp.fromDate(DateTime(2024, 6, 2)),
    },
    {
      'userName': 'محمد',
      'rating': 3,
      'comment': 'الخدمة جيدة بشكل عام',
      'createdAt': Timestamp.fromDate(DateTime(2024, 6, 15)),
    },
  ];
  final TextEditingController commentController = TextEditingController();
  double userRating = 0;
  @override
  Widget build(BuildContext context) {
    MyCubit cubit = MyCubit.get(context);
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
                    Image.network(
                      'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300.h,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                  onLongPress: ()=>print(service[0]),
                                  child: Container(
                                    height: 70.h,
                                    width: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg'
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                  child: Container(
                                    height: 70.h,
                                    width: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://i.pinimg.com/736x/d2/89/9f/d2899f239623e6cb64f1854b469af5b5.jpg'
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                  child: Container(
                                    height: 70.h,
                                    width: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://i.pinimg.com/736x/6d/66/af/6d66af4d10a9a7d19d1df880b0ce3b23.jpg'
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: ()=>move(context, const ImageViewerPage(imageUrl:'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg' ),),
                                  child: Container(
                                    height: 70.h,
                                    width: 70.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                'https://i.pinimg.com/1200x/9b/9c/93/9b9c93ac5db55031a32139e972ee6da6.jpg'
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                              padding: EdgeInsets.all(18.r),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: cubit.isDark? lightDarkColor: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow (
                                      color: mainColor.withOpacity(0.1),
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
                                      '${service['category']}  >  ${service['subCategory']}',
                                      style: TextStyle(
                                        color: cubit.isDark? Colors.white: Colors.grey.shade700,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    service['name'],
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
                                                  '${service['price']} $reyalSymbol',
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
                                                  '${service['period']} دقيقة',
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
                              color: mainColor.withOpacity(0.1),
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
                            service['description'],
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
                              color: mainColor.withOpacity(0.1),
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
                                    'عبد الله عبد الرحمن ناصر',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: cubit.isDark? Colors.white: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'كهرباء',
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
                            color: mainColor.withOpacity(0.1),
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
                                    '3.6',
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
                                      color: index < 3.6 ? Colors.orange : Colors.grey.shade300,
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
                                    setState(() {
                                      review.insert(0, {
                                        'userName': 'أنت',
                                        'rating': userRating,
                                        'comment': commentController.text,
                                        'createdAt': Timestamp.now(),
                                      });
                                    });
                                    commentController.clear();
                                    userRating = 0;
                                  }
                                },
                                text: 'نشر',
                                isLined: false,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: review.length,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade300),
                            itemBuilder: (context, index) {
                              Timestamp? createdAt = review[index]['createdAt'];
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
                                              review[index]['userName'],
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
                                          (review[index]['rating'] ?? 0)
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
                                    review[index]['comment'],
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
              onPressed: ()=>move(context,BookingDetailsScreen(
                serciveName: service['name'],
                serciveCategory: service['category'],
                serciveSubCategory: service['subCategory'],
                servicePrice: service['price'],
                servicePeriod: service['period']
              )),
              text: 'حجز'
          ),
        ),
      ),
    );
  }
}
