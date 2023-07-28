import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  // scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
  scaffoldBackgroundColor: const Color(0xFF0E1017),
  dividerColor: Colors.white24,
  primarySwatch: Colors.yellow,

  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff0e1017),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      )),

  // listTileTheme: const ListTileThemeData(iconColor: Colors.white),


  drawerTheme: DrawerThemeData(
    backgroundColor: const Color(0xFF0E1017),
  ),

  textTheme: TextTheme(
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    labelSmall: TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
  ),

// colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow,),
  useMaterial3: false,
);
