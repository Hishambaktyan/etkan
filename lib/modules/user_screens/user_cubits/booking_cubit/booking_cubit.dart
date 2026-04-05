import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/booking_cubit/booking_states.dart';

class BookingCubit extends Cubit<BookingStates>{

  BookingCubit(): super(BookingInitState());

  static BookingCubit get(context)=>BlocProvider.of(context);

  List<Map<String,dynamic>> userRequests = [];

  Future<void> getUserRequests()async{
    try{
      emit(GetUserRequestLoadingState());
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('customerId' ,isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
    required String subCategory,
    required String address,
    required String latitude,
    required String clientName,
    required String clientPhone,
    required String title,
    required String description,
    required String image,
    required String clientImage,
    required String duration,
    required int price,
    required int number,
    required Timestamp scheduledAt ,
  })
  async {
    try {
      emit(CreateRequestLoadingState());
      DateTime now = DateTime.now();
      await FirebaseFirestore.instance.collection('requests').add({
        "address": address,
        "category": category,
        "clientImage": clientImage,
        "clientName": clientName,
        "clientPhone": clientPhone,
        "createdAt": Timestamp.fromDate(now),
        "customerId": customerId,
        "description": description,
        "duration": duration,
        "image": image,
        "latitude": latitude,
        "number": 1,
        "price": price,
        "providerId": providerId,
        "scheduledAt": scheduledAt,
        "status": "قيد الانتظار",
        "statusHistory": {
          "pendingAt": Timestamp.fromDate(now),
        },
        "subCategory": subCategory,
        "title": title,
      });
      emit(CreateRequestSuccessState());
      print("request created successfully");
    } catch (e) {
      emit(CreateRequestErrorState(error: e.toString()));
      print("Error creating request: $e");
    }
  }

}