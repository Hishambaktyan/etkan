import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'Tajawal',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
    appBarTheme: const AppBarTheme(
      backgroundColor:  Colors.white,
      scrolledUnderElevation: 0,
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