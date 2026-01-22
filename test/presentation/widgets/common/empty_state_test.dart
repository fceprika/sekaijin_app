import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/widgets/common/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Test Title',
              message: 'Test message',
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('renders default icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Title',
              message: 'Message',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Title',
              message: 'Message',
              icon: Icons.place_outlined,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.place_outlined), findsOneWidget);
    });

    testWidgets('shows action button when provided', (tester) async {
      bool actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Title',
              message: 'Message',
              actionText: 'Do Action',
              onAction: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_state_action')), findsOneWidget);
      expect(find.text('Do Action'), findsOneWidget);

      await tester.tap(find.byKey(const Key('empty_state_action')));
      expect(actionCalled, isTrue);
    });

    testWidgets('hides action button when actionText is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Title',
              message: 'Message',
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_state_action')), findsNothing);
    });

    testWidgets('has correct widget keys', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'Title',
              message: 'Message',
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_state')), findsOneWidget);
      expect(find.byKey(const Key('empty_state_title')), findsOneWidget);
      expect(find.byKey(const Key('empty_state_message')), findsOneWidget);
    });
  });

  group('EmptyState factory methods', () {
    testWidgets('noPlaces returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noPlaces(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_places_state')), findsOneWidget);
      expect(find.text('Aucun lieu'), findsOneWidget);
      expect(find.byIcon(Icons.place_outlined), findsOneWidget);
    });

    testWidgets('noNews returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noNews(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_news_state')), findsOneWidget);
      expect(find.text('Aucune actualité'), findsOneWidget);
    });

    testWidgets('noArticles returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noArticles(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_articles_state')), findsOneWidget);
      expect(find.text('Aucun article'), findsOneWidget);
    });

    testWidgets('noEvents returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noEvents(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_events_state')), findsOneWidget);
      expect(find.text('Aucun événement'), findsOneWidget);
    });

    testWidgets('noReviews returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noReviews(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_reviews_state')), findsOneWidget);
      expect(find.text('Aucun avis'), findsOneWidget);
    });

    testWidgets('myPlacesEmpty returns correct empty state with action', (tester) async {
      bool actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.myPlacesEmpty(
              onAddPlace: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_my_places_state')), findsOneWidget);
      expect(find.text('Aucun lieu ajouté'), findsOneWidget);
      expect(find.text('Ajouter un lieu'), findsOneWidget);

      await tester.tap(find.text('Ajouter un lieu'));
      expect(actionCalled, isTrue);
    });

    testWidgets('myReviewsEmpty returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.myReviewsEmpty(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_my_reviews_state')), findsOneWidget);
      expect(find.text('Aucun avis donné'), findsOneWidget);
    });

    testWidgets('noSearchResults returns correct empty state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noSearchResults(),
          ),
        ),
      );

      expect(find.byKey(const Key('empty_search_state')), findsOneWidget);
      expect(find.text('Aucun résultat'), findsOneWidget);
    });
  });
}
