import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_subscriptions_screen.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/networks/local/cache_helper.dart';

class WorkerAccountVerification extends StatefulWidget {
  final bool isFromOnboarding;

  const WorkerAccountVerification({
    super.key,
    this.isFromOnboarding = false,
  });

  @override
  State<WorkerAccountVerification> createState() =>
      _WorkerAccountVerificationState();
}

class _WorkerAccountVerificationState extends State<WorkerAccountVerification> {
  String selectedDocumentType = 'بطاقة شخصية';

  final List<String> documentTypes = [
    'بطاقة شخصية',
    'جواز سفر',
  ];

  final List<Map<String, dynamic>> verificationItems = [
    {
      'title': 'صورة الوثيقة الأمامية',
      'subtitle': 'ارفع صورة واضحة للوجه الأمامي من الوثيقة',
      'icon': 'assets/doc.svg',
      'isUploaded': false,
      'image': null,
      'required': true,
    },
    {
      'title': 'صورة الوثيقة الخلفية',
      'subtitle': 'ارفع صورة واضحة للوجه الخلفي من الوثيقة',
      'icon': 'assets/back_doc.svg',
      'isUploaded': false,
      'image': null,
      'required': true,
    },
    {
      'title': 'صورة شخصية للعامل',
      'subtitle': 'ارفع صورة شخصية حديثة وواضحة',
      'icon': 'assets/acc.svg',
      'isUploaded': false,
      'image': null,
      'required': true,
    },
  ];

