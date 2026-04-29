import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerAccountVerificationScreen extends StatefulWidget {
  const WorkerAccountVerificationScreen({super.key});

  @override
  State<WorkerAccountVerificationScreen> createState() =>
      _WorkerAccountVerificationScreenState();
}

class _WorkerAccountVerificationScreenState
    extends State<WorkerAccountVerificationScreen> {
  String selectedDocumentType = 'بطاقة شخصية';

  final List<String> documentTypes = [
    'بطاقة شخصية',
    'جواز سفر',
    'رخصة عمل',
  ];

  final List<Map<String, dynamic>> verificationItems = [
    {
      'title': 'صورة البطاقة الأمامية',
      'subtitle': 'ارفع صورة واضحة للوجه الأمامي من الوثيقة',
      'icon': Icons.badge_outlined,
      'isUploaded': true,
    },
    {
      'title': 'صورة البطاقة الخلفية',
      'subtitle': 'ارفع صورة واضحة للوجه الخلفي من الوثيقة',
      'icon': Icons.credit_card_rounded,
      'isUploaded': false,
    },
    {
      'title': 'صورة شخصية للعامل',
      'subtitle': 'ارفع صورة شخصية حديثة وواضحة',
      'icon': Icons.person_outline_rounded,
      'isUploaded': false,
    },
    {
      'title': 'شهادة أو تصريح مزاولة',
      'subtitle': 'اختياري حسب نوع الخدمة المقدمة',
      'icon': Icons.workspace_premium_outlined,
      'isUploaded': false,
    },
  ];

  Widget _buildStatusCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: cubit.isDark
            ? []
            : [
                BoxShadow(
                  color: mainColor.withOpacity(0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(13.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: Colors.white,
              size: 32.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'توثيق حساب العامل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'أكمل بيانات التوثيق لزيادة ثقة العملاء وظهور حسابك بشكل أفضل.',
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
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: mainColor,
            size: 20.r,
          ),
        ),
        SizedBox(width: 8.w),
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200,
        ),
        boxShadow: cubit.isDark ? [] : shadow,
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
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200,
        ),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(11.r),
            decoration: BoxDecoration(
              color: item['isUploaded']
                  ? Colors.green.withOpacity(0.12)
                  : mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              item['icon'],
              color: item['isUploaded'] ? Colors.green : mainColor,
              size: 25.r,
            ),
          ),
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
            onTap: () {},
            borderRadius: BorderRadius.circular(10.r),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: item['isUploaded']
                    ? Colors.green.withOpacity(0.12)
                    : mainColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                item['isUploaded'] ? 'تم الرفع' : 'رفع',
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
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200,
        ),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.orange,
                size: 22.r,
              ),
              SizedBox(width: 8.w),
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
              backgroundColor: mainColor,
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

  Widget _buildReviewStatus(BuildContext context, AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.orange.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_top_rounded,
              color: Colors.orange.shade800,
              size: 22.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'حالة التوثيق الحالية: قيد المراجعة',
              style: TextStyle(
                color: cubit.isDark
                    ? Colors.orange.shade200
                    : Colors.orange.shade900,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
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
                  Text(
                    'توثيق الحساب',
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
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 25.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(cubit),
                  SizedBox(height: 18.h),
                  _buildReviewStatus(context, cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'نوع وثيقة التوثيق',
                    icon: Icons.assignment_ind_outlined,
                  ),
                  SizedBox(height: 15.h),
                  _buildDocumentTypeCard(cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(
                    context: context,
                    cubit: cubit,
                    title: 'المستندات المطلوبة',
                    icon: Icons.upload_file_rounded,
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: verificationItems.map((item) {
                      return _buildUploadItem(
                        context: context,
                        cubit: cubit,
                        item: item,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  _buildNotesCard(context, cubit),
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
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    showSnackBar(
                      Colors.green,
                      'تم إرسال طلب التوثيق بنجاح',
                      context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'إرسال طلب التوثيق',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
