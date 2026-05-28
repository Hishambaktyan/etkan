import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/cubits/bloc_observer.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_cubit.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'package:trying_homy/shared/styles/styles.dart';
import 'firebase_options.dart';
import 'layout/user_layout/user_main_screen.dart';
import 'layout/worker_layout/worker_main_screen.dart';
import 'modules/admin_screens/admin_home_screen.dart';
import 'modules/on_boarding.dart';
import 'modules/the_chat.dart';
import 'modules/user_screens/user_cubits/booking_cubit/booking_cubit.dart';

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

Map<String, dynamic>? pendingNotificationData;

const AndroidNotificationChannel highImportanceChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> initLocalNotifications({bool requestPermission = true}) async {
  const androidSettings =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const settings = InitializationSettings(
    android: androidSettings,
  );

  await localNotifications.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Local notification clicked while app running/background');
      print('Payload: ${response.payload}');

      if (response.payload == null || response.payload!.isEmpty) return;

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(response.payload!));

      final context = navigatorKey.currentContext;

      if (context != null) {
        NotificationCubit.get(context).handleNotificationData(data);
      } else {
        pendingNotificationData = data;
      }
    },
  );

  if (requestPermission) {
    final NotificationAppLaunchDetails? launchDetails =
        await localNotifications.getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails!.notificationResponse?.payload;

      print('App launched from local notification');
      print('Launch payload: $payload');

      if (payload != null && payload.isNotEmpty) {
        pendingNotificationData =
            Map<String, dynamic>.from(jsonDecode(payload));

        print('pendingNotificationData saved: $pendingNotificationData');
      }
    }
  }

  await localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(highImportanceChannel);

  if (requestPermission) {
    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
}

Future<void> showLocalNotification(RemoteMessage message) async {
  final data = message.data;

  final String type = data['type']?.toString() ?? '';
  final String relatedId = data['relatedId']?.toString() ?? '';

  if (type == 'new_message' && TheChat.currentChatId == relatedId) {
    print('تم تجاهل إشعار الرسالة لأن المستخدم داخل نفس الدردشة');
    return;
  }

  final title = data['title']?.toString() ?? 'إشعار جديد';
  final body = data['body']?.toString() ?? '';

  await localNotifications.show(
    DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        highImportanceChannel.id,
        highImportanceChannel.name,
        channelDescription: highImportanceChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
      ),
    ),
    payload: jsonEncode(data),
  );
}

Widget startWidget = const OnBoardingScreen();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DartPluginRegistrant.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initLocalNotifications(requestPermission: false);

  print('رسالة وصلت في الخلفية: ${message.messageId}');
  print('Data: ${message.data}');

  await showLocalNotification(message);
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

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initLocalNotifications(requestPermission: true);

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolen(key: 'isDark');
  bool isLoggedIn = CacheHelper.getBoolen(key: 'isLoggedIn') ?? false;
  String role = CacheHelper.getData(key: 'role') ?? '';

  if (isLoggedIn) {
    if (role == 'user') {
      startWidget = const UserMainScreen();
    } else if (role == 'provider') {
      startWidget = const WorkerMainScreen();
    } else if (role == 'admin') {
      startWidget = const AdminHomeScreen();
    } else {
      startWidget = const OnBoardingScreen();
    }
  } else {
    startWidget = const OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  const MyApp({super.key, this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit()
            ..changeTheme(fromShared: isDark)
            ..getAllUsers(),
        ),
        BlocProvider<UserServicesCubit>(
          create: (context) => UserServicesCubit(),
        ),
        BlocProvider<BookingCubit>(
          create: (context) => BookingCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(),
        ),
        BlocProvider<AdminCubit>(
          create: (context) => AdminCubit()
            ..getAdminData()
            ..startListening(),
        ),
        BlocProvider<WorkerCubit>(
            create: (context) => WorkerCubit()..getWorkerData()),
        BlocProvider(
          create: (context) => NotificationCubit()..initFirebaseMessaging(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              var cubit = AppCubit.get(context);
              return MaterialApp(
                  navigatorKey: navigatorKey,
                  themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  debugShowCheckedModeBanner: false,
                  home: startWidget);
            },
          );
        },
      ),
    );
  }
}
