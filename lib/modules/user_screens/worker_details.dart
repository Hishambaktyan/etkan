import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/user_screens/booking_details_screen.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';

import '../../shared/styles/colors.dart';

class Worker_details extends StatefulWidget {
  const Worker_details({super.key});

  @override
  State<Worker_details> createState() => _Worker_detailsState();
}

class _Worker_detailsState extends State<Worker_details> {
  List<String> basicServices = [
    "تمديد الأسلاك الكهربائية",
    "إصلاح الأعطال المنزلية",
    "تركيب الإنارة الداخلية والخارجية",
    "صيانة المولدات",
    "صيانة أجهزة التكييف المرتبطة بالكهرباء",
    "فحص سلامة الأحمال وتوزيع الطاقة",
    "تركيب مفاتيح وقواطع كهربائية",
    "تركيب لوحات توزيع كهربائية",
  ];
  int price = 5000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 270.h,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: Icon(
                            Icons.wifi_off_rounded,
                            color: Colors.grey.shade400,
                            size: 50.h,
                          ),
                        );
                      },
                      height: 270.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: 30.h, start: 20.w, end: 20.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border_rounded),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.share_rounded),
                              onPressed: () {},
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: 15.w, end: 15.w, top: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: mainColor.withOpacity(0.1),
                            ),
                            child: const Center(child: Text('الكهرباء')),
                          ),
                          const Spacer(),
                          Container(
                            height: 30.h,
                            width: 73.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: mainColor.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h),
                                    child: const Text('4.4'),
                                  ),
                                  SizedBox(width: 5.w),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2.w),
                                    child: Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.orange.shade300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'محمد عصام اليزيدي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'عدن-المنصورة-بلوك32',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10.h),

                       TabBar(
                        labelColor: mainColor,
                        unselectedLabelColor: Colors.grey,
                        splashBorderRadius: BorderRadius.only(topRight: Radius.circular(15.r),topLeft: Radius.circular(15.r)),
                        tabs: [
                          Tab(text: 'نبذة'),
                          Tab(text: 'المعرض'),
                          Tab(text: 'التقييم'),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Builder(builder: (context) {
                        final TabController controller =
                        DefaultTabController.of(context);
                        return AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            final idx = controller.index;
                            if (idx == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(start: 15.w,end: 15.w,top: 15.h),
                                    child: Text(
                                      'نبذة عني',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10.h
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 15.w),
                                    child: ReadMoreText(
                                      'أنا كهربائي متخصص في تركيب وصيانة الأنظمة الكهربائية للمنازل والمحال التجارية. '
                                          'أمتلك خبرة في تمديد الأسلاك الكهربائية بطريقة آمنة وفق المعايير. '
                                          'إصلاح الأعطال المنزلية مثل القواطع (السكويتشات) والمفاتيح والمقابس. '
                                          'تركيب أجهزة الإنارة الداخلية والخارجية. '
                                          'صيانة المولدات وأجهزة التكييف المرتبطة بالشبكة الكهربائية. '
                                          'التأكد من سلامة الأحمال وتوزيع الطاقة بشكل متوازن.',
                                      trimLines: 4,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: 'عرض المزيد',
                                      trimExpandedText: 'عرض أقل',
                                      style: TextStyle(fontSize: 12.sp),
                                      moreStyle: TextStyle(color: mainColor),
                                      lessStyle: TextStyle(color: mainColor),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 20.h
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 15.w),
                                    child: Text(
                                      'الخدمات الأساسية',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10.h
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                    child: ListView.separated(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 10.w),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => Chip(
                                          label: Text(
                                            basicServices[index],
                                            style:
                                            TextStyle(fontSize: 10.sp),
                                          ),
                                        ),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(width: 10.w),
                                        itemCount: basicServices.length),
                                  ),
                                  SizedBox(
                                      height: 20.h
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 15.w),
                                    child: Text(
                                      'تواصل معي',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 5.h
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 15.w),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25.r,
                                          backgroundImage: NetworkImage(
                                            "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
                                          ),
                                        ),
                                        SizedBox(
                                            width: 10.w
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 120.w,
                                              child: Text(
                                                'محمد عصام اليزيدي أحمد',
                                                style:
                                                TextStyle(fontSize: 10.sp),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              'كهربائي',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10.sp),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {},
                                          child: CircleAvatar(
                                            radius: 22.r,
                                            backgroundColor: mainColor
                                                .withOpacity(0.1),
                                            child: Icon(
                                              Icons.chat_rounded,
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {},
                                          child: CircleAvatar(
                                            radius: 22.r,
                                            backgroundColor: mainColor
                                                .withOpacity(0.1),
                                            child: Icon(
                                              Icons.call_rounded,
                                              color: mainColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              );
                            }
                            else if (idx == 1) {
                              // تاب المعرض
                              return GridView.builder(
                                 padding: EdgeInsetsDirectional.only(top: 10.h,bottom: 30.w),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 12,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 3,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.error_outline_rounded,
                                          size: 50.h,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  );
                                },
                              );
                            }
                            else {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: RatingBar.builder(
                                            initialRating: 1,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => const Icon(
                                            Icons.star_rate_rounded,
                                            color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                            print(rating);
                                            },
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: (){},
                                        child: Text('ارسال'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  defaultTextFormfeild(
                                      text: 'تعليق',
                                      prefixIcon: 'assets/chat2.svg',
                                      errorMes: 'حقل التعليق يجب ان لا يكون فارغ',
                                      controller: TextEditingController(),
                                      type: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ListView.separated(
                                    padding: EdgeInsetsDirectional.only(top: 10.h),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 5,
                                    separatorBuilder: (_, __) =>SizedBox(
                                      height: 20.h,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.r,
                                                backgroundImage: NetworkImage(
                                                  'https://i.pinimg.com/1200x/65/7c/e1/657ce19e18e65061190c7927400947cf.jpg'
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              SizedBox(
                                                width: 180.w,
                                                child: Text(
                                                  'هشام هاني أحمد باقطيان',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12.sp
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                height: 20.h,
                                                width: 90.w,
                                                child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (context, index) => Icon(
                                                      Icons.star_rounded,
                                                      size: 17,
                                                      color: Colors.orangeAccent.shade200,
                                                    ),
                                                    separatorBuilder: (context, index) => SizedBox(),
                                                    itemCount: 5
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                          ReadMoreText(
                                            'فنان بصراحة وشغله نظيف يشتل بضمير يعني وياخذذ وقته، بس مشكلته يشتي الحاجات الغالبة ويشل كثير',
                                            trimLines: 2,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'عرض المزيد',
                                            trimExpandedText: 'عرض أقل',
                                            style: TextStyle(fontSize: 12.sp),
                                            moreStyle: TextStyle(color: mainColor),
                                            lessStyle: TextStyle(color: mainColor),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 10.h),
        child: defualtButton(onPressed: ()=>move(context, BookingDetailsScreen()), text: 'حجز'),
      ),
    );
  }
}
