import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/compenents/components.dart';
import '../../shared/cubits/app_cubit/app_cubit.dart';
import '../../shared/cubits/app_cubit/app_states.dart';
import '../../shared/styles/colors.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  DateTime? lastBackPressedTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              final now = DateTime.now();
              final bool shouldExit = lastBackPressedTime != null &&
                  now.difference(lastBackPressedTime!) <= const Duration(seconds: 2);
              if (shouldExit) {
                SystemNavigator.pop();
              } else {
                lastBackPressedTime = now;
                showSnackBar(Colors.orange, 'اضغط مرة أخرى للخروج', context);
              }
            },
            child: Scaffold(
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: NavigationBar(
                      labelTextStyle: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return TextStyle(
                            color: mainColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          );
                        }
                        return TextStyle(
                          color: appCubit.isDark ? Colors.grey : Colors.black54,
                          fontSize: 11.sp,
                        );
                      }),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      indicatorColor: mainColor.withOpacity(0.2),
                      selectedIndex: appCubit.currentIndex,
                      onDestinationSelected: (value) {
                        appCubit.changeIndex(value);
                      },
                      destinations: [
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            'assets/home.svg',
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey,
                          ),
                          selectedIcon: SvgPicture.asset(
                            'assets/home_bold.svg',
                            width: 25.w,
                            height: 25.h,
                            color: appCubit.currentIndex == 0
                                ? mainColor
                                : Colors.grey,
                          ),
                          label: 'الرئيسية',
                        ),
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            'assets/grid.svg',
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey,
                          ),
                          selectedIcon: SvgPicture.asset(
                            'assets/grid_bold.svg',
                            width: 25.w,
                            height: 25.h,
                            color: appCubit.currentIndex == 1
                                ? mainColor
                                : Colors.grey,
                          ),
                          label: 'الأقسام',
                        ),
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            'assets/ticket.svg',
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey,
                          ),
                          selectedIcon: SvgPicture.asset(
                            'assets/ticket_bold.svg',
                            width: 25.w,
                            height: 25.h,
                            color: appCubit.currentIndex == 2
                                ? mainColor
                                : Colors.grey,
                          ),
                          label: 'الحجوزات',
                        ),
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            'assets/chat.svg',
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey,
                          ),
                          selectedIcon: SvgPicture.asset(
                            'assets/chat_bold.svg',
                            width: 25.w,
                            height: 25.h,
                            color: appCubit.currentIndex == 3
                                ? mainColor
                                : Colors.grey,
                          ),
                          label: 'المحادثات',
                        ),
                        NavigationDestination(
                          icon: SvgPicture.asset(
                            'assets/setting.svg',
                            width: 25.w,
                            height: 25.h,
                            color: Colors.grey,
                          ),
                          selectedIcon: SvgPicture.asset(
                            'assets/setting_bold.svg',
                            width: 25.w,
                            height: 25.h,
                            color: appCubit.currentIndex == 4
                                ? mainColor
                                : Colors.grey,
                          ),
                          tooltip: 'الإعدادات',
                          label: 'الإعدادات',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: appCubit.userScreen[appCubit.currentIndex],
            ),
          ),
        );
      },
    );
  }
}
