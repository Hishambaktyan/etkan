import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../modules/user_screens/user_requests_list.dart';
import '../../../modules/user_screens/user_categories.dart';
import '../../../modules/user_screens/user_home.dart';
import '../../../modules/user_screens/user_account.dart';
import '../../../modules/user_screens/user_chats.dart';
import '../../../modules/worker_screens/worker_account.dart';
import '../../../modules/worker_screens/worker_requests_list.dart';
import '../../../modules/worker_screens/worker_chats.dart';
import '../../../modules/worker_screens/worker_home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../networks/local/cache_helper.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit(): super(InitState());

  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> workerScreens = [
     const WorkerHome(),
    const WorkerRequestsList(),
    const WorkerChats(),
    const WorkerAccount(),
  ];

  List<Widget> userScreen = [
    const UserHome(),
    const UserCategories(),
    const UserRequestsList(),
    const UserChats(),
    const UserAccount(),
  ];

  void changeIndex(value){
    currentIndex=value;
    emit(ChangeNavBarState());
  }

  bool isDark = true;

  void  changeTheme({bool? fromShared}) {
    if(fromShared != null){
      isDark = fromShared;
    }
    else{
      isDark=!isDark;
      CacheHelper.setBoolen(key: 'isDark', value: isDark).then(
            (value) {
          emit(ChangeThemeState());
        },
      ).catchError(
              (error){
            print(error.toString());
          }
      );
    }
  }

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

}