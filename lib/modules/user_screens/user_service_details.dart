import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:readmore/readmore.dart';
import 'package:trying_homy/modules/user_screens/user_complete_request_info.dart';
import 'package:trying_homy/modules/user_screens/user_worker_profile.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import '../../main.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/user_cubit/user_cubit.dart';
import '../../shared/cubits/user_cubit/user_states.dart';
import '../../shared/styles/colors.dart';

class UserServiceDetails extends StatefulWidget {
  final String category;
  final String name;
  final String image;
  final int price;
  final String period;
  final String desc;
  final String providerName;
  final String providerSpec;
  final dynamic reviews;
  final String providerId;
  final String serviceId;

  const UserServiceDetails({
    super.key,
    required this.category,
    required this.name,
    required this.price,
    required this.period,
    required this.desc,
    required this.providerName,
    required this.providerSpec,
    required this.reviews,
    required this.providerId,
    required this.image,
    required this.serviceId,
  });

  @override
  State<UserServiceDetails> createState() => _UserServiceDetailsState();
}

class _UserServiceDetailsState extends State<UserServiceDetails> {
  final TextEditingController commentController = TextEditingController();
  double userRating = 0;

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

  Widget buildReviewsCard({
    required AppCubit cubit,
    required UserCubit userCubit,
    required UserStates state,
  })
  {
    if (state is GetServiceReviewsLoadingState) {
      return Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.all(25.r),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
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

    if (state is GetServiceReviewsErrorState) {
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

    final List<Map<String, dynamic>> reviews = userCubit.serviceReviews;
    final double rate = userCubit.serviceRate;
    final int reviewsCount = userCubit.serviceReviewsCount;

    return Container(
      padding: EdgeInsetsDirectional.all(10.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
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
                color: index < rate.round()
                    ? Colors.orange
                    : Colors.grey.shade300,
              );
            }),
          ),
          SizedBox(height: 6.h),
          Text(
            '$reviewsCount مراجعة',
            style: TextStyle(
              fontSize: 11.sp,
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
            ),
          ),
          SizedBox(height: 10.h,),
          if (reviews.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(14.r),
              decoration: BoxDecoration(
                color: cubit.isDark ? darkBgColor : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                'لا توجد مراجعات حتى الآن',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cubit.isDark ? darkSubTextColor : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsetsDirectional.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final review = reviews[index];

                final Timestamp? createdAt = review['createdAt'] is Timestamp
                    ? review['createdAt']
                    : null;

                final String reviewDate = createdAt != null
                    ? DateFormat('yyyy/MM/dd').format(createdAt.toDate())
                    : '';

                final double rating = double.tryParse('${review['rating'] ?? 0}') ?? 0.0;

                final String reviewText = '${review['review'] ?? ''}';
                final String customerName =
                    '${review['customerName'] ?? 'مستخدم'}';
                final String customerImage =
                    '${review['customerImage'] ?? ''}';

                return Container(
                  padding: EdgeInsetsDirectional.all(12.r),
                  decoration: BoxDecoration(
                    color: cubit.isDark
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
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                if (reviewDate.isNotEmpty)
                                  Text(
                                    reviewDate,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: cubit.isDark
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
                            color: cubit.isDark
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserCubit.get(context).getServiceReviews(serviceId: widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final name = widget.name;
    final price = widget.price;
    final period = widget.period;
    final desc = widget.desc;
    final image = widget.image;
    final providerId = widget.providerId;
    final serviceId = widget.serviceId;
    AppCubit appCubit = AppCubit.get(context);
    final providerData = Map<String, dynamic>.from(appCubit.allUsers[providerId] ?? {});

    return BlocListener<UserCubit,UserStates>(
        listener: (context, state) {
          if(state is GetServiceReviewsLoadingState){
            showLoadingDialog(context);
          }
          if(state is GetServiceReviewsSuccessState){
            hideLoadingDialog(context);
          }
          if(state is GetServiceReviewsLoadingState){
            showLoadingDialog(context);
          }
          if(state is GetServiceReviewsErrorState){
            hideLoadingDialog(context);
          }
        },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox (
                  height: 400.h,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusDirectional.vertical(
                            bottom: Radius.circular(10.r)),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 20.h, start: 10.w, end: 10.w),
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(7.w),
                          child: buildButton(
                            context: context,
                            isDark: appCubit.isDark,
                            icon: CupertinoIcons.back,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(18.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    boxShadow: blueShadow),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: appCubit.isDark
                                            ? darkBgColor
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        '$category',
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
                                      name,
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
                                              SvgPicture.asset(
                                                'assets/money.svg',
                                                color: Colors.grey,
                                                width: 20.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'السعر التقديري',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: appCubit.isDark
                                                          ? darkSubTextColor
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$price $reyalSymbol',
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
                                          color: appCubit.isDark
                                              ? darkSubTextColor
                                              : Colors.grey.shade300,
                                        ),
                                        SizedBox(width: 15.w),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/timer.svg',
                                                color: Colors.grey,
                                                width: 20.w,
                                              ),
                                              SizedBox(width: 8.w),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'المدة المتوقعة',
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: appCubit.isDark
                                                          ? darkSubTextColor
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$period دقيقة',
                                                    style: TextStyle(
                                                      color: appCubit.isDark
                                                          ? Colors.white
                                                          : Colors.black87,
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
                SizedBox(height: 10.h,),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle(
                          title: 'وصف الخدمة',
                          icon: Icons.notes_rounded,
                          cubit: appCubit
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.r),
                        decoration: BoxDecoration(
                            color: appCubit.isDark ? lightDarkColor : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: blueShadow),
                        child: Column(
                          children: [
                            ReadMoreText(
                              desc,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color:
                                  appCubit.isDark ? Colors.white : Colors.black,
                                  height: 1.5),
                              trimLines: 3,
                              colorClickableText: mainColor,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: ' عرض المزيد',
                              trimExpandedText: ' عرض أقل',
                              moreStyle:
                              TextStyle(fontSize: 12.sp, color: mainColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      buildSectionTitle(
                          title: 'معلومات الفني',
                          icon: Icons.person_pin_outlined,
                          cubit: appCubit
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsetsDirectional.all(18.r),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: appCubit.isDark ? lightDarkColor : Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: blueShadow),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor: mainColor.withOpacity(0.1),
                                  backgroundImage: NetworkImage(
                                    providerData['profileImage'] ?? '',
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${providerData['name'] ?? 'فني غير معروف'}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).textTheme.bodyLarge!.color,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.w,),
                                          SvgPicture.asset('assets/verf_bold.svg',color: Colors.blue,),
                                        ],
                                      ),
                                      Text(
                                        providerData['specialization'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(vertical: 15.h),
                              child: Divider(
                                  color: appCubit.isDark
                                      ? darkSubTextColor
                                      : Colors.grey.shade100,
                                  height: 1),
                            ),
                            defaultOutlinedButtonWithIcon(
                              onPressed: () {
                                move(
                                  context,
                                  UserWorkerProfile(
                                    providerId: providerId,
                                    providerData: providerData,
                                  ),
                                );
                              },
                              text: 'المزيد',
                              fontSize: 13.sp,
                              height: 45.h,
                              textColor: appCubit.isDark ? Colors.white : mainColor,
                              border: appCubit.isDark ? Colors.white : mainColor,
                              icon: SvgPicture.asset(
                                'assets/acc.svg',
                                color: appCubit.isDark ? Colors.white : mainColor,
                                width: 20.r,
                                height: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      buildSectionTitle(
                          title: 'التقييمات والمراجعات',
                          icon: Icons.star_outline_rounded,
                          cubit: appCubit
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<UserCubit, UserStates>(
                        builder: (context, state) {
                          final userCubit = UserCubit.get(context);

                          return buildReviewsCard(
                            cubit: appCubit,
                            userCubit: userCubit,
                            state: state,
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding:
            EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h),
            child: defaultButton(
                onPressed: () => move(
                    context,
                    UserCompleteRequestInfo(
                      serciveName: name,
                      serciveCategory: category,
                      servicePrice: price,
                      servicePeriod: period,
                      serciveImage: image,
                      providerId: providerId,
                      serviceId: serviceId,
                    )),
                text: 'حجز'),
          ),
        ),
      ),
    );
  }
}
