import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/widgets/common/error_state.dart';

void main() {
  group('ErrorState', () {
    testWidgets('renders error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Test error message',
            ),
          ),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('Une erreur est survenue'), findsOneWidget);
    });

    testWidgets('renders error icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (tester) async {
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('retry_button')), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);

      await tester.tap(find.byKey(const Key('retry_button')));
      expect(retryCalled, isTrue);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error',
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('retry_button')), findsNothing);
    });

    testWidgets('has correct widget key', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error',
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('error_state')), findsOneWidget);
    });

    test('provides predefined error messages', () {
      expect(ErrorState.networkError, 'Vérifiez votre connexion internet');
      expect(ErrorState.serverError, 'Une erreur est survenue, réessayez plus tard');
      expect(ErrorState.authError, 'Session expirée, veuillez vous reconnecter');
      expect(ErrorState.unknownError, 'Une erreur inattendue est survenue');
    });
  });
}
