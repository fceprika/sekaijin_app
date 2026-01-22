import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/screens/auth/register_screen.dart';

void main() {
  Widget createTestWidget({VoidCallback? onLoginTap}) {
    return ProviderScope(
      child: MaterialApp(
        home: RegisterScreen(onLoginTap: onLoginTap),
      ),
    );
  }

  group('RegisterScreen', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check title
      expect(find.text('Créer un compte'), findsOneWidget);

      // Check form fields
      expect(find.byKey(const Key('pseudo_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('password_confirm_field')), findsOneWidget);
      expect(find.byKey(const Key('country_residence_dropdown')), findsOneWidget);
      expect(find.byKey(const Key('interest_country_dropdown')), findsOneWidget);
    });

    testWidgets('renders terms checkbox and register button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to bottom to find terms and buttons
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('terms_checkbox')), findsOneWidget);
      expect(find.byKey(const Key('register_button')), findsOneWidget);
      expect(find.text('Créer mon compte'), findsOneWidget);
    });

    testWidgets('pseudo validation errors display', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter short pseudo
      await tester.enterText(find.byKey(const Key('pseudo_field')), 'ab');

      // Fill other required fields
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'TestPassword123');
      await tester.enterText(
          find.byKey(const Key('password_confirm_field')), 'TestPassword123');

      // Scroll to register button and tap
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      // Check for pseudo validation error
      expect(find.textContaining('entre 3 et 255'), findsOneWidget);
    });

    testWidgets('password requirements validation shows error', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter weak password
      await tester.enterText(find.byKey(const Key('password_field')), 'short');

      // Fill other fields
      await tester.enterText(find.byKey(const Key('pseudo_field')), 'testuser');
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_confirm_field')), 'short');

      // Scroll and tap register
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      // Check for password validation error
      expect(find.textContaining('au moins 12'), findsOneWidget);
    });

    testWidgets('password confirmation mismatch shows error', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Fill fields with mismatched passwords
      await tester.enterText(find.byKey(const Key('pseudo_field')), 'testuser');
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'TestPassword123');
      await tester.enterText(
          find.byKey(const Key('password_confirm_field')), 'DifferentPass123');

      // Scroll and tap register
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      // Check for password mismatch error
      expect(find.text('Les mots de passe ne correspondent pas'), findsOneWidget);
    });

    testWidgets('password hints are displayed', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check that password hints exist
      expect(find.text('Au moins 12 caractères'), findsOneWidget);
      expect(find.text('Au moins une majuscule'), findsOneWidget);
      expect(find.text('Au moins une minuscule'), findsOneWidget);
      expect(find.text('Au moins un chiffre'), findsOneWidget);
    });
  });
}
