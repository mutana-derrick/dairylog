import 'package:flutter/material.dart';

/// Defines all the color constants used across the app.
/// Synchronized with app_theme.dart for consistency
class AppColors {
  // 🌞 Primary Colors - Light Theme
  static const Color primary = Color(0xFF2E7D32); // Green tone for health/farming
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFF66BB6A);
  static const Color accent = Color(0xFF43A047);
  
  // 📄 Backgrounds - Light Theme
  static const Color background = Color(0xFFF9FAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFFFF8E1);

  // 🌚 Dark Theme Colors
  static const Color darkPrimary = Color(0xFF1B5E20);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2C2C2C);

  // ⚪️ Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);

  // 🔲 Borders & Dividers
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);

  // ❤️ Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color info = Color(0xFF1976D2);

  // 🔘 Disabled States
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledBackground = Color(0xFFF5F5F5);

  // 🎨 Effects
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x66000000);

  // 🦴 Skeleton Placeholder Colors
  static const Color skeletonBase = Color(0xFFE0E0E0);
  static const Color skeletonHighlight = Color(0xFFF5F5F5);
}