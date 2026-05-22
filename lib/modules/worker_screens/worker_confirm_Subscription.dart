import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerConfirmSubscription extends StatefulWidget {
  final Map<String, dynamic> plan;
  final Map<String, dynamic> paymentMethod;

  const WorkerConfirmSubscription({
    super.key,
    required this.plan,
    required this.paymentMethod,
  });

  @override
  State<WorkerConfirmSubscription> createState() => _WorkerConfirmSubscriptionState();
}

class _WorkerConfirmSubscriptionState extends State<WorkerConfirmSubscription> {
  File? transferImage;

  Future<void> pickTransferImage() async {

    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        transferImage = File(image.path);
      });
    }
  }

  Widget _buildSectionTitle(String title, String icon, AppCubit cubit) {
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
          child: SvgPicture.asset(
            icon,
            color: mainColor,
            width: 25.w,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String value,
    required String icon,
    required AppCubit cubit,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      margin: EdgeInsetsDirectional.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: blueShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(10.r),
            decoration: BoxDecoration(
              color: cubit.isDark
                  ? mainColor.withOpacity(0.20)
                  : mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: mainColor,
              width: 20.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                color: cubit.isDark ? darkSubTextColor : Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankInfoCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: blueShadow,
      ),
      child: Column(
        children: [
          _buildBankInfoRow('اسم البنك', 'بنك الكريمي', cubit),
          Divider(color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200),
          _buildBankInfoRow('اسم الحساب', 'Homy Services', cubit),
          Divider(color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200),
          _buildBankInfoRow('رقم الحساب', '1234567890', cubit),
        ],
      ),
    );
  }

  Widget _buildBankInfoRow(String title, String value, AppCubit cubit) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferImageCard(AppCubit cubit) {
    return InkWell(
      onTap: pickTransferImage,
      borderRadius: BorderRadius.circular(20.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: transferImage == null ? 150.h : 190.h,
        padding: EdgeInsetsDirectional.all(15.r),
        decoration: BoxDecoration(
          color: cubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: transferImage == null
                ? mainColor.withOpacity(0.30)
                : mainColor,
            width: transferImage == null ? 1 : 1.5,
          ),
          boxShadow: blueShadow,
        ),
        child: transferImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(12.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset('assets/add_doc.svg',color: mainColor,width: 25.w,)
            ),
            SizedBox(height: 12.h),
            Text(
              'ارفع صورة سند التحويل',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'اضغط هنا لاختيار الصورة من المعرض',
              style: TextStyle(
                fontSize: 11.sp,
                color: cubit.isDark ? darkSubTextColor : Colors.grey,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Image.file(
            transferImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildNoteCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/info.svg',color: Colors.orange.shade900 , width: 20.w,),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'سيتم إرسال طلب الاشتراك للإدارة، وبعد مراجعة الدفع سيتم تفعيل الاشتراك للعامل.',
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: Colors.orange.shade900,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadInstructionsCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: mainColor.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/info.svg',
                color: mainColor,
                width: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'تعليمات إرفاق السند',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'تأكد أن صورة السند واضحة وتحتوي على مبلغ الاشتراك واسم أو رقم الحساب وتاريخ العملية.',
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.6,
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'لا تقص أي جزء مهم من الصورة، ولا ترفق صورة غير واضحة أو سند لا يخص عملية الدفع.',
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.6,
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'بعد الإرسال سيتم مراجعة السند من الإدارة، ثم تفعيل الاشتراك عند التأكد من الدفع.',
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.6,
              color: cubit.isDark ? darkSubTextColor : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
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
                  Padding(
                    padding:  EdgeInsetsDirectional.all(10.w),
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
                  Text(
                    'تأكيد الاشتراك',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(start: 10.w, end: 10.w, top: 10.h, bottom: 20.h,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    'ملخص الاشتراك',
                    'assets/card.svg',
                    cubit,
                  ),
                  SizedBox(height: 15.h),
                  _buildInfoRow(
                    title: 'الباقة',
                    value: widget.plan['title'],
                    icon: 'assets/subs.svg',
                    cubit: cubit,
                  ),
                  _buildInfoRow(
                    title: 'السعر',
                    value: '${widget.plan['price']} ﷼',
                    icon: 'assets/money.svg',
                    cubit: cubit,
                  ),
                  _buildInfoRow(
                    title: 'المدة',
                    value: widget.plan['period'],
                    icon: 'assets/date.svg',
                    cubit: cubit,
                  ),
                  _buildInfoRow(
                    title: 'طريقة الدفع',
                    value: widget.paymentMethod['title'],
                    icon: widget.paymentMethod['icon'],
                    cubit: cubit,
                  ),
                  SizedBox(height: 15.h),
                  _buildSectionTitle(
                    'بيانات الدفع',
                    'assets/bank.svg',
                    cubit,
                  ),
                  SizedBox(height: 15.h),
                  _buildBankInfoCard(cubit),
                  SizedBox(height: 20.h),
                  _buildSectionTitle(
                    'سند التحويل',
                    'assets/upload.svg',
                    cubit,
                  ),
                  SizedBox(height: 15.h),
                  _buildTransferImageCard(cubit),
                  SizedBox(height: 15.h),
                  _buildUploadInstructionsCard(cubit),
                  SizedBox(height: 15.h),
                  _buildNoteCard(cubit),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 20.h,
              ),
              decoration: BoxDecoration(
                color: cubit.isDark ? darkBgColor : Colors.white,
                boxShadow: cubit.isDark
                    ? []
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: defaultButton(
                  onPressed: () {
                    if (transferImage == null) {
                      showSnackBar(Colors.red, 'يرجى رفع صورة سند التحويل', context,);
                      return;
                    }

                    showSnackBar(Colors.green, 'تم إرسال طلب الاشتراك بنجاح', context,);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: 'إرسال طلب التفعيل'
              )
            ),
          ),
        );
      },
    );
  }
}