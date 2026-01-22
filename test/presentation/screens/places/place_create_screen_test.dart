import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/domain/entities/place.dart';
import 'package:sekaijin_app/presentation/providers/create_place_provider.dart';
import 'package:sekaijin_app/presentation/screens/places/place_create_screen.dart';

void main() {
  Widget createScreen({CreatePlaceFormState? formState}) {
    return ProviderScope(
      overrides: [
        if (formState != null)
          createPlaceFormProvider.overrideWith((ref) {
            return _MockCreatePlaceFormNotifier(ref, formState);
          }),
      ],
      child: const MaterialApp(
        home: PlaceCreateScreen(),
      ),
    );
  }

  group('PlaceCreateScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_create_screen')), findsOneWidget);
    });

    testWidgets('displays form title field', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_title_field')), findsOneWidget);
      expect(find.text('Nom du lieu *'), findsOneWidget);
    });

    testWidgets('displays category dropdown', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_category_dropdown')), findsOneWidget);
      expect(find.text('Catégorie *'), findsOneWidget);
    });

    testWidgets('category dropdown shows all options', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      // Open dropdown
      await tester.tap(find.byKey(const Key('place_category_dropdown')));
      await tester.pumpAndSettle();

      // Verify 5 categories are shown
      expect(find.text('🛵 Location de scooters'), findsOneWidget);
      expect(find.text('💼 Espaces de travail'), findsOneWidget);
      expect(find.text('🏋️ Centres sportifs'), findsOneWidget);
      expect(find.text('🍜 Restaurants'), findsOneWidget);
      expect(find.text('💆 Spa & Massage'), findsOneWidget);
    });

    testWidgets('displays city dropdown', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_city_dropdown')), findsOneWidget);
      expect(find.text('Ville *'), findsOneWidget);
    });

    testWidgets('displays Google Maps URL field', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_google_maps_field')), findsOneWidget);
      expect(find.text('Lien Google Maps *'), findsOneWidget);
    });

    testWidgets('displays description field', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_description_field')), findsOneWidget);
      expect(find.text('Description *'), findsOneWidget);
    });

    testWidgets('displays image picker', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      expect(find.byKey(const Key('place_images_picker')), findsOneWidget);
      expect(find.text('Photos (max 3)'), findsOneWidget);
    });

    testWidgets('submit button is disabled when form is invalid', (tester) async {
      await tester.pumpWidget(createScreen(
        formState: const CreatePlaceFormState(), // Empty state = invalid
      ));
      await tester.pump();

      final submitButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('submit_place_button')),
      );

      expect(submitButton.onPressed, isNull);
    });

    testWidgets('submit button is enabled when form is valid', (tester) async {
      await tester.pumpWidget(createScreen(
        formState: const CreatePlaceFormState(
          title: 'Test Place',
          cityId: 1,
          category: PlaceCategory.restaurants,
          description: 'This is a test description for the place.',
          googleMapsUrl: 'https://maps.google.com/test',
        ),
      ));
      await tester.pump();

      final submitButton = tester.widget<ElevatedButton>(
        find.byKey(const Key('submit_place_button')),
      );

      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('displays moderation info note', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();

      // Scroll to bottom to see the note
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();

      expect(
        find.text('Votre lieu sera vérifié par un modérateur avant d\'être publié.'),
        findsOneWidget,
      );
    });

    testWidgets('shows wifi speed field when workspace category selected', (tester) async {
      await tester.pumpWidget(createScreen(
        formState: const CreatePlaceFormState(
          category: PlaceCategory.espacesTravail,
        ),
      ));
      await tester.pump();

      // Scroll down to find the wifi field
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pump();

      expect(find.text('Vitesse Wifi (Mbps)'), findsOneWidget);
    });
  });
}

class _MockCreatePlaceFormNotifier extends CreatePlaceFormNotifier {
  final CreatePlaceFormState _mockState;

  _MockCreatePlaceFormNotifier(super.ref, this._mockState);

  @override
  CreatePlaceFormState get state => _mockState;
}
