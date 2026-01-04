import 'package:flutter/material.dart';

class AppTheme {
  // Raw Colors
  static const Color _primaryOrange = Color(0xFFE88E4D);
  static const Color _darkBackground = Color(0xFF1D1A49);
  static const Color _darkSurface = Color(0xFF292C6D);
  static const Color _lightBackground = Color(0xFFF5F5F5); // Grey 100
  static const Color _lightSurface = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryOrange,
    scaffoldBackgroundColor: _lightBackground,
    cardColor: _lightSurface,
    colorScheme: const ColorScheme.light(
      primary: _primaryOrange,
      secondary: _primaryOrange, // Accent
      surface: _lightSurface,
      onSurface: Colors.black,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryOrange,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryOrange,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryOrange,
    scaffoldBackgroundColor: _darkBackground,
    cardColor: _darkSurface,
    colorScheme: const ColorScheme.dark(
      primary: _primaryOrange,
      secondary: _primaryOrange,
      surface: _darkSurface,
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryOrange, // Keeping primary for appbar in dark mode too? Or dark? 
      // Original was: backgroundColor: AppColors.primary (Orange)
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryOrange,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
