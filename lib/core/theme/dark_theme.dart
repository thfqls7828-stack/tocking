import 'package:flutter/material.dart';

import 'tocking_tokens.dart';

abstract final class DarkTheme {
  static ThemeData build() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: TockingColors.primary,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
