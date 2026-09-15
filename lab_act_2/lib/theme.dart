import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF70823E);
  static const cream = Color(0xFFDFCF99);
  static const yellow = Color(0xFFE0B44A);
  static const orange = Color(0xFFD8853F);
  static const lightCream = Color(0xFFF3EAD8);
  static const brown = Color(0xFF866C5A);

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: lightCream,

    appBarTheme: const AppBarTheme(
      backgroundColor: brown,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cream,
        foregroundColor: brown,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}