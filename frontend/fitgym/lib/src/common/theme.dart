import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.orangeAccent,
      side: const BorderSide(color: Colors.orangeAccent, width: 2),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    titleLarge: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 28),
  ),
  iconTheme: const IconThemeData(color: Colors.orangeAccent, size: 32),
); 