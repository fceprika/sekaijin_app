import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class for integration tests
class TestHelper {
  /// Pump and settle with a generous timeout for slow operations
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration duration = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle(duration);
  }

  /// Enter text into a field by key
  static Future<void> enterText(
    WidgetTester tester,
    String key,
    String text,
  ) async {
    final finder = find.byKey(Key(key));
    await tester.ensureVisible(finder);
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Tap a widget by key
  static Future<void> tap(
    WidgetTester tester,
    String key,
  ) async {
    final finder = find.byKey(Key(key));
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Tap a widget by text
  static Future<void> tapText(
    WidgetTester tester,
    String text,
  ) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Login with test credentials
  /// Note: This attempts a real login which requires a working backend.
  /// If the backend is unavailable, the test may remain on the login screen.
  static Future<void> login(WidgetTester tester) async {
    await pumpAndSettle(tester);

    // Wait for splash screen to redirect
    await tester.pump(const Duration(seconds: 2));
    await pumpAndSettle(tester);

    // Check if we're on login screen
    final loginScreen = find.byKey(const Key('login_screen'));
    if (!tester.any(loginScreen)) {
      // Maybe already logged in or on a different screen
      return;
    }

    // Enter email
    await enterText(tester, 'email_field', 'test@sekaijin.fr');

    // Enter password
    await enterText(tester, 'password_field', 'TestPassword123');

    // Tap login button
    await tap(tester, 'login_button');

    // Wait for login to complete (may fail if no backend)
    await tester.pump(const Duration(seconds: 3));
    await pumpAndSettle(tester, duration: const Duration(seconds: 2));
  }

  /// Scroll to make a widget visible
  static Future<void> scrollTo(
    WidgetTester tester,
    String scrollKey,
    String targetKey, {
    double delta = -300,
  }) async {
    final scrollable = find.byKey(Key(scrollKey));
    final target = find.byKey(Key(targetKey));

    // Try to scroll until target is visible
    for (int i = 0; i < 10; i++) {
      if (tester.any(target)) {
        try {
          await tester.ensureVisible(target);
          return;
        } catch (_) {
          // Continue scrolling
        }
      }
      await tester.drag(scrollable, Offset(0, delta));
      await tester.pumpAndSettle();
    }
  }

  /// Wait for a specific duration
  static Future<void> wait(
    WidgetTester tester, {
    Duration duration = const Duration(seconds: 1),
  }) async {
    await tester.pump(duration);
    await tester.pumpAndSettle();
  }

  /// Check if a widget exists
  static bool exists(WidgetTester tester, String key) {
    return tester.any(find.byKey(Key(key)));
  }

  /// Check if text exists
  static bool textExists(WidgetTester tester, String text) {
    return tester.any(find.text(text));
  }

  /// Check if user is logged in (not on login screen)
  static bool isLoggedIn(WidgetTester tester) {
    return !tester.any(find.byKey(const Key('login_screen')));
  }

  /// Skip test if not logged in (graceful handling for tests without backend)
  static bool skipIfNotLoggedIn(WidgetTester tester) {
    if (tester.any(find.byKey(const Key('login_screen')))) {
      return true; // Should skip
    }
    return false; // Continue with test
  }
}
