import 'dart:ui';

import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const _fontFamily = '.AppleSystemUIFont';
  static const _monoFamily = 'SF Mono';

  // Display — only for the big timer clock
  static const displayLarge = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 48,
    fontWeight: FontWeight.w200,
    letterSpacing: 4,
    height: 1.0,
  );

  // Section headers
  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
  );

  // Subsection titles
  static const titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // Body text
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Small text, captions
  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.5,
  );

  // Labels, buttons
  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.4,
  );

  // Uppercase micro-labels
  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.4,
  );

  // Monospace — large timer readout
  static const monoLarge = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 48,
    fontWeight: FontWeight.w200,
    letterSpacing: 4,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Monospace — secondary values (daily totals, stats)
  static const monoMedium = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5,
    height: 1.2,
  );

  // Monospace — small inline values
  static const monoSmall = TextStyle(
    fontFamily: _monoFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.4,
  );
}
