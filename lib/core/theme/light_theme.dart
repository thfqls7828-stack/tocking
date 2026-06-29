import 'package:flutter/material.dart';

import 'tocking_tokens.dart';

abstract final class LightTheme {
  static ThemeData build() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: TockingColors.primary,
        surface: TockingColors.canvas,
      ),
      scaffoldBackgroundColor: TockingColors.canvas,
      useMaterial3: true,
    );
  }
}
