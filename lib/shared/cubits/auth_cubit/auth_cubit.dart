import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit(): super(AuthInitSatate());

  static AuthCubit get(context)=>BlocProvider.of(context);

  void changePasswordVisiability(){
    isPassword=!isPassword;
    emit(ChangePasswordVisiability());
  }


  bool isPassword = true;
  String get suffixIcon => isPassword? 'assets/eye.svg' : 'assets/eye-slash.svg';

  String? selectedDept;
  var workerNameController = TextEditingController();
  var workerPasswordController = TextEditingController();
  var workerAddController = TextEditingController();
  var workerPhoneController = TextEditingController();

  String? userId;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> workerSignUpUser(String email, String password) async  {
    try {
      emit(WorkerSignUpLoadingState());
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
        'totalAmount':0
      });
      await verifyEmail();
      await saveUserToken();
      emit(WorkerSignUpSuccessState());

    } on FirebaseAuthException catch (e) {

      String errorMessage = 'حدث خطأ ما';
      if (e.code == 'email-already-in-use') errorMessage = 'هذا البريد مستخدم بالفعل';
      if (e.code == 'weak-password') errorMessage = 'كلمة المرور ضعيفة جداً';

      emit(WorkerSignUpErrorState(error: errorMessage.toString()));
    } catch (e) {
      emit(WorkerSignUpErrorState(error: e.toString()));
    }
  }

  var userNameController = TextEditingController();
  var userPasswordController = TextEditingController();
  var userPhoneController = TextEditingController();

  Future<void> signUpUser(String email, String password) async  {
    try {
      emit(UserSignUpLoadingState());
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId = userCredential.user!.uid;
      await users.doc(userId).set({
        'uid': userId,
        'email':userCredential.user!.email,
        'name':userNameController.text.trim(),
        'role':'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
      await verifyEmail();
      await saveUserToken();
      emit(UserSignUpSuccessState());

    } on FirebaseAuthException catch (e) {

      String errorMessage = 'حدث خطأ ما';
      if (e.code == 'email-already-in-use') errorMessage = 'هذا البريد مستخدم بالفعل';
      if (e.code == 'weak-password') errorMessage = 'كلمة المرور ضعيفة جداً';

      emit(UserSignUpErrorState(error: errorMessage.toString()));
    } catch (e) {
      emit(UserSignUpErrorState(error: e.toString()));
    }
  }

  var workerLoginPhoneController = TextEditingController();
  var workerLoginPasswordController = TextEditingController();

  ////////////////////////////////////////////////////////////////

  var userLoginPhoneController = TextEditingController();
  var userLoginPasswordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    try {
      emit(LoginLoadingState());
      UserCredential userCredential=  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user?.reload();
      await saveUserToken();
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

}