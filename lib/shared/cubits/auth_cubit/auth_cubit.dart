import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitSatate());

  static AuthCubit get(context) => BlocProvider.of(context);

  void changePasswordVisiability() {
    isPassword = !isPassword;
    emit(ChangePasswordVisiability());
  }

  bool isPassword = true;
  String get suffixIcon =>
      isPassword ? 'assets/eye.svg' : 'assets/eye-slash.svg';

  String generateCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> requestCode({
    required String phone,
    required String userType,
    String purpose = 'signup',
  }) async {
    try {
      emit(SendPhoneCodeLoadingState());

      final String formattedPhone = phone.trim();

      if (formattedPhone.isEmpty) {
        emit(SendPhoneCodeErrorState(
          error: 'يرجى إدخال رقم الهاتف',
        ));
        return;
      }

      // في حالة نسيان كلمة المرور، نتأكد أولًا أن الحساب موجود
      if (purpose == 'reset_password') {
        final userQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: formattedPhone)
            .where('role', isEqualTo: userType)
            .limit(1)
            .get();

        if (userQuery.docs.isEmpty) {
          emit(SendPhoneCodeErrorState(
            error: userType == 'provider'
                ? 'لا يوجد حساب فني مسجل بهذا الرقم'
                : 'لا يوجد حساب مستخدم مسجل بهذا الرقم',
          ));
          return;
        }
      }

      final String code = generateCode();
      final DateTime now = DateTime.now();

      await FirebaseFirestore.instance.collection('verification_requests').add({
        'clientPhone': formattedPhone,
        'code': code,
        'userType': userType,
        'purpose': purpose,
        'status': 'pending',
        'sentByAdmin': false,
        'verified': false,
        'used': false,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(
          now.add(const Duration(minutes: 10)),
        ),
        'sentAt': null,
      });

      emit(SendPhoneCodeSuccessState(
        phone: formattedPhone,
        userType: userType,
      ));
    } catch (e) {
      emit(SendPhoneCodeErrorState(error: e.toString()));
    }
  }

  Future<bool> checkCode({
    required String phone,
    required String code,
    required String userType,
    String purpose = 'signup',
  }) async {
    emit(CheckPhoneCodeLoadingState());

    try {
      final query = await FirebaseFirestore.instance
          .collection('verification_requests')
          .where('clientPhone', isEqualTo: phone.trim())
          .where('code', isEqualTo: code.trim())
          .where('verified', isEqualTo: false)
          .get();

      final matchingRequests = query.docs.where((doc) {
        final data = doc.data();

        final String requestPurpose = data['purpose']?.toString() ?? 'signup';

        final String requestUserType = data['userType']?.toString() ?? userType;

        return requestPurpose == purpose && requestUserType == userType;
      }).toList();

      if (matchingRequests.isEmpty) {
        emit(CheckPhoneCodeErrorState(
          error: 'الكود غير صحيح',
        ));
        return false;
      }

      final doc = matchingRequests.first;
      final data = doc.data();

      final Timestamp? expiresAt = data['expiresAt'] as Timestamp?;

      if (expiresAt == null || expiresAt.toDate().isBefore(DateTime.now())) {
        emit(CheckPhoneCodeErrorState(
          error: 'انتهت صلاحية الكود',
        ));
        return false;
      }

      await doc.reference.update({
        'verified': true,
        'status': 'verified',
        'verifiedAt': FieldValue.serverTimestamp(),
      });

      emit(CheckPhoneCodeSuccessState(
        userType: userType,
        phone: phone.trim(),
      ));

      return true;
    } catch (e) {
      emit(CheckPhoneCodeErrorState(error: e.toString()));
      return false;
    }
  }

  var userNameController = TextEditingController();
  var userPasswordController = TextEditingController();
  var userPhoneController = TextEditingController();

  Future<void> signUpUser(
      {required String name,
      required String phone,
      required String password}) async {
    try {
      emit(UserSignUpLoadingState());

      final formattedPhone = phone.trim();
      final uid = FirebaseFirestore.instance.collection('users').doc().id;

      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        emit(UserSignUpErrorState(error: 'رقم الهاتف مستخدم مسبقًا'));
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'phone': formattedPhone,
        'password': password,
        'role': 'user',
        'profileImage': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await saveUserToken(uid);

      await CacheHelper.saveData(key: 'uid', value: uid);
      await CacheHelper.setBoolen(key: 'isLoggedIn', value: true);
      CacheHelper.saveData(key: 'role', value: 'user');

      emit(UserSignUpSuccessState());
    } catch (e) {
      emit(UserSignUpErrorState(error: e.toString()));
    }
  }

  String? selectedCategory;
  var workerNameController = TextEditingController();
  var workerPasswordController = TextEditingController();
  var workerAddController = TextEditingController();
  var workerPhoneController = TextEditingController();

  Future<void> workerSignUpUser({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      emit(WorkerSignUpLoadingState());

      final uid = FirebaseFirestore.instance.collection('users').doc().id;

      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone.trim())
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        emit(WorkerSignUpErrorState(error: 'رقم الهاتف مستخدم مسبقًا'));
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'phone': phone.trim(),
        'name': name.trim(),
        'password': password,
        'role': 'provider',
        'specialization': '',
        'address': '',
        'avgRating': 0.0,
        'isAvailable': true,
        'isSubscribed': false,
        'profileImage': '',
        'about': '',
        'experiences': [],
        'previousWorks': [],
        'subscription': {
          'isActive': false,
          'status': 'not_submitted',
          'requestId': null,
          'planId': null,
          'packageName': null,
          'price': null,
          'startDate': null,
          'endDate': null,
          'rejectionReason': null,
        },
        'isVerified': false,
        'verificationStatus': 'not_submitted',
        'verification': {
          'status': 'not_submitted',
          'requestId': null,
          'documentType': null,
          'rejectionReason': null,
          'approvedAt': null,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'token': '',
      });

      await saveUserToken(uid);

      await CacheHelper.saveData(key: 'uid', value: uid);
      await CacheHelper.setBoolen(key: 'isLoggedIn', value: true);
      await CacheHelper.saveData(key: 'role', value: 'provider');

      emit(WorkerSignUpSuccessState());
    } catch (e) {
      emit(WorkerSignUpErrorState(error: e.toString()));
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String userType,
    required String newPassword,
  }) async {
    try {
      emit(ResetPasswordLoadingState());

      final String formattedPhone = phone.trim();
      final String formattedPassword = newPassword.trim();

      if (formattedPassword.length < 6) {
        emit(ResetPasswordErrorState(
          error: 'كلمة المرور يجب أن تحتوي على 6 أحرف أو أرقام على الأقل',
        ));
        return;
      }

      final verificationQuery = await FirebaseFirestore.instance
          .collection('verification_requests')
          .where('clientPhone', isEqualTo: formattedPhone)
          .get();

      QueryDocumentSnapshot<Map<String, dynamic>>? validRequest;

      for (final doc in verificationQuery.docs) {
        final data = doc.data();

        final Timestamp? expiresAt = data['expiresAt'] as Timestamp?;

        final bool isValid = data['purpose'] == 'reset_password' &&
            data['userType'] == userType &&
            data['verified'] == true &&
            data['used'] != true &&
            expiresAt != null &&
            expiresAt.toDate().isAfter(DateTime.now());

        if (isValid) {
          validRequest = doc;
          break;
        }
      }

      final requestDoc = validRequest;

      if (requestDoc == null) {
        emit(ResetPasswordErrorState(
          error: 'يجب التحقق من رقم الهاتف أولًا',
        ));
        return;
      }

      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .where('role', isEqualTo: userType)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        emit(ResetPasswordErrorState(
          error: 'لم يتم العثور على الحساب',
        ));
        return;
      }

      final userDoc = userQuery.docs.first;

      final batch = FirebaseFirestore.instance.batch();

      batch.update(userDoc.reference, {
        'password': formattedPassword,
        'passwordUpdatedAt': FieldValue.serverTimestamp(),
      });

      batch.update(requestDoc.reference, {
        'used': true,
        'status': 'completed',
        'usedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      emit(ResetPasswordSuccessState());
    } catch (e) {
      emit(ResetPasswordErrorState(error: e.toString()));
    }
  }

  Future<String> uploadImageToCloudinary(String imagePath) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagePath,
        filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
      'upload_preset': 'unsiged_upload',
    });

    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/dxftdrzdu/image/upload',
      data: formData,
    );

    return response.data['secure_url'];
  }

  Future<void> completeWorkerProfile({
    required String specialization,
    required String address,
    required String about,
    required List<String> experiences,
    required List<String> previousWorks,
    required String profileImage,
  }) async {
    try {
      emit(CompleteWorkerProfileLoadingState());

      String profileImageUrl = '';
      List<String> previousWorksImageUrl = [];

      if (profileImage.trim().isNotEmpty) {
        profileImageUrl = await uploadImageToCloudinary(profileImage);
      }

      if (previousWorks.isNotEmpty) {
        for (String imagePath in previousWorks) {
          final imageUrl = await uploadImageToCloudinary(imagePath);
          previousWorksImageUrl.add(imageUrl);
        }
      }

      final uid = CacheHelper.getData(key: 'uid');

      if (uid == null || uid.toString().isEmpty) {
        emit(CompleteWorkerProfileErrorState(
          error: 'تعذر العثور على معرف المستخدم',
        ));
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'specialization': specialization.trim(),
        'address': address.trim(),
        'about': about.trim(),
        'experiences': experiences,
        'previousWorks': previousWorksImageUrl,
        'profileImage': profileImageUrl,
      });

      emit(CompleteWorkerProfileSuccessState());
    } catch (e) {
      emit(CompleteWorkerProfileErrorState(error: e.toString()));
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

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone.trim())
          .where('password', isEqualTo: password.trim())
          .where('role', isEqualTo: requiredRole)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        String message = 'رقم الهاتف أو كلمة المرور غير صحيحة';

        if (requiredRole == 'admin') {
          message = 'هذا الحساب ليس حساب مسؤول';
        } else if (requiredRole == 'provider') {
          message = 'هذا الحساب ليس حساب فني';
        } else if (requiredRole == 'user') {
          message = 'هذا الحساب ليس حساب مستخدم';
        }

        emit(LoginErrorState(error: message));
        return;
      }

      final doc = userDoc.docs.first;
      final userData = doc.data();

      final String role = userData['role']?.toString().trim() ?? '';
      final String uid = doc.id;

      if (role != requiredRole) {
        emit(LoginErrorState(error: 'ليس لديك صلاحية الدخول من هذه الصفحة'));
        return;
      }

      await CacheHelper.saveData(key: 'uid', value: uid);
      await CacheHelper.saveData(key: 'role', value: role);
      await CacheHelper.setBoolen(key: 'isLoggedIn', value: true);

      await saveUserToken(uid);

      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }

  Future<void> logoutUser() async {
    try {
      emit(LogOutLoadingState());

      final String? uid = CacheHelper.getData(key: 'uid');

      if (uid != null && uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'token': '',
        });
      }

      await CacheHelper.removeData(key: 'uid');
      await CacheHelper.removeData(key: 'isLoggedIn');
      await CacheHelper.removeData(key: 'role');

      emit(LogOutSuccessState());
    } catch (e) {
      emit(LogOutErrorState(error: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      emit(DeleteUserAccLoadingState());

      final String? uid = CacheHelper.getData(key: 'uid');

      if (uid != null && uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      }

      await CacheHelper.removeData(key: 'uid');
      await CacheHelper.removeData(key: 'isLoggedIn');
      await CacheHelper.removeData(key: 'role');

      emit(DeleteUserAccSuccessState());
    } catch (e) {
      emit(DeleteUserAccErrorState(error: e.toString()));
    }
  }

  Future<void> saveUserToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'token': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        print("تم حفظ الـ Token بنجاح: $token");
      }
    } catch (e) {
      print("خطأ أثناء حفظ الـ Token: ${e.toString()}");
    }
  }
}
