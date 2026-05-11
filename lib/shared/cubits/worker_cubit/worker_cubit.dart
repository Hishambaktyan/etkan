import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';

import '../../networks/local/cache_helper.dart';

class WorkerCubit extends Cubit<WorkerStates>{

  WorkerCubit(): super(WorkerInitState());

  static WorkerCubit get(context)=>BlocProvider.of(context);

  bool amAvailable = true;

  bool isServicesActive = true;

  /*
  Future<void> changeAvailability(value) async {
    if (userData == null) return;
    amAvailable = value;
    emit(ChangeAvailabilityState());

    try {
      await userData!.update({
        'isAvailable': value
      });

    } catch (e) {
      print(e.toString());
    }
  }
*/

  void changeServiceActivity(value){
    isServicesActive = value;
    emit(ChangeServiceActivityState());
  }

  String? workerName;
  String? workerDept;
  int? workerRequestsCount;
  int? workerServicesCount;
  int? workerCompletedRequestsCount;
  double? workerRating;

  List<Map<String,dynamic>> workerServices = [];
  List<Map<String,dynamic>> workerRequests=[];


  Future<void> getWorkerData() async {

    workerName='';
    workerDept='';
    workerRequestsCount=0;
    workerServicesCount=0;
    workerCompletedRequestsCount=0;
    workerRating=0.0;
    workerServices=[];

    emit(GetWorkerDataLoadingState());

    final uid = CacheHelper.getData(key: 'uid');

    if (uid == null || uid.toString().isEmpty) {
      emit(GetWorkerDataErrorState(error: 'لم يتم العثور على معرف المستخدم'));
      return;
    }

    try {

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userSnapshot.exists || userSnapshot.data() == null) {
        emit(GetWorkerDataErrorState(error: 'بيانات العامل غير موجودة'));
        return;
      }

      final servicesSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .count()
          .get();

      final completedRequestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId',isEqualTo: uid)
          .where('status',isEqualTo: 'completed')
          .count()
          .get();

      final requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId',isEqualTo: uid)
          .count()
          .get();

      final getServicesSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      workerName = userSnapshot.data()?['name'];
      workerDept = userSnapshot.data()?['specialization'];
      workerRequestsCount = requestSnapshot.count;
      workerCompletedRequestsCount = completedRequestSnapshot.count;
      workerServicesCount = servicesSnapshot.count;
      workerRating = userSnapshot.data()?['avgRating'];



      for (var doc in getServicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerServices.add(data);
      }

      emit(GetWorkerDataSuccessState());

    } catch (e) {
      emit(GetWorkerDataErrorState(error: e.toString()));
    }
  }

  Future<void> getWorkerServices() async {

    final uid = CacheHelper.getData(key: 'uid');
    if (uid == null) {
      print("لا يوجد مستخدم، تم إلغاء جلب البيانات");
      return;
    }

    workerServices=[];

    emit(GetWorkerServicesLoadingState());
    try {
      final servicesSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

      for (var doc in servicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerServices.add(data);
      }

      emit(GetWorkerServicesSuccessState());

    } catch (e) {
      emit(GetWorkerServicesErrorState(error: e.toString()));
    }
  }

  Future<void> getWorkerRequests() async {

    final uid = CacheHelper.getData(key: 'uid');
    if (uid == null) {
      print("لا يوجد مستخدم، تم إلغاء جلب البيانات");
      return;
    }

    workerRequests=[];

    emit(GetWorkerRequestsLoadingState());

    try {
      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .get();

      for (var doc in requestsSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerRequests.add(data);
      }

      emit(GetWorkerRequestsSuccessState());

    } catch (e) {
      emit(GetWorkerRequestsErrorState(error: e.toString()));
    }
  }

  TextEditingController serviceName = TextEditingController();

  TextEditingController serviceDept = TextEditingController();

  TextEditingController servicePrice = TextEditingController();

  TextEditingController serviceDuration = TextEditingController();

  TextEditingController serviceDesc = TextEditingController();


  Future<void> uploadService({
    required String name,
    required String description,
    required String category,
    required String price,
    required String period,
  })
  async {
    try {
      emit(UploadServiceLoadingState());
      Map<String, dynamic> serviceData = {
        'name': name,
        'description': description,
        'category': category,
        'price': int.parse(price),
        'period': period,
        'serviceImage': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
        'providerId': CacheHelper.getData(key: 'uid'),
        'isActive': true,
        'rate': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'reviews': '',
      };

      await FirebaseFirestore.instance.collection('services').add(serviceData);

      emit(UploadServiceSuccessState());

    } catch (e) {
      emit(UploadServiceErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  }