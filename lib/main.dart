import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/modules/user_screens/user_cubits/user_servies_cubit/user_services_cubit.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/cubits/bloc_observer.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_cubit.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'package:trying_homy/shared/styles/styles.dart';
import 'firebase_options.dart';
import 'layout/user_layout/user_main_screen.dart';
import 'layout/worker_layout/worker_main_screen.dart';
import 'modules/admin_screens/admin_home_screen.dart';
import 'modules/on_boarding.dart';
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

Widget startWidget = const OnBoardingScreen();

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
