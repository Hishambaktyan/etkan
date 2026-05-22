import 'dart:ui';

 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/images_view.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../main.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../notifications_screen.dart';
import 'worker_edit_profile.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return BlocBuilder<WorkerCubit,WorkerStates>(
              builder: (context, state) {
                WorkerCubit workerCubit = WorkerCubit.get(context);
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
                                buildQuickStats(cubit: appCubit,user: user,workerCubit:workerCubit ),
                                SizedBox(height: 25.h),
                                buildSectionHeader(
                                    title: 'معلومات التواصل',
                                    icon: SvgPicture.asset('assets/contact.svg',color: mainColor,width: 25.w,),
                                    cubit: appCubit
                                ),
                                SizedBox(height: 10.h),
                                buildContactCard(user: user,cubit: appCubit),
                                SizedBox(height: 20.h),
                                buildSectionHeader(
                                    title: 'نبذة عن العامل',
                                    icon: SvgPicture.asset('assets/info.svg',color: mainColor,width: 25.w,),
                                    cubit: appCubit
                                ),
                                SizedBox(height: 10.h),
                                buildAboutCard(cubit: appCubit,user: user),
                                SizedBox(height: 20.h),
                                buildSectionHeader(
                                    title: 'الخبرات',
                                    icon: SvgPicture.asset('assets/subs.svg',color: mainColor,width: 25.w,),
                                    cubit: appCubit
                                ),
                                SizedBox(height: 10.h),
                                buildExperiencesCard(user: user,cubit:appCubit,experiences: user['experiences'] ??[] ),
                                SizedBox(height: 20.h),
                                buildSectionHeader(
                                    title: 'الأعمال السابقة',
                                    icon: SvgPicture.asset('assets/image.svg',color: mainColor,width: 25.w,),
                                    cubit: appCubit
                                ),
                                SizedBox(height: 10.h),
                                buildPreviousWorksCard(user: user,cubit: appCubit,previousWorks: user['previousWorks'] ?? []),
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
        },
    );
  }


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
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          move(context,  WorkerEditProfileScreen(worker: user,));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/pen.svg',color: Colors.white,),
                              SizedBox(width: 5.w),
                              Text(
                                'تعديل',
                                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
                            backgroundImage: NetworkImage('${user['profileImage'] ?? ''}'),
                            child: user['profileImage']==null
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
                          user['name'] ?? 'الاسم',
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
                            user['specialization'] ?? 'المهنة',
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

  Widget buildQuickStats({
    required Map<String, dynamic> user,
    required WorkerCubit workerCubit,
    required AppCubit cubit
  }) {
    return Row(
      children: [
        buildStatCard(
          cubit: cubit,
          icon: SvgPicture.asset(
            'assets/star.svg',
            color: mainColor,
            width: 30.w,
          ),
          value: '${user['avgRating']}' ?? '',
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
          value: '${workerCubit.workerCompletedRequestsCount}' ?? '',
          title: 'عمل مكتمل',
        ),
      ],
    );
  }

  Widget buildAboutCard({
    required Map<String, dynamic> user,
    required AppCubit cubit
  })
  {
    return buildWhiteCard(
      cubit: cubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${user['about'] ?? 'لا توجد لديك نبذة'}',
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

  Widget buildContactCard({
    required Map<String, dynamic> user,
    required AppCubit cubit
  })
  {
    return buildWhiteCard(
      cubit: cubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(13.r),
            decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.18)
                  : mainColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/phone.svg',
                  color: mainColor,
                  width: 20.r,
                  height: 20.r,
                ),
                SizedBox(width: 10.w),
                Text(
                  '${user['phone'] ?? ''}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 13.sp,
                    letterSpacing: 5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExperiencesCard({
    required Map<String, dynamic> user,
    required AppCubit cubit,
    required List experiences
  })
  {
    return buildWhiteCard(
      cubit: cubit,
      child: experiences.isEmpty? Column(
        children: [
          Icon(Icons.inbox_rounded,color: Colors.grey.shade400,size: 60.w,),
          SizedBox(height: 5.h,),
          Text(
            'لا توجد خبرات سابقة لك',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.grey.shade400
            ),
          ),
        ],
      ) :ListView.builder(
        padding: EdgeInsetsDirectional.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: experiences.length ,
        itemBuilder: (context, index) {
          final experience = experiences[index];
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
                    experience,
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
        },
      )
    );
  }

  Widget buildPreviousWorksCard({
    required Map<String, dynamic> user,
    required List previousWorks,
    required AppCubit cubit
  })
  {
    return buildWhiteCard(
      cubit: cubit,
      child: previousWorks.isEmpty ? Center(
        child: Column(
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
        ),
      )
          :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 165.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsetsDirectional.all(10.w),
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
        ],
      ),
    );
  }
}