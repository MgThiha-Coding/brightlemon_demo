import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'LemonBright Foundation';
  
  // Compassionate Professional Blue & White
  static const Color primaryColor = Color(0xFF172554); // Deep Navy/Professional Blue
  static const Color accentColor = Color(0xFF3B82F6);  // Modern Blue for highlights
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFF8FAFC);    // Refined Slate/White
  static const Color textMainColor = Color(0xFF0F172A); // Midnight Slate
  static const Color textSecondaryColor = Color(0xFF475569); // Professional Steel Gray
  static const Color whiteColor = Colors.white;
  static const Color errorColor = Color(0xFF991B1B);

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  static const double borderRadius = 12.0;

  // Mock Delay
  static const Duration mockDelay = Duration(milliseconds: 500);
}
