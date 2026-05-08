import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitSatate());

  static AuthCubit get(context) => BlocProvider.of(context);

  final String baseUrl = 'http://10.0.2.2:3000';

  void changePasswordVisiability() {
    isPassword = !isPassword;
    emit(ChangePasswordVisiability());
  }

  bool isPassword = true;
  String get suffixIcon =>
      isPassword ? 'assets/eye.svg' : 'assets/eye-slash.svg';

  String? selectedDept;
  var workerNameController = TextEditingController();
  var workerPasswordController = TextEditingController();
  var workerAddController = TextEditingController();
  var workerPhoneController = TextEditingController();

  String? userId;
  String normalizePhone(String phone) {
    String cleanPhone = phone.trim();

    cleanPhone = cleanPhone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    if (cleanPhone.startsWith('+967')) {
      return cleanPhone;
    }

    if (cleanPhone.startsWith('967')) {
      return '+$cleanPhone';
    }

    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }

    return '+967$cleanPhone';
  }

  String phoneToFakeEmail(String phone) {
    final formattedPhone = normalizePhone(phone);

    final cleanPhone = formattedPhone
        .replaceAll('+', '')
        .replaceAll(' ', '')
        .replaceAll('-', '');

    return '$cleanPhone@homy.app';
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> workerSignUpUser(String phone, String password) async {
    try {
      emit(WorkerSignUpLoadingState());

      final formattedPhone = normalizePhone(phone);
      final fakeEmail = phoneToFakeEmail(formattedPhone);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      userId = userCredential.user!.uid;

      await users.doc(userId).set({
        'uid': userId,
        'phone': formattedPhone,
        'name': workerNameController.text.trim(),
        'role': 'provider',
        'specialization': selectedDept,
        'address': workerAddController.text.trim(),
        'avgRating': 0.0,
        'isAvailable': true,
        'profileImage':
            'https://i.pinimg.com/736x/52/21/33/522133dfd3c48af9689f9f7c9f86f3e9.jpg',
        'createdAt': FieldValue.serverTimestamp(),
        'totalAmount': 0,
      });

      await saveUserToken();

      emit(WorkerSignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ ما';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'هذا الرقم مستخدم بالفعل';
      }

      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جداً';
      }

      emit(WorkerSignUpErrorState(error: errorMessage));
    } catch (e) {
      emit(WorkerSignUpErrorState(error: e.toString()));
    }
  }

  var userNameController = TextEditingController();
  var userPasswordController = TextEditingController();
  var userPhoneController = TextEditingController();
  Future<void> signUpUser(String phone, String password) async {
    try {
      emit(UserSignUpLoadingState());

      final formattedPhone = normalizePhone(phone);
      final fakeEmail = phoneToFakeEmail(formattedPhone);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      userId = userCredential.user!.uid;

      await users.doc(userId).set({
        'uid': userId,
        'phone': formattedPhone,
        'name': userNameController.text.trim(),
        'role': 'user',
        'profileImage':
            'https://i.pinimg.com/736x/52/21/33/522133dfd3c48af9689f9f7c9f86f3e9.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await saveUserToken();

      emit(UserSignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ ما';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'هذا الرقم مستخدم بالفعل';
      }

      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جداً';
      }

      emit(UserSignUpErrorState(error: errorMessage));
    } catch (e) {
      emit(UserSignUpErrorState(error: e.toString()));
    }
  }

  var workerLoginPhoneController = TextEditingController();
  var workerLoginPasswordController = TextEditingController();

  ////////////////////////////////////////////////////////////////

  var userLoginPhoneController = TextEditingController();
  var userLoginPasswordController = TextEditingController();

  Future<void> loginUser({
    required String phone,
    required String password,
    required String requiredRole,
  }) async {
    try {
      emit(LoginLoadingState());

      final formattedPhone = normalizePhone(phone);
      final fakeEmail = phoneToFakeEmail(formattedPhone);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      await userCredential.user?.reload();

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        emit(LoginErrorState(error: 'بيانات الحساب غير موجودة'));
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final role = userData['role'];

      if (role != requiredRole) {
        await FirebaseAuth.instance.signOut();

        String message = 'ليس لديك صلاحية الدخول من هذه الصفحة';

        if (requiredRole == 'admin') {
          message = 'هذا الحساب ليس حساب مسؤول';
        } else if (requiredRole == 'provider') {
          message = 'هذا الحساب ليس حساب عامل';
        } else if (requiredRole == 'user') {
          message = 'هذا الحساب ليس حساب مستخدم';
        }

        emit(LoginErrorState(error: message));
        return;
      }

      await saveUserToken();

      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      String error = 'حدث خطأ ما';

      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'invalid-login-credentials') {
        error = 'رقم الهاتف أو كلمة المرور غير صحيحة';
      }

      if (e.code == 'wrong-password') {
        error = 'كلمة المرور خاطئة';
      }

      if (e.code == 'too-many-requests') {
        error = 'تم حظر المحاولة مؤقتًا بسبب كثرة المحاولات. حاول لاحقًا';
      }

      emit(LoginErrorState(error: error));
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }

  /*Future<void> verifyEmail() async {
    try {
      emit(SendVerficationCodeLoadingState());
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      emit(SendVerficationCodeSuccessState());
    } catch (e) {
      emit(SendVerficationCodeErrorState(error: e.toString()));
    }
  }*/

  Future<void> logOutUser() async {
    try {
      emit(LogOutLoadingState());
      await FirebaseAuth.instance.signOut();
      emit(LogOutSuccessState());
    } catch (e) {
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

    if (user != null) {
      await saveUserToken();

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        saveUserToken();
      });
    }
  }

  Future<void> sendPhoneCode({
    required String phone,
    required String userType,
  }) async {
    emit(SendPhoneCodeLoadingState());

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        emit(SendPhoneCodeSuccessState(
          phone: phone,
          userType: userType,
        ));
      } else {
        emit(SendPhoneCodeErrorState(
          error: data['message'] ?? 'فشل إرسال كود التحقق',
        ));
      }
    } catch (e) {
      emit(SendPhoneCodeErrorState(error: e.toString()));
    }
  }

  Future<void> checkPhoneCode({
    required String phone,
    required String code,
    required String userType,
  }) async {
    emit(CheckPhoneCodeLoadingState());

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/check-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'code': code,
          'userType': userType,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        emit(CheckPhoneCodeSuccessState(
          phone: phone,
          userType: userType,
        ));
      } else {
        emit(CheckPhoneCodeErrorState(
          error: data['message'] ?? 'كود التحقق غير صحيح',
        ));
      }
    } catch (e) {
      emit(CheckPhoneCodeErrorState(error: e.toString()));
    }
  }

  Future<void> adminSignUpUser(String phone, String password) async {
    try {
      emit(UserSignUpLoadingState());

      final formattedPhone = normalizePhone(phone);
      final fakeEmail = phoneToFakeEmail(formattedPhone);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      userId = userCredential.user!.uid;

      await users.doc(userId).set({
        'uid': userId,
        'phone': formattedPhone,
        'name': userNameController.text.trim(),
        'role': 'admin',
        'profileImage':
            'https://i.pinimg.com/736x/52/21/33/522133dfd3c48af9689f9f7c9f86f3e9.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await saveUserToken();

      emit(UserSignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ ما';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'هذا الرقم مستخدم بالفعل';
      }

      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جداً';
      }

      emit(UserSignUpErrorState(error: errorMessage));
    } catch (e) {
      emit(UserSignUpErrorState(error: e.toString()));
    }
  }
}
