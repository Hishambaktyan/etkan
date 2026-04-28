import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';

import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';

class FavServices extends StatefulWidget {
  const FavServices({super.key});

  @override
  State<FavServices> createState() => _FavServicesState();
}

class _FavServicesState extends State<FavServices> {
  bool isGrid = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context, state) {},
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: ()=>Navigator.pop(context)
                , icon: const Icon(
                Icons.arrow_back_ios_rounded
            )
            ),
            title: Text(
              'الخدمات المفضلة',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold
              ),
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    setState(() {
                      isGrid=!isGrid;
                    });
                  },
                  icon:  isGrid? SvgPicture.asset('assets/list.svg') :SvgPicture.asset('assets/grid.svg')
              )
            ],
            automaticallyImplyLeading: false,
          ),
          body: isGrid? GridView.builder(
            itemCount: 5,
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, bottom: 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 15.h,
              mainAxisExtent: 270
            ),
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                onTap: (){},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppCubit.get(context).isDark ? lightDarkColor : mainColor.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 125.h,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(15.r),
                                topEnd: Radius.circular(15.r),
                              ),
                              child: Image.network(
                                'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                                height: 110.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 110.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(15.r),
                                      topEnd: Radius.circular(15.r),
                                    ),
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: Container(
                                height: 30.h,
                                width: 90.w,
                                alignment: Alignment.center,
                                margin: EdgeInsetsDirectional.only(end: 10.w),
                                padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 7.w),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Text(
                                  '${25000} $reyalSymbol',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,color: Colors.orange,
                                ),
                                SizedBox(width: 5.w,),
                                Text(
                                  '${3.8}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h,),
                            Text(
                              'تنظيف تكييف مركزي',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            Row(
                              children: [
                                CircleAvatar(
                                  foregroundImage: const NetworkImage(
                                    'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg',
                                  ),
                                  radius: 15.r,
                                ),
                                SizedBox(width: 5.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${'عبد الله عبد الفتاح'}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      Text(
                                        '${'فني تكييف'}',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              :ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.only(start:15.w,end: 15.w,bottom: 20.h),
            itemBuilder: (context, index) {
              // var service = userServicesCubit.userElecServices[index];
              // var providerData = cubit.allUsers[service['providerId']];
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                onTap: (){},/*move(context, ServiceDetails(
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
                    color: AppCubit.get(context).isDark ? lightDarkColor : mainColor.withOpacity(0.1),
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
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(15.r),
                                  topEnd: Radius.circular(15.r),
                                ),
                                color: Colors.grey.shade200
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 10.w,end: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'تنظيف تكييف مركزي',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 7.w),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.r),
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
                            SizedBox(height: 5.h,),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,color: Colors.orange,
                                ),
                                SizedBox(width: 5.w,),
                                Text(
                                  '${3.8}',
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Row(
                              children: [
                                CircleAvatar(
                                  foregroundImage: const NetworkImage(
                                      'https://i.pinimg.com/1200x/47/91/f0/4791f027dcad85f85883359daf191c5d.jpg'
                                  ),
                                  radius: 20.r,
                                ),
                                SizedBox(width: 10.w,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        '${'عبد الله عبد الفتاح'}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.sp
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${'فني تكييف'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey
                                      ),
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
              height: 15.h,
            ),
          ),
        ),
      );
    },
    );
  }
}
