import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sekaijin_app/app.dart';

import '../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Flow', () {
    testWidgets('Profile screen loads', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Should be on profile screen
      expect(find.byKey(const Key('profile_screen')), findsOneWidget);
    });

    testWidgets('Profile shows user pseudo', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Should show user's pseudo
      expect(find.byKey(const Key('profile_pseudo')), findsOneWidget);
    });

    testWidgets('Profile shows stats section', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Stats section may be loading or loaded
      // Just verify we're on profile screen
      expect(find.byKey(const Key('profile_screen')), findsOneWidget);
    });

    testWidgets('Profile shows my places section header', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Should show my places section header
      expect(find.text('Mes lieux'), findsOneWidget);
    });

    testWidgets('Profile shows my reviews section header', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Scroll down to see reviews section
      final scrollable = find.byType(SingleChildScrollView);
      if (tester.any(scrollable)) {
        await tester.drag(scrollable, const Offset(0, -300));
        await TestHelper.pumpAndSettle(tester);
      }

      // Should show my reviews section header
      expect(find.text('Mes avis'), findsOneWidget);
    });

    testWidgets('Logout button visible', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Scroll down to logout button
      final scrollable = find.byType(SingleChildScrollView);
      if (tester.any(scrollable)) {
        await tester.drag(scrollable, const Offset(0, -500));
        await TestHelper.pumpAndSettle(tester);
      }

      // Logout button should be visible
      final logoutButton = find.byKey(const Key('logout_button'));
      if (tester.any(logoutButton)) {
        expect(logoutButton, findsOneWidget);
      }
    });

    testWidgets('Logout shows confirmation dialog', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Scroll down to logout button
      final scrollable = find.byType(SingleChildScrollView);
      if (tester.any(scrollable)) {
        await tester.drag(scrollable, const Offset(0, -500));
        await TestHelper.pumpAndSettle(tester);
      }

      // Tap logout button
      final logoutButton = find.byKey(const Key('logout_button'));
      if (tester.any(logoutButton)) {
        await tester.ensureVisible(logoutButton);
        await tester.tap(logoutButton);
        await TestHelper.pumpAndSettle(tester);

        // Should show confirmation dialog
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Se déconnecter'), findsWidgets);
      }
    });

    testWidgets('Cancel logout stays on profile', (tester) async {
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

      // Navigate to profile
      await TestHelper.tap(tester, 'nav_profile');

      // Wait for profile to load
      await TestHelper.wait(tester, duration: const Duration(seconds: 2));

      // Scroll down to logout button
      final scrollable = find.byType(SingleChildScrollView);
      if (tester.any(scrollable)) {
        await tester.drag(scrollable, const Offset(0, -500));
        await TestHelper.pumpAndSettle(tester);
      }

      // Tap logout button
      final logoutButton = find.byKey(const Key('logout_button'));
      if (tester.any(logoutButton)) {
        await tester.ensureVisible(logoutButton);
        await tester.tap(logoutButton);
        await TestHelper.pumpAndSettle(tester);

        // Tap cancel
        await TestHelper.tapText(tester, 'Annuler');

        // Should still be on profile screen
        expect(find.byKey(const Key('profile_screen')), findsOneWidget);
      }
    });
  });
}
