import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tocking/core/tocking_tokens.dart';
import 'package:tocking/features/home/presentation/home_screen.dart';
import 'package:tocking/main.dart';

void main() {
  testWidgets('renders the Tocking home app bar', (WidgetTester tester) async {
    await tester.pumpWidget(const TockingApp());

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/logo/logo-row.png')),
      findsOneWidget,
    );
    expect(find.text('검색어를 입력해주세요.'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('matches requested app bar asset sizes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TockingApp());

    final logo = tester.widget<Image>(
      find.image(const AssetImage('assets/logo/logo-row.png')),
    );
    final searchIconBox = tester.getSize(
      find.byKey(const Key('home-search-icon-box')),
    );

    expect(logo.width, TockingSizes.logo.width);
    expect(logo.height, TockingSizes.logo.height);
    expect(searchIconBox.width, TockingSizes.searchIcon);
    expect(searchIconBox.height, TockingSizes.searchIcon);
  });
}
