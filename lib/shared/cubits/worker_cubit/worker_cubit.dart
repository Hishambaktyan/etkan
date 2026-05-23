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

  Future<void> changeServiceActivity({
    required bool value,
    required String serviceId,
  })
  async {
    try {
      final index = workerServices.indexWhere((service) => service['id'] == serviceId,);

      if (index != -1) {
        workerServices[index]['isActive'] = value;
        emit(ChangeServiceActivitySuccessState());
      }

      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .update({
        'isActive': value,
      });
    } catch (e) {
      emit(ChangeServiceActivityErrorState(error: e.toString()));
    }
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
  bool isWorkerServicesLoaded = false;

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

  Future<void> getWorkerServices({bool forceRefresh = false}) async {

    final uid = CacheHelper.getData(key: 'uid');
    if (uid == null) {
      print("لا يوجد مستخدم، تم إلغاء جلب البيانات");
      return;
    }
    if (isWorkerServicesLoaded && !forceRefresh) {
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

      isWorkerServicesLoaded = true;

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

  String getCategoryFromSpecialization(String specialization) {
    switch (specialization.trim()) {
      case 'كهربائي':
        return 'الكهرباء';

      case 'سباك':
        return 'السباكة';

      case 'فني تكييف':
      case 'تكييف':
        return 'التكييف';

      case 'بناء':
      case 'بنّاء':
        return 'البناء';

      case 'حداد':
        return 'الحدادة';

      case 'نجار':
        return 'النجارة';

      case 'دهان':
        return 'الدهان';

      case 'فني مياه':
      case 'مياه':
        return 'الماء';

      default:
        return specialization;
    }
  }

  Future<void> uploadService({
    required String serviceName,
    required String serviceDescription,
    required String servicePrice,
    required String servicePeriod,
    required String serviceImage,
  })
  async {
    try {
      String serviceImageLink = '';
      emit(UploadServiceLoadingState());
      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(UploadServiceErrorState(error: 'لم يتم العثور على معرف الفني'));
        return;
      }

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userSnapshot.exists || userSnapshot.data() == null) {
        emit(UploadServiceErrorState(error: 'بيانات الفني غير موجودة'));
        return;
      }

      final userData = userSnapshot.data()!;
      final specialization = userData['specialization'] ?? '';

      final serviceCategory = getCategoryFromSpecialization(specialization);

      if(serviceImage.trim().isNotEmpty){
        serviceImageLink = await uploadImageToCloudinary(serviceImage);
      }

      final price = int.tryParse(servicePrice.trim());

      if (price == null) {
        emit(UploadServiceErrorState(error: 'السعر غير صحيح'));
        return;
      }

      Map<String, dynamic> serviceData = {
        'name': serviceName.trim(),
        'description': serviceDescription.trim(),
        'category': serviceCategory,
        'price': price,
        'period': servicePeriod.trim(),
        'serviceImage': serviceImageLink,
        'providerId': uid,
        'isActive': true,
        'rate': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'reviews': [],
      };

      final docRef = await FirebaseFirestore.instance.collection('services').add(serviceData);
      serviceData['id'] = docRef.id;

      workerServices.add(serviceData);
      workerServicesCount = workerServices.length;

      isWorkerServicesLoaded = true;

      emit(UploadServiceSuccessState());

    } catch (e) {
      emit(UploadServiceErrorState(error: e.toString()));
    }
  }

  Future<void> editService({
    required String serviceId,
    required String serviceName,
    required String serviceDescription,
    required String servicePrice,
    required String servicePeriod,
    String? newServiceImagePath,
    required String oldServiceImageUrl,
  })
  async {
    emit(EditServiceLoadingState());

    try {
      String finalServiceImage = oldServiceImageUrl;

      if (newServiceImagePath != null && newServiceImagePath.trim().isNotEmpty) {
        finalServiceImage = await uploadImageToCloudinary(newServiceImagePath);
      }

      final price = int.tryParse(servicePrice.trim());

      if (price == null) {
        emit(EditServiceErrorState(error: 'السعر غير صحيح'));
        return;
      }

      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .update({
        'name': serviceName.trim(),
        'description': serviceDescription.trim(),
        'price': price,
        'period': servicePeriod.trim(),
        'serviceImage': finalServiceImage,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final index = workerServices.indexWhere((service) => service['id'] == serviceId,);

      if (index != -1) {
        workerServices[index]['name'] = serviceName.trim();
        workerServices[index]['description'] = serviceDescription.trim();
        workerServices[index]['price'] = price;
        workerServices[index]['period'] = servicePeriod.trim();
        workerServices[index]['serviceImage'] = finalServiceImage;
      }

      emit(EditServiceSuccessState());
    } catch (e) {
      emit(EditServiceErrorState(error: e.toString()));
    }
  }

  Future<void> deleteService({
    required String serviceId,
  })
  async {
    emit(DeleteServiceLoadingState());

    try {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .delete();

      workerServices.removeWhere((service) => service['id'] == serviceId,);
      workerServicesCount = workerServices.length;

      emit(DeleteServiceSuccessState());
    } catch (e) {
      emit(DeleteServiceErrorState(error: e.toString()));
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

  Future<void> updateRequestStatus({
    required String requestId,
    required String status,
  })
  async {
    try {
      emit(UpdateRequestStatusLoadingState());

      String? timeField;

      if (status == 'مقبول') {
        timeField = 'acceptedAt';
      } else if (status == 'في الطريق') {
        timeField = 'onWayAt';
      } else if (status == 'مكتمل') {
        timeField = 'completedAt';
      } else if (status == 'مرفوض') {
        timeField = 'rejectedAt';
      } else if (status == 'ملغي') {
        timeField = 'cancelledAt';
      }

      final requestRef = FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId);

      final Map<String, dynamic> requestData = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (timeField != null) {
        requestData[timeField] = FieldValue.serverTimestamp();
      }

      final batch = FirebaseFirestore.instance.batch();

      batch.update(requestRef, requestData);

      batch.set(
        requestRef.collection('statusHistory').doc(),
        {
          'status': status,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      await batch.commit();

      emit(UpdateRequestStatusSuccessState());
    } catch (error) {
      emit(UpdateRequestStatusErrorState(error: error.toString()));
    }
  }

  Future<void> createOrGetChat({
    required String customerId,
    required String providerId,
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> providerData,
  })
  async {
    try {
      emit(CreateOrGetChatLoadingState());
      final String chatId = '${customerId}_$providerId';

      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId);

      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          'chatId': chatId,
          'users': [
            customerId,
            providerId,
          ],
          'userInfo': {
            customerId: {
              'name': customerData['name'] ?? 'مستخدم',
              'image': customerData['profileImage'] ?? '',
            },
            providerId: {
              'name': providerData['name'] ?? 'فني',
              'image': providerData['profileImage'] ?? '',
            },
          },
          'lastMessage': '',
          'lastMessageType': 'text',
          'lastSenderId': '',
          'lastUpdate': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'typingStatus': {
            customerId: false,
            providerId: false,
          },
          'unreadCount': {
            customerId: 0,
            providerId: 0,
          },
        });
      }

      emit(CreateOrGetChatSuccessState(chatId: chatId));

    } catch (error) {
      emit(CreateOrGetChatErrorState(error: error.toString()));
    }
  }

  }