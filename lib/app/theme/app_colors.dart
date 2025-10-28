import 'package:flutter/material.dart';

/// Defines all the color constants used across the app.
class AppColors {
  // 🌞 Light theme colors
  static const Color primary = Color(0xFF2E7D32); // green tone for health/farming
  static const Color secondary = Color(0xFF66BB6A);
  static const Color accent = Color(0xFF43A047);
  static const Color background = Color(0xFFF9FAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // 🌚 Dark theme colors
  static const Color darkPrimary = Color(0xFF1B5E20);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  // ⚪️ Neutrals
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);

  // ❤️ Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // 🦴 Skeleton placeholder colors
  static const Color skeletonBase = Color(0xFFE0E0E0);
  static const Color skeletonHighlight = Color(0xFFF5F5F5);
}
