import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/tocking_tokens.dart';
import 'home_viewmodel.dart';
import 'widgets/tocking_animation_placeholder/tocking_animation_placeholder.dart';
import 'widgets/tocking_home_app_bar/tocking_home_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeViewmodelProvider);

    return Scaffold(
      backgroundColor: TockingColors.pageBackground,
      appBar: TockingHomeAppBar(),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: TockingSpacing.appFrameWidth,
              maxHeight: TockingSpacing.appFrameHeight,
            ),
            child: Padding(
              key: Key('home-body-padding'),
              padding: const EdgeInsets.all(TockingSpacing.bodyPadding),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: TockingSizes.animationPlaceholder.width,
                  ),
                  child: AspectRatio(
                    aspectRatio:
                        TockingSizes.animationPlaceholder.width /
                        TockingSizes.animationPlaceholder.height,
                    child: TockingAnimationPlaceholder(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
