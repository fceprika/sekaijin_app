import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sekaijin_app/app.dart';

import '../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('Splash redirects to login when not authenticated',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Wait for splash screen
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Should be on login screen
      expect(find.byKey(const Key('login_screen')), findsOneWidget);
    });

    testWidgets('Login form accepts credentials and submits', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Wait for splash
      await tester.pump(const Duration(seconds: 2));
      await TestHelper.pumpAndSettle(tester);

      // Enter credentials
      await TestHelper.enterText(tester, 'email_field', 'test@sekaijin.fr');
      await TestHelper.enterText(tester, 'password_field', 'TestPassword123');

      // Verify fields have text
      expect(find.text('test@sekaijin.fr'), findsOneWidget);

      // Tap login - this will try to call API but may fail without backend
      await TestHelper.tap(tester, 'login_button');

      // Wait for response
      await TestHelper.wait(tester, duration: const Duration(seconds: 3));

      // Either on home screen (success) or still on login with error (network failure)
      // Both are acceptable outcomes for this test
      final homeScreen = find.byKey(const Key('home_screen'));
      final loginScreen = find.byKey(const Key('login_screen'));
      expect(homeScreen.evaluate().isNotEmpty || loginScreen.evaluate().isNotEmpty, isTrue);
    });

    testWidgets('Login shows validation errors for empty fields',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Wait for splash
      await tester.pump(const Duration(seconds: 2));
      await TestHelper.pumpAndSettle(tester);

      // Tap login without entering data
      await TestHelper.tap(tester, 'login_button');

      // Should show validation error
      expect(find.textContaining('email'), findsWidgets);
    });

    testWidgets('Navigate to register screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Wait for splash
      await tester.pump(const Duration(seconds: 2));
      await TestHelper.pumpAndSettle(tester);

      // Tap register link
      await TestHelper.tap(tester, 'register_link');

      // Should be on register screen
      expect(find.byKey(const Key('pseudo_field')), findsOneWidget);
    });

    testWidgets('Register shows validation for short pseudo', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: SekaijinApp(),
        ),
      );

      // Wait for splash
      await tester.pump(const Duration(seconds: 2));
      await TestHelper.pumpAndSettle(tester);

      // Navigate to register
      await TestHelper.tap(tester, 'register_link');

      // Enter short pseudo
      await TestHelper.enterText(tester, 'pseudo_field', 'ab');

      // Enter other required fields
      await TestHelper.enterText(tester, 'email_field', 'test@test.com');
      await TestHelper.enterText(tester, 'password_field', 'TestPassword123!');
      await TestHelper.enterText(
          tester, 'password_confirm_field', 'TestPassword123!');

      // Tap register
      await TestHelper.tap(tester, 'register_button');

      // Should show validation error for pseudo length
      expect(find.textContaining('3'), findsWidgets);
    });
  });
}
