import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/tocking_theme.dart';

void main() {
  runApp(const TockingApp());
}

class TockingApp extends StatelessWidget {
  const TockingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tocking',
      debugShowCheckedModeBanner: false,
      theme: TockingTheme.light(),
      routerConfig: AppRouter.router,
    );
  }
}
