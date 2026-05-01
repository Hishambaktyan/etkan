import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import '../../shared/styles/colors.dart';

class SelectAdsress extends StatefulWidget {
  const SelectAdsress({super.key});

  @override
  State<SelectAdsress> createState() => _SelectAdsressState();
}

class _SelectAdsressState extends State<SelectAdsress> {

  bool isGettingLocation = false;

  Future<void> getCurrentLocation() async {
    if (isGettingLocation) return;

    setState(() {
      isGettingLocation = true;
    });
    try{
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        showSnackBar(Colors.red, 'فعّل خدمة الموقع من إعدادات الجهاز', context);
        return;
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          showSnackBar(Colors.red, 'تم رفض صلاحية الموقع', context);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showSnackBar(
          Colors.red,
          'صلاحية الموقع مرفوضة نهائيًا، افتحها من الإعدادات',
          context,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!isValidLatLng(newLocation)) {
        showSnackBar(Colors.red, 'تعذر تحديد موقع صحيح', context);
        return;
      }

      setState(() {
        selectedLocation = newLocation;
      });

      mapController.move(newLocation, 16);
      setState(() {
        isGettingLocation=false;
      });
    }catch(e){
      showSnackBar(Colors.red, 'تعذر تحديد الموقع، حاول مرة أخرى', context);

    }
  }

  final MapController mapController = MapController();

  LatLng selectedLocation = const LatLng(15.3694, 44.1910);

  bool isValidLatLng(LatLng point) {
    return point.latitude.isFinite &&
        point.longitude.isFinite &&
        point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: selectedLocation,
                initialZoom: 14,
                onTap: (tapPosition, point) {
                  if (isValidLatLng(point)) {
                    setState(() {
                      selectedLocation = point;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.edit_homy',
                ),
                MarkerLayer(
                  markers: isValidLatLng(selectedLocation)
                      ? [
                    Marker(
                      point: selectedLocation,
                      width: 50.w,
                      height: 50.h,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: mainColor,
                        size: 45.sp,
                      ),
                    ),
                  ]
                      : [],
                ),
              ],
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: shadow
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
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: shadow
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/loc.svg',color: mainColor,),
                          SizedBox(width: 8.w),
                          Text(
                            'تحديد الموقع',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
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
                    onTap: isGettingLocation ? null : getCurrentLocation,
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: shadow,
                      ),
                      child: Center(
                        child: isGettingLocation
                            ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: CircularProgressIndicator(
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
                  SizedBox(height: 10.h,),
                  Container(
                    padding: EdgeInsetsDirectional.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: shadow
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(10.w),
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.my_location_rounded,
                                color: mainColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  '${selectedLocation.latitude.toStringAsFixed(5)}, ${selectedLocation.longitude.toStringAsFixed(5)}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        defualtButton(onPressed: (){}, text: 'حفظ الموقع')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}