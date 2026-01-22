import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/domain/entities/place.dart';
import 'package:sekaijin_app/domain/entities/place_review.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/presentation/providers/place_detail_provider.dart';
import 'package:sekaijin_app/presentation/screens/places/place_detail_screen.dart';

void main() {
  late Place mockPlace;

  setUp(() {
    mockPlace = Place(
      id: 1,
      title: 'Test Place',
      slug: 'test-place',
      description: '<p>Test description with HTML</p>',
      userId: 1,
      cityId: 1,
      category: PlaceCategory.restaurants,
      googleMapsUrl: 'https://maps.google.com/test',
      address: '123 Test Street',
      imageUrl: 'https://example.com/image1.jpg',
      imageUrl2: 'https://example.com/image2.jpg',
      ratingAverage: 4.5,
      reviewsCount: 10,
      wifiSpeed: 50,
      websiteUrl: 'https://example.com',
      menuUrl: 'https://example.com/menu',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: User(
        id: 1,
        name: 'Test User',
        nameSlug: 'test-user',
        email: 'test@test.com',
        createdAt: DateTime.now(),
      ),
      reviews: [
        PlaceReview(
          id: 1,
          placeId: 1,
          userId: 1,
          comment: 'Great place!',
          rating: 5,
          isApproved: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now(),
          user: User(
            id: 1,
            name: 'Reviewer',
            nameSlug: 'reviewer',
            email: 'reviewer@test.com',
            createdAt: DateTime.now(),
          ),
        ),
      ],
    );
  });

  Widget createScreen({Place? place, bool loading = false, String? error, Completer<Place>? loadingCompleter}) {
    return ProviderScope(
      overrides: [
        placeDetailProvider('test-place').overrideWith((ref) {
          if (loading && loadingCompleter != null) {
            // Return a completer-based future for loading state that can be cancelled
            return loadingCompleter.future;
          }
          if (error != null) {
            return Future.error(Exception(error));
          }
          return Future.value(place ?? mockPlace);
        }),
      ],
      child: const MaterialApp(
        home: PlaceDetailScreen(slug: 'test-place'),
      ),
    );
  }

  group('PlaceDetailScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen());
      // Wait for future to complete and UI to rebuild
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const Key('place_detail_screen')), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      final completer = Completer<Place>();
      await tester.pumpWidget(createScreen(loading: true, loadingCompleter: completer));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future to clean up the test
      completer.complete(mockPlace);
      await tester.pump();
    });

    testWidgets('displays place title', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const Key('place_title')), findsOneWidget);
      expect(find.text('Test Place'), findsOneWidget);
    });

    testWidgets('displays rating section', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const Key('place_rating')), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('(10 avis)'), findsOneWidget);
    });

    testWidgets('displays Google Maps button', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll down to find the button
      final scrollView = find.byKey(const Key('place_detail_scroll'));
      if (scrollView.evaluate().isNotEmpty) {
        await tester.drag(scrollView, const Offset(0, -200));
        await tester.pump();
      }

      expect(find.byKey(const Key('google_maps_button')), findsOneWidget);
      expect(find.text('Voir sur Google Maps'), findsOneWidget);
    });

    testWidgets('displays reviews section', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll down to reviews section
      final scrollView = find.byKey(const Key('place_detail_scroll'));
      if (scrollView.evaluate().isNotEmpty) {
        await tester.drag(scrollView, const Offset(0, -500));
        await tester.pump();
      }

      expect(find.byKey(const Key('reviews_section')), findsOneWidget);
    });

    testWidgets('displays add review button', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll down to reviews section
      final scrollView = find.byKey(const Key('place_detail_scroll'));
      if (scrollView.evaluate().isNotEmpty) {
        await tester.drag(scrollView, const Offset(0, -500));
        await tester.pump();
      }

      expect(find.byKey(const Key('add_review_button')), findsOneWidget);
    });

    testWidgets('displays image carousel', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const Key('image_carousel')), findsOneWidget);
    });

    testWidgets('displays info section with wifi', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll down to info section
      final scrollView = find.byKey(const Key('place_detail_scroll'));
      if (scrollView.evaluate().isNotEmpty) {
        await tester.drag(scrollView, const Offset(0, -400));
        await tester.pump();
      }

      expect(find.byKey(const Key('place_info_section')), findsOneWidget);
      expect(find.text('50 Mbps'), findsOneWidget);
    });

    testWidgets('displays creator info', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Ajouté par Test User'), findsOneWidget);
    });
  });
}
