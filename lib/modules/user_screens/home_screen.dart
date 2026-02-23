import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trying_homy/modules/user_screens/worker_details.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';
import 'dept.dart';
import 'electric_workers.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onCategoryTap;
   const HomeScreen({required this.onCategoryTap});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> theServices = [
    {'imagePath': 'assets/SVGs/P.svg', 'label': 'السباكة'},
    {'imagePath': 'assets/SVGs/E.svg', 'label': 'الكهرباء'},
    {'imagePath': 'assets/SVGs/AC.svg', 'label': 'التكييف'},
    {'imagePath': 'assets/SVGs/WT.svg', 'label': 'الماء'},
  ];
  final List<String> homeServices = [
    'إصلاح تسريب المياه',
    'تركيب لمبات وثريات',
    'صيانة دورية للمكيفات',
    'تصليح الأبواب والنوافذ',
    'إصلاح الأعطال الكهربائية',
    'تسليك المجاري والأنابيب',
    'تركيب غرف نوم وخزائن',
    'إصلاح أعطال التبريد',
    'تركيب مفاتيح وبرايز كهربائية',
    'تصليح المطابخ والخزائن الخشبية',
  ];
  final List<Map<String, dynamic>> workers = [
  {
  "name": "محمد علي اليوسفي",
  "price": 5000,
  "image": "https://i.pinimg.com/1200x/3e/f3/50/3ef350dc86cc82a092463e5d795654b5.jpg",
  "isBusy": false,
  "rating": 4.5,
},
{
"name": "سعيد حسن القحطاني",
"price": 11200,
"image": "https://i.pinimg.com/736x/eb/76/a4/eb76a46ab920d056b02d203ca95e9a22.jpg",
"isBusy": true,
"rating": 4.0,
},
{
"name": "أحمد خالد الفهد",
"price": 9000,
"image": "https://i.pinimg.com/736x/27/90/03/27900371354079f41e16751f2a320fdb.jpg",
"isBusy": false,
"rating": 4.2,
},
{
"name": "خالد يوسف العتيبي",
"price": 1100,
"image": "https://i.pinimg.com/1200x/65/7c/e1/657ce19e18e65061190c7927400947cf.jpg",
"isBusy": true,
"rating": 3.8,
},
{
"name": "سلمان عمر الحربي",
"price": 9500,
"image": "https://i.pinimg.com/736x/25/33/8f/25338f488af2c45912c15ebab325e363.jpg",
"isBusy": false,
"rating": 4.7,
},
{
"name": "ياسر محمد الدوسري",
"price": 13000,
"image": "https://i.pinimg.com/1200x/d8/5a/f1/d85af1b5204c5a8546a7a2e929af45c7.jpg",
"isBusy": true,
"rating": 3.9,
},
];
  PageController controller =PageController(viewportFraction: 0.5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'مرحبا هشام',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.sp
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset(
                        'assets/search.svg',
                        width: 25.w,
                        height: 25.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                  setState(() {
                  });
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset(
                        'assets/not.svg',
                        width: 25.w,
                        height: 25.h,
                      ),
                      true?Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                      ):SizedBox()
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Padding(
                        padding:EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                        child: Container(
                          height: 100.h,
                          padding: EdgeInsetsDirectional.only(start: 10.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 180.w,
                                child: Text(
                                  'خدماتك المنزلية على بعد نقرة واحدة فقط!',
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.asset(
                                    'assets/hm.png',
                                    fit: BoxFit.cover,
                                    width: 100.w,
                                    height: 100.h,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),*/
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.w,end: 5.w),
                        child: Row(
                          children: [
                            Text(
                              'الأقسام',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: (){
                                widget.onCategoryTap(1);
                              },
                              child: Text(
                                  'عرض الكل'
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                          itemCount: theServices.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder:(context, index) {
                            final service = theServices[index];
                            return Padding(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: ()=>move(context, const Electric_workers()),
                                child: CategoryBuilder(
                                    imagePath: service['imagePath']!,
                                    label: service['label']!
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.w,end: 5.w),
                        child: Text(
                          'الخدمات الأكثر طلبا',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        child: ListView.separated(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index)=>InkWell(
                              child: Chip(
                                label: Text(homeServices[index]),

                              ),
                              onTap: ()=>move(context, const Dept()),
                            ),
                            separatorBuilder: (context, index) => SizedBox(width: 10.w,),
                            itemCount: homeServices.length
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 20.w,end: 5.w),
                        child: Text(
                          'الفنيون الرائجون',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 210.h,
                        child: Padding(
                          padding:EdgeInsetsDirectional.symmetric(horizontal: 5.w),
                          child: PageView.builder(
                            padEnds: false,
                            scrollDirection: Axis.horizontal,
                            controller: controller,
                            itemBuilder:(context, index) {
                              final worker= workers[index];
                              return  InkWell(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(top: 5.h,bottom: 20.h,start: 7.w,end: 7.w,),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15.r),
                                        boxShadow: shadow
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w,vertical: 5.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15.r),
                                            child: Image.network(
                                              worker['image'],
                                              width: double.infinity,
                                              height: 120.h,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                color: Colors.grey.shade300,
                                                height: 120.h,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.wifi_off_rounded,
                                                    color: Colors.grey.shade400,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            worker['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                '\$ يبدأ من ',
                                                style: TextStyle(
                                                    fontSize: 10.sp
                                                ),
                                              ),
                                              Text(
                                                '${worker['price']}',
                                                style: TextStyle(
                                                    fontSize: 10.sp
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 20.h,
                                                width: 43.w,
                                                decoration:BoxDecoration(
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(7.r)
                                                ),
                                                child:
                                                Padding(
                                                  padding: EdgeInsetsDirectional.symmetric(vertical: 1.h,horizontal: 2.w),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.symmetric(vertical: 2.h),
                                                        child: Text(
                                                          '${worker['rating']}',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10.sp,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.only(bottom: 2.w),
                                                        child: Icon(
                                                          Icons.star_rate_rounded,
                                                          size: 16,
                                                          color: Colors.orange.shade300,
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: ()=>move(context, const Worker_details()),
                              );
                            },
                            itemCount: workers.length,

                          ),
                        ),
                      ),
                      Center(
                        child: SmoothPageIndicator(
                            controller: controller,
                            count: workers.length-1,
                            effect: ExpandingDotsEffect(
                              dotColor: Colors.grey,
                              activeDotColor: mainColor,
                              dotHeight: 8.h,
                              dotWidth: 8.w,
                            )
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
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
}