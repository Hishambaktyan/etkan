import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'Tajawal',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
    appBarTheme: const AppBarTheme(
      backgroundColor:  Colors.white,
      scrolledUnderElevation: 0,
    )
);