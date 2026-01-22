import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/presentation/widgets/common/bottom_nav_bar.dart';

void main() {
  group('BottomNavBar', () {
    testWidgets('renders all navigation items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Explorer'), findsOneWidget);
      expect(find.text('Actus'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('displays correct icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.newspaper_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outlined), findsOneWidget);
    });

    testWidgets('calls onTap with correct index when item is tapped',
        (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Explorer'));
      expect(tappedIndex, 1);

      await tester.tap(find.text('Actus'));
      expect(tappedIndex, 3);

      await tester.tap(find.text('Profil'));
      expect(tappedIndex, 4);
    });

    testWidgets('shows active icon for selected index', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              currentIndex: 1,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.explore), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets('add button has larger icon size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      final addIcon = find.byIcon(Icons.add);
      expect(addIcon, findsOneWidget);

      final iconWidget = tester.widget<Icon>(addIcon);
      expect(iconWidget.size, 32);
    });

    testWidgets('has correct widget keys', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('nav_home')), findsOneWidget);
      expect(find.byKey(const Key('nav_explore')), findsOneWidget);
      expect(find.byKey(const Key('nav_add')), findsOneWidget);
      expect(find.byKey(const Key('nav_news')), findsOneWidget);
      expect(find.byKey(const Key('nav_profile')), findsOneWidget);
    });
  });
}
