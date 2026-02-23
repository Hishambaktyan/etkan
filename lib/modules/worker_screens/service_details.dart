import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/images_view.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/cubit/states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,States>(
        listener: (context, state) {},
        builder: (context, state) {
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
                                          cubit.isServicesActive=!cubit.isServicesActive;
                                          print(cubit.isServicesActive);
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: shadow,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            'سباكة  >  تركيب أدوات صحية',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          'تركيب حوض حمام جداري (معلق) رخامي ابيض',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        Divider(color: Colors.grey.shade100, height: 1),
                                        SizedBox(height: 15.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.payments_outlined, size: 18.r, color: Colors.grey),
                                                  SizedBox(width: 8.w),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('السعر التقديري',
                                                          style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                                                      Text(
                                                        '15000 $reyalSymbol',
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
                                            Container(height: 30.h, width: 1, color: Colors.grey.shade100),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.timer_outlined, size: 18.r, color: Colors.grey),
                                                  SizedBox(width: 8.w),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('المدة المتوقعة',
                                                          style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                                                      Text(
                                                        '45 دقيقة',
                                                        style: TextStyle(
                                                          color: Colors.black87,
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
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.description_outlined, size: 20.r, color: mainColor),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'وصف الخدمة',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: 10.h
                                ),
                                ReadMoreText(
                                  'خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات',
                                  style: TextStyle(fontSize: 12.sp, color: Colors.black87, height: 1.5),
                                  trimLines: 3,
                                  colorClickableText: mainColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' عرض المزيد',
                                  trimExpandedText: ' عرض أقل',
                                  moreStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: mainColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 24.h
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                    Icons.star_outline_rounded,
                                    size: 22.r,
                                    color: mainColor
                                ),
                              ),
                              SizedBox(
                                  width: 10.w
                              ),
                              Text(
                                'التقييمات والمراجعات',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    Text('3.3', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 13.sp)),
                                    SizedBox(width: 4.w),
                                    Icon(Icons.star_rounded, color: Colors.orange, size: 16.r),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            separatorBuilder: (context, index) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(14.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(color: Colors.grey.shade100),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: Colors.blueGrey.shade50,
                                          child: Icon(Icons.person_outline, size: 20.r, color: Colors.blueGrey),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'أحمد خالد',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                                              ),
                                              Text(
                                                'منذ يومين',
                                                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(5, (i) => Icon(
                                            Icons.star_rounded,
                                            size: 16.r,
                                            color: i < 4 ? Colors.orange : Colors.grey.shade300,
                                          )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'شغل ممتاز وسريع جداً، التزم بالمواعيد وكان محترم جداً في التعامل. أنصح به بشدة.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                
                  ],
                ),
              ),
            ),
          ) ;
        },
    );
  }
}
