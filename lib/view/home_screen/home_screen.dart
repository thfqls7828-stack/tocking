import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_failure.dart';
import '../../core/theme/tocking_tokens.dart';
import 'widgets/daily_issue_panel/daily_issue_list_notifier.dart';
import 'widgets/daily_issue_panel/daily_issue_panel.dart';
import 'widgets/tocking_animation_placeholder/tocking_animation_placeholder.dart';
import 'widgets/tocking_home_app_bar/tocking_home_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyIssueState = ref.watch(dailyIssueListProvider);

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
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio:
                            TockingSizes.animationPlaceholder.width /
                            TockingSizes.animationPlaceholder.height,
                        child: const TockingAnimationPlaceholder(),
                      ),
                      const SizedBox(
                        height: TockingSpacing.heroToDailyIssueGap,
                      ),
                      Expanded(
                        child: dailyIssueState.when(
                          data: (state) {
                            return DailyIssuePanel(
                              items: state.items,
                              onRetry: () {
                                ref
                                    .read(dailyIssueListProvider.notifier)
                                    .refresh();
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return DailyIssuePanel(
                              items: const [],
                              errorMessage: _dailyIssueErrorMessage(error),
                              onRetry: () {
                                ref
                                    .read(dailyIssueListProvider.notifier)
                                    .refresh();
                              },
                            );
                          },
                          loading: () {
                            return const DailyIssuePanel(
                              items: [],
                              isLoading: true,
                            );
                          },
                        ),
                      ),
                    ],
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

String _dailyIssueErrorMessage(Object error) {
  return switch (error) {
    AppFailure(:final message) => message,
    _ => '토론방을 불러오지 못했습니다.',
  };
}
