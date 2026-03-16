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
import 'package:trying_homy/shared/cubit/states.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'package:trying_homy/shared/styles/styles.dart';
import 'firebase_options.dart';
import 'layout/worker_layout/worker_main_screen.dart';
import 'modules/user_screens/the_chat.dart';
import 'notification_helper.dart';
import 'on_boarding.dart';

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

void handleNotificationClick(RemoteMessage message) {
  String chatId = message.data['chatId'] ?? '';
  String senderId = message.data['senderId'] ?? '';
  String senderName = message.data['senderName'] ?? 'مستخدم';
  String senderImage = message.data['senderImage'] ?? '';

  if (chatId.isNotEmpty && senderId.isNotEmpty && FirebaseAuth.instance.currentUser != null) {
    moveAndReplace(
      navigatorKey.currentContext!,
      TheChat(
        otherUserId: senderId,
        chatId: chatId,
        myId: FirebaseAuth.instance.currentUser!.uid,
        otherUsername: senderName,
        otherUserImage: senderImage,
      ),
    );
  }
}

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
    NotificationHelper.display(message);
  });

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        handleNotificationClick(message);
      });
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    handleNotificationClick(message);
  });

  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolen(key: 'isDark');

  runApp(MyApp(isDark));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  const MyApp(this.isDark, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyCubit()..checkUser()..changeTheme(fromShared: isDark)..getWorkerData(),
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<MyCubit, States>(
            builder: (context, state) {
              var cubit = MyCubit.get(context);
              return MaterialApp(
                navigatorKey: navigatorKey,
                themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
                theme: lightTheme,
                darkTheme: darkTheme,
                debugShowCheckedModeBanner: false,
                home: FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified
                    ? const WorkerMainScreen()
                    : const OnBoardingScreen(),
              );
            },
          );
        },
      ),
    );
  }
}