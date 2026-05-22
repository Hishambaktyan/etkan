import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_states.dart';
import '../../shared/networks/local/cache_helper.dart';
import '../../shared/styles/colors.dart';

class EditAddress extends StatefulWidget {
  final Map<String,dynamic> address;
  const EditAddress({super.key, required this.address});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {

  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();


  @override
  void initState() {
    GeoPoint geoPoint = widget.address['location'];
    LocationCubit.get(context).selectedLocation=LatLng(geoPoint.latitude, geoPoint.longitude);
    titleController.text=widget.address['label'];
    detailsController.text=widget.address['addressName'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocConsumer<LocationCubit, LocationStates>(
          listener: (context, state) {
            if(state is EditAddressSuccessState){
              LocationCubit.get(context).getAddresses(CacheHelper.getData(key: 'uid'));
              Navigator.pop(context);
              showSnackBar(Colors.green, 'تم تعديل الموقع بنجاح', context);
            }
          },
          builder: (context, state) {
            LocationCubit locationCubit = LocationCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: locationCubit.selectedLocation,
                        zoom: 14,
                      ),
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        locationCubit.mapController = controller;
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected_location'),
                          position: locationCubit.selectedLocation,
                        ),
                      },
                      onTap: (LatLng point) {
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
                          InkWell(
                            onTap: () =>Navigator.pop(context),
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
                          SizedBox(width: 10.w),
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
                                    'تعديل الموقع',
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
                                : () => locationCubit.getCurrentLocation(context),
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
                                  child: const CircularProgressIndicator(
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
                                  height: 50.h,
                                  padding: EdgeInsetsDirectional.all(10.w),
                                  decoration: BoxDecoration(
                                    color: appCubit.isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.grey.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.my_location_rounded,
                                        color: Colors.grey,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
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
                                  height: 50.h,
                                  child: defaultTextFormField(
                                      cubit: appCubit,
                                      controller: titleController,
                                      text: 'اسم العنوان',
                                      prefixIcon: 'assets/saved.svg',
                                      type: TextInputType.text,
                                      errorMes: 'يرجى تعبئة الحقل'
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                SizedBox(
                                  height: 50.h,
                                  child: defaultTextFormField(
                                      cubit: appCubit,
                                      controller: detailsController,
                                      text: 'تفاصيل العنوان',
                                      prefixIcon: 'assets/note.svg',
                                      type: TextInputType.text,
                                      errorMes: 'يرجى تعبئة الحقل'
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                state is EditAddressLoadingState ? const Center( child: CircularProgressIndicator())
                                    : defaultButton(
                                  onPressed:() async {
                                    if(titleController.text.isEmpty || detailsController.text.isEmpty){
                                      showSnackBar(Colors.red, 'يرجى تعبئة كل الحقول', context);
                                    }else{
                                      await locationCubit.editAddress(
                                          addressId: widget.address['id'],
                                          uId: CacheHelper.getData(key: 'uid'),
                                          label: titleController.text.trim(),
                                          addressDetails: detailsController.text.trim(),
                                          lat: locationCubit.selectedLocation.latitude,
                                          long: locationCubit.selectedLocation.longitude,
                                          isDefault: false
                                      );
                                    }
                                  },
                                  text: 'حفظ الموقع',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h,),
                        ],
                      ),
                    ),
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