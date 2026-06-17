import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:readmore/readmore.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/worker_screens/worker_edit_service.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:Etkan/shared/cubits/worker_cubit/worker_states.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/styles/colors.dart';

class WorkerServiceDetails extends StatefulWidget {
  final Map<String, dynamic> service;
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

  Widget buildWorkerReviewsCard({
    required AppCubit appCubit,
    required WorkerCubit workerCubit,
    required WorkerStates state,
  }) {
    if (state is GetWorkerServiceReviewsLoadingState) {
      return Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(25.r),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: blueShadow,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: mainColor,
          ),
        ),
      );
    }

    if (state is GetWorkerServiceReviewsErrorState) {
      return Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(18.r),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: Colors.red.withOpacity(0.2),
          ),
        ),
        child: Text(
          state.error,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> reviews = workerCubit.workerServiceReviews;

    final double rate = workerCubit.workerServiceRate;
    final int reviewsCount = workerCubit.workerServiceReviewsCount;

    return Container(
      padding: EdgeInsetsDirectional.all(10.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.withOpacity(0.15),
            radius: 35.r,
            child: Text(
              rate.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                Icons.star_rounded,
                size: 18.r,
                color:
                    index < rate.round() ? Colors.orange : Colors.grey.shade300,
              );
            }),
          ),
          SizedBox(height: 6.h),
          Text(
            '$reviewsCount مراجعة',
            style: TextStyle(
              fontSize: 11.sp,
              color: appCubit.isDark ? darkSubTextColor : Colors.grey,
            ),
          ),
          SizedBox(height: 10.h),
          if (reviews.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(14.r),
              decoration: BoxDecoration(
                color: appCubit.isDark
                    ? darkBgColor
                    : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                'لا توجد مراجعات حتى الآن',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: appCubit.isDark ? darkSubTextColor : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.zero,
              itemCount: reviews.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final Map<String, dynamic> review = reviews[index];

                final Timestamp? createdAt = review['createdAt'] is Timestamp
                    ? review['createdAt']
                    : null;

                final String reviewDate = createdAt != null
                    ? DateFormat('yyyy/MM/dd').format(createdAt.toDate())
                    : '';

                final double rating =
                    double.tryParse('${review['rating'] ?? 0}') ?? 0.0;

                final String reviewText = '${review['review'] ?? ''}';

                final String customerName =
                    '${review['customerName'] ?? 'مستخدم'}';

                final String customerImage = '${review['customerImage'] ?? ''}';

                return Container(
                  padding: EdgeInsetsDirectional.all(10.r),
                  decoration: BoxDecoration(
                    color: appCubit.isDark
                        ? darkBgColor
                        : Colors.grey.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: mainColor.withOpacity(0.1),
                            backgroundImage: customerImage.isNotEmpty
                                ? NetworkImage(customerImage)
                                : null,
                            child: customerImage.isEmpty
                                ? Icon(
                                    Icons.person_outline_rounded,
                                    color: mainColor,
                                    size: 20.r,
                                  )
                                : null,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: appCubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                if (reviewDate.isNotEmpty)
                                  Text(
                                    reviewDate,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: appCubit.isDark
                                          ? darkSubTextColor
                                          : Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                Icons.star_rounded,
                                size: 15.r,
                                color: i < rating
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                              );
                            }),
                          ),
                        ],
                      ),
                      if (reviewText.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        Text(
                          reviewText,
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.5,
                            color: appCubit.isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
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
            boxShadow: blueShadow),
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
                child: SvgPicture.asset(
                  icon,
                  color: iconColor,
                )),
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
  }) {
    final BuildContext parentContext = context;
    final bool isActive = service['isActive'] ?? true;

    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsetsDirectional.only(
            start: 10.w,
            end: 10.w,
            top: 10.h,
            bottom: 25.h,
          ),
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
                      child: SvgPicture.asset(
                        'assets/setting.svg',
                        color: mainColor,
                      )),
                  SizedBox(width: 10.w),
                  Text(
                    'إجراءات الخدمة',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(parentContext).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              buildServiceActionItem(
                context: parentContext,
                appCubit: appCubit,
                icon: isActive ? 'assets/eye-slash.svg' : 'assets/eye.svg',
                iconColor: isActive ? Colors.orange : Colors.green,
                title: isActive ? 'إلغاء تفعيل الخدمة' : 'تفعيل الخدمة',
                subtitle: isActive
                    ? 'لن تظهر هذه الخدمة للعملاء'
                    : 'ستظهر هذه الخدمة للعملاء',
                onTap: () {
                  Navigator.pop(sheetContext);
                  workerCubit.changeServiceActivity(
                    serviceId: service['id'],
                    value: !isActive,
                  );
                },
              ),
              SizedBox(height: 10.h),
              buildServiceActionItem(
                context: parentContext,
                appCubit: appCubit,
                icon: 'assets/pen.svg',
                iconColor: mainColor,
                title: 'تعديل الخدمة',
                subtitle: 'تعديل الاسم، السعر، المدة أو الصورة',
                onTap: () {
                  Navigator.pop(sheetContext);
                  move(
                    parentContext,
                    WorkerEditService(service: service),
                  );
                },
              ),
              SizedBox(height: 10.h),
              buildServiceActionItem(
                context: parentContext,
                appCubit: appCubit,
                icon: 'assets/delete.svg',
                iconColor: Colors.red,
                title: 'حذف الخدمة',
                subtitle: 'حذف الخدمة نهائيًا من قائمة خدماتك',
                onTap: () {
                  Navigator.pop(sheetContext);

                  Future.delayed(const Duration(milliseconds: 150), () {
                    if (!mounted) return;

                    defaultConfirmDialog(
                      context: parentContext,
                      isDark: appCubit.isDark,
                      icon: 'assets/delete.svg',
                      iconColor: Colors.red,
                      title: 'حذف الخدمة',
                      body:
                          'هل أنت متأكد أنك تريد حذف هذه الخدمة؟ لا يمكن التراجع عن هذا الإجراء.',
                      confirmText: 'حذف',
                      cancelText: 'إلغاء',
                      onConfirm: () {
                        Navigator.pop(parentContext);

                        workerCubit.deleteService(
                          serviceId: service['id'],
                        );
                      },
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String serviceId =
          '${widget.service['id'] ?? widget.service['serviceId'] ?? ''}';

      if (serviceId.isNotEmpty) {
        WorkerCubit.get(context).getWorkerServiceReviews(
          serviceId: serviceId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocConsumer<WorkerCubit, WorkerStates>(
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
            if (state is GetWorkerServiceReviewsErrorState) {
              showSnackBar(
                Colors.red,
                state.error,
                context,
              );
            }
          },
          builder: (context, state) {
            WorkerCubit workerCubit = WorkerCubit.get(context);
            final String currentServiceId = '${widget.service['id'] ?? widget.service['serviceId'] ?? ''}';

            final int serviceIndex = workerCubit.workerServices.indexWhere(
              (service) {
                final String id = '${service['id'] ?? service['serviceId'] ?? ''}';
                return id == currentServiceId;
              },
            );

            if (serviceIndex == -1) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(20.r),
                    child: Text(
                      'تم حذف الخدمة أو لم تعد موجودة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }

            Map<String, dynamic> service = Map<String, dynamic>.from(
                workerCubit.workerServices[serviceIndex]);

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 400.h,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusDirectional.vertical(
                                bottom: Radius.circular(15.r)),
                            child: Image.network(
                              '${service['serviceImage'] ?? ''}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 300.h,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                top: 35.h, start: 10.w, end: 10.w),
                            child: Row(
                              children: [
                                buildButton(
                                  context: context,
                                  isDark: appCubit.isDark,
                                  icon: Icons.arrow_back_ios_new_rounded,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const Spacer(),
                                buildButton(
                                  context: context,
                                  isDark: appCubit.isDark,
                                  icon: Icons.more_vert_rounded,
                                  onTap: () {
                                    showServiceActionsSheet(
                                      context: context,
                                      service: service,
                                      appCubit: appCubit,
                                      workerCubit: workerCubit,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.all(18.r),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: appCubit.isDark
                                          ? lightDarkColor
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(25.r),
                                      boxShadow: blueShadow,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: mainColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            '${service['category']}',
                                            style: TextStyle(
                                              color: appCubit.isDark
                                                  ? Colors.white
                                                  : Colors.grey.shade700,
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
                                            color: appCubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        Divider(
                                            color: appCubit.isDark
                                                ? darkSubTextColor
                                                : Colors.grey.shade300,
                                            height: 1),
                                        SizedBox(height: 15.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.payments_outlined,
                                                    size: 18.r,
                                                    color: appCubit.isDark
                                                        ? darkSubTextColor
                                                        : Colors.grey,
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'السعر التقديري',
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: appCubit
                                                                  .isDark
                                                              ? darkSubTextColor
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${service['price']} $reyalSymbol',
                                                        style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                              color: appCubit.isDark
                                                  ? darkSubTextColor
                                                  : Colors.grey.shade300,
                                            ),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.timer_outlined,
                                                    size: 18.r,
                                                    color: appCubit.isDark
                                                        ? darkSubTextColor
                                                        : Colors.grey,
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'المدة المتوقعة',
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: appCubit
                                                                  .isDark
                                                              ? darkSubTextColor
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${service['period']} دقيقة',
                                                        style: TextStyle(
                                                          color: appCubit
                                                                  .isDark
                                                              ? Colors.white
                                                              : Colors
                                                                  .black87,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          '* السعر النهائي قد يزيد أو ينقص حسب طبيعة الخدمة الفعلية، وحجم العمل المطلوب، وبعد موقع العميل عن مقدم الخدمة',
                                          style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 8.sp),
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
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSectionTitle(
                              title: 'وصف الخدمة',
                              icon: Icons.notes_rounded,
                              cubit: appCubit),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsetsDirectional.all(15.r),
                            decoration: BoxDecoration(
                              color: appCubit.isDark
                                  ? lightDarkColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: blueShadow,
                            ),
                            child: Column(
                              children: [
                                ReadMoreText(
                                  service['description'],
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: appCubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      height: 1.5),
                                  trimLines: 3,
                                  colorClickableText: mainColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' عرض المزيد',
                                  trimExpandedText: ' عرض أقل',
                                  moreStyle: TextStyle(
                                      fontSize: 12.sp, color: mainColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          buildSectionTitle(
                            title: 'التقييم والمراجعة',
                            icon: Icons.star_border_rounded,
                            cubit: appCubit,
                          ),
                          SizedBox(height: 10.h),
                          buildWorkerReviewsCard(
                            appCubit: appCubit,
                            workerCubit: workerCubit,
                            state: state,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
