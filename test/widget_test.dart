import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/core/router/route_paths.dart';
import 'package:tocking/core/theme/tocking_tokens.dart';
import 'package:tocking/view/home_screen/home_screen.dart';
import 'package:tocking/view/home_screen/widgets/daily_issue_panel/daily_issue_list_notifier.dart';
import 'package:tocking/view/home_screen/widgets/daily_issue_panel/daily_issue_panel.dart';
import 'package:tocking/view/home_screen/widgets/tocking_animation_placeholder/tocking_animation_placeholder.dart';
import 'package:tocking/view/home_screen/widgets/tocking_home_app_bar/tocking_home_app_bar.dart';
import 'package:tocking/view/home_screen/widgets/tocking_search_action/tocking_search_action.dart';
import 'package:tocking/main.dart';

void main() {
  Future<void> pumpTockingApp(WidgetTester tester) {
    return tester.pumpWidget(const ProviderScope(child: TockingApp()));
  }

  testWidgets('renders the Tocking home app bar', (WidgetTester tester) async {
    await pumpTockingApp(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/logo/logo-row.png')),
      findsOneWidget,
    );
    expect(find.byType(TockingAnimationPlaceholder), findsOneWidget);
    expect(find.byType(DailyIssuePanel), findsOneWidget);
    expect(find.text('일상의 쟁점'), findsOneWidget);
    expect(find.text('토론 규칙'), findsOneWidget);
    expect(find.text('토론 규칙 안내'), findsNothing);
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const Key('home-search-placeholder-opacity')),
          )
          .opacity,
      0,
    );
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('uses home as the initial route', (WidgetTester tester) async {
    await pumpTockingApp(tester);

    expect(RoutePaths.home, '/');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('matches requested app bar asset sizes', (
    WidgetTester tester,
  ) async {
    await pumpTockingApp(tester);

    final logo = tester.widget<Image>(
      find.image(const AssetImage('assets/logo/logo-row.png')),
    );
    final searchIconBox = tester.getSize(
      find.byKey(const Key('home-search-icon-box')),
    );
    final searchIcon = tester.widget<Icon>(find.byIcon(Icons.search));
    final searchAction = tester.getSize(
      find.byKey(const Key('home-search-action')),
    );
    final appBar = tester.widget<TockingHomeAppBar>(
      find.byType(TockingHomeAppBar),
    );

    expect(logo.width, TockingSizes.logo.width);
    expect(logo.height, TockingSizes.logo.height);
    expect(appBar.preferredSize.height, TockingSizes.appBarHeight);
    expect(searchAction.width, TockingSizes.searchCollapsedWidth);
    expect(searchAction.height, TockingSizes.searchHeight);
    expect(searchIconBox.width, TockingSizes.searchIconBox);
    expect(searchIconBox.height, TockingSizes.searchIconBox);
    expect(searchIcon.size, TockingSizes.searchIcon);
  });

  testWidgets('applies body padding and animation placeholder size', (
    WidgetTester tester,
  ) async {
    await pumpTockingApp(tester);

    final bodyPadding = tester.widget<Padding>(
      find.byKey(const Key('home-body-padding')),
    );
    final animationPlaceholder = tester.getSize(
      find.byKey(const Key('home-animation-placeholder')),
    );

    expect(
      bodyPadding.padding,
      const EdgeInsets.all(TockingSpacing.bodyPadding),
    );
    expect(animationPlaceholder.width, TockingSizes.animationPlaceholder.width);
    expect(
      animationPlaceholder.height,
      TockingSizes.animationPlaceholder.height,
    );
  });

  testWidgets('renders a scrollable daily issue panel with ten mock issues', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(720, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await pumpTockingApp(tester);

    final providerContainer = ProviderScope.containerOf(
      tester.element(find.byType(HomeScreen)),
    );

    expect(providerContainer.read(dailyIssueListProvider).items, hasLength(10));
    expect(find.byKey(const Key('home-daily-issue-panel')), findsOneWidget);
    expect(find.byKey(const Key('home-daily-issue-list')), findsOneWidget);
    expect(find.text('짬뽕이 VS 볶순이!!'), findsOneWidget);
    expect(find.byIcon(Icons.record_voice_over), findsWidgets);
    expect(find.text('10개'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('여행은 맛집 VS 풍경!!'),
      160,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('여행은 맛집 VS 풍경!!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test(
    'daily issue list notifier stores and filters submitted search query',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(dailyIssueListProvider).items, hasLength(10));

      container.read(dailyIssueListProvider.notifier).submitSearch(' 민초 ');
      final searchedState = container.read(dailyIssueListProvider);

      expect(searchedState.submittedSearchQuery, '민초');
      expect(searchedState.items, hasLength(1));
      expect(searchedState.items.single.title, '민초파 VS 반민초파!!');
      expect(searchedState.items.single.participantCount, 1);
      expect(searchedState.items.single.proPercent, 100);
      expect(searchedState.items.single.conPercent, 0);
    },
  );

  testWidgets(
    'toggles the hardcoded debate rules guide inside the placeholder',
    (WidgetTester tester) async {
      await pumpTockingApp(tester);

      final rulesPillPadding = tester.widget<Padding>(
        find.byKey(const Key('home-rules-pill-padding')),
      );

      expect(
        rulesPillPadding.padding,
        const EdgeInsets.symmetric(
          horizontal: TockingSpacing.rulesPillHorizontalPadding,
          vertical: TockingSpacing.rulesPillVerticalPadding,
        ),
      );
      expect(find.byKey(const Key('home-rules-guide-card')), findsNothing);
      expect(find.byKey(const Key('home-rules-guide-arrow')), findsNothing);

      await tester.tap(find.byKey(const Key('home-rules-pill-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home-rules-guide-card')), findsOneWidget);
      expect(find.byKey(const Key('home-rules-guide-arrow')), findsOneWidget);
      expect(
        find.text('토론방 입장 시 자신의 입장을 선택하고, 토론방에서 사용할 닉네임을 입력해야 합니다.'),
        findsOneWidget,
      );
      expect(find.text('"발언권 신청"을 통해 발언 순서를 획득 후 발언이 가능합니다.'), findsOneWidget);
      expect(find.text('발언순서는 찬성/반대의 입장이 번갈아가며 진행됩니다.'), findsOneWidget);

      final guideTexts = tester.widgetList<Text>(
        find.descendant(
          of: find.byKey(const Key('home-rules-guide-card')),
          matching: find.byType(Text),
        ),
      );
      for (final guideText in guideTexts) {
        expect(guideText.style?.fontSize, greaterThanOrEqualTo(12));
      }

      await tester.tap(find.byKey(const Key('home-rules-pill-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home-rules-guide-card')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('closes the debate rules guide when tapping outside it', (
    WidgetTester tester,
  ) async {
    await pumpTockingApp(tester);

    await tester.tap(find.byKey(const Key('home-rules-pill-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-rules-guide-card')), findsOneWidget);

    await tester.tap(find.image(const AssetImage('assets/logo/logo-row.png')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-rules-guide-card')), findsNothing);

    await tester.tap(find.byKey(const Key('home-rules-pill-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-rules-guide-card')), findsOneWidget);

    final placeholderBottomRight = tester.getBottomRight(
      find.byKey(const Key('home-animation-placeholder')),
    );
    await tester.tapAt(placeholderBottomRight - const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-rules-guide-card')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expands and collapses the search action from the app bar', (
    WidgetTester tester,
  ) async {
    await pumpTockingApp(tester);
    final providerContainer = ProviderScope.containerOf(
      tester.element(find.byType(TockingSearchAction)),
    );

    final collapsedRightEdge = tester.getTopRight(
      find.byKey(const Key('home-search-action')),
    );
    expect(
      providerContainer.read(dailyIssueListProvider).submittedSearchQuery,
      isNull,
    );

    await tester.tap(find.byKey(const Key('home-search-collapsed-button')));
    await tester.pumpAndSettle();

    expect(find.text('검색어를 입력해주세요.'), findsOneWidget);
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const Key('home-search-placeholder-opacity')),
          )
          .opacity,
      1,
    );
    expect(
      find.image(const AssetImage('assets/logo/logo-row.png')),
      findsOneWidget,
    );
    expect(
      tester.getTopRight(find.byKey(const Key('home-search-action'))).dx,
      collapsedRightEdge.dx,
    );

    final expandedSearchAction = tester.getSize(
      find.byKey(const Key('home-search-action')),
    );
    final expandedSearchAnimation = tester.widget<AnimatedContainer>(
      find.byKey(const Key('home-search-action')),
    );
    final expandedPlaceholderOpacity = tester.widget<AnimatedOpacity>(
      find.byKey(const Key('home-search-placeholder-opacity')),
    );

    expect(expandedSearchAction.width, TockingSizes.searchExpandedWidth);
    expect(expandedSearchAction.height, TockingSizes.searchHeight);
    expect(expandedSearchAnimation.duration, TockingMotion.searchTransition);
    expect(expandedSearchAnimation.curve, Curves.easeOutCubic);
    expect(
      expandedPlaceholderOpacity.duration,
      TockingMotion.searchContentTransition,
    );
    expect(expandedPlaceholderOpacity.curve, Curves.easeOutCubic);

    await tester.tap(find.byKey(const Key('home-search-expanded-icon-button')));
    await tester.pumpAndSettle();

    expect(
      providerContainer.read(dailyIssueListProvider).submittedSearchQuery,
      '',
    );
    expect(find.text('검색어를 입력해주세요.'), findsOneWidget);
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const Key('home-search-placeholder-opacity')),
          )
          .opacity,
      0,
    );
    final collapsedSearchAnimation = tester.widget<AnimatedContainer>(
      find.byKey(const Key('home-search-action')),
    );
    final collapsedPlaceholderOpacity = tester.widget<AnimatedOpacity>(
      find.byKey(const Key('home-search-placeholder-opacity')),
    );

    expect(
      collapsedSearchAnimation.duration,
      TockingMotion.searchReverseTransition,
    );
    expect(collapsedSearchAnimation.curve, Curves.easeInOutCubic);
    expect(
      collapsedPlaceholderOpacity.duration,
      TockingMotion.searchContentReverseTransition,
    );
    expect(collapsedPlaceholderOpacity.curve, Curves.easeInOutCubic);
    expect(
      tester.getSize(find.byKey(const Key('home-search-action'))).width,
      TockingSizes.searchCollapsedWidth,
    );
    expect(
      tester.getTopRight(find.byKey(const Key('home-search-action'))).dx,
      collapsedRightEdge.dx,
    );
    expect(
      find.image(const AssetImage('assets/logo/logo-row.png')),
      findsOneWidget,
    );
  });

  testWidgets('keeps the expanded search action inside a narrow app bar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await pumpTockingApp(tester);
    await tester.tap(find.byKey(const Key('home-search-collapsed-button')));
    await tester.pumpAndSettle();

    final expandedSearchAction = tester.getSize(
      find.byKey(const Key('home-search-action')),
    );

    expect(expandedSearchAction.width, TockingSizes.searchExpandedWidth);
    expect(tester.takeException(), isNull);
  });
}
