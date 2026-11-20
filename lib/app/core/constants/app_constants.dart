import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOrange = Color(0xFFFF6B2C);
  static const Color mangoYellow = Color(0xFFFFB703);
  static const Color strawberryRed = Color(0xFFE63946);
  static const Color leafGreen = Color(0xFF2DC653);
  static const Color creamBg = Color(0xFFFFF8F0);
  static const Color softPeach = Color(0xFFFFE0CC);
  static const Color deepCharcoal = Color(0xFF1A1A2E);
  static const Color mutedGrey = Color(0xFF8D8D8D);
  static const Color cardWhite = Color(0xFFFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, mangoYellow],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFFF8C00), Color(0xFFE63946)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF2DC653), Color(0xFF00B09B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppStrings {
  static const String appName = 'Fruzo';
  static const String tagline = 'Fresh Fruit Cups 🍓';
  static const String currency = 'PKR';
  static const String adminUsername = 'admin';
  static const String adminPassword = 'admin123';
}

class AppSizes {
  static const double borderRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double navBarRadius = 30.0;
  static const double cardElevation = 4.0;
  static const double screenPadding = 16.0;
}
