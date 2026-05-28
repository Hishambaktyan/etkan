import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/booking_cubit/booking_states.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';

import '../../../../shared/networks/local/cache_helper.dart';
import '../../../../shared/networks/remote/notification_service.dart';

class BookingCubit extends Cubit<BookingStates>{

  BookingCubit(): super(BookingInitState());

  static BookingCubit get(context)=>BlocProvider.of(context);

  List<Map<String,dynamic>> userRequests = [];

  Future<void> getUserRequests()async{
    try{
      emit(GetUserRequestLoadingState());
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('customerId' ,isEqualTo: CacheHelper.getData(key: 'uid'))
          .get();

      for (var doc in requestSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        userRequests.add(data);
      }
      emit(GetUserRequestSuccessState());

    }catch(e){
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

      final requestRef = FirebaseFirestore.instance.collection('requests').doc();

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