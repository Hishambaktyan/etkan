import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_States.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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

  String normalizeYemeniPhone(String phone) {
    String formattedPhone = phone.trim().replaceAll(RegExp(r'[\s\-()]'), '');

    if (formattedPhone.startsWith('+967')) {
      formattedPhone = formattedPhone.substring(4);
    } else if (formattedPhone.startsWith('00967')) {
      formattedPhone = formattedPhone.substring(5);
    } else if (formattedPhone.startsWith('967') && formattedPhone.length == 12) {
      formattedPhone = formattedPhone.substring(3);
    }

    return formattedPhone;
  }

  bool isValidYemeniPhone(String phone) {
    final String formattedPhone = normalizeYemeniPhone(phone);
    return RegExp(r'^7[0-9]{8}$').hasMatch(formattedPhone);
  }

  String normalizeQuadName(String name) {
    return name.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  bool isValidQuadName(String name) {
    final List<String> nameParts = normalizeQuadName(name)
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .toList();

    return nameParts.length == 4;
  }

  Future<void> requestCode({
    required String phone,
    required String userType,
    String purpose = 'signup',
  }) async {
    try {
      emit(SendPhoneCodeLoadingState());

      final String formattedPhone = normalizeYemeniPhone(phone);

      if (formattedPhone.isEmpty) {
        emit(SendPhoneCodeErrorState(
          error: 'يرجى إدخال رقم الهاتف',
        ));
        return;
      }

      if (!isValidYemeniPhone(formattedPhone)) {
        emit(SendPhoneCodeErrorState(
          error: 'يرجى إدخال رقم يمني صحيح مكون من 9 أرقام ويبدأ بالرقم 7',
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

  Map<String, dynamic>? pendingUserAddress;
  String pendingUserProfileImagePath = '';

  void setPendingUserAddress({
    required String label,
    required String addressDetails,
    required double lat,
    required double long,
  }) {
    pendingUserAddress = {
      'label': label.trim(),
      'addressDetails': addressDetails.trim(),
      'lat': lat,
      'long': long,
    };
  }

  Future<void> finalizeUserSignUp({String profileImagePath = ''}) async {
    try {
      emit(UserSignUpLoadingState());

      final formattedPhone = normalizeYemeniPhone(userPhoneController.text);
      final formattedName = normalizeQuadName(userNameController.text);
      final String password = userPasswordController.text.trim();
      final Map<String, dynamic>? addressData = pendingUserAddress;

      if (!isValidQuadName(formattedName)) {
        emit(UserSignUpErrorState(
          error: 'يرجى إدخال الاسم الرباعي المكون من 4 أسماء فقط',
        ));
        return;
      }

      if (!isValidYemeniPhone(formattedPhone)) {
        emit(UserSignUpErrorState(
          error: 'يرجى إدخال رقم يمني صحيح مكون من 9 أرقام ويبدأ بالرقم 7',
        ));
        return;
      }

      if (password.isEmpty) {
        emit(UserSignUpErrorState(error: 'كلمة المرور غير موجودة'));
        return;
      }

      if (addressData == null) {
        emit(UserSignUpErrorState(error: 'يرجى إضافة العنوان أولًا'));
        return;
      }

      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        emit(UserSignUpErrorState(error: 'رقم الهاتف مستخدم مسبقًا'));
        return;
      }

      String profileImageUrl = '';

      if (profileImagePath.trim().isNotEmpty) {
        profileImageUrl = await uploadImageToCloudinary(profileImagePath);
      }

      final uid = FirebaseFirestore.instance.collection('users').doc().id;
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final addressRef = userRef.collection('addresses').doc();

      final batch = FirebaseFirestore.instance.batch();

      batch.set(userRef, {
        'uid': uid,
        'name': formattedName,
        'phone': formattedPhone,
        'password': password,
        'role': 'user',
        'profileImage': profileImageUrl,
        'address': addressData['addressDetails'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      batch.set(addressRef, {
        'id': addressRef.id,
        'label': addressData['label'] ?? '',
        'addressName': addressData['addressDetails'] ?? '',
        'location': GeoPoint(
          double.tryParse(addressData['lat'].toString()) ?? 0,
          double.tryParse(addressData['long'].toString()) ?? 0,
        ),
        'createdAt': FieldValue.serverTimestamp(),
        'isDefault': true,
      });

      await batch.commit();

      await saveUserToken(uid);

      await CacheHelper.saveData(key: 'uid', value: uid);
      await CacheHelper.setBoolen(key: 'isLoggedIn', value: true);
      await CacheHelper.saveData(key: 'role', value: 'user');

      pendingUserAddress = null;
      pendingUserProfileImagePath = '';
      userNameController.clear();
      userPhoneController.clear();
      userPasswordController.clear();

      emit(UserSignUpSuccessState());
    } catch (e) {
      emit(UserSignUpErrorState(error: e.toString()));
    }
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password.trim())).toString();
  }

  Future<void> signUpUser(
      {required String name,
      required String phone,
      required String password})
  async {
    try {
      emit(UserSignUpLoadingState());

      final formattedPhone = normalizeYemeniPhone(phone);
      final formattedName = normalizeQuadName(name);

      if (!isValidQuadName(formattedName)) {
        emit(UserSignUpErrorState(
          error: 'يرجى إدخال الاسم الرباعي المكون من 4 أسماء فقط',
        ));
        return;
      }

      if (!isValidYemeniPhone(formattedPhone)) {
        emit(UserSignUpErrorState(
          error: 'يرجى إدخال رقم يمني صحيح مكون من 9 أرقام ويبدأ بالرقم 7',
        ));
        return;
      }

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
        'name': formattedName,
        'phone': formattedPhone,
        'password': hashPassword(password),
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

  Map<String, dynamic>? pendingWorkerProfile;
  Map<String, dynamic>? pendingWorkerVerification;
  Map<String, dynamic>? pendingWorkerSubscription;

  void setPendingWorkerProfile({
    required String specialization,
    required String address,
    required String about,
    required List<String> experiences,
    required List<String> previousWorks,
    required String profileImage,
  }) {
    pendingWorkerProfile = {
      'specialization': specialization.trim(),
      'address': address.trim(),
      'about': about.trim(),
      'experiences': List<String>.from(experiences),
      'previousWorks': List<String>.from(previousWorks),
      'profileImage': profileImage.trim(),
    };
  }

  void setPendingWorkerVerification({
    required String documentType,
    required File frontImage,
    required File backImage,
    required File personalImage,
  }) {
    pendingWorkerVerification = {
      'documentType': documentType,
      'frontImage': frontImage,
      'backImage': backImage,
      'personalImage': personalImage,
    };
  }

  void skipPendingWorkerVerification() {
    pendingWorkerVerification = null;
  }

  void setPendingWorkerSubscription({
    required File transferImage,
    required Map<String, dynamic> plan,
    required Map<String, dynamic> paymentMethod,
  }) {
    pendingWorkerSubscription = {
      'transferImage': transferImage,
      'plan': Map<String, dynamic>.from(plan),
      'paymentMethod': Map<String, dynamic>.from(paymentMethod),
    };
  }

  void skipPendingWorkerSubscription() {
    pendingWorkerSubscription = null;
  }

  Future<void> finalizeWorkerSignUp() async {
    try {
      emit(WorkerSignUpLoadingState());

      final formattedPhone = normalizeYemeniPhone(workerPhoneController.text);
      final formattedName = normalizeQuadName(workerNameController.text);
      final String password = workerPasswordController.text.trim();
      final Map<String, dynamic>? profileData = pendingWorkerProfile;

      if (!isValidQuadName(formattedName)) {
        emit(WorkerSignUpErrorState(
          error: 'يرجى إدخال الاسم الرباعي المكون من 4 أسماء فقط',
        ));
        return;
      }

      if (!isValidYemeniPhone(formattedPhone)) {
        emit(WorkerSignUpErrorState(
          error: 'يرجى إدخال رقم يمني صحيح مكون من 9 أرقام ويبدأ بالرقم 7',
        ));
        return;
      }

      if (password.isEmpty) {
        emit(WorkerSignUpErrorState(error: 'كلمة المرور غير موجودة'));
        return;
      }

      if (profileData == null) {
        emit(WorkerSignUpErrorState(error: 'يرجى إكمال الملف المهني أولًا'));
        return;
      }

      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        emit(WorkerSignUpErrorState(error: 'رقم الهاتف مستخدم مسبقًا'));
        return;
      }

      String profileImageUrl = '';
      final List<String> previousWorksImageUrl = [];
      final String profileImagePath = profileData['profileImage']?.toString() ?? '';

      if (profileImagePath.trim().isNotEmpty) {
        profileImageUrl = await uploadImageToCloudinary(profileImagePath);
      }

      final List<String> previousWorks =
          List<String>.from(profileData['previousWorks'] ?? []);

      for (String imagePath in previousWorks) {
        if (imagePath.trim().isNotEmpty) {
          final imageUrl = await uploadImageToCloudinary(imagePath);
          previousWorksImageUrl.add(imageUrl);
        }
      }

      final uid = FirebaseFirestore.instance.collection('users').doc().id;
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final batch = FirebaseFirestore.instance.batch();

      final Map<String, dynamic> workerData = {
        'uid': uid,
        'phone': formattedPhone,
        'name': formattedName,
        'password': password,
        'role': 'provider',
        'specialization': profileData['specialization'] ?? '',
        'address': profileData['address'] ?? '',
        'avgRating': 0.0,
        'isAvailable': true,
        'isSubscribed': false,
        'profileImage': profileImageUrl,
        'about': profileData['about'] ?? '',
        'experiences': List<String>.from(profileData['experiences'] ?? []),
        'previousWorks': previousWorksImageUrl,
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
      };

      final Map<String, dynamic>? verificationData = pendingWorkerVerification;

      if (verificationData != null) {
        final uploadedImages = await Future.wait([
          uploadImageToCloudinary((verificationData['frontImage'] as File).path),
          uploadImageToCloudinary((verificationData['backImage'] as File).path),
          uploadImageToCloudinary((verificationData['personalImage'] as File).path),
        ]);

        final requestRef = FirebaseFirestore.instance
            .collection('profile_verification_requests')
            .doc();

        batch.set(requestRef, {
          'requestId': requestRef.id,
          'providerId': uid,
          'providerName': formattedName,
          'providerPhone': formattedPhone,
          'providerImage': profileImageUrl,
          'documentType': verificationData['documentType'] ?? '',
          'frontDocumentImage': uploadedImages[0],
          'backDocumentImage': uploadedImages[1],
          'personalImage': uploadedImages[2],
          'status': 'pending',
          'rejectionReason': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        workerData['isVerified'] = false;
        workerData['verificationStatus'] = 'pending';
        workerData['verificationRequestId'] = requestRef.id;
        workerData['verification'] = {
          'status': 'pending',
          'requestId': requestRef.id,
          'documentType': verificationData['documentType'] ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'approvedAt': null,
          'rejectionReason': null,
        };
      }

      final Map<String, dynamic>? subscriptionData = pendingWorkerSubscription;

      if (subscriptionData != null) {
        final Map<String, dynamic> plan =
            Map<String, dynamic>.from(subscriptionData['plan'] ?? {});
        final Map<String, dynamic> paymentMethod =
            Map<String, dynamic>.from(subscriptionData['paymentMethod'] ?? {});
        final File transferImage = subscriptionData['transferImage'] as File;
        final String transferImageUrl =
            await uploadImageToCloudinary(transferImage.path);

        final requestRef =
            FirebaseFirestore.instance.collection('subscriptionRequests').doc();

        final int price = int.tryParse(plan['price'].toString()) ?? 0;
        final int durationMonths =
            int.tryParse(plan['durationMonths'].toString()) ?? 1;

        batch.set(requestRef, {
          'requestId': requestRef.id,
          'providerId': uid,
          'providerName': formattedName,
          'providerPhone': formattedPhone,
          'providerImage': profileImageUrl,
          'planId': plan['id'] ?? '',
          'packageName': plan['title'] ?? '',
          'period': plan['period'] ?? '',
          'durationMonths': durationMonths,
          'price': price,
          'paymentMethodId': paymentMethod['id'] ?? '',
          'paymentMethodTitle': paymentMethod['title'] ?? '',
          'transferImage': transferImageUrl,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        workerData['isSubscribed'] = false;
        workerData['subscription'] = {
          'isActive': false,
          'status': 'pending',
          'requestId': requestRef.id,
          'planId': plan['id'] ?? '',
          'packageName': plan['title'] ?? '',
          'period': plan['period'] ?? '',
          'durationMonths': durationMonths,
          'price': price,
          'paymentMethodId': paymentMethod['id'] ?? '',
          'paymentMethodTitle': paymentMethod['title'] ?? '',
          'transferImage': transferImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
          'startDate': null,
          'endDate': null,
          'rejectionReason': null,
        };
      }

      batch.set(userRef, workerData);

      await batch.commit();

      await saveUserToken(uid);

      await CacheHelper.saveData(key: 'uid', value: uid);
      await CacheHelper.setBoolen(key: 'isLoggedIn', value: true);
      await CacheHelper.saveData(key: 'role', value: 'provider');

      pendingWorkerProfile = null;
      pendingWorkerVerification = null;
      pendingWorkerSubscription = null;
      selectedCategory = null;
      workerNameController.clear();
      workerPhoneController.clear();
      workerPasswordController.clear();

      emit(WorkerSignUpSuccessState());
    } catch (e) {
      emit(WorkerSignUpErrorState(error: e.toString()));
    }
  }

  Future<void> workerSignUpUser({
    required String name,
    required String phone,
    required String password,
  })
  async {
    try {
      emit(WorkerSignUpLoadingState());

      final formattedPhone = normalizeYemeniPhone(phone);
      final formattedName = normalizeQuadName(name);

      if (!isValidQuadName(formattedName)) {
        emit(WorkerSignUpErrorState(
          error: 'يرجى إدخال الاسم الرباعي المكون من 4 أسماء فقط',
        ));
        return;
      }

      if (!isValidYemeniPhone(formattedPhone)) {
        emit(WorkerSignUpErrorState(
          error: 'يرجى إدخال رقم يمني صحيح مكون من 9 أرقام ويبدأ بالرقم 7',
        ));
        return;
      }

      final uid = FirebaseFirestore.instance.collection('users').doc().id;

      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        emit(WorkerSignUpErrorState(error: 'رقم الهاتف مستخدم مسبقًا'));
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'phone': formattedPhone,
        'name': formattedName,
        'password': hashPassword(password),
        'role': 'provider',
        'specialization': '',
        'address': '',
        'avgRating': 0.0,
        'ratingSum': 0.0,
        'ratingsCount': 0,
        'isActive' : true,
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
  })
  async {
    try {
      emit(ResetPasswordLoadingState());

      final String formattedPhone = normalizeYemeniPhone(phone);
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
        'password': hashPassword(formattedPassword),
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
  })
  async {
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
  })
  async {
    try {
      emit(LoginLoadingState());

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: normalizeYemeniPhone(phone))
          .where('password', isEqualTo: hashPassword(password.trim()))
          .where('role', isEqualTo: requiredRole)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        emit(LoginErrorState(error: 'رقم الهاتف أو كلمة المرور غير صحيحة',),);
        return;
      }

      final doc = userDoc.docs.first;
      final userData = doc.data();

      final bool isActive = userData['isActive'] ?? true;

      if (!isActive) {
        emit(LoginErrorState(error: 'تم تعطيل هذا الحساب، يرجى التواصل مع الإدارة',),);
        return;
      }

      final String role = userData['role']?.toString().trim() ?? '';
      final String uid = doc.id;

      if (role != requiredRole) {
        emit(LoginErrorState(error: 'ليس لديك صلاحية الدخول من هذه الصفحة',),);
        return;
      }

      await CacheHelper.saveData(key: 'uid', value: uid,);
      await CacheHelper.saveData(key: 'role', value: role,);
      await CacheHelper.setBoolen(key: 'isLoggedIn', value: true,);

      await saveUserToken(uid);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(error: e.toString(),),);
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

  Future<void> saveUserToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'token': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        });
        print("تم تحديث الـ Token في الخلفية بنجاح");
      }
    } catch (e) {
      print("فشل تحديث الـ Token: ${e.toString()}");
    }
  }
}
