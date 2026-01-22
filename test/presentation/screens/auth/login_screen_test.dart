import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/screens/auth/login_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders all elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check login screen exists
      expect(find.byKey(const Key('login_screen')), findsOneWidget);

      // Check logo/title
      expect(find.text('Sekaijin'), findsOneWidget);
      expect(find.text('Connexion'), findsOneWidget);

      // Check form fields
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);

      // Check buttons and links
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.byKey(const Key('register_link')), findsOneWidget);
      expect(find.byKey(const Key('forgot_password_link')), findsOneWidget);
      expect(find.byKey(const Key('password_visibility_toggle')), findsOneWidget);

      // Check button text
      expect(find.text('Se connecter'), findsOneWidget);
      expect(find.text('Créer un compte'), findsOneWidget);
      expect(find.text('Mot de passe oublié ?'), findsOneWidget);
    });

    testWidgets('email validation shows error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter invalid email
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');

      // Enter valid password to isolate email validation
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');

      // Tap login button to trigger validation
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Check for email validation error
      expect(find.text('Veuillez entrer un email valide'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially, password is hidden (visibility_outlined icon shown)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap visibility toggle
      await tester.tap(find.byKey(const Key('password_visibility_toggle')));
      await tester.pump();

      // Now password is visible (visibility_off_outlined icon shown)
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byKey(const Key('password_visibility_toggle')));
      await tester.pump();

      // Password is hidden again
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets('login button triggers validation when fields empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap login button without entering anything
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Check for validation errors
      expect(find.text("L'email est requis"), findsOneWidget);
      expect(find.text('Le mot de passe est requis'), findsOneWidget);
    });

    testWidgets('password validation shows error for short password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter valid email
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');

      // Enter short password
      await tester.enterText(find.byKey(const Key('password_field')), 'short');

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Check for password validation error
      expect(find.textContaining('au moins'), findsOneWidget);
    });
  });
}
