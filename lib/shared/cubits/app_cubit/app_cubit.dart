import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../modules/user_screens/bookings_screen.dart';
import '../../../modules/user_screens/dept_screen.dart';
import '../../../modules/user_screens/user_home_screen.dart';
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
     WorkerHome(),
    const WorkerRequestsList(),
    const WorkerChats(),
    const WorkerAccount(),
  ];

  List<Widget> userScreen = [
    const UserHomeScreen(),
    const DeptScreen(),
    const BookingsScreen(),
    const UserChats(),
    const UserAccount(),
  ];

  void changeIndex(value){
    currentIndex=value;
    emit(ChangeNavBarState());
  }

  Future<String> getAccessToken() async {

    final jsonString = await rootBundle.loadString('assets/service-account.json');
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonString);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    return client.credentials.accessToken.data;
  }

  Future<void> sendNotificationV1({
    required String receiverToken,
    required String messageText,
    required String chatId,
  })
  async {
    try {
      var uid = CacheHelper.getData(key: 'uid');
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final String accessToken = await getAccessToken();
      const String projectId = "homy-1de67";

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': receiverToken,
            'data': {
              'title': 'رسالة جديدة من ${snapshot.data()!['name']}',
              'body': messageText,
              'chatId': chatId,
              'senderId': uid,
              'senderName': snapshot.data()!['name'],
              'senderImage': snapshot.data()!['image'],
              'type': 'chat'
            },
            'android': {
              'priority': 'high',
            }
          },
        }),
      );

      if (response.statusCode == 200) {
        print('تم إرسال الإشعار بنجاح (V1)');
      } else {
        print('خطأ في الإرسال: ${response.body}');
      }
    } catch (e) {
      print("حدث خطأ أثناء توليد التوكن: $e");
    }
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