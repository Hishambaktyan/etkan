import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:trying_homy/modules/user_screens/dept_screen.dart';
import 'package:trying_homy/modules/user_screens/service_details.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_states.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = [
    'تركيب مكيفات سبليت',
    'صيانة تسربات الحمام',
    'دهانات جوتن داخلية',
  ];
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final List<Map<String, String>> servicesDepts = [
    {
      "name": "الكهرباء",
      "icon": "assets/SVGs/E.svg",
      "type":"كهرباء"
    },
    {
      "name": "السباكة",
      "icon": "assets/SVGs/P.svg",
      "type":"سباكة"
    },
    {
      "name": "البناء",
      "icon": "assets/SVGs/C.svg",
      "type":"بناء"
    },
    {
      "name": "التكييف",
      "icon": "assets/SVGs/AC.svg",
      "type":"تكييف"
    },
    {
      "name": "الحدادة",
      "icon": "assets/SVGs/A.svg",
      "type":"حدادة"
    },
    {
      "name": "الماء",
      "icon": "assets/SVGs/WT.svg",
      "type":"ماء"
    },
    {
      "name": "النجارة",
      "icon": "assets/SVGs/CA.svg",
      "type":"نجارة"
    },
    {
      "name": "الدهان",
      "icon": "assets/SVGs/PA.svg",
      "type":"دهان"
    },
  ];


  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: BlocBuilder<UserServicesCubit,UserServicesStates>(
                builder:(context, state) {
                  UserServicesCubit userServicesCubit = UserServicesCubit.get(context);
                  List<Map<String,dynamic>> services = List.of(userServicesCubit.userServices);
                  services.shuffle();
                  List<Map<String,dynamic>> selectedServices = services.take(4).toList();
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusDirectional.vertical(
                            bottom: Radius.circular(30.r)),
                        child: Container(
                          height: 160.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                mainColor.withOpacity(0.9),
                                const Color(0xFF0F0F1E),
                              ],
                              stops: const [0.0, 0.8],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -50.h,
                                left: -50.w,
                                child: CircleAvatar(
                                  radius: 100.r,
                                  backgroundColor: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              Positioned(
                                top: 80.h,
                                right: -60.w,
                                child: Container(
                                  width: 250.r,
                                  height: 250.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFF00F2FF).withOpacity(0.5),
                                        const Color(0xFF00F2FF).withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 200.h,
                                left: -40.w,
                                child: Container(
                                  width: 200.r,
                                  height: 200.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        mainColor.withOpacity(0.4),
                                        mainColor.withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.topCenter,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(top: 30.h, start: 10.w, end: 10.w, bottom: 20.h,),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: ()=>Navigator.pop(context),
                                              icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)
                                          ),
                                          Text(
                                            'البحث',
                                            style: TextStyle(
                                                fontSize: 23.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 50.h,
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 17),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/search.svg',
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: TextFormField(
                                                controller: searchController,
                                                focusNode: searchFocusNode,
                                                autofocus: true,
                                                textInputAction: TextInputAction.search,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'ابحث عن خدمات أو فنيين',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.sp,
                                                  ),
                                                  border: InputBorder.none,
                                                  isCollapsed: true,
                                                ),
                                                onFieldSubmitted: (value) {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(end: 15.w, start: 15.w, top: 5.h, bottom: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'عمليات البحث الأخيرة',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                defaultTextButton(
                                    onPressed: (){},
                                    text: 'مسح الكل',
                                    isBold: true,
                                    isLined: false
                                )
                              ],
                            ),
                            SizedBox(height: 10.h),
                            recentSearches.isNotEmpty? ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recentSearches.length,
                              separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  height: 1.h,
                                ),
                              ),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          recentSearches.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.blueGrey.shade200,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        recentSearches[index],
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Icon(
                                      Icons.history,
                                      color: Colors.blueGrey.shade200,
                                      size: 18,
                                    ),
                                  ],
                                );
                              },
                            ) : Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Center(
                                child: Text(
                                  'لا توجد عمليات بحث أخيرة',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'الأقسام الشائعة',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.zero,
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
                                  borderRadius: BorderRadius.circular(15.r),
                                  onTap: ()=>move(context,
                                      BlocProvider.value(
                                          value: BlocProvider.of<UserServicesCubit>(context),
                                        child: const DeptScreen(),
                                      )
                                  ),
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
                                            servicesDepts[index]['icon']!,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          servicesDepts[index]['name']!,
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
                            SizedBox(height: 20.h),
                            Text(
                              'خدمات مقترحة لك',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 320.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedServices.length,
                                itemBuilder: (context, index){
                                  var service = selectedServices[index];
                                  var providerData = userServicesCubit.allUsers[service['providerId']];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(start: index==0?0:15.w),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: ()=>move(context, ServiceDetails(
                                        name: service['name'] ,
                                        image: service['serviceImage'],
                                        category: service['category'] ,
                                        subCategory: service['subCategory'] ,
                                        desc: service['description'] ,
                                        price: service['price'] ,
                                        period: service['period'] ,
                                        rate: service['rate'] ,
                                        providerName: providerData['name'],
                                        providerSpec: providerData['specialization'],
                                        reviews: service['reviews'],
                                        providerId: providerData['uid'],
                                      )),
                                      child: Container(
                                        width: 300.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.r),
                                          color: appCubit.isDark ? lightDarkColor : mainColor.withOpacity(0.1),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.r),
                                                  child: Image.network(
                                                    '${service['serviceImage']}',
                                                    height: 160.h,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                      height: 160.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15.r),
                                                          color: Colors.grey.shade200
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: AlignmentDirectional.topStart,
                                                  child: Container(
                                                    width: 80.w,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsetsDirectional.only(top: 10.h,start: 10.w),
                                                    padding: EdgeInsetsDirectional.symmetric(vertical: 3.h,horizontal: 5.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.5),
                                                      border: Border.all(color: Colors.white),
                                                      borderRadius: BorderRadius.circular(30.r),
                                                    ),
                                                    child: Text(
                                                      '${service['category']}',
                                                      style: TextStyle(
                                                        color:mainColor,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                                          service['name'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14.sp,
                                                            color: appCubit.isDark ? Colors.white : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsetsDirectional.symmetric(vertical: 2.h,horizontal: 7.w),
                                                        decoration: BoxDecoration(
                                                          color: mainColor,
                                                          border: Border.all(color: Colors.white),
                                                          borderRadius: BorderRadius.circular(30.r),
                                                        ),
                                                        child: Text(
                                                          '${service['price']} $reyalSymbol',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12.sp,
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
                                                        '${service['rate']}',
                                                        style: const TextStyle(
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
                                                              '${providerData['name']}',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 12.sp
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '${providerData['specialization']}',
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },)
            ),
          );
        },
    );
  }
}
