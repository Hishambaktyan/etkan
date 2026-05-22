import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../images_view.dart';

class UserWorkerProfile extends StatefulWidget {
  const UserWorkerProfile({super.key});

  @override
  State<UserWorkerProfile> createState() => _UserWorkerProfileState();
}

class _UserWorkerProfileState extends State<UserWorkerProfile> {

  final String workerName = 'هادي محمد';
  final String workerSpec = 'كهربائي';
  final String phone = '778830326';
  final double rating = 4.8;
  final int completedJobs = 37;
  final String workerImage = 'https://d26e3f10zvrezp.cloudfront.net/Gallery/d72c67af-9f10-4d9d-b3db-fdc1647e6acc-1024x1024.webp';

  final String coverImage = 'https://img.pikbest.com/photo/20241027/rear-view-of-two-female-multiracial-electrical-workers-dressed_11011952.jpg!bw700';

  final String about = 'فني محترف في أعمال الكهرباء والصيانة المنزلية، أمتلك خبرة واسعة في تركيب الإنارة، إصلاح الأعطال، وتمديدات الكهرباء للمنازل والمحلات، وأهتم بجودة العمل والالتزام بالمواعيد.';

  final List<String> experiences = [
    'خبرة أكثر من 5 سنوات في الصيانة الكهربائية',
    'تركيب وصيانة لوحات الكهرباء',
    'إصلاح التماس والأعطال المنزلية',
    'تمديدات كهربائية للمنازل والمكاتب',
  ];

  final List<String> previousWorks = [

    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?q=80&w=1200&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1517048676732-d65bc937f952?q=80&w=1200&auto=format&fit=crop'
  ];

  Widget buildSectionHeader({
    required String title,
    required Widget icon,
    required AppCubit cubit,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.r),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.20)
                : mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: icon,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }

  Widget buildWhiteCard({
    required Widget child,
    required AppCubit cubit,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsetsDirectional.all(18.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : null,
        boxShadow: cubit.isDark ? [] : blueShadow,
      ),
      child: child,
    );
  }

  Widget buildStatCard({
    required Widget icon,
    required String value,
    required String title,
    required AppCubit cubit,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.all(15.w),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: cubit.isDark
              ? Border.all(color: const Color(0xFF30363D))
              : null,
          boxShadow: cubit.isDark ? [] : blueShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const Spacer(),
                icon,
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required AppCubit appCubit,
    required Map<String, dynamic> user,
  }) {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.vertical(
        bottom: Radius.circular(35.r),
      ),
      child: Container(
        width: double.infinity,
        height: 300.h,
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
            Padding(
              padding: EdgeInsetsDirectional.only(top: 35.h, start: 5.w, end: 18.w,),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed:()=>Navigator.pop(context),
                          icon: const Icon(CupertinoIcons.back,color: Colors.white,)
                      ),
                      Text(
                        'الحساب',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 98.r,
                          height: 98.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 48.r,
                            backgroundColor: Colors.white.withOpacity(0.12),
                            backgroundImage:
                            workerImage.isNotEmpty ? NetworkImage(workerImage) : null,
                            child: workerImage.isEmpty
                                ? Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 48.r,
                            )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          workerName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Container(
                          padding: EdgeInsetsDirectional.only(start: 12.w,end: 15.w,top: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            workerSpec,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickStats(AppCubit cubit) {
    return Row(
      children: [
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/star.svg',
            color: mainColor,
            width: 30.w,
          ),
          value: rating.toString(),
          title: 'التقييم',
        ),
        SizedBox(width: 15.w),
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/services.svg',
            color: mainColor,
            width: 30.w,
          ),
          value: '$completedJobs',
          title: 'عمل مكتمل',
        ),
      ],
    );
  }

  Widget buildAboutCard(AppCubit cubit) {
    return buildWhiteCard(
      cubit: cubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            about,
            style: TextStyle(
              fontSize: 12.sp,
              color: cubit.isDark ? darkSubTextColor : Colors.black87,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactCard(AppCubit cubit) {
    return buildWhiteCard(
      cubit: cubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: defaultButtonWithIcon(
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
                child: defaultOutlinedButtonWithIcon(
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
    );
  }

  Widget buildExperiencesCard(AppCubit cubit) {
    return buildWhiteCard(
      cubit: cubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: experiences.map((exp) {
              return Padding(
                padding: EdgeInsetsDirectional.only(bottom: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(3.r),
                      decoration: BoxDecoration(
                        color: cubit.isDark
                            ? mainColor.withOpacity(0.20)
                            : mainColor.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: mainColor,
                        size: 14.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        exp,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: cubit.isDark ? darkSubTextColor : Colors.black87,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildPreviousWorksCard(AppCubit cubit) {
    return buildWhiteCard(
      cubit: cubit,
      padding: EdgeInsetsDirectional.only(bottom: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 10.w,
              end: 18.w,
              top: 18.h,
              bottom: 14.h,
            ),
            child: SizedBox(
              height: 155.h,
              child: previousWorks.isEmpty ? Column(
                children: [
                  Icon(Icons.inbox_rounded,color: Colors.grey.shade400,size: 60.w,),
                  SizedBox(height: 5.h,),
                  Text(
                    'لا توجد أعمال سابقة لك',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.grey.shade400
                    ),
                  ),
                ],
              ) : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: previousWorks.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final work = previousWorks[index];
                  return InkWell(
                    onTap: () => move(context, ImageViewerPage(imageUrl: work),),
                    child: Container(
                      width: 175.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: cubit.isDark
                            ? darkBgColor
                            : Colors.grey.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.network(
                          work,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: cubit.isDark
                                  ? darkBgColor
                                  : Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: cubit.isDark
                                    ? darkSubTextColor
                                    : Colors.grey,
                                size: 35.r,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        Map<String, dynamic> user = appCubit.allUsers[CacheHelper.getData(key: 'uid')] ?? {};
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader(appCubit:appCubit,user: user ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 20.h, bottom: 20.h,),
                    child: Column(
                      children: [
                        buildQuickStats(appCubit),
                        SizedBox(height: 25.h),
                        buildSectionHeader(
                            title: 'معلومات التواصل',
                            icon: SvgPicture.asset('assets/contact.svg',color: mainColor,width: 25.w,),
                            cubit: appCubit
                        ),
                        SizedBox(height: 10.h),
                        buildContactCard(appCubit),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                            title: 'نبذة عن العامل',
                            icon: SvgPicture.asset('assets/info.svg',color: mainColor,width: 25.w,),
                            cubit: appCubit
                        ),
                        SizedBox(height: 10.h),
                        buildAboutCard(appCubit),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                            title: 'الخبرات',
                            icon: SvgPicture.asset('assets/subs.svg',color: mainColor,width: 25.w,),
                            cubit: appCubit
                        ),
                        SizedBox(height: 10.h),
                        buildExperiencesCard(appCubit),
                        SizedBox(height: 20.h),
                        buildSectionHeader(
                            title: 'الأعمال السابقة',
                            icon: SvgPicture.asset('assets/image.svg',color: mainColor,width: 25.w,),
                            cubit: appCubit
                        ),
                        SizedBox(height: 10.h),
                        buildPreviousWorksCard(appCubit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
