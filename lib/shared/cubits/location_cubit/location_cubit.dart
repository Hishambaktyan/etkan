import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Etkan/shared/cubits/location_cubit/location_states.dart';

import '../../compenents/components.dart';

class LocationCubit extends Cubit<LocationStates> {
  LocationCubit() : super(LocationInitState());

  static LocationCubit get(context) => BlocProvider.of(context);

  bool isGettingLocation = false;

  final LatLng adenCenter = const LatLng(12.7855, 45.0187);

  final LatLngBounds adenBounds = LatLngBounds(
    southwest: const LatLng(12.60, 44.70),
    northeast: const LatLng(13.05, 45.20),
  );

  bool isInsideAden(LatLng point) {
    return point.latitude >= adenBounds.southwest.latitude &&
        point.latitude <= adenBounds.northeast.latitude &&
        point.longitude >= adenBounds.southwest.longitude &&
        point.longitude <= adenBounds.northeast.longitude;
  }

  void moveCameraToAden() {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(adenCenter, 13),
    );
  }

  Future<void> getCurrentLocation(context) async {
    if (isGettingLocation) return;

    isGettingLocation = true;
    emit(GetCurrentLocationLoadingState());

    try {
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

      if (!isInsideAden(newLocation)) {
        showSnackBar(
          Colors.red,
          'الخدمة متاحة داخل مدينة عدن فقط',
          context,
        );

        moveCameraToAden();

        emit(GetCurrentLocationErrorState(
          error: 'موقع المستخدم خارج مدينة عدن',
        ));

        return;
      }

      selectedLocation = newLocation;

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newLocation, 16),
      );

      emit(GetCurrentLocationSuccessState());
    } catch (e) {
      showSnackBar(Colors.red, 'تعذر تحديد الموقع، حاول مرة أخرى', context);
      emit(GetCurrentLocationErrorState(error: e.toString()));
    } finally {
      isGettingLocation = false;
      emit(GetCurrentLocationFinishState());
    }
  }

  GoogleMapController? mapController;

  LatLng selectedLocation = const LatLng(12.7855, 45.0187);

  bool isValidLatLng(LatLng point) {
    return point.latitude.isFinite &&
        point.longitude.isFinite &&
        point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }

  Future<void> addAddress({
    required String uId,
    required String label,
    required String addressDetails,
    required double lat,
    required double long,
  }) async {
    final CollectionReference addresses = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('addresses');

    try {
      emit(AddAddressesLoadingState());

      final LatLng addressPoint = LatLng(lat, long);

      if (!isValidLatLng(addressPoint)) {
        emit(AddAddressesErrorState(error: 'إحداثيات العنوان غير صحيحة'));
        return;
      }

      if (!isInsideAden(addressPoint)) {
        emit(AddAddressesErrorState(
          error: 'لا يمكن حفظ عنوان خارج مدينة عدن',
        ));
        return;
      }

      final batch = FirebaseFirestore.instance.batch();

      final oldAddressesSnapshot = await addresses.get();

      for (var doc in oldAddressesSnapshot.docs) {
        batch.update(doc.reference, {
          'isDefault': false,
        });
      }

      final newAddressRef = addresses.doc();

      batch.set(newAddressRef, {
        'id': newAddressRef.id,
        'label': label,
        'addressName': addressDetails,
        'location': GeoPoint(lat, long),
        'createdAt': FieldValue.serverTimestamp(),
        'isDefault': true,
      });

      await batch.commit();

      emit(AddAddressesSuccessState());
    } catch (e) {
      emit(AddAddressesErrorState(error: e.toString()));
    }
  }

  List<Map<String, dynamic>> allAddresses = [];

  Future<void> getAddresses(String uId) async {
    try {
      emit(GetAddressesLoadingState());

      allAddresses = [];

      if (uId.trim().isEmpty) {
        emit(GetAddressesErrorState(error: 'معرف المستخدم غير موجود'));
        return;
      }

      final addressesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('addresses')
          .get();

      for (var doc in addressesSnapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        allAddresses.add(data);
      }

      emit(GetAddressesSuccessState());
    } catch (e) {
      emit(GetAddressesErrorState(error: e.toString()));
    }
  }

  Future<void> setDefaultAddress({
    required String uId,
    required String addressId,
  }) async {
    emit(SetDefaultAddressLoadingState());

    try {
      // تحديث محلي سريع للواجهة
      for (var address in allAddresses) {
        address['isDefault'] = address['id'] == addressId;
      }

      emit(SetDefaultAddressSuccessState());

      final addressesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('addresses');

      final snapshot = await addressesRef.get();

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'isDefault': doc.id == addressId,
        });
      }

      await batch.commit();
    } catch (e) {
      emit(SetDefaultAddressErrorState(error: e.toString()));
    }
  }

  Future<void> deleteAddress({
    required String uId,
    required String addressId,
  }) async {
    emit(DeleteAddressLoadingState());

    try {
      allAddresses.removeWhere((address) => address['id'] == addressId);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('addresses')
          .doc(addressId)
          .delete();
      emit(DeleteAddressSuccessState());
    } catch (e) {
      emit(DeleteAddressErrorState(error: e.toString()));
    }
  }

  Future<void> editAddress({
    required String uId,
    required String addressId,
    required String label,
    required String addressDetails,
    required double lat,
    required double long,
    required bool isDefault,
  }) async {
    emit(EditAddressLoadingState());

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('addresses')
          .doc(addressId)
          .update({
        'label': label,
        'addressName': addressDetails,
        'location': GeoPoint(lat, long),
        'isDefault': isDefault,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      emit(EditAddressSuccessState());
    } catch (e) {
      emit(EditAddressErrorState(error: e.toString()));
    }
  }
}
