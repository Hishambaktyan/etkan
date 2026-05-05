import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'Tajawal',
    scaffoldBackgroundColor: const Color(0xFFF6FBFF),
    colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
    appBarTheme: const AppBarTheme(
      backgroundColor:  Color(0xFFF6FBFF),
      scrolledUnderElevation: 0,
      titleSpacing: 10,
      elevation: 0,
    ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
      )
  ),
  iconTheme: const IconThemeData(
      color: Colors.black
  ),
);

ThemeData darkTheme = ThemeData(
    fontFamily: 'Tajawal',
    scaffoldBackgroundColor: darkBgColor,
    colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
    appBarTheme: const AppBarTheme(
      backgroundColor:  darkBgColor,
      scrolledUnderElevation: 0,
    ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.white,
    )
  ),
  iconTheme: const IconThemeData(
    color: Colors.white
  ),
);