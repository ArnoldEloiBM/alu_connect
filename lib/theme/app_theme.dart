import 'package:flutter/material.dart';

/// Central place for the ALU Connect dark theme: deep navy backgrounds with
/// gold accents. Tweak these values to restyle the whole app.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B1220);
  static const Color surface = Color(0xFF131C2E);
  static const Color surfaceAlt = Color(0xFF1B2840);
  static const Color gold = Color(0xFFF5B301);
  static const Color goldDark = Color(0xFFD99B00);
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF8A97AC);
  static const Color danger = Color(0xFFE5484D);
  static const Color border = Color(0xFF223049);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.gold,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
      ),
      cardColor: AppColors.surface,
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
      ),
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF0F2F5),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.gold,
        secondary: AppColors.gold,
        surface: Colors.white,
        onPrimary: Colors.black,
        onSurface: const Color(0xFF0D1B2A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF0D1B2A),
        centerTitle: false,
      ),
      cardColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
      ),
    );
  }
}
