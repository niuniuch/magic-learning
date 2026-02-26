import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFF6C63FF);
  static const _secondaryColor = Color(0xFFFF6584);
  static const _backgroundColor = Color(0xFFF5F0FF);
  static const _surfaceColor = Colors.white;
  static const _correctColor = Color(0xFF4CAF50);
  static const _incorrectColor = Color(0xFFFF5252);
  static const _starColor = Color(0xFFFFD700);

  static Color get correctColor => _correctColor;
  static Color get incorrectColor => _incorrectColor;
  static Color get starColor => _starColor;

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          secondary: _secondaryColor,
          surface: _surfaceColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: _backgroundColor,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D2D2D),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFF2D2D2D),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF2D2D2D),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF2D2D2D),
        ),
      );
}
