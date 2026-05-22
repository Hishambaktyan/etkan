import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_states.dart';

import '../../networks/local/cache_helper.dart';

class WorkerCubit extends Cubit<WorkerStates>{

  WorkerCubit(): super(WorkerInitState());

  static WorkerCubit get(context)=>BlocProvider.of(context);

  Map<String,dynamic> allUsers = {};

  Future<void> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    allUsers={};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }

  }

  bool amAvailable = true;

  bool isServicesActive = true;


  Future<void> changeAvailability(bool value) async {
    try {
      amAvailable = value;
      emit(ChangeAvailabilityState());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getData(key: 'uid'))
          .update({
        'isAvailable': value,
      });
    } catch (e) {
      print(e.toString());
    }
  }

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

  bool isWorkerDataLoaded = false;
  bool isWorkerRequestsLoaded = false;

  Future<void> getWorkerData({bool forceRefresh = false}) async {
    final uid = CacheHelper.getData(key: 'uid');

    if (uid == null || uid.toString().isEmpty) {
      emit(GetWorkerDataErrorState(error: 'لم يتم العثور على معرف المستخدم'));
      return;
    }

    if (isWorkerDataLoaded && !forceRefresh) {
      return;
    }

    emit(GetWorkerDataLoadingState());

    try {
      workerName = '';
      workerDept = '';
      workerRequestsCount = 0;
      workerServicesCount = 0;
      workerCompletedRequestsCount = 0;
      workerRating = 0.0;

      final userFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final completedRequestsCountFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .where('status', isEqualTo: 'مكتمل')
          .count()
          .get();

      final requestsCountFuture = FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .count()
          .get();

      final servicesFuture = FirebaseFirestore.instance
          .collection('services')
          .where('providerId', isEqualTo: uid)
          .get();

       await Future.wait([
        userFuture,
        completedRequestsCountFuture,
        requestsCountFuture,
        servicesFuture,
      ]);

      final userSnapshot = await userFuture;
      final completedRequestSnapshot = await completedRequestsCountFuture;
      final requestSnapshot = await requestsCountFuture;
      final getServicesSnapshot = await servicesFuture;

      if (!userSnapshot.exists || userSnapshot.data() == null) {
        emit(GetWorkerDataErrorState(error: 'بيانات الفني غير موجودة'));
        return;
      }

      final userData = userSnapshot.data()!;

      workerName = userData['name'] ?? '';
      workerDept = userData['specialization'] ?? '';
      workerRequestsCount = requestSnapshot.count ?? 0;
      workerCompletedRequestsCount = completedRequestSnapshot.count ?? 0;
      workerRating = (userData['avgRating'] ?? 0.0).toDouble();

      workerServices=[];
      for (var doc in getServicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerServices.add(data);
      }

      workerServicesCount = workerServices.length;

      isWorkerDataLoaded = true;

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

  Future<void> getWorkerRequests({bool forceRefresh = false}) async {

    final uid = CacheHelper.getData(key: 'uid');
    if (uid == null) {
      emit(GetWorkerRequestsErrorState(error: 'لا يوجد مستخدم، تم إلغاء جلب البيانات'));
      return;
    }
    if (isWorkerRequestsLoaded && !forceRefresh) {
      return;
    }


    emit(GetWorkerRequestsLoadingState());

    try {
      workerRequests=[];
      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .get();

      workerRequests=[];
      for (var doc in requestsSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerRequests.add(data);
      }
      isWorkerRequestsLoaded = true;

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

  Future<String> uploadImageToCloudinary(String imagePath) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
      'upload_preset': 'unsiged_upload',
    });

    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
      data: formData,
    );

    return response.data['secure_url'];
  }

  Future<List<String>> uploadImagesToCloudinary(List<String> imagePaths)
  async {
    List<String> uploadedUrls = [];

    for (String path in imagePaths) {
      final url = await uploadImageToCloudinary(path);
      uploadedUrls.add(url);
    }

    return uploadedUrls;
  }

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

  Future<void> editWorkerData({
    required String name,
    required String phone,
    required String about,
    required List<String> experiences,
    String? profileImagePath,
    String? oldProfileImage,
    required List<String> previousWorks,
  })
  async {
    emit(EditWorkerDataLoadingState());

    try {
      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(EditWorkerDataErrorState(
          error: 'تعذر العثور على معرف المستخدم',
        ));
        return;
      }

      String finalProfileImage = oldProfileImage ?? '';

      if (profileImagePath != null && profileImagePath.trim().isNotEmpty) {
        finalProfileImage = await uploadImageToCloudinary(profileImagePath);
      }

      List<String> oldImages = previousWorks
          .where((image) => image.startsWith('http'))
          .toList();

      List<String> newImages = previousWorks
          .where((image) => !image.startsWith('http'))
          .toList();

      List<String> uploadedNewImages = await Future.wait(
        newImages.map((imagePath) => uploadImageToCloudinary(imagePath)),
      );

      List<String> finalPreviousWorks = [
        ...oldImages,
        ...uploadedNewImages,
      ];

      List<String> finalExperiences = experiences
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name.trim(),
        'phone': phone.trim(),
        'about': about.trim(),
        'experiences': finalExperiences,
        'previousWorks': finalPreviousWorks,
        'profileImage': finalProfileImage,
      });

      workerName = name.trim();

      isWorkerDataLoaded = false;
      emit(EditWorkerDataSuccessState());
    } catch (e) {
      emit(EditWorkerDataErrorState(error: e.toString()));
    }
  }

  }