import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_states.dart';

class UserServicesCubit extends Cubit<UserServicesStates> {
  UserServicesCubit() : super(UserServicesInitState());

  static UserServicesCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>> userServices = [];

  Map<String, dynamic> allUsers = {};

  List<Map<String, dynamic>> categories = [];
  bool isGetCategoriesLoading = false;

  Future<void> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    allUsers = {};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }
  }

  List<dynamic> userElecServices = [];

  Future<void> getUserSpecServices(String type) async {
    userElecServices = [];
    emit(GetUserElecServicesLoadingState());
    try {
      final getServicesSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('category', isEqualTo: type)
          .get();
      for (var doc in getServicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        userElecServices.add(data);
        emit(GetUserElecServicesSuccessState());
      }
    } catch (e) {
      emit(GetUserElecServicesErrorState(error: e.toString()));
    }
  }

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

  Future<void> getCategories() async {
    try {
      categories = [];
      isGetCategoriesLoading = true;
      emit(GetCategoryLoadingState());

      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      for (var doc in categoriesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        categories.add(data);
      }

      isGetCategoriesLoading = false;
      emit(GetCategorySuccessState());
    } catch (e) {
      isGetCategoriesLoading = false;
      emit(GetCategoryErrorState(error: e.toString()));
    }
  }
}
