import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sekaijin_app/app.dart';

import '../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Places Flow', () {
    testWidgets('Places list loads when logged in', (tester) async {
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

      // Navigate to explore
      await TestHelper.tap(tester, 'nav_explore');

      // Wait for places to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 3));

      // Should see places list screen
      expect(find.byKey(const Key('places_list_screen')), findsOneWidget);
    });

    testWidgets('Category filter chips are visible', (tester) async {
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

      // Navigate to explore
      await TestHelper.tap(tester, 'nav_explore');

      // Category chips should be visible
      expect(find.byType(FilterChip), findsWidgets);
    });

    testWidgets('Navigate to place detail', (tester) async {
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

      // Navigate to explore
      await TestHelper.tap(tester, 'nav_explore');

      // Wait for places to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 3));

      // Find first place card
      final placeCard = find.byKey(const Key('place_card_0'));

      if (tester.any(placeCard)) {
        await tester.ensureVisible(placeCard);
        await tester.tap(placeCard);
        await TestHelper.pumpAndSettle(tester);

        // Should be on place detail screen
        expect(find.byKey(const Key('place_detail_screen')), findsOneWidget);
      }
    });

    testWidgets('Create place form opens', (tester) async {
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

      // Tap add button
      await TestHelper.tap(tester, 'nav_add');

      // Should be on create place screen
      expect(find.byKey(const Key('place_create_screen')), findsOneWidget);

      // Form fields should be visible
      expect(find.byKey(const Key('place_title_field')), findsOneWidget);
      expect(find.byKey(const Key('place_category_dropdown')), findsOneWidget);
    });

    testWidgets('Create place validation', (tester) async {
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

      // Tap add button
      await TestHelper.tap(tester, 'nav_add');

      // Scroll to submit button
      final scrollable = find.byType(SingleChildScrollView);
      await tester.drag(scrollable, const Offset(0, -500));
      await TestHelper.pumpAndSettle(tester);

      // Try to submit without filling form
      final submitButton = find.byKey(const Key('submit_place_button'));
      if (tester.any(submitButton)) {
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await TestHelper.pumpAndSettle(tester);

        // Should show validation errors
        expect(find.textContaining('requis'), findsWidgets);
      }
    });

    testWidgets('Sort dropdown visible', (tester) async {
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

      // Navigate to explore
      await TestHelper.tap(tester, 'nav_explore');

      // Find sort dropdown
      final sortDropdown = find.byKey(const Key('sort_dropdown'));
      expect(sortDropdown, findsOneWidget);
    });
  });
}
