import 'package:flutter/material.dart';

abstract final class AppColors {
  // Coding — desaturated teal, not screaming neon
  static const codingPrimary = Color(0xFF2DD4BF);
  static const codingLight = Color(0xFF5EEAD4);
  static const codingDark = Color(0xFF14B8A6);
  static const codingMuted = Color(0xFF0D3D38);

  // Meeting — warm amber, not traffic-cone orange
  static const meetingPrimary = Color(0xFFFBBF24);
  static const meetingLight = Color(0xFFFDE68A);
  static const meetingDark = Color(0xFFF59E0B);
  static const meetingMuted = Color(0xFF3D3210);

  // Light theme — tinted cool gray
  static const lightBackground = Color(0xFFF4F4F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFEBEBF0);
  static const lightBorder = Color(0xFFD4D4DC);
  static const lightTextPrimary = Color(0xFF18181B);
  static const lightTextSecondary = Color(0xFF71717A);
  static const lightTextTertiary = Color(0xFFA1A1AA);

  // Dark theme — deep blue-gray, not pure black
  static const darkBackground = Color(0xFF0C0C14);
  static const darkSurface = Color(0xFF13131D);
  static const darkSurfaceVariant = Color(0xFF1C1C28);
  static const darkBorder = Color(0xFF27273A);
  static const darkTextPrimary = Color(0xFFE4E4ED);
  static const darkTextSecondary = Color(0xFF71717F);
  static const darkTextTertiary = Color(0xFF52526A);

  // Semantic
  static const error = Color(0xFFEF4444);
  static const idle = Color(0xFF52526A);

  // Positive/negative trends
  static const positive = Color(0xFF22C55E);
  static const negative = Color(0xFFEF4444);
}
