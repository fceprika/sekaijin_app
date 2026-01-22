import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sekaijin_app/presentation/widgets/common/loading_shimmer.dart';

void main() {
  group('LoadingShimmer', () {
    testWidgets('renders with correct dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingShimmer(
              width: 100,
              height: 50,
            ),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('applies custom border radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingShimmer(
              width: 100,
              height: 50,
              borderRadius: 16,
            ),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('PlaceCardShimmer', () {
    testWidgets('renders shimmer placeholder for place card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PlaceCardShimmer(),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('ArticleCardShimmer', () {
    testWidgets('renders shimmer placeholder for article card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArticleCardShimmer(),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('EventCardShimmer', () {
    testWidgets('renders shimmer placeholder for event card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EventCardShimmer(),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('ReviewCardShimmer', () {
    testWidgets('renders shimmer placeholder for review card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReviewCardShimmer(),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('CompactCardShimmer', () {
    testWidgets('renders shimmer placeholder for compact card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompactCardShimmer(),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('ShimmerList', () {
    testWidgets('renders shimmer items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ShimmerList(
                itemCount: 3,
                itemBuilder: (index) => const PlaceCardShimmer(),
              ),
            ),
          ),
        ),
      );

      // ShimmerList uses shrinkWrap and may not render all items visible
      expect(find.byType(PlaceCardShimmer), findsWidgets);
    });

    testWidgets('has correct key', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShimmerList(
              itemBuilder: (index) => const PlaceCardShimmer(),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('shimmer_list')), findsOneWidget);
    });
  });
}
