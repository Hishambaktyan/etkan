import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/compenents/components.dart';
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
        currentIndex=0;
      emit(LoginSuccessState());

    } on FirebaseAuthException catch (e) {

      emit(LoginErrorState(error: e.message.toString()));

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

  Future<void> deleteUser()async{
    try{
      emit(DeleteUserAccLoadingState());
      await FirebaseAuth.instance.currentUser!.delete();
      emit(DeleteUserAccSuccessState());
    }catch(e){
      emit(DeleteUserAccErrorState(error: e.toString()));
      print(e.toString());
    }
  }


}