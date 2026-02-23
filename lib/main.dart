import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/cubit/bloc_observer.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/styles/styles.dart';
import 'layout/worker_layout/worker_main_screen.dart';

void move(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: Duration(milliseconds: 10),
      reverseTransitionDuration: Duration(milliseconds: 10),
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
      transitionDuration: Duration(milliseconds: 10),
      reverseTransitionDuration: Duration(milliseconds: 10),
    ),
    (route) => false,
  );
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  Bloc.observer = MyBlocObserver();
  runApp( const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) =>  BlocProvider(
          create: (context) => MyCubit(),
        child: MaterialApp(
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home:const WorkerMainScreen(),
        ),
      )
    );
  }
}