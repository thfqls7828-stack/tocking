import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/tocking_tokens.dart';
import '../view_models/home_view_model.dart';
import '../widgets/tocking_home_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: TockingSpacing.appFrameWidth,
            height: TockingSpacing.appFrameHeight,
            child: Column(
              children: [
                TockingHomeAppBar(
                  logoAssetPath: viewState.logoAssetPath,
                  searchPlaceholder: viewState.searchPlaceholder,
                ),
                const Expanded(child: SizedBox.expand()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
