import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_states.dart';

import '../../compenents/components.dart';

class LocationCubit extends Cubit<LocationStates>{

  LocationCubit(): super(LocationInitState());

  static LocationCubit get(context)=>BlocProvider.of(context);

  bool isGettingLocation = false;

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

      selectedLocation = newLocation;

      mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 16),);

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

  LatLng selectedLocation = const LatLng(12.8351, 44.9757);

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
    bool isDefault=false
  })
  async {

    final CollectionReference addresses = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('addresses');

    try {
      emit(AddAddressesLoadingState());
      await addresses.add(
        {
          'label': label,
          'addressName': addressDetails,
          'location':  GeoPoint(lat, long),
          'createdAt': FieldValue.serverTimestamp(),
          'isDefault': isDefault
        }
      );
      emit(AddAddressesSuccessState());

    } catch (e) {
      emit(AddAddressesErrorState(error: e.toString()));
    }
  }

  List<Map<String,dynamic>> allAddresses = [];

  Future<void> getAddresses(String uId)async{

    emit(GetAddressesLoadingState());

    allAddresses=[];

    final addresses = await  FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('addresses').get();

    try{
      for (var doc in addresses.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        allAddresses.add(data);
      }
      emit(GetAddressesSuccessState());

    }catch(e){
      emit(GetAddressesErrorState(error: e.toString()));
    }
  }

  Future<void> setDefaultAddress({
    required String uId,
    required String addressId,
  })
  async {
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
  })
  async {
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