import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_states.dart';

import '../../networks/local/cache_helper.dart';
import '../../networks/remote/notification_service.dart';

class UserCubit extends Cubit<UserStates>{

  UserCubit(): super(UserInitState());

  static UserCubit get(context) => BlocProvider.of(context);

  Map<String, dynamic> allUsers = {};


  Future<void> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    allUsers = {};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }
  }

  List<dynamic> userSpecServices = [];

  Future<void> getUserSpecServices(String type) async {
    try {
      userSpecServices = [];
      emit(GetUserSpecServicesLoadingState());

      final getServicesSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('category', isEqualTo: type)
          .get();

      for (var doc in getServicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        userSpecServices.add(data);
      }
      emit(GetUserSpecServicesSuccessState());
    } catch (e) {
      emit(GetUserSpecServicesErrorState(error: e.toString()));
    }
  }

  List<Map<String, dynamic>> userServices = [];

  Future<void> getUserServices() async {
    try {
      emit(GetUserAllServicesLoadingState());

      userServices.clear();

      final servicesSnapshot =
      await FirebaseFirestore.instance.collection('services').get();

      for (var doc in servicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        userServices.add(data);
      }

      emit(GetUserAllServicesSuccessState());
    } catch (e) {
      emit(GetUserAllServicesErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  List<Map<String, dynamic>> categories = [];
  bool isGetCategoriesLoading = false;

  Future<void> getCategories() async {
    if (isGetCategoriesLoading) return;

    try {
      isGetCategoriesLoading = true;
      emit(GetCategoryLoadingState());

      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      final List<Map<String, dynamic>> loadedCategories = [];

      for (var doc in categoriesSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        loadedCategories.add(data);
      }

      categories = loadedCategories;

      isGetCategoriesLoading = false;
      emit(GetCategorySuccessState());
    } catch (e) {
      isGetCategoriesLoading = false;
      emit(GetCategoryErrorState(error: e.toString()));
    }
  }

  List<Map<String, dynamic>> userRequests = [];

  Future<void> getUserRequests() async {
    try {
      emit(GetUserRequestLoadingState());
      userRequests.clear();
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('customerId', isEqualTo: CacheHelper.getData(key: 'uid'))
          .get();

      for (var doc in requestSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        userRequests.add(data);
      }
      emit(GetUserRequestSuccessState());
    } catch (e) {
      emit(GetUserRequestErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  Future<void> createRequest({
    required String category,
    required String customerId,
    required String providerId,
    required String address,
    required String title,
    required String description,
    required String image,
    required String duration,
    required int price,
    required Timestamp scheduledAt,
  })
  async {
    try {
      emit(CreateRequestLoadingState());

      final DateTime now = DateTime.now();
      final Timestamp nowTimestamp = Timestamp.fromDate(now);

      final requestRef =
      FirebaseFirestore.instance.collection('requests').doc();

      final Map<String, dynamic> requestData = {
        'requestId': requestRef.id,
        'id': requestRef.id,
        'address': address,
        'category': category,
        'customerId': customerId,
        'providerId': providerId,
        'title': title,
        'description': description,
        'image': image,
        'duration': duration,
        'price': price,
        'scheduledAt': scheduledAt,
        'status': 'قيد الانتظار',
        'createdAt': nowTimestamp,
        'updatedAt': nowTimestamp,
        'statusHistory': {
          'pendingAt': nowTimestamp,
          'acceptedAt': null,
          'rejectedAt': null,
          'completedAt': null,
          'cancelledAt': null,
        },
      };

      await requestRef.set(requestData);

      final providerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(providerId)
          .get();

      final providerData = providerDoc.data() ?? {};
      final receiverToken = providerData['token']?.toString() ?? '';

      if (receiverToken.isNotEmpty) {
        await NotificationService.sendNotification(
          receiverToken: receiverToken,
          title: 'حجز جديد',
          body: 'لديك حجز خدمة جديد: $title',
          type: 'new_booking',
          relatedId: requestRef.id,
          senderId: customerId,
        );
      }
      await NotificationService.createNotificationInFirestore(
        receiverId: providerId,
        receiverType: 'worker',
        senderId: customerId,
        title: 'حجز جديد',
        body: 'لديك حجز خدمة جديد: $title',
        type: 'new_booking',
        relatedId: requestRef.id,
      );

      emit(CreateRequestSuccessState());
    } catch (e) {
      emit(CreateRequestErrorState(error: e.toString()));
    }
  }

}