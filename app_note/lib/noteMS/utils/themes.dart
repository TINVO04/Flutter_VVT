import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
      bodySmall: TextStyle(color: Colors.grey, fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey[900],
      foregroundColor: Colors.white,
    ),
    cardColor: Colors.grey[800],
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      bodySmall: TextStyle(color: Colors.grey[400], fontSize: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
    ),
  );
}