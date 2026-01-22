import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/config/theme.dart';
import 'package:sekaijin_app/presentation/screens/reviews/review_form_screen.dart';

void main() {
  group('ReviewFormScreen', () {
    Widget createTestWidget({String placeSlug = 'test-place', String placeName = 'Test Place'}) {
      return ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: ReviewFormScreen(
            placeSlug: placeSlug,
            placeName: placeName,
          ),
        ),
      );
    }

    testWidgets('renders review form screen', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('review_form_screen')), findsOneWidget);
    });

    testWidgets('displays place name', (tester) async {
      await tester.pumpWidget(createTestWidget(placeName: 'My Test Place'));
      await tester.pumpAndSettle();

      expect(find.text('My Test Place'), findsOneWidget);
    });

    testWidgets('displays star rating input', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('star_rating_input')), findsOneWidget);
    });

    testWidgets('displays comment field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('review_comment_field')), findsOneWidget);
    });

    testWidgets('displays submit button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('submit_review_button')), findsOneWidget);
    });

    testWidgets('submit button is disabled when form is invalid', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final submitButton = find.byKey(const Key('submit_review_button'));
      final ElevatedButton button = tester.widget(submitButton);

      expect(button.onPressed, isNull);
    });

    testWidgets('shows add title when creating new review', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Donner mon avis'), findsOneWidget);
    });

    testWidgets('displays guidelines note', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('Soyez respectueux et constructif dans vos commentaires.'),
        findsOneWidget,
      );
    });
  });
}
