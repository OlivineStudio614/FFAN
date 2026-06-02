import 'package:flutter/material.dart';

/// App-wide theme. Tablet-first AAC: large touch targets, high contrast.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      visualDensity: VisualDensity.comfortable,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(fontSizeFactor: 1.1),
    );
  }
}
