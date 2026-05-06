import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../modules/user_screens/bookings_screen.dart';
import '../../../modules/user_screens/dept_screen.dart';
import '../../../modules/user_screens/home_screen.dart';
import '../../../modules/user_screens/user_account.dart';
import '../../../modules/user_screens/user_chats.dart';
import '../../../modules/worker_screens/worker_account_screeen.dart';
import '../../../modules/worker_screens/worker_booking_screen.dart';
import '../../../modules/worker_screens/worker_chat.dart';
import '../../../modules/worker_screens/worker_home_screen.dart';
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

  bool amAvailable = true;

  DocumentReference<Map<String, dynamic>>? get userData {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance.collection('users').doc(user.uid);
  }

  bool isServicesActive = true;

  List<Widget> workerScreens = [
     WorkerHomeScreen(),
    const WorkerBookingScreen(),
    const WorkerChat(),
    const WorkerAccountScreeen(),
  ];

  List<Widget> userScreen = [
    const HomeScreen(),
    const DeptScreen(),
    const BookingsScreen(),
    const UserChats(),
    const UserAccount(),
  ];

  void changeIndex(value){
    currentIndex=value;
    emit(ChangeNavBarState());
  }

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

  void changeServiceActivity(value){
    isServicesActive = value;
    emit(ChangeServiceActivityState());
  }

  String? workerName;
  String? workerDept;
  int? workerTotalAmount;
  int? workerRequestsCount;
  int? workerServicesCount;
  int? workerComplatedRequestsCount;
  double? workerRating;

  List<Map<String,dynamic>> workerServices = [];

  bool workerDataLoaded = false;

  Future<void> getWorkerData() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("لا يوجد مستخدم، تم إلغاء جلب البيانات");
      return;
    }

    if (workerDataLoaded) return;

    emit(GetWorkerDataLoadingState());

    final uid = user.uid;

    try {

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

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
      workerTotalAmount = userSnapshot.data()?['totalAmount'];
      workerRequestsCount = requestSnapshot.count;
      workerComplatedRequestsCount = completedRequestSnapshot.count;
      workerServicesCount = servicesSnapshot.count;
      workerRating = userSnapshot.data()?['avgRating'];

      workerServices.clear();

      for (var doc in getServicesSnapshot.docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerServices.add(data);
      }

      workerDataLoaded = true;

      emit(GetWorkerDataSuccessState());

    } catch (e) {
      emit(GetWorkerDataErrorState(error: e.toString()));
    }
  }

  File? serviceImage;
  var picker = ImagePicker();

  Future<void> getProfileImage({required ImageSource source,String? error})
  async {
    try{
      emit(UploadServiceImagesLoadingState());
      final pickedFile = await picker.pickImage(
        source: source,
      );
      if (pickedFile != null) {
        serviceImage=File(pickedFile.path);
        emit(UploadServiceImagesSuccessState());
      } else {
        print('لم يتم اختيار صورة');
      }
    }catch(e){
      emit(UploadServiceImagesErrorState(error: e.toString()));
    }
  }

  void clearServiceImages() {
    serviceImage=null;
    emit(ClearUploadedImages());
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
      var uid = FirebaseAuth.instance.currentUser!.uid;
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

  Future<void> uploadService({
    required String name,
    required String description,
    required String category,
    required String subCategory,
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
        'providerId': FirebaseAuth.instance.currentUser!.uid,
        'isActive': true,
        'rate': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'subCategory': subCategory,
        'reviews': FieldValue.arrayUnion(
            [
              {
                'comment': 'شغله تمام بصراحة بس يهدر كثير',
                'createdAt': DateTime.now(),
                'rating': 3,
                'userId': 'FeIIQoLQZuSiVK2T2q2WBcOjMsn2',
                'userName': 'عمر نصر',
              },
              {
                'comment': 'خدمة ممتازة جداً وانصح بالتعامل معه، فني محترف ومواعيده دقيقة.',
                'createdAt': DateTime.now(),
                'rating': 5,
                'userId': 'j0z415zBtFWBXb1qPiCSHLWtLop2',
                'userName': 'أحمد محمد',
              }
        ]),
      };

      await FirebaseFirestore.instance.collection('services').add(serviceData);

      emit(UploadServiceSuccessState());

    } catch (e) {
      emit(UploadServiceErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  List<Map<String,dynamic>> workerRequests=[];

  List<Map<String,dynamic>> users =[];
  List<Map<String,dynamic>> providers =[];
  List<Map<String,dynamic>> services =[];
  List<Map<String,dynamic>> requests =[];

  Future<void> getAdminData()async{
    try{
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').where('role',isEqualTo: 'user').get();
      final servicesSnapshot = await FirebaseFirestore.instance.collection('services').get();
      final requestsSnapshot = await FirebaseFirestore.instance.collection('requests').get();
      final providersSnapshot = await FirebaseFirestore.instance.collection('users').where('role',isEqualTo: 'provider').get();

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

    }catch(e){}
  }

  Future<void> getWorkerRequests()
  async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("لا يوجد مستخدم، تم إلغاء جلب البيانات");
      return;
    }

    emit(GetWorkerRequestsLoadingState());

    final uid = user.uid;
    workerRequests.clear();

    try {
      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('providerId', isEqualTo: uid)
          .get();

      final docs = requestsSnapshot.docs;

      for (var doc in docs) {
        var data = doc.data();
        data['id'] = doc.id;
        workerRequests.add(data);
      }

      emit(GetWorkerRequestsSuccessState());

    } catch (e) {
      emit(GetWorkerRequestsErrorState(error: e.toString()));
    }
  }

  int getStepFromStatus(String status) {
    switch (status) {
      case "قيد الانتظار":
        return 0; // تم الطلب
      case "مقبول":
        return 1; // تم القبول
      case "جاري التنفيذ":
        return 2; // جاري التنفيذ
      case "مكتمل":
        return 3; // تم اكمال الخدمة
      default:
        return 0;
    }
  }

  String formatStatusTime(dynamic timestamp) {
    if (timestamp == null) return "";
    DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy - hh:mm a').format(date) .replaceAll('AM', 'ص').replaceAll('PM', 'م');

  }

  String dateFormatStatusTime(dynamic timestamp) {
    if (timestamp == null) return "";
    DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(date);

  }

  String timeFormatStatusTime(dynamic timestamp) {
    if (timestamp == null) return "";
    DateTime date = timestamp.toDate();
    return DateFormat('hh:mm a').format(date) .replaceAll('AM', 'ص').replaceAll('PM', 'م');

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