  Future<void> pickDocumentImage(int index) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 55,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (image != null) {
      setState(() {
        verificationItems[index]['image'] = File(image.path);
        verificationItems[index]['isUploaded'] = true;
      });
    }
  }

  String verificationStatus = 'not_submitted';

  String getVerificationStatusTextFromFirebase(String status) {
    if (status == 'pending') {
      return 'حالة التوثيق الحالية: قيد المراجعة';
    } else if (status == 'approved') {
      return 'حالة التوثيق الحالية: موثق';
    } else if (status == 'rejected') {
      return 'حالة التوثيق الحالية: مرفوض';
    } else {
      return 'حالة التوثيق الحالية: لم يتم الإرسال';
    }
  }

  Color getVerificationStatusColor(String status) {
    if (status == 'approved') {
      return Colors.green;
    } else if (status == 'pending') {
      return Colors.orange;
    } else if (status == 'rejected') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  IconData getVerificationStatusIcon(String status) {
    if (status == 'approved') {
      return Icons.verified_rounded;
    } else if (status == 'pending') {
      return Icons.access_time_rounded;
    } else if (status == 'rejected') {
      return Icons.cancel_rounded;
    } else {
      return Icons.info_outline_rounded;
    }
  }

  Widget _buildStatusCard(
      AppCubit cubit, Map<String, dynamic> verificationData) {
    final String status =
        verificationData['status']?.toString() ?? 'not_submitted';
    final String documentType =
        verificationData['documentType']?.toString() ?? '';

    String title = 'توثيق حساب العامل';
    String subtitle =
        'أكمل بيانات التوثيق لزيادة ثقة العملاء وظهور حسابك بشكل أفضل.';

    if (status == 'pending') {
      title = 'طلب التوثيق قيد المراجعة';
      subtitle = documentType.isNotEmpty
          ? 'تم إرسال طلب توثيق $documentType، وسيتم مراجعته من قبل الإدارة.'
          : 'تم إرسال طلب التوثيق، وسيتم مراجعته من قبل الإدارة.';
    } else if (status == 'approved') {
      title = 'حسابك موثق';
      subtitle = documentType.isNotEmpty
          ? 'تم توثيق حسابك باستخدام $documentType، ويمكن للعملاء رؤية علامة التوثيق.'
          : 'تم توثيق حسابك، ويمكن للعملاء رؤية علامة التوثيق.';
    } else if (status == 'rejected') {
      title = 'تم رفض طلب التوثيق';
      subtitle = 'يمكنك مراجعة بياناتك ورفع صور أوضح ثم إرسال الطلب مرة أخرى.';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Icon(
              getVerificationStatusIcon(status),
              color: Colors.white,
              size: 40.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required BuildContext context,
    required AppCubit cubit,
    required String title,
    required String icon,
  }) {
    return Row(
      children: [
        Container(
            padding: EdgeInsetsDirectional.all(8.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: mainColor,
              width: 25.w,
            )),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentTypeCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDocumentType,
        borderRadius: BorderRadius.circular(15.r),
        dropdownColor: cubit.isDark ? lightDarkColor : Colors.white,
        decoration: InputDecoration(
          labelText: 'نوع الوثيقة',
          labelStyle: TextStyle(
            color: cubit.isDark ? darkSubTextColor : Colors.grey,
            fontSize: 12.sp,
          ),
          border: InputBorder.none,
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: cubit.isDark ? Colors.white70 : Colors.grey,
        ),
        items: documentTypes.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDocumentType = value!;
          });
        },
      ),
    );
  }

  Widget _buildUploadItem({
    required BuildContext context,
    required AppCubit cubit,
    required Map<String, dynamic> item,
    required int index,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 15.h),
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: item['isUploaded']
                    ? Colors.green.withOpacity(0.12)
                    : mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: SvgPicture.asset(
                item['icon'],
                color: mainColor,
                width: 20.w,
              )),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  item['subtitle'],
                  style: TextStyle(
                    color: cubit.isDark ? darkSubTextColor : Colors.grey,
                    fontSize: 11.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () => pickDocumentImage(index),
            borderRadius: BorderRadius.circular(10.r),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: item['isUploaded'] && item['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      item['image'],
                      width: 45.w,
                      height: 45.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: item['isUploaded']
                          ? Colors.green.withOpacity(0.12)
                          : mainColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'رفع',
                      style: TextStyle(
                        color: item['isUploaded'] ? Colors.green : mainColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
          color: Colors.orange.shade800.withOpacity(0.10),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: Colors.orange.withOpacity(0.25),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/info.svg',
                color: Colors.orange.shade800,
                width: 20.w,
              ),
              SizedBox(width: 10.w),
              Text(
                'ملاحظات مهمة',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildNoteText(
            cubit,
            'تأكد أن الصور واضحة وغير مقصوصة.',
          ),
          _buildNoteText(
            cubit,
            'سيتم مراجعة الطلب من قبل الإدارة قبل تفعيل علامة التوثيق.',
          ),
          _buildNoteText(
            cubit,
            'قد يتم رفض الطلب إذا كانت البيانات غير صحيحة.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoteText(AppCubit cubit, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: CircleAvatar(
              radius: 3.r,
              backgroundColor: Colors.orange.shade800,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStatus(
    BuildContext context,
    AppCubit cubit,
    Map<String, dynamic> verificationData,
  ) {
    final String status =
        verificationData['status']?.toString() ?? 'not_submitted';
    final String documentType =
        verificationData['documentType']?.toString() ?? '';
    final Color statusColor = getVerificationStatusColor(status);

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getVerificationStatusIcon(status),
              color: statusColor,
              size: 22.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getVerificationStatusTextFromFirebase(status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (documentType.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'نوع الوثيقة: $documentType',
                    style: TextStyle(
                      color: cubit.isDark
                          ? darkSubTextColor
                          : Colors.grey.shade700,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool canSendVerificationRequest(String status) {
    return status != 'pending' && status != 'approved';
  }

  Widget _buildRejectionReasonCard(
    AppCubit cubit,
    Map<String, dynamic> verificationData,
  ) {
    final String reason = verificationData['rejectionReason']?.toString() ?? '';

    if (reason.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.red.withOpacity(0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.red,
            size: 22.r,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'سبب الرفض: $reason',
              style: TextStyle(
                color: cubit.isDark ? Colors.white : Colors.red.shade800,
                fontSize: 12.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationForm(AppCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25.h),
        _buildSectionTitle(
          context: context,
          cubit: cubit,
          title: 'نوع وثيقة التوثيق',
          icon: 'assets/doc_type.svg',
        ),
        SizedBox(height: 15.h),
        _buildDocumentTypeCard(cubit),
        SizedBox(height: 25.h),
        _buildSectionTitle(
          context: context,
          cubit: cubit,
          title: 'المستندات المطلوبة',
          icon: 'assets/upload.svg',
        ),
        SizedBox(height: 15.h),
        Column(
          children: List.generate(
            verificationItems.length,
            (index) {
              return _buildUploadItem(
                context: context,
                cubit: cubit,
                item: verificationItems[index],
                index: index,
              );
            },
          ),
        ),
        SizedBox(height: 10.h),
        _buildNotesCard(context, cubit),
      ],
    );
  }

  void _goToSubscription() {
    moveAndReplace(
      context,
      const WorkerSubscriptionsScreen(isFromOnboarding: true),
    );
  }

  Widget _buildOnboardingSkipButton(AppCubit cubit) {
    if (!widget.isFromOnboarding) {
      return const SizedBox.shrink();
    }

    return defaultOutlinedButton(
      onPressed: () {
        AuthCubit.get(context).skipPendingWorkerVerification();
        _goToSubscription();
      },
      text: 'تخطي التوثيق الآن',
      textColor: mainColor,
      border: mainColor,
      bgColor: cubit.isDark ? lightDarkColor : Colors.white,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return BlocConsumer<WorkerCubit, WorkerStates>(
          listener: (context, state) {
            if (state is SendVerificationRequestLoadingState) {
              showLoadingDialog(context);
            }
            if (state is SendVerificationRequestSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.green, 'تم إرسال طلب التوثيق بنجاح', context);

              if (widget.isFromOnboarding) {
                _goToSubscription();
              } else {
                Navigator.pop(context);
              }
            }
            if (state is SendVerificationRequestErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, state) {
            WorkerCubit workerCubit = WorkerCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  titleSpacing: 10,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      if (!widget.isFromOnboarding) ...[
                        Padding(
                          padding: const EdgeInsets.all(7),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              CupertinoIcons.back,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Text(
                        'توثيق الحساب',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: widget.isFromOnboarding
                      ? null
                      : FirebaseFirestore.instance
                          .collection('users')
                          .doc(CacheHelper.getData(key: 'uid'))
                          .snapshots(),
                  builder: (context, snapshot) {
                    Map<String, dynamic> verificationData = {};

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData = snapshot.data!.data() ?? {};
                      final dynamic rawVerification = userData['verification'];

                      if (rawVerification is Map) {
                        verificationData =
                            Map<String, dynamic>.from(rawVerification);
                      }
                    }

                    final String currentStatus =
                        verificationData['status']?.toString() ??
                            'not_submitted';

                    return SingleChildScrollView(
                      padding: EdgeInsetsDirectional.only(
                        start: 10.w,
                        end: 10.w,
                        top: 10.h,
                        bottom: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusCard(cubit, verificationData),
                          SizedBox(height: 18.h),
                          _buildReviewStatus(
                            context,
                            cubit,
                            verificationData,
                          ),
                          _buildRejectionReasonCard(
                            cubit,
                            verificationData,
                          ),
                          if (canSendVerificationRequest(currentStatus))
                            _buildVerificationForm(cubit),
                        ],
                      ),
                    );
                  },
                ),
                bottomNavigationBar:
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: widget.isFromOnboarding
                      ? null
                      : FirebaseFirestore.instance
                          .collection('users')
                          .doc(CacheHelper.getData(key: 'uid'))
                          .snapshots(),
                  builder: (context, snapshot) {
                    Map<String, dynamic> verificationData = {};

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData = snapshot.data!.data() ?? {};
                      final dynamic rawVerification = userData['verification'];

                      if (rawVerification is Map) {
                        verificationData =
                            Map<String, dynamic>.from(rawVerification);
                      }
                    }

                    final String currentStatus =
                        verificationData['status']?.toString() ??
                            'not_submitted';

                    if (!canSendVerificationRequest(currentStatus)) {
                      if (!widget.isFromOnboarding) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        padding: EdgeInsetsDirectional.only(
                          start: 20.w,
                          end: 20.w,
                          top: 10.h,
                          bottom: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: cubit.isDark ? darkBgColor : Colors.white,
                          boxShadow: blueShadow,
                        ),
                        child: defaultButton(
                          onPressed: _goToSubscription,
                          text: 'المتابعة إلى الاشتراك',
                        ),
                      );
                    }

                    return Container(
                      padding: EdgeInsetsDirectional.only(
                        start: 20.w,
                        end: 20.w,
                        top: 10.h,
                        bottom: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: cubit.isDark ? darkBgColor : Colors.white,
                        boxShadow: blueShadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultButton(
                            onPressed: () {
                              if (verificationItems[0]['image'] != null &&
                                  verificationItems[1]['image'] != null &&
                                  verificationItems[2]['image'] != null) {
                                if (widget.isFromOnboarding) {
                                  AuthCubit.get(context).setPendingWorkerVerification(
                                    documentType: selectedDocumentType,
                                    frontImage: verificationItems[0]['image'],
                                    backImage: verificationItems[1]['image'],
                                    personalImage: verificationItems[2]['image'],
                                  );
                                  _goToSubscription();
                                } else {
                                  workerCubit.sendVerificationRequest(
                                    documentType: selectedDocumentType,
                                    frontImage: verificationItems[0]['image'],
                                    backImage: verificationItems[1]['image'],
                                    personalImage: verificationItems[2]['image'],
                                  );
                                }
                              } else {
                                showSnackBar(
                                  Colors.red,
                                  'يرجى رفع كل الوثائق المطلوبة',
                                  context,
                                );
                              }
                            },
                            text: currentStatus == 'rejected'
                                ? 'إعادة إرسال طلب التوثيق'
                                : 'إرسال طلب التوثيق',
                          ),
                          if (widget.isFromOnboarding) ...[
                            SizedBox(height: 10.h),
                            _buildOnboardingSkipButton(cubit),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
