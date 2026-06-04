import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class WorkerRequestLocation extends StatefulWidget {
  final Map<String, dynamic> request;

  const WorkerRequestLocation({
    super.key,
    required this.request,
  });

  @override
  State<WorkerRequestLocation> createState() => _WorkerRequestLocationState();
}

class _WorkerRequestLocationState extends State<WorkerRequestLocation> {
  GoogleMapController? mapController;

  LatLng? getBookingLatLng() {
    final dynamic location =
        widget.request['location'] ?? widget.request['addressLocation'];

    if (location is GeoPoint) {
      return LatLng(location.latitude, location.longitude);
    }

    if (location is Map) {
      final dynamic lat = location['lat'] ?? location['latitude'];
      final dynamic lng =
          location['lng'] ?? location['long'] ?? location['longitude'];

      if (lat is num && lng is num) {
        return LatLng(lat.toDouble(), lng.toDouble());
      }
    }

    return null;
  }

  String get addressText {
    return (widget.request['address'] ??
        widget.request['addressName'] ??
        widget.request['addressDetails'] ??
        'موقع الحجز')
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final AppCubit appCubit = AppCubit.get(context);
    final LatLng? bookingLatLng = getBookingLatLng();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: bookingLatLng == null
            ? _buildNoLocationBody(context, appCubit)
            : Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: bookingLatLng,
                zoom: 16,
              ),
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('booking_location'),
                  position: bookingLatLng,
                  infoWindow: InfoWindow(
                    title: 'موقع الحجز',
                    snippet: addressText,
                  ),
                ),
              },
            ),

            PositionedDirectional(
              top: 45.h,
              start: 15.w,
              end: 15.w,
              child: Row(
                children: [
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
                        CupertinoIcons.back,
                        color: mainColor,
                        size: 22.sp,
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
                            width: 22.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'موقع الحجز',
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
              bottom: 15.h,
              child: Container(
                padding: EdgeInsetsDirectional.all(15.w),
                decoration: BoxDecoration(
                  color: appCubit.isDark ? lightDarkColor : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: shadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 45.r,
                          height: 45.r,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: mainColor,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عنوان العميل',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: appCubit.isDark
                                      ? darkSubTextColor
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                addressText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: appCubit.isDark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      height: 45.h,
                      padding: EdgeInsetsDirectional.all(10.w),
                      decoration: BoxDecoration(
                        color: appCubit.isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: appCubit.isDark
                              ? const Color(0xFF30363D)
                              : Colors.grey.shade100,
                        ),
                      ),
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
                              '${bookingLatLng.latitude.toStringAsFixed(6)}, ${bookingLatLng.longitude.toStringAsFixed(6)}',
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
                    defaultButton(
                      onPressed: () {
                        mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            bookingLatLng,
                            17,
                          ),
                        );
                      },
                      text: 'الانتقال إلى موقع الحجز',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLocationBody(BuildContext context, AppCubit appCubit) {
    return Stack(
      children: [
        Container(
          color: appCubit.isDark ? darkBgColor : Colors.grey.shade100,
        ),
        PositionedDirectional(
          top: 45.h,
          start: 15.w,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(15.r),
            child: Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                color: appCubit.isDark ? lightDarkColor : Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: shadow,
              ),
              child: Icon(
                CupertinoIcons.back,
                color: mainColor,
                size: 22.sp,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(25.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.all(20.w),
              decoration: BoxDecoration(
                color: appCubit.isDark ? lightDarkColor : Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: shadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_off_rounded,
                    color: Colors.red,
                    size: 55.sp,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    'لا يوجد موقع محفوظ لهذا الحجز',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: appCubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'تأكد أن الحجز يحتوي على حقل location من نوع GeoPoint.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                      appCubit.isDark ? darkSubTextColor : Colors.grey,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}