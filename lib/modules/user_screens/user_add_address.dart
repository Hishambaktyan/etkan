import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Etkan/main.dart';
import 'package:Etkan/modules/user_screens/user_add_profile_image.dart';
import 'package:Etkan/shared/compenents/components.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_cubit.dart';
import 'package:Etkan/shared/cubits/app_cubit/app_states.dart';
import 'package:Etkan/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:Etkan/shared/cubits/location_cubit/location_cubit.dart';
import 'package:Etkan/shared/cubits/location_cubit/location_states.dart';
import 'package:Etkan/shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';

class UserAddAddress extends StatefulWidget {
  final bool isOnboarding;

  const UserAddAddress({super.key, this.isOnboarding = false});

  @override
  State<UserAddAddress> createState() => _UserAddAddressState();
}

class _UserAddAddressState extends State<UserAddAddress> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final LatLng adenCenter = const LatLng(12.7855, 45.0187);

  final LatLngBounds adenBounds = LatLngBounds(
    southwest: const LatLng(12.60, 44.70),
    northeast: const LatLng(13.05, 45.15),
  );

  bool isInsideAden(LatLng point) {
    return point.latitude >= adenBounds.southwest.latitude &&
        point.latitude <= adenBounds.northeast.latitude &&
        point.longitude >= adenBounds.southwest.longitude &&
        point.longitude <= adenBounds.northeast.longitude;
  }

  void selectLocationInsideAden(LatLng point) {
    if (!isInsideAden(point)) {
      showSnackBar(
        Colors.red,
        'الخدمة متاحة داخل مدينة عدن فقط',
        context,
      );

      LocationCubit.get(context).mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(adenCenter, 13),
          );

      return;
    }

    setState(() {
      LocationCubit.get(context).selectedLocation = point;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocConsumer<LocationCubit, LocationStates>(
          listener: (context, state) {
            if (state is AddAddressesLoadingState) {
              showLoadingDialog(context);
            }
            if (state is AddAddressesSuccessState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.green, 'تم إضافة العنوان بنجاح', context);
              LocationCubit.get(context)
                  .getAddresses(CacheHelper.getData(key: 'uid'));

              if (widget.isOnboarding) {
                moveAndReplace(context, const UserAddProfileImage());
              } else {
                Navigator.pop(context);
              }
            }
            if (state is AddAddressesErrorState) {
              hideLoadingDialog(context);
              showSnackBar(Colors.red, state.error, context);
            }
          },
          builder: (context, state) {
            LocationCubit locationCubit = LocationCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: PopScope(
                canPop: !widget.isOnboarding,
                child: Scaffold(
                  body: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: isInsideAden(locationCubit.selectedLocation)
                              ? locationCubit.selectedLocation
                              : adenCenter,
                          zoom: 13,
                        ),
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        cameraTargetBounds: CameraTargetBounds(adenBounds),
                        minMaxZoomPreference:
                            const MinMaxZoomPreference(11, 19),
                        onMapCreated: (GoogleMapController controller) {
                          locationCubit.mapController = controller;
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('selected_location'),
                            position:
                                isInsideAden(locationCubit.selectedLocation)
                                    ? locationCubit.selectedLocation
                                    : adenCenter,
                          ),
                        },
                        onTap: (LatLng point) {
                          if (!locationCubit.isInsideAden(point)) {
                            showSnackBar(
                              Colors.red,
                              'الخدمة متاحة داخل مدينة عدن فقط',
                              context,
                            );

                            locationCubit.moveCameraToAden();
                            return;
                          }

                          setState(() {
                            locationCubit.selectedLocation = point;
                          });
                        },
                      ),
                      PositionedDirectional(
                        top: 45.h,
                        start: 15.w,
                        end: 15.w,
                        child: Row(
                          children: [
                            if (!widget.isOnboarding)
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(15.r),
                                child: Container(
                                  height: 45.h,
                                  width: 45.w,
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? lightDarkColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15.r),
                                    boxShadow: shadow,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: mainColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            if (!widget.isOnboarding) SizedBox(width: 10.w),
                            Expanded(
                              child: Container(
                                height: 45.h,
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  color: appCubit.isDark
                                      ? lightDarkColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: shadow,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/loc.svg',
                                      color: mainColor,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      widget.isOnboarding
                                          ? 'إضافة العنوان لإكمال الحساب'
                                          : 'إضافة العنوان',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: appCubit.isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                        start: 15.w,
                        end: 15.w,
                        bottom: 10.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: locationCubit.isGettingLocation
                                  ? null
                                  : () =>
                                      locationCubit.getCurrentLocation(context),
                              borderRadius: BorderRadius.circular(15.r),
                              child: Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: appCubit.isDark
                                      ? lightDarkColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: shadow,
                                ),
                                child: Center(
                                  child: locationCubit.isGettingLocation
                                      ? SizedBox(
                                          height: 22.h,
                                          width: 22.w,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: mainColor,
                                          ),
                                        )
                                      : Icon(
                                          Icons.my_location_rounded,
                                          color: mainColor,
                                          size: 25.sp,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              padding: EdgeInsetsDirectional.all(15.w),
                              decoration: BoxDecoration(
                                color: appCubit.isDark
                                    ? lightDarkColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: shadow,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45.h,
                                    padding: EdgeInsetsDirectional.all(10.w),
                                    decoration: BoxDecoration(
                                        color: appCubit.isDark
                                            ? Colors.white.withOpacity(0.06)
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        border: Border.all(
                                            color: Colors.grey.shade100)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.my_location_rounded,
                                          color: mainColor,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            '${locationCubit.selectedLocation.latitude.toStringAsFixed(5)}, ${locationCubit.selectedLocation.longitude.toStringAsFixed(5)}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: appCubit.isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  SizedBox(
                                    height: 45.h,
                                    child: defaultTextFormField(
                                        cubit: appCubit,
                                        controller: titleController,
                                        text: 'اسم العنوان',
                                        prefixIcon: 'assets/saved.svg',
                                        type: TextInputType.text,
                                        errorMes: 'الرجاء تحديد اسم العنوان'),
                                  ),
                                  SizedBox(height: 15.h),
                                  SizedBox(
                                    height: 45.h,
                                    child: defaultTextFormField(
                                        cubit: appCubit,
                                        controller: detailsController,
                                        text: 'تفاصيل العنوان',
                                        prefixIcon: 'assets/note.svg',
                                        type: TextInputType.text,
                                        errorMes:
                                            'الرجاء تحديد تفاصيل العنوان'),
                                  ),
                                  SizedBox(height: 10.h),
                                  defaultButton(
                                    onPressed: () async {
                                      // إغلاق الكيبورد قبل إرسال الطلب
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (titleController.text.isEmpty ||
                                          detailsController.text.isEmpty) {
                                        showSnackBar(
                                            Colors.red,
                                            'يرجى إدخال اسم العنوان وتفاصيله',
                                            context);
                                      } else if (!locationCubit.isInsideAden(
                                          locationCubit.selectedLocation)) {
                                        showSnackBar(
                                          Colors.red,
                                          'الخدمة متاحة داخل مدينة عدن فقط',
                                          context,
                                        );
                                      } else if (widget.isOnboarding) {
                                        AuthCubit.get(context)
                                            .setPendingUserAddress(
                                          label: titleController.text.trim(),
                                          addressDetails:
                                              detailsController.text.trim(),
                                          lat: locationCubit
                                              .selectedLocation.latitude,
                                          long: locationCubit
                                              .selectedLocation.longitude,
                                        );

                                        moveAndReplace(
                                          context,
                                          const UserAddProfileImage(),
                                        );
                                      } else {
                                        await locationCubit.addAddress(
                                          uId: CacheHelper.getData(key: 'uid'),
                                          label: titleController.text.trim(),
                                          addressDetails:
                                              detailsController.text.trim(),
                                          lat: locationCubit
                                              .selectedLocation.latitude,
                                          long: locationCubit
                                              .selectedLocation.longitude,
                                        );
                                      }
                                    },
                                    text: widget.isOnboarding
                                        ? 'حفظ العنوان والمتابعة'
                                        : 'حفظ العنوان',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
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
        );
      },
    );
  }
}
