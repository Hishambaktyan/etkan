import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/states.dart';
import '../../modules/worker_screens/worker_account_screeen.dart';
import '../../modules/worker_screens/worker_booking_screen.dart';
import '../../modules/worker_screens/worker_chat.dart';
import '../../modules/worker_screens/worker_home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../networks/local/cache_helper.dart';

class MyCubit extends Cubit<States>{

  final AudioPlayer player = AudioPlayer();

  MyCubit(): super(InitState()){
    player.setSource(AssetSource('sounds/pop.mp3')).then((_) {
      print("تم تحميل صوت الإرسال مسبقاً");
    });
  }

  static MyCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;

  bool isNewNot = false;

  bool amAvailable = true;


  DocumentReference<Map<String, dynamic>> userData  =  FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);


  bool isServicesActive = true;

  List<Widget> screens = [
     WorkerHomeScreen(),
    const WorkerBookingScreen(),
    const WorkerChat(),
    const WorkerAccountScreeen(),
  ];

  void changeIndex(value){
    currentIndex=value;
    emit(ChangeNavBarState());
  }

  Future<void> changeAvailability(value) async {
    try{
      await userData.update({
        'isAvailable' : value
      });
      amAvailable =value;
      emit(ChangeAvailabilityState());
    }catch(e){
      print(e.toString());
    }
  }

  void changeServiceActivity(value){
    isServicesActive = value;
    emit(ChangeServiceActivityState());
  }

  void changePasswordVisiability(){
    isPassword=!isPassword;
    emit(ChangePasswordVisiability());
  }

  String? selectedDept;
  var workerNameController = TextEditingController();
  var workerPasswordController = TextEditingController();
  var workerAddController = TextEditingController();
  var workerPhoneController = TextEditingController();
  bool isPassword = true;
  String get suffixIcon => isPassword? 'assets/eye.svg' : 'assets/eye-slash.svg';
  String? userId;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> signUpUser(String email, String password) async  {
    try {
      emit(SignUpLoadingState());
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId = userCredential.user!.uid;
      await users.doc(userId).set({
        'uid': userId,
        'email':userCredential.user!.email,
        'name':workerNameController.text.trim(),
        'role':'provider',
        'specialization':selectedDept,
        'address':workerAddController.text.trim(),
        'avgRating':0.0,
        'isAvailable ': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await verifyEmail();
      await saveUserToken();
      emit(SignUpSuccessState());

    } on FirebaseAuthException catch (e) {

      String errorMessage = 'حدث خطأ ما';
      if (e.code == 'email-already-in-use') errorMessage = 'هذا البريد مستخدم بالفعل';
      if (e.code == 'weak-password') errorMessage = 'كلمة المرور ضعيفة جداً';

      emit(SignUpErrorState(error: errorMessage.toString()));
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
    }
  }

  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    try {
      emit(LoginLoadingState());
        UserCredential userCredential=  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user?.reload();
      await saveUserToken();
        currentIndex=0;
      emit(LoginSuccessState());

    } on FirebaseAuthException catch (e) {
      String error = 'حدث خطأ ما';
      if (e.code == 'user-not-found') error = 'المستخدم غير موجود';
      if (e.code == 'wrong-password') error = 'كلمة المرور خاطئة';
      if (e.code == 'invalid-email') error = 'البريد الإلكتروني غير صحيح';

      emit(LoginErrorState(error: error.toString()));

    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }

  Future<void> verifyEmail()async{
    try{
      emit(SendVerficationCodeLoadingState());
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      emit(SendVerficationCodeSuccessState());

    }catch(e){
      emit(SendVerficationCodeErrorState(error: e.toString()));
    }
  }

  Future<void> logOutUser()async{
    try{
      emit(LogOutLoadingState());
      await FirebaseAuth.instance.signOut();
      emit(LogOutSuccessState());
    }catch(e){
      emit(LogOutErrorState(error: e.toString()));
      print(e.toString());
    }
  }

  Future<void> saveUserToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      User? user = FirebaseAuth.instance.currentUser;

      if (token != null && user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'token': token,
        });
        print("تم حفظ الـ Token بنجاح: $token");
      }
    } catch (e) {
      print("خطأ أثناء حفظ الـ Token: ${e.toString()}");
    }
  }

  Future<void> checkUser() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {

      await saveUserToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        saveUserToken();
      });
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

  TextEditingController message = TextEditingController();

  Widget buildMessageStatus(String status, bool isSeen, bool isMe) {
    if (!isMe) return const SizedBox.shrink();

    switch(status) {
      case 'sending':
        return SvgPicture.asset(
          'assets/timer.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.grey.shade300,
        );
      case 'sent':
        return SvgPicture.asset(
          'assets/check.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.green.shade100,
        );
      case 'seen':
        return SvgPicture.asset(
          'assets/checks.svg',
          width: 12.w,
          height: 12.h,
          color: Colors.green.shade100,
        );
      default:
        return const SizedBox.shrink();
    }
  }
  Future<void> resetUnreadCount(String chatId, String myId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .update({
        'unreadCount.$myId': 0,
      });
    } catch (e) {
      print('خطأ أثناء تصفير العداد: $e');
    }
  }
  Future<void> sendMessage(String chatId, String receiverId, String senderId) async {
    try{
      if (message.text.trim().isEmpty) return;
      String text = message.text.trim();


      message.clear();
      emit(SendMessageLoadingState());
      DocumentReference messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();
      await messageRef.set({
        'messageId': messageRef.id,
        'chatId': chatId,
        'text': text,
        'messageStatus': 'sending',
        'receiverId': receiverId,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
        'isSeen': false,
      });

      await messageRef.update({
        'messageStatus': 'sent',
      }) ;
      playSendSound();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .update({
        'lastMessage': text,
        'lastUpdate': FieldValue.serverTimestamp(),
        'lastSenderId': senderId,
        'unreadCount.$receiverId': FieldValue.increment(1),
      });
      var receiverDoc = await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
      String? receiverToken = receiverDoc.data()?['token'];
      if (receiverToken != null) {
        await sendNotificationV1(
            receiverToken: receiverToken,
            messageText: text,
          chatId: chatId
        );
      }
      emit(SendMessageSuccessState());
    }catch(e){
      emit(SendMessageErrorState(error: e.toString()));
    }
  }
  Future<void> markAsSeen(String chatId, String myId) async {
    var query = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: myId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      await doc.reference.update({
        'isSeen': true,
        'messageStatus': 'seen',
      });
    }

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .update({
      'unreadCount.$myId': 0,
      'isLastMessagesRead': true,
    });
  }
  bool isTyping=false;

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

  Future<void> playSendSound() async {
    try {
      await player.stop();
      await player.play(AssetSource('sounds/pop.mp3'), volume: 0.4);
      print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=');
    } catch (e) {
      print("Error playing sound: $e");
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
      Map<String, dynamic> serviceData = {
        'name': name,
        'description': description,
        'category': category,
        'price': int.parse(price),
        'period': "$period دقيقة",
        'serviceImage': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
        'providerId': FirebaseAuth.instance.currentUser!.uid,
        'isActive': true,
        'rate': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'subCategory': subCategory,
      };

      await FirebaseFirestore.instance.collection('services').add(serviceData);

      emit(UploadService());

    } catch (error) {
      print(error.toString());
    }
  }
}