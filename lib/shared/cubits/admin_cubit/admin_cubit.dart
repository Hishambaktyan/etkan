import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_states.dart';

class AdminCubit extends Cubit<AdminStates>{

  AdminCubit(): super(AdminInitState());

  static AdminCubit get(context)=>BlocProvider.of(context);

  List<Map<String,dynamic>> users =[];
  List<Map<String,dynamic>> providers =[];
  List<Map<String,dynamic>> services =[];
  List<Map<String,dynamic>> requests =[];
  List<Map<String,dynamic>> categories =[];

  bool isGetUsersLoading=false;
  bool isGetServicesLoading = false;
  bool isGetRequestsLoading = false;
  bool isGetProvidersLoading = false;
  bool isGetAdminDataLoading=false;
  bool isGetCategoriesLoading=false;

  Future<void> getUsers()async{
    try{
      users=[];
      isGetUsersLoading=true;
      emit(GetUsersLoadingState());
      final usersSnapshot = await FirebaseFirestore.instance.collection('users')
          .where('role', isEqualTo: 'user')
          .get();

      for(var doc in usersSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        users.add(data);
      }
      isGetUsersLoading=false;
      emit(GetUsersSuccessState());

    }catch(e){
      isGetUsersLoading=false;
      emit(GetUsersErrorState(error: e.toString()));
    }
  }

  Future<void> getServices() async {
    try {
      services = [];
      isGetServicesLoading = true;
      emit(GetServicesLoadingState());

      final servicesSnapshot = await FirebaseFirestore.instance.collection('services').get();

      for (var doc in servicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        services.add(data);
      }

      isGetServicesLoading = false;
      emit(GetServicesSuccessState());
    } catch (e) {
      isGetServicesLoading = false;
      emit(GetServicesErrorState(error: e.toString()));
    }
  }

  Future<void> getRequests() async {
    try {
      requests = [];
      isGetRequestsLoading = true;
      emit(GetRequestsLoadingState());

      final requestsSnapshot =
      await FirebaseFirestore.instance.collection('requests').get();

      for (var doc in requestsSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        requests.add(data);
      }

      isGetRequestsLoading = false;
      emit(GetRequestsSuccessState());
    } catch (e) {
      isGetRequestsLoading = false;
      emit(GetRequestsErrorState(error: e.toString()));
    }
  }

  Future<void> getProviders() async {
    try {
      providers = [];
      isGetProvidersLoading = true;
      emit(GetProvidersLoadingState());

      final providersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'provider')
          .get();

      for (var doc in providersSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        providers.add(data);
      }

      isGetProvidersLoading = false;
      emit(GetProvidersSuccessState());
    } catch (e) {
      isGetProvidersLoading = false;
      emit(GetProvidersErrorState(error: e.toString()));
    }
  }

  Future<void> getAdminData()async{
    users=[];
    services=[];
    requests=[];
    providers=[];
    categories=[];
    isGetAdminDataLoading=true;
    emit(GetAdminDataLoadingState());
    try{
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').where('role',isEqualTo: 'user').get();
      final servicesSnapshot = await FirebaseFirestore.instance.collection('services').get();
      final requestsSnapshot = await FirebaseFirestore.instance.collection('requests').get();
      final providersSnapshot = await FirebaseFirestore.instance.collection('users').where('role',isEqualTo: 'provider').get();
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();


      for(var doc in usersSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        users.add(data);
      }
      for(var doc in servicesSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        services.add(data);
      }
      for(var doc in requestsSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        requests.add(data);
      }
      for(var doc in providersSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        providers.add(data);
      }
      for(var doc in categoriesSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        categories.add(data);
      }
      isGetAdminDataLoading =false;
      emit(GetAdminDataSuccessState());

    }catch(e){
      isGetAdminDataLoading =false;
      emit(GetAdminDataErrorState(error: e.toString()));
    }
  }

  Future<void> getCategories()async{
    try{
      categories=[];
      isGetCategoriesLoading=true;
      emit(GetCategoryLoadingState());
      final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();

      for(var doc in categoriesSnapshot.docs){
        var data = doc.data();
        data['id'] = doc.id;
        categories.add(data);
      }
      isGetCategoriesLoading=false;
      emit(GetCategorySuccessState());

    }catch(e){
      isGetCategoriesLoading=false;
      emit(GetCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> createCategory({
    required String title,
    required File imageFile,
    required bool isActive,
  })
  async {

    final dio = Dio();
    String? imageUrl;

    try{

      emit(AddCategoryLoadingState());

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
            imageFile.path,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg'
        ),
        'upload_preset': 'unsiged_upload',
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
        data: formData,
      );

      imageUrl = response.data['secure_url'];

      await FirebaseFirestore.instance.collection('categories').add({
        'title': title,
        'image': imageUrl,
        'isActive': isActive,
      });

      emit(AddCategorySuccessState());

    }catch(e){
      emit(AddCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> deleteCategory(String docId)async{
    try{
      emit(DeleteCategoryLoadingState());
      await FirebaseFirestore.instance.collection('categories').doc(docId).delete();
      emit(DeleteCategorySuccessState());

    }catch(e){
      emit(DeleteGetCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> editCategory({
    required String docId,
    required String title,
    required bool isActive,
    required File imageFile,
  })
  async {

    final dio = Dio();
    String? imageUrl;

    try{

      emit(EditCategoryLoadingState());

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
            imageFile.path,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg'
        ),
        'upload_preset': 'unsiged_upload',
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
        data: formData,
      );

      imageUrl = response.data['secure_url'];

      await FirebaseFirestore.instance.collection('categories').doc(docId).update({
        'title':title,
        'isActive': isActive,
        'image': imageUrl
      });
      emit(EditCategorySuccessState());

    }catch(e){
      emit(EditCategoryErrorState(error: e.toString()));
    }
  }

  Future<void> editUser({
    required String docId,
    required bool isActive,
  })
  async {
    try{
      emit(EditUserLoadingState());
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'isActive': isActive,
      });
      emit(EditUserSuccessState());

    }catch(e){
      emit(EditUserErrorState(error: e.toString()));
    }
  }
}