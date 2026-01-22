import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/widgets/forms/star_rating_input.dart';

void main() {
  group('StarRatingInput', () {
    testWidgets('renders 5 star icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingInput(
              rating: 0,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Should have 5 star icons
      final starIcons = find.byIcon(Icons.star_outline_rounded);
      expect(starIcons, findsNWidgets(5));
    });

    testWidgets('displays correct number of filled stars', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingInput(
              rating: 3,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Should have 3 filled stars and 2 empty stars
      final filledStars = find.byIcon(Icons.star_rounded);
      final emptyStars = find.byIcon(Icons.star_outline_rounded);

      expect(filledStars, findsNWidgets(3));
      expect(emptyStars, findsNWidgets(2));
    });

    testWidgets('calls onChanged when star is tapped', (tester) async {
      int? selectedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingInput(
              rating: 0,
              onChanged: (value) => selectedRating = value,
            ),
          ),
        ),
      );

      // Tap the third star
      final stars = find.byType(GestureDetector);
      await tester.tap(stars.at(2));
      await tester.pump();

      expect(selectedRating, equals(3));
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      int? selectedRating;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingInput(
              rating: 0,
              onChanged: (value) => selectedRating = value,
              enabled: false,
            ),
          ),
        ),
      );

      // Tap the first star
      final stars = find.byType(GestureDetector);
      await tester.tap(stars.first);
      await tester.pump();

      // Should not have changed
      expect(selectedRating, isNull);
    });

    testWidgets('respects custom size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingInput(
              rating: 1,
              onChanged: (_) {},
              size: 60,
            ),
          ),
        ),
      );

      // Find the filled star icon and verify its size
      final iconFinder = find.byIcon(Icons.star_rounded);
      final Icon icon = tester.widget(iconFinder);
      expect(icon.size, equals(60));
    });
  });
}
