import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/modules/user_screens/user_chats.dart';
import '../../modules/user_screens/bookings_screen.dart';
import '../../modules/user_screens/home_screen.dart';
import '../../modules/user_screens/user_account.dart';
import '../../modules/user_screens/dept.dart';
import '../../shared/styles/colors.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = <Widget>[
      HomeScreen(
        onCategoryTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      const Dept(),
      const BookingsScreen(),
      const UserChats(),
      const UserAccount(),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: currentIndex,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/home.svg',
                width: 25.w,
                height: 25.h,
                color: currentIndex == 0 ? mainColor : Colors.grey,
              ),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/grid.svg',
                width: 25.w,
                height: 25.h,
                color: currentIndex == 1 ? mainColor : Colors.grey,
              ),
              label: 'الأقسام',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/ticket.svg',
                width: 25.w,
                height: 25.h,
                color: currentIndex == 2 ? mainColor : Colors.grey,
              ),
              label: 'الحجوزات',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/chat.svg',
                width: 25.w,
                height: 25.h,
                color: currentIndex == 3 ? mainColor : Colors.grey,
              ),
              label: 'الدردشة',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/acc.svg',
                width: 25.w,
                height: 25.h,
                color: currentIndex == 4 ? mainColor : Colors.grey,
              ),
              label: 'الحساب',
            ),
          ],
          onDestinationSelected: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
        body: screens[currentIndex],
      ),
    );
  }
}
