import 'package:flutter/material.dart';

import 'core/tocking_theme.dart';
import 'features/home/presentation/home_screen.dart';

void main() {
  runApp(const TockingApp());
}

class TockingApp extends StatelessWidget {
  const TockingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tocking',
      debugShowCheckedModeBanner: false,
      theme: TockingTheme.light(),
      home: const HomeScreen(),
    );
  }
}
