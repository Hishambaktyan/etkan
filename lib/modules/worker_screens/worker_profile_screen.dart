import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  final String workerName = 'هادي محمد';
  final String workerSpec = 'فني كهرباء وتمديدات';
  final String phone = '778830326';
  final double rating = 4.8;
  final int completedJobs = 37;
  final String workerImage =
      'https://d26e3f10zvrezp.cloudfront.net/Gallery/d72c67af-9f10-4d9d-b3db-fdc1647e6acc-1024x1024.webp';

  final String about =
      'فني محترف في أعمال الكهرباء والصيانة المنزلية، أمتلك خبرة واسعة في تركيب الإنارة، إصلاح الأعطال، وتمديدات الكهرباء للمنازل والمحلات، وأهتم بجودة العمل والالتزام بالمواعيد.';

  final List<String> experiences = [
    'خبرة أكثر من 5 سنوات في الصيانة الكهربائية',
    'تركيب وصيانة لوحات الكهرباء',
    'إصلاح التماس والأعطال المنزلية',
    'تمديدات كهربائية للمنازل والمكاتب',
  ];

  final List<Map<String, String>> previousWorks = [
    {
      'title': 'تركيب إنارة منزلية كاملة',
      'image':
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop'
    },
    {
      'title': 'صيانة لوحة كهرباء',
      'image':
          'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?q=80&w=1200&auto=format&fit=crop'
    },
    {
      'title': 'تمديدات شقة سكنية',
      'image':
          'https://images.unsplash.com/photo-1517048676732-d65bc937f952?q=80&w=1200&auto=format&fit=crop'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 290.h,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadiusDirectional.vertical(
                        bottom: Radius.circular(18),
                      ),
                      child: Image.network(
                        "https://img.pikbest.com/photo/20241027/rear-view-of-two-female-multiracial-electrical-workers-dressed_11011952.jpg!bw700",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 30.h,
                        start: 12.w,
                        end: 12.w,
                      ),
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 115.w,
                        height: 115.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(
                              workerImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.12),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.all(8),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(Icons.info_outline,
                                    size: 20.r, color: mainColor),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'نبذة عن العامل',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            about,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black87,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      padding: EdgeInsets.all(18.r),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.all(8),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.person_pin_outlined,
                                  size: 22.r,
                                  color: mainColor,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'معلومات الفني',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28.r,
                                backgroundColor: mainColor.withOpacity(0.1),
                                backgroundImage: NetworkImage(
                                  workerImage,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workerName,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      workerSpec,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child:
                                Divider(color: Colors.grey.shade200, height: 1),
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined,
                                  color: Colors.grey.shade600, size: 18),
                              SizedBox(width: 10.w),
                              Text(
                                phone,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.sp,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star_rounded,
                                          color: mainColor, size: 20.r),
                                      SizedBox(width: 8.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rating.toString(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'التقييم',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.07),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.work_outline,
                                          color: mainColor, size: 20.r),
                                      SizedBox(width: 8.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$completedJobs',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'الأعمال',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),
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
                                  textColor: mainColor,
                                  border: mainColor,
                                  icon: SvgPicture.asset(
                                    'assets/phone.svg',
                                    color: mainColor,
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
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.12),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.all(8),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(Icons.workspace_premium_outlined,
                                    size: 20.r, color: mainColor),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'الخبرات',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Column(
                            children: experiences
                                .map(
                                  (exp) => Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: mainColor, size: 18.r),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            exp,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.black87,
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.only(bottom: 18.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.12),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 18, end: 18, top: 18, bottom: 14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsetsDirectional.all(8),
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(Icons.image_outlined,
                                      size: 20.r, color: mainColor),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'الأعمال السابقة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 150.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: previousWorks.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) {
                                final work = previousWorks[index];
                                return Container(
                                  width: 170.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.network(
                                          work['image']!,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.6),
                                              ],
                                            ),
                                          ),
                                          padding: EdgeInsets.all(10.r),
                                          child: Text(
                                            work['title']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
