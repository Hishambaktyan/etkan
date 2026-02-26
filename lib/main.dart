import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/shared/cubit/bloc_observer.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/styles/styles.dart';
import 'firebase_options.dart';
import 'layout/worker_layout/worker_main_screen.dart';
import 'modules/user_screens/the_chat.dart';
import 'notification_helper.dart';

void move(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 10),
      reverseTransitionDuration: const Duration(milliseconds: 10),
    ),
  );
}

void moveAndReplace(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 10),
      reverseTransitionDuration: const Duration(milliseconds: 10),
    ),
    (route) => false,
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationHelper.display(message);
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
    if(user.emailVerified){
        print('-----------------------------------------"تم تسجيل الدخول بنجاح، الـ UID هو: ${user.uid}');
      }
    }
    else {
      print("لا يوجد مستخدم مسجل حاليا-----------------------------ً");
    }
  });

  Bloc.observer = MyBlocObserver();

  NotificationHelper.initialize();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      NotificationHelper.display(message);
    }
  });

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    String chatId = message.data['chatId'] ?? '';
    String senderId = message.data['senderId'] ?? '';

    if (chatId.isNotEmpty && senderId.isNotEmpty) {

      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(senderId).get();

      String otherUsername = snapshot.data()?['name'] ?? 'مستخدم';
      String otherUserImage = snapshot.data()?['image'] ?? '';

      move(
        navigatorKey.currentContext!,
        TheChat(
          otherUserId: senderId,
          chatId: chatId,
          myId: FirebaseAuth.instance.currentUser!.uid,
          otherUsername: otherUsername,
          otherUserImage: otherUserImage,
        ),
      );
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      NotificationHelper.display(message);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) =>  BlocProvider(
        create: (context) => MyCubit()..checkUser(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: FirebaseAuth.instance.currentUser!= null
          && FirebaseAuth.instance.currentUser!.emailVerified ? const WorkerMainScreen()
              : const LoginScreen() ,
        ),
      ),
    );
  }
}