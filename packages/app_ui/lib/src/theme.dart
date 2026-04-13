import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

/// Application themes for the time tracker (light and dark).
abstract final class AppTheme {
  static ThemeData lightTheme() {
    const bg = AppColors.lightBackground;
    const surface = AppColors.lightSurface;
    const border = AppColors.lightBorder;
    const primary = AppColors.lightTextPrimary;
    const secondary = AppColors.lightTextSecondary;

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      side: const BorderSide(color: border, width: 1),
    );

    final textTheme = TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primary),
      displayMedium: AppTypography.headlineMedium.copyWith(color: primary),
      displaySmall: AppTypography.titleMedium.copyWith(color: primary),
      headlineLarge: AppTypography.displayLarge.copyWith(color: primary),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: primary),
      headlineSmall: AppTypography.titleMedium.copyWith(color: primary),
      titleLarge: AppTypography.titleMedium.copyWith(color: primary),
      titleMedium: AppTypography.titleMedium.copyWith(color: primary),
      titleSmall: AppTypography.bodyLarge.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primary),
      bodyMedium: AppTypography.bodyLarge.copyWith(color: primary),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondary),
      labelLarge: AppTypography.labelLarge.copyWith(color: primary),
      labelMedium: AppTypography.bodySmall.copyWith(color: secondary),
      labelSmall: AppTypography.bodySmall.copyWith(color: secondary),
    );

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: AppColors.codingPrimary,
      canvasColor: bg,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: border,
      splashColor: AppColors.codingPrimary.withValues(alpha: 0.12),
      highlightColor: AppColors.codingPrimary.withValues(alpha: 0.08),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: cardShape,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bg,
        foregroundColor: primary,
        iconTheme: const IconThemeData(color: primary, size: 22),
        titleTextStyle: AppTypography.titleMedium.copyWith(color: primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.codingPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.codingPrimary.withValues(
            alpha: 0.4,
          ),
          disabledForegroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      iconTheme: const IconThemeData(color: primary, size: 22),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      textTheme: textTheme,
    );
  }

  static ThemeData darkTheme() {
    const bg = AppColors.darkBackground;
    const surface = AppColors.darkSurface;
    const border = AppColors.darkBorder;
    const primary = AppColors.darkTextPrimary;
    const secondary = AppColors.darkTextSecondary;

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      side: const BorderSide(color: border, width: 1),
    );

    final textTheme = TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primary),
      displayMedium: AppTypography.headlineMedium.copyWith(color: primary),
      displaySmall: AppTypography.titleMedium.copyWith(color: primary),
      headlineLarge: AppTypography.displayLarge.copyWith(color: primary),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: primary),
      headlineSmall: AppTypography.titleMedium.copyWith(color: primary),
      titleLarge: AppTypography.titleMedium.copyWith(color: primary),
      titleMedium: AppTypography.titleMedium.copyWith(color: primary),
      titleSmall: AppTypography.bodyLarge.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primary),
      bodyMedium: AppTypography.bodyLarge.copyWith(color: primary),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondary),
      labelLarge: AppTypography.labelLarge.copyWith(color: primary),
      labelMedium: AppTypography.bodySmall.copyWith(color: secondary),
      labelSmall: AppTypography.bodySmall.copyWith(color: secondary),
    );

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primaryColor: AppColors.codingPrimary,
      canvasColor: bg,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: border,
      splashColor: AppColors.codingLight.withValues(alpha: 0.14),
      highlightColor: AppColors.codingLight.withValues(alpha: 0.08),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: cardShape,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bg,
        foregroundColor: primary,
        iconTheme: const IconThemeData(color: primary, size: 22),
        titleTextStyle: AppTypography.titleMedium.copyWith(color: primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.codingPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.codingPrimary.withValues(
            alpha: 0.35,
          ),
          disabledForegroundColor: Colors.white54,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      iconTheme: const IconThemeData(color: primary, size: 22),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      textTheme: textTheme,
    );
  }
}
