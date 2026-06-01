import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/user_screens/user_add_address.dart';
import 'package:trying_homy/modules/user_screens/user_edit_address.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

import '../../shared/networks/local/cache_helper.dart';

class UserAddressesList extends StatefulWidget {
  const UserAddressesList({super.key});

  @override
  State<UserAddressesList> createState() =>
      _UserAddressesListState();
}

class _UserAddressesListState extends State<UserAddressesList> {

  Widget _buildHeaderCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
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
            padding: EdgeInsetsDirectional.all(15.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadiusDirectional.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: SvgPicture.asset('assets/loc.svg',color: Colors.white,width: 40.w,)
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إدارة العناوين',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'أضف وعدّل عناوينك لاستخدامها عند إنشاء طلب خدمة جديد.',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildSectionTitle(AppCubit cubit) {
    return Row(
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(10.r),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SvgPicture.asset('assets/saved.svg',color: mainColor,width: 20.w,)
        ),
        SizedBox(width: 8.w),
        Text(
          'العناوين المحفوظة',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddressCard({
    required AppCubit appCubit,
    required Map<String, dynamic> address,
    required int index,
    required LocationCubit locationCubit,
    required String uId,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 15.h),
      padding: EdgeInsetsDirectional.all(15.r),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: address['isDefault']
              ? mainColor
              : Colors.transparent,
          width: address['isDefault'] ? 1.3 : 1,
        ),
        boxShadow: blueShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(10.r),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: SvgPicture.asset('assets/home.svg',color: mainColor,width: 25.w,)
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address['label'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (address['isDefault']) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Text(
                              'افتراضي',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              color:
                  appCubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200,
              height: 1,
            ),
          ),
          SizedBox(height: 10.h),
          _buildInfoRow(
            cubit: appCubit,
            icon: 'assets/this_loc.svg',
            title: 'الوصف: ',
            value: address['addressName'],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: _buildSmallButton(
                  title: 'تعديل',
                  icon: 'assets/pen.svg',
                  color: mainColor,
                  onTap: ()=>move(context,  UserEditAddress(address: address)),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildSmallButton(
                  title: address['isDefault'] ? 'افتراضي' : 'جعله افتراضي',
                  icon: 'assets/all.svg',
                  color: Colors.green,
                  onTap: () {
                    locationCubit.setDefaultAddress(
                        uId: CacheHelper.getData(key: 'uid'),
                        addressId: address['id']
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _buildSmallButton(
            title: 'حذف',
            icon: 'assets/delete.svg',
            color: Colors.red,
            onTap: ()=>_showDeleteAddressDialog(appCubit,locationCubit,uId, address['id']),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required AppCubit cubit,
    required String icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(icon,color: Colors.grey,),
        SizedBox(width: 10.w),
        SizedBox(
          width: 55.w,
          child: Text(
            title,
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: cubit.isDark ? Colors.white : Colors.black87,
              fontSize: 12.sp,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton({
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon,color: color,),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAddressDialog(AppCubit appCubit,LocationCubit locationCubit,String uId, String addressId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: AlertDialog(
                  backgroundColor:
                  appCubit.isDark ? lightDarkColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  contentPadding: EdgeInsets.all(22.r),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset('assets/delete.svg',color: Colors.red,width: 50.w,)
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'حذف العنوان',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'هل أنت متأكد من حذف العنوان؟ لا يمكن التراجع عن هذه العملية بعد تنفيذها.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: appCubit.isDark
                              ? darkSubTextColor
                              : Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        children: [
                          Expanded(
                            child: defaultButton(
                              onPressed: () => Navigator.pop(context),
                              text: 'إلغاء',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: defaultOutlinedButton(
                              onPressed: (){
                                locationCubit.deleteAddress(uId: uId, addressId: addressId);
                                Navigator.pop(context);
                              },
                              text: 'حذف',
                              border: Colors.red,
                              textColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    LocationCubit.get(context).getAddresses(CacheHelper.getData(key: 'uid'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return BlocBuilder<LocationCubit,LocationStates>(
          builder: (context, state) {
              LocationCubit locationCubit = LocationCubit.get(context);
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
                          'إدارة العناوين',
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
                    padding: const EdgeInsetsDirectional.all(10),
                    child: state is GetAddressesLoadingState? AddressManagementShimmer(isDark: appCubit.isDark,)
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(appCubit),
                        SizedBox(height: 25.h),
                        _buildSectionTitle(appCubit),
                        SizedBox(height: 15.h),
                        locationCubit.allAddresses.isEmpty?
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 85.w,
                                height: 85.w,
                                padding: EdgeInsets.all(18.r),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  'assets/no_loc.svg',
                                  width: 45.w,
                                  colorFilter: ColorFilter.mode(
                                    mainColor.withOpacity(0.75),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'لا توجد عناوين محفوظة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'أضف عنوانك الآن لتسهيل استخدامه عند حجز الخدمات.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  height: 1.6,
                                  color: appCubit.isDark
                                      ? darkSubTextColor
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: locationCubit.allAddresses.length,
                          itemBuilder: (context, index) {
                            final address = locationCubit.allAddresses[index];
                            return _buildAddressCard(
                                appCubit: appCubit,
                                address: address,
                                index: index,
                              locationCubit: locationCubit,
                              uId: CacheHelper.getData(key: 'uid')
                            );
                          },
                        ),
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
                      color: appCubit.isDark ? darkBgColor : Colors.white,
                      boxShadow: blueShadow
                    ),
                    child: defaultButtonWithIcon(
                        onPressed: ()=>move(context, const UserAddAddress()),
                        height: 50.h,
                        text: 'إضافة عنوان جديد',
                        icon: SvgPicture.asset('assets/add_loc.svg',color: Colors.white,)
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
