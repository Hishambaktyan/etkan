import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:readmore/readmore.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/images_view.dart';
import 'package:trying_homy/modules/worker_screens/worker_edit_service.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerServiceDetails extends StatefulWidget {
  final Map<String,dynamic> service;
   const WorkerServiceDetails({super.key, required this.service});

  @override
  State<WorkerServiceDetails> createState() => _WorkerServiceDetailsState();
}

class _WorkerServiceDetailsState extends State<WorkerServiceDetails> {

  Widget buildSectionTitle({
    required String title,
    required IconData icon,
    required dynamic cubit,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(8.w),
          decoration: BoxDecoration(
            color: cubit.isDark
                ? mainColor.withOpacity(0.2)
                : mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            size: 22.r,
            color: mainColor,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: cubit.isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildServiceActionItem({
    required BuildContext context,
    required AppCubit appCubit,
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.all(14.r),
        decoration: BoxDecoration(
          color: appCubit.isDark
              ? darkBgColor.withOpacity(0.8)
              : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: blueShadow
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              padding: EdgeInsetsDirectional.all(10.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: SvgPicture.asset(icon,color: iconColor,)
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: appCubit.isDark
                          ? darkSubTextColor
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.r,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void showServiceActionsSheet({
    required BuildContext context,
    required Map<String, dynamic> service,
    required AppCubit appCubit,
    required WorkerCubit workerCubit,
  })
  {
    final bool isActive = service['isActive'] ?? true;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 25.h,),
            decoration: BoxDecoration(
              color: appCubit.isDark ? lightDarkColor : Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(10.r),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: SvgPicture.asset('assets/setting.svg',color: mainColor,)
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'إجراءات الخدمة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                buildServiceActionItem(
                  context: context,
                  appCubit: appCubit,
                  icon: isActive ?'assets/eye-slash.svg': 'assets/eye.svg',
                  iconColor: isActive ? Colors.orange : Colors.green,
                  title: isActive ? 'إلغاء تفعيل الخدمة' : 'تفعيل الخدمة',
                  subtitle: isActive
                      ? 'لن تظهر هذه الخدمة للعملاء'
                      : 'ستظهر هذه الخدمة للعملاء',
                  onTap: () {
                    Navigator.pop(context);
                    workerCubit.changeServiceActivity(serviceId: service['id'], value: !isActive,);
                  },
                ),
                SizedBox(height: 10.h),
                buildServiceActionItem(
                  context: context,
                  appCubit: appCubit,
                  icon: 'assets/pen.svg',
                  iconColor: mainColor,
                  title: 'تعديل الخدمة',
                  subtitle: 'تعديل الاسم، السعر، المدة أو الصورة',
                  onTap: () {
                    Navigator.pop(context);
                    move(context, WorkerEditService(service: service),);
                  },
                ),
                SizedBox(height: 10.h),
                buildServiceActionItem(
                  context: context,
                  appCubit: appCubit,
                  icon: 'assets/delete.svg',
                  iconColor: Colors.red,
                  title: 'حذف الخدمة',
                  subtitle: 'حذف الخدمة نهائيًا من قائمة خدماتك',
                  onTap: () {
                    Navigator.pop(context);
                    defaultConfirmDialog(
                        context: context,
                        isDark: appCubit.isDark,
                        icon: 'assets/delete.svg',
                        iconColor: Colors.red,
                        title:'حذف الخدمة',
                        body: 'هل أنت متأكد أنك تريد حذف هذه الخدمة؟ لا يمكن التراجع عن هذا الإجراء.',
                        confirmText: 'حذف',
                        cancelText: 'إلغاء',
                        onConfirm: () {
                          workerCubit.deleteService(
                            serviceId: service['id'],
                          );
                        },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
        builder: (context, state) {
          AppCubit appCubit = AppCubit.get(context);
          return BlocConsumer<WorkerCubit,WorkerStates>(
            listener: (context, state) {
              if (state is DeleteServiceLoadingState) {
                showLoadingDialog(context);
              }
              if (state is DeleteServiceSuccessState) {
                hideLoadingDialog(context);
                showSnackBar(Colors.green, 'تم حذف الخدمة بنجاح', context);

                Navigator.pop(context);
              }
              if (state is DeleteServiceErrorState) {
                hideLoadingDialog(context);
                showSnackBar(Colors.red, state.error, context);
              }
            },
              builder: (context, state) {
                WorkerCubit workerCubit = WorkerCubit.get(context);
                Map<String,dynamic> service = workerCubit.workerServices.firstWhere(
                        (service) =>service['id']==widget.service['id']);
                List<dynamic> reviews = service['reviews'];
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
                                ClipRRect(
                                  borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(15.r)),
                                  child: Image.network(
                                    'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 300.h,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(top: 20.h,start: 10.w,end: 10.w),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsetsDirectional.all(7.w),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 42.r,
                                            height: 42.r,
                                            decoration: BoxDecoration(
                                              color: appCubit.isDark
                                                  ? darkBgColor.withOpacity(0.8)
                                                  : Colors.white.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.6),
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              CupertinoIcons.back,
                                              color: Theme.of(context).iconTheme.color,
                                              size: 24.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:  EdgeInsetsDirectional.all(7.w),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            showServiceActionsSheet(
                                              context: context,
                                              service: service,
                                              appCubit: appCubit,
                                              workerCubit: workerCubit,
                                            );
                                          },
                                          child: Container(
                                            width: 42.r,
                                            height: 42.r,
                                            decoration: BoxDecoration(
                                              color: appCubit.isDark
                                                  ? darkBgColor.withOpacity(0.8)
                                                  : Colors.white.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.6),
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.more_vert_rounded,
                                              color: Theme.of(context).iconTheme.color,
                                              size: 24.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsetsDirectional.all(18.r),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: appCubit.isDark? lightDarkColor: Colors.white,
                                              borderRadius: BorderRadius.circular(25.r),
                                              boxShadow: blueShadow,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: mainColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6.r),
                                                ),
                                                child: Text(
                                                  '${service['category']}',
                                                  style: TextStyle(
                                                    color: appCubit.isDark? Colors.white: Colors.grey.shade700,
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
                                                  color: appCubit.isDark? Colors.white: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 15.h),
                                              Divider(color: appCubit.isDark? darkSubTextColor: Colors.grey.shade300, height: 1),
                                              SizedBox(height: 15.h),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.payments_outlined,
                                                          size: 18.r,
                                                          color:  appCubit.isDark? darkSubTextColor: Colors.grey,                                                  ),
                                                        SizedBox(width: 8.w),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('السعر التقديري',
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color:  appCubit.isDark? darkSubTextColor: Colors.grey,
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
                                                    color:  appCubit.isDark? darkSubTextColor: Colors.grey.shade300,
                                                  ),
                                                  SizedBox(width: 15.w),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.timer_outlined,
                                                          size: 18.r,
                                                          color:  appCubit.isDark? darkSubTextColor: Colors.grey,
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'المدة المتوقعة',
                                                              style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color:  appCubit.isDark? darkSubTextColor: Colors.grey,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${service['period']} دقيقة',
                                                              style: TextStyle(
                                                                color: appCubit.isDark? Colors.white: Colors.black87,
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
                                              SizedBox(height: 10.h,),
                                              Text(
                                                '* السعر النهائي قد يزيد أو ينقص حسب طبيعة الخدمة الفعلية، وحجم العمل المطلوب، وبعد موقع العميل عن مقدم الخدمة',
                                                style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 8.sp
                                                ),

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
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildSectionTitle(title: 'وصف الخدمة', icon: Icons.notes_rounded, cubit: appCubit),
                                SizedBox(height: 10.h,),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsetsDirectional.all(15.r),
                                  decoration: BoxDecoration(
                                      color: appCubit.isDark? lightDarkColor: Colors.white,
                                      borderRadius: BorderRadius.circular(15.r),
                                      boxShadow: blueShadow,
                                  ),
                                  child: Column(
                                    children: [
                                      ReadMoreText(
                                        service['description'],
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color:  appCubit.isDark? Colors.white: Colors.black,
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
                                Row(
                                  children: [
                                    Expanded(child: buildSectionTitle(title: 'التقييم والمراجعة', icon: Icons.star_border_rounded, cubit: appCubit)),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(25.r),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              '${service['rate']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  fontSize: 12.sp,
                                                  height: 1
                                              )
                                          ),
                                          SizedBox(width: 4.w),
                                          const Icon(Icons.star_rounded, color: Colors.orange,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reviews.length,
                                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                                  itemBuilder: (context, index) {
                                    Timestamp? createdAt = reviews[index]['createdAt'];
                                    DateTime? date = createdAt?.toDate();
                                    String reviewDate = date != null
                                        ? DateFormat('yyyy/MM/dd')
                                        .format(date):'';

                                    return Container(
                                      padding: EdgeInsets.all(14.r),
                                      decoration: BoxDecoration(
                                        color: appCubit.isDark? lightDarkColor: Colors.white,
                                        borderRadius: BorderRadius.circular(25.r),
                                        boxShadow: blueShadow,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20.r,
                                                backgroundColor: appCubit.isDark? darkSubTextColor: Colors.blueGrey.shade50,
                                                child: Icon(
                                                    Icons.person_outline,
                                                    size: 20.r,
                                                    color:appCubit.isDark? Colors.white: Colors.blueGrey
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      reviews[index]['userName'],
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 13.sp,
                                                          color: appCubit.isDark? Colors.white: Colors.black
                                                      ),
                                                    ),
                                                    Text(
                                                      reviewDate,
                                                      style: TextStyle(
                                                          color:  appCubit.isDark? darkSubTextColor: Colors.grey,
                                                          fontSize: 11.sp
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: List.generate(5, (i) {
                                                  double rating = (reviews[index]['rating'] ?? 0).toDouble();
                                                  return Icon(
                                                    Icons.star_rounded,
                                                    size: 16.r,
                                                    color: i < rating ? Colors.orange : Colors.grey.shade300,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            reviews[index]['comment'],
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: appCubit.isDark? Colors.white70: Colors.black54,
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
                );
              },
          );
        },
    );
  }
}
