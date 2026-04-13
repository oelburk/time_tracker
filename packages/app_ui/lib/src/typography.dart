import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const _fontFamily = '.AppleSystemUIFont';

  static const displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static const monoLarge = TextStyle(
    fontFamily: 'SF Mono',
    fontSize: 36,
    fontWeight: FontWeight.w300,
    letterSpacing: 2,
    height: 1.1,
  );

  static const monoMedium = TextStyle(
    fontFamily: 'SF Mono',
    fontSize: 24,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5,
    height: 1.2,
  );
}
