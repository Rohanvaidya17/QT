import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Brand Colors
  static const Color primaryColor = Color(0xFF009688);
  static const Color secondaryColor = Color(0xFF26A69A);
  static const Color accentColor = Color(0xFF80CBC4);
  
  // Neutral Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1C1C1E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFABABAB);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Spacing
  static const double spacing_2xs = 4;
  static const double spacing_xs = 8;
  static const double spacing_sm = 12;
  static const double spacing_md = 16;
  static const double spacing_lg = 24;
  static const double spacing_xl = 32;
  static const double spacing_2xl = 48;
  static const double spacing_3xl = 64;

  // Border Radius
  static const double radius_sm = 4;
  static const double radius_md = 8;
  static const double radius_lg = 12;
  static const double radius_xl = 16;
  static const double radius_2xl = 24;
  static const double radius_full = 999;

  // Shadows
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Get theme data
  static ThemeData getLightTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      brightness: Brightness.light,
      textTheme: _getTextTheme(false),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      appBarTheme: _getAppBarTheme(false),
      cardTheme: _getCardTheme(false),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceLight,
        background: backgroundLight,
        error: error,
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      brightness: Brightness.dark,
      textTheme: _getTextTheme(true),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      appBarTheme: _getAppBarTheme(true),
      cardTheme: _getCardTheme(true),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceDark,
        background: backgroundDark,
        error: error,
      ),
    );
  }

  // Text Theme
  static TextTheme _getTextTheme(bool isDark) {
    final Color primaryTextColor = isDark ? textPrimaryDark : textPrimaryLight;
    final Color secondaryTextColor = isDark ? textSecondaryDark : textSecondaryLight;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: primaryTextColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: secondaryTextColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryTextColor,
      ),
    );
  }

  // Button Themes
  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 48),
      padding: const EdgeInsets.symmetric(horizontal: spacing_md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius_md),
      ),
      elevation: 0,
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      minimumSize: const Size(88, 48),
      padding: const EdgeInsets.symmetric(horizontal: spacing_md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius_md),
      ),
      side: const BorderSide(color: primaryColor),
    ),
  );

  // Input Decoration Theme
  static final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: surfaceLight,
    contentPadding: const EdgeInsets.all(spacing_md),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius_md),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius_md),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius_md),
      borderSide: const BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius_md),
      borderSide: const BorderSide(color: error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius_md),
      borderSide: const BorderSide(color: error),
    ),
  );

  // AppBar Theme
  static AppBarTheme _getAppBarTheme(bool isDark) {
    return AppBarTheme(
      backgroundColor: isDark ? surfaceDark : surfaceLight,
      elevation: 0,
      iconTheme: IconThemeData(
        color: isDark ? textPrimaryDark : textPrimaryLight,
      ),
      titleTextStyle: TextStyle(
        color: isDark ? textPrimaryDark : textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Card Theme
  static CardTheme _getCardTheme(bool isDark) {
    return CardTheme(
      color: isDark ? surfaceDark : surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius_lg),
      ),
      margin: const EdgeInsets.all(spacing_xs),
    );
  }
}