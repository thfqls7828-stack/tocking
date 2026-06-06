import 'package:flutter/material.dart';

import 'tocking_tokens.dart';

abstract final class TockingTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1976D2),
        surface: TockingColors.canvas,
      ),
      scaffoldBackgroundColor: TockingColors.canvas,
      useMaterial3: true,
    );
  }
}
