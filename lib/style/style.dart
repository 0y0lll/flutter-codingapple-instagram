import 'package:flutter/material.dart';

var themeData = ThemeData(
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      backgroundColor: Colors.black,
      textStyle: TextStyle(
        color: Colors.white,
        decorationColor: Colors.white,
      ),
    )),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Colors.black),
      selectedLabelStyle: TextStyle(color: Colors.black),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black, fontSize: 16)));
