import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryLight = Color(0xFFB71C1C);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFFFF4E6);
  static const Color onBackgroundLight = Color(0xFF7A0000);
  static const Color onSurfaceLight = Color(0xFF3A0000);
  static const Color primaryDark = Color(0xFFFFC107);
  static const Color onPrimaryDark = Color(0xFF2A0000);
  static const Color backgroundDark = Color(0xFF0D0B0B);
  static const Color onBackgroundDark = Color(0xFFFFE082);
  static const Color onSurfaceDark = Color(0xFFCFD8DC);

  static const ColorScheme lightColors = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: onPrimaryLight,
    secondary: primaryLight,
    onSecondary: onPrimaryLight,
    error: Colors.red,
    onError: Colors.white,
    surface: backgroundLight,
    onSurface: onSurfaceLight,
  );

  static const ColorScheme darkColors = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: onPrimaryDark,
    secondary: primaryDark,
    onSecondary: onPrimaryDark,
    error: Colors.redAccent,
    onError: Colors.black,
    surface: backgroundDark,
    onSurface: onSurfaceDark,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColors,
    scaffoldBackgroundColor: backgroundLight,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColors,
    scaffoldBackgroundColor: backgroundDark,
  );
}
