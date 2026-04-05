  import 'dart:ui';
  import 'package:animated_text_kit/animated_text_kit.dart';
  import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/svg.dart';
  import 'package:trying_homy/modules/search_screen.dart';
  import 'package:trying_homy/modules/user_screens/services_list.dart';
  import 'package:trying_homy/modules/user_screens/service_details.dart';
  import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
  import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_states.dart';
  import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
  import '../../main.dart';
  import '../../shared/compenents/components.dart';
  import '../../shared/cubits/app_cubit/app_states.dart';
  import '../../shared/styles/colors.dart';
  import '../worker_screens/add_service.dart';

  class HomeScreen extends StatefulWidget {
     const HomeScreen({super.key});
    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }
  class _HomeScreenState extends State<HomeScreen> {
    final List<Map<String, String>> services = [
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
   void initState(){
      AppCubit.get(context).getAllUsers();
    super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
              return  Scaffold(
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: BlocBuilder<UserServicesCubit,UserServicesStates>(
                    builder: (context, state) {
                      UserServicesCubit userServicesCubit = UserServicesCubit.get(context);
                      return ConditionalBuilder(
                        condition: state is GetUserAllServicesLoadingState,
                        builder: (context) => UserHomeShimmer(isDark: appCubit.isDark),
                        fallback: (context) => SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(30.r)),
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
                                          stops: const [
                                            0.0,
                                            0.8,
                                          ]
                                      )
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
                                          padding: EdgeInsetsDirectional.only(top: 30.h,start: 10.w,end: 10.w,bottom: 20.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/loc.svg'
                                                    ,color: Colors.white,
                                                    width: 35.w,
                                                    height: 35.h,
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'موقعك',
                                                        style:  TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 13.sp,
                                                            color: Colors.white,
                                                            height: 1
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(
                                                        'عدن - المنصورة - ريمي',
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors.white,
                                                            height: 1
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    highlightColor: Colors.transparent,
                                                    splashColor: Colors.transparent,
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsetsDirectional.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(10.r),
                                                      ),
                                                      child: SvgPicture.asset(
                                                        'assets/not.svg',
                                                        width: 23.w,
                                                        height: 23.h,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                borderRadius: BorderRadius.circular(15.r),
                                                onTap: ()=>move(context,
                                                     BlocProvider.value(
                                                        value: BlocProvider.of<UserServicesCubit>(context),
                                                      child: const SearchScreen(),
                                                    ),
                                                ),
                                                child: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.symmetric(horizontal: 17),
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
                                                          child: IgnorePointer(
                                                            child: SizedBox(
                                                              height: 20,
                                                              child: AnimatedTextKit(
                                                                repeatForever: true,
                                                                pause: const Duration(seconds: 2),
                                                                animatedTexts: [
                                                                  TyperAnimatedText("ابحث عن خدمات",textStyle: const TextStyle(color: Colors.grey)),
                                                                  TyperAnimatedText("ابحث عن أقسام",textStyle: const TextStyle(color: Colors.grey)),
                                                                  TyperAnimatedText("ابحث عن فني تكييف",textStyle: const TextStyle(color: Colors.grey)),
                                                                  TyperAnimatedText("ابحث عن كهربائي",textStyle: const TextStyle(color: Colors.grey)),
                                                                  TyperAnimatedText("ابحث عن سبّاك",textStyle: const TextStyle(color: Colors.grey)),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h,),
                              Column(
                                children: [
                                  /*بانر ترحيبي*/
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: Container(
                                        height: 140.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              mainColor,
                                              mainColor.withOpacity(0.8),
                                            ],
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              right: -25,
                                              top: -25,
                                              child: CircleAvatar(
                                                radius: 45.r,
                                                backgroundColor: Colors.white.withOpacity(0.12),
                                              ),
                                            ),
                                            Positioned(
                                              left: 20,
                                              bottom: -25,
                                              child: CircleAvatar(
                                                radius: 30.r,
                                                backgroundColor: Colors.white.withOpacity(0.10),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'أهلا بك 👋',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17.sp,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        Text(
                                                          'ابحث عن أفضل العمال والخدمات',
                                                          style: TextStyle(
                                                            color: Colors.white.withOpacity(0.9),
                                                            fontSize: 13.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    radius: 40.r,
                                                    backgroundColor: Colors.white.withOpacity(0.2),
                                                    child: Transform.rotate(
                                                      angle: -0.2,
                                                      child: SvgPicture.asset(
                                                        'assets/ticket_bold.svg',
                                                        color: Colors.white,
                                                        width: 50.w,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h,),
                                  /*الأقسام*/
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'الأقسام',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp
                                              ),
                                            ),
                                            const Spacer(),
                                            TextButton(
                                              onPressed: ()=>appCubit.changeIndex(1),
                                              child: const Text(
                                                  'عرض الكل'
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h,),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          padding:EdgeInsetsDirectional.zero,
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
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              borderRadius: BorderRadius.circular(15.r),
                                              onTap: ()=>move(context, BlocProvider.value(
                                                value: BlocProvider.of<UserServicesCubit>(context),
                                                child: ServicesList(categoryType: services[index]['type']!,),
                                              )
                                              ),
                                              child: Container(
                                                padding: const EdgeInsetsDirectional.all(10),
                                                decoration: BoxDecoration(
                                                    color: mainColor.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(15.r)
                                                ),
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
                                                        services[index]['icon']!,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Text(
                                                      services[index]['name']!,
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h,),
                                  /*الخدمات الرائجة*/
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                                        child: Row(
                                          children: [
                                            Text(
                                              'الخدمات الرائجة',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h,),
                                      SizedBox(
                                        height: 320.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsetsDirectional.only(start:15.w),
                                          itemCount: 4,
                                          itemBuilder: (context, index){
                                            var service = userServicesCubit.userServices[index];
                                            var providerData = userServicesCubit.allUsers[service['providerId']];
                                            return Padding(
                                              padding: EdgeInsetsDirectional.only(start: index==0?0:15.w,end: index==3?15.w:0),
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
                                  SizedBox(height: 20.h,),
                                  /*اعلان نشر حدمة*/
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(15.r),topEnd:Radius.circular(15.r) ),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              mainColor,
                                              mainColor.withOpacity(0.7),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: mainColor.withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              right: -20,
                                              top: -20,
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white.withOpacity(0.1),
                                              ),
                                            ),
                                            Positioned(
                                              left: 30,
                                              bottom: -30,
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.white.withOpacity(0.1),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(20.r),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'لم تجد الخدمة المناسبة؟',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.sp,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.h),
                                                        Text(
                                                          'يمكنك نشر إعلان لخدمتك الآن لتصل إلى العمال المهتمين',
                                                          style: TextStyle(
                                                            color: Colors.white.withOpacity(0.9),
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15.h),
                                                        ElevatedButton(
                                                          onPressed: () => move(context, const AddService()),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.white,
                                                            foregroundColor: mainColor,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.r),
                                                            ),
                                                            elevation: 0,
                                                          ),
                                                          child: const Text('نشر إعلان الخدمة'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.campaign_rounded,
                                                    size: 70.r,
                                                    color: Colors.white.withOpacity(0.3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              );
            },
      );
    }
  }