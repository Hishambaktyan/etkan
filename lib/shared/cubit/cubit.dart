import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/cubit/states.dart';
import '../../modules/worker_screens/worker_account_screeen.dart';
import '../../modules/worker_screens/worker_booking_screen.dart';
import '../../modules/worker_screens/worker_chat.dart';
import '../../modules/worker_screens/worker_home_screen.dart';

class MyCubit extends Cubit<States>{

  MyCubit(): super(InitState());

  static MyCubit get(context)=>BlocProvider.of(context);

  int currentIndex = 0;

  bool isNewNot = false;

  bool amAvailable = true;

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

  void changeAvailability(value){
    amAvailable = value;
    emit(ChangeAvailabilityState());
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

  TextEditingController message = TextEditingController();

  Widget buildMessageStatus(String status, bool isSeen, bool isMe) {
    if (!isMe) return const SizedBox.shrink();
    if (status == 'seen') {
      return SvgPicture.asset(
        'assets/checks.svg',
        width: 12.w,
        height: 12.h,
        color: Colors.green.shade100,
      );
    }
    if (status == 'sent') {
      return SvgPicture.asset(
        'assets/check.svg',
        width: 12.w,
        height: 12.h,
        color: Colors.green.shade100,
      );
    }
    return SvgPicture.asset(
      'assets/timer.svg',
      width: 12.w,
      height: 12.h,
      color: Colors.grey.shade300,
    );
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
        'messageStatus': 'sent',
        'receiverId': receiverId,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
        'isSeen': false,
      });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .update({
        'lastMessage': text,
        'lastUpdate': FieldValue.serverTimestamp(),
        'lastSenderId': senderId,
        'unreadCount.$receiverId': FieldValue.increment(1),
        'lastSenderId': senderId,
      });
      emit(SendMessageSuccessState());
      message.clear();
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







}