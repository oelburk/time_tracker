import 'package:flutter/material.dart';

abstract final class AppColors {
  // Coding mode
  static const codingPrimary = Color(0xFF00BFA5);
  static const codingLight = Color(0xFF1DE9B6);
  static const codingDark = Color(0xFF00897B);

  // Meeting mode
  static const meetingPrimary = Color(0xFFFF9800);
  static const meetingLight = Color(0xFFFFB74D);
  static const meetingDark = Color(0xFFF57C00);

  // Light theme
  static const lightBackground = Color(0xFFF8F9FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF1F3F4);
  static const lightBorder = Color(0xFFE0E0E0);
  static const lightTextPrimary = Color(0xFF1A1A2E);
  static const lightTextSecondary = Color(0xFF6B7280);

  // Dark theme
  static const darkBackground = Color(0xFF0F0F1A);
  static const darkSurface = Color(0xFF1A1A2E);
  static const darkSurfaceVariant = Color(0xFF252540);
  static const darkBorder = Color(0xFF2D2D4A);
  static const darkTextPrimary = Color(0xFFE8E8F0);
  static const darkTextSecondary = Color(0xFF9CA3AF);

  // Shared
  static const error = Color(0xFFEF4444);
  static const idle = Color(0xFF6B7280);
}
