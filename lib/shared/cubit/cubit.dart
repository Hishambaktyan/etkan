import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
}