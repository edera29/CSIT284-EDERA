
import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF386641);
  static const lightGreen = Color(0xFFA7C957);
  static const cream = Color(0xFFF2E8CF);
  static const orange = Color(0xFFE09F3E);
  static const dark = Color(0xFF283618);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: cream,

    colorScheme: ColorScheme.fromSeed(
      seedColor: green,
      primary: green,
      secondary: orange,
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: green,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}