
import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF7F2DF);
  static const Color darkRed = Color(0xFF900000);
  static const Color deepRed = Color(0xFFB00000);
  static const Color roseRed = Color(0xFFC4143D);
  static const Color mutedRed = Color(0xFFA5363C);
  static const Color accentRed = Color(0xFF7E0000);

  static const List<Color> classColors = [
    darkRed,
    deepRed,
    roseRed,
    mutedRed,
    accentRed,
  ];

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkRed,
        surface: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: darkRed,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: roseRed.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            color: darkRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
