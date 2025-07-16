import 'package:flutter/material.dart';

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.orangeAccent,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.orangeAccent,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.orangeAccent,
    secondary: Colors.orangeAccent,
    background: Colors.black,
    surface: Colors.grey,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  cardColor: Colors.grey[850],
  dialogBackgroundColor: Colors.grey[900],
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey[900]),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      overlayColor: Colors.transparent,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.orangeAccent,
      side: const BorderSide(color: Colors.orangeAccent, width: 2),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      overlayColor: Colors.transparent,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      overlayColor: Colors.transparent,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    titleLarge: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 28),
  ),
  iconTheme: const IconThemeData(color: Colors.orangeAccent, size: 32),
);

final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orangeAccent,
    foregroundColor: Colors.black,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.orangeAccent,
    secondary: Colors.orangeAccent,
    background: Colors.white,
    surface: Colors.white,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      overlayColor: Colors.transparent,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.orangeAccent,
      side: const BorderSide(color: Colors.orangeAccent, width: 2),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      overlayColor: Colors.transparent,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      overlayColor: Colors.transparent,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
    titleLarge: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 28),
  ),
  iconTheme: const IconThemeData(color: Colors.orangeAccent, size: 32),
); 