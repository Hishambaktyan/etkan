import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trying_homy/modules/worker_screens/worker_services_list.dart';

import '../../../modules/user_screens/user_requests_list.dart';
import '../../../modules/user_screens/user_categories.dart';
import '../../../modules/user_screens/user_home.dart';
import '../../../modules/user_screens/user_account.dart';
import '../../../modules/user_screens/user_chats.dart';
import '../../../modules/worker_screens/worker_account.dart';
import '../../../modules/worker_screens/worker_requests_list.dart';
import '../../../modules/worker_screens/worker_chats.dart';
import '../../../modules/worker_screens/worker_home.dart';
import '../../networks/local/cache_helper.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> with WidgetsBindingObserver {
  AppCubit() : super(InitState()) {
    WidgetsBinding.instance.addObserver(this);

    final bool? savedTheme = CacheHelper.getBoolen(key: 'isDark');

    if (savedTheme != null) {
      isDark = savedTheme;
    } else {
      syncThemeWithSystem(emitChange: false);
    }
  }

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  List<Widget> workerScreens = [
    const WorkerHome(),
    const WorkerServicesList(),
    const WorkerRequestsList(),
    const WorkerChats(),
    const WorkerAccount(),
  ];

  List<Widget> userScreen = [
    const UserHome(),
    const UserCategories(),
    const UserRequestsList(),
    const UserChats(),
    const UserAccount(),
  ];

  void changeIndex(value) {
    currentIndex = value;
    emit(ChangeNavBarState());
  }

  void syncThemeWithSystem({bool emitChange = true}) {
    final bool? savedTheme = CacheHelper.getBoolen(key: 'isDark');

    // إذا المستخدم اختار الثيم من الزر، لا تخلي النظام يغيره عليه
    if (savedTheme != null) {
      isDark = savedTheme;
      return;
    }

    final bool systemIsDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;

    if (isDark == systemIsDark) return;

    isDark = systemIsDark;

    if (emitChange) {
      emit(ChangeThemeState());
    }
  }

  @override
  void didChangePlatformBrightness() {
    syncThemeWithSystem();
  }

  void changeTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
    } else {
      isDark = !isDark;
    }

    CacheHelper.saveData(key: 'isDark', value: isDark);

    emit(ChangeThemeState());
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  Map<String, dynamic> allUsers = {};

  Future<void> getAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    allUsers = {};

    for (var doc in snapshot.docs) {
      allUsers[doc.id] = doc.data();
    }
  }
}
