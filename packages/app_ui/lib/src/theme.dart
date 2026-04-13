import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

abstract final class AppTheme {
  static ThemeData lightTheme() {
    const bg = AppColors.lightBackground;
    const surface = AppColors.lightSurface;
    const border = AppColors.lightBorder;
    const primary = AppColors.lightTextPrimary;
    const secondary = AppColors.lightTextSecondary;
    const tertiary = AppColors.lightTextTertiary;

    return _build(
      brightness: Brightness.light,
      bg: bg,
      surface: surface,
      border: border,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
    );
  }

  static ThemeData darkTheme() {
    const bg = AppColors.darkBackground;
    const surface = AppColors.darkSurface;
    const border = AppColors.darkBorder;
    const primary = AppColors.darkTextPrimary;
    const secondary = AppColors.darkTextSecondary;
    const tertiary = AppColors.darkTextTertiary;

    return _build(
      brightness: Brightness.dark,
      bg: bg,
      surface: surface,
      border: border,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color border,
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    final isDark = brightness == Brightness.dark;

    final textTheme = TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primary),
      displayMedium: AppTypography.monoMedium.copyWith(color: primary),
      displaySmall: AppTypography.headlineMedium.copyWith(color: primary),
      headlineLarge: AppTypography.displayLarge.copyWith(color: primary),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: primary),
      headlineSmall: AppTypography.titleMedium.copyWith(color: primary),
      titleLarge: AppTypography.headlineMedium.copyWith(color: primary),
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
      labelSmall: AppTypography.labelSmall.copyWith(color: tertiary),
    );

    return ThemeData(
      useMaterial3: false,
      brightness: brightness,
      primaryColor: AppColors.codingPrimary,
      canvasColor: bg,
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: border,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: AppColors.codingPrimary.withValues(alpha: isDark ? 0.06 : 0.04),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: BorderSide(color: border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bg,
        foregroundColor: primary,
        iconTheme: IconThemeData(color: secondary, size: 18),
        titleTextStyle: AppTypography.labelLarge.copyWith(color: primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.codingPrimary.withValues(alpha: 0.15),
          foregroundColor: AppColors.codingPrimary,
          disabledBackgroundColor: border.withValues(alpha: 0.3),
          disabledForegroundColor: tertiary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: border, width: 0.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondary,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      iconTheme: IconThemeData(color: secondary, size: 18),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 0.5,
        space: 0.5,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: BorderSide(color: border, width: 0.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightTextPrimary,
        contentTextStyle: AppTypography.bodySmall.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: textTheme,
    );
  }
}
