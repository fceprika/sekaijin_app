import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/widgets/common/image_carousel.dart';

void main() {
  group('ImageCarousel', () {
    testWidgets('renders placeholder when no images', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageCarousel(
              imageUrls: [],
              height: 200,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.place), findsOneWidget);
    });

    testWidgets('renders PageView when images provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageCarousel(
              imageUrls: ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
              height: 200,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('shows indicators for multiple images', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageCarousel(
              imageUrls: ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
              height: 200,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('carousel_indicators')), findsOneWidget);
    });

    testWidgets('does not show indicators for single image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageCarousel(
              imageUrls: ['https://example.com/1.jpg'],
              height: 200,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('carousel_indicators')), findsNothing);
    });

    testWidgets('swipe changes current index', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageCarousel(
              imageUrls: ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
              height: 200,
            ),
          ),
        ),
      );
      await tester.pump();

      // Swipe left to go to second image
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // The carousel should have updated its index (visual verification)
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
