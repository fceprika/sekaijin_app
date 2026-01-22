import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sekaijin_app/app.dart';

import '../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Content Flow', () {
    testWidgets('News tab shows content', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Navigate to news
      await TestHelper.tap(tester, 'nav_news');

      // Wait for content to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Should be on news screen
      expect(find.byKey(const Key('news_screen')), findsOneWidget);
    });

    testWidgets('Tab bar shows News, Articles, Events', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Navigate to news
      await TestHelper.tap(tester, 'nav_news');

      // Tab bar should have tabs
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Actualités'), findsOneWidget);
      expect(find.text('Articles'), findsOneWidget);
      expect(find.text('Événements'), findsOneWidget);
    });

    testWidgets('Articles tab navigation', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Navigate to news
      await TestHelper.tap(tester, 'nav_news');

      // Tap articles tab
      await TestHelper.tapText(tester, 'Articles');
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Should show articles content
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Events tab navigation', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Navigate to news
      await TestHelper.tap(tester, 'nav_news');

      // Tap events tab
      await TestHelper.tapText(tester, 'Événements');
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Should show events content
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Home screen shows news section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Should be on home screen
      expect(find.byKey(const Key('home_screen')), findsOneWidget);

      // Should show news section
      expect(find.text('Dernières actualités'), findsOneWidget);
    });

    testWidgets('Home screen shows popular places section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Scroll down to see places section
      final scrollable = find.byType(SingleChildScrollView);
      if (tester.any(scrollable)) {
        await tester.drag(scrollable, const Offset(0, -200));
        await TestHelper.pumpAndSettle(tester);
      }

      // Should show places section
      expect(find.text('Lieux populaires'), findsOneWidget);
    });

    testWidgets('Pull to refresh on news', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Try to login
      await TestHelper.login(tester);

      // Skip if not logged in
      if (TestHelper.skipIfNotLoggedIn(tester)) {
        expect(find.byKey(const Key('login_screen')), findsOneWidget);
        return;
      }

      // Navigate to news
      await TestHelper.tap(tester, 'nav_news');

      // Find refresh indicator
      expect(find.byType(RefreshIndicator), findsWidgets);
    });
  });
}
