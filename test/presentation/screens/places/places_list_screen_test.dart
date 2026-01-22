import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/data/models/create_place_request.dart';
import 'package:sekaijin_app/domain/entities/place.dart';
import 'package:sekaijin_app/domain/repositories/place_repository.dart';
import 'package:sekaijin_app/presentation/providers/places_provider.dart';
import 'package:sekaijin_app/presentation/screens/places/places_list_screen.dart';

void main() {
  final mockPlaces = [
    Place(
      id: 1,
      title: 'Test Place 1',
      slug: 'test-place-1',
      description: 'Description 1',
      userId: 1,
      cityId: 1,
      category: PlaceCategory.restaurants,
      googleMapsUrl: 'https://maps.google.com',
      ratingAverage: 4.5,
      reviewsCount: 10,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Place(
      id: 2,
      title: 'Test Place 2',
      slug: 'test-place-2',
      description: 'Description 2',
      userId: 1,
      cityId: 1,
      category: PlaceCategory.spaMassage,
      googleMapsUrl: 'https://maps.google.com',
      ratingAverage: 4.0,
      reviewsCount: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Widget createScreen({
    PlacesState? placesState,
    PlaceCategory? categoryFilter,
    String? sortBy,
  }) {
    return ProviderScope(
      overrides: [
        placesProvider.overrideWith((ref) {
          final notifier = _MockPlacesNotifier(ref, placesState ?? const PlacesState());
          return notifier;
        }),
        if (categoryFilter != null)
          placeCategoryFilterProvider.overrideWith((ref) => categoryFilter),
        placeSortProvider.overrideWith((ref) => sortBy ?? 'created_at'),
      ],
      child: const MaterialApp(
        home: PlacesListScreen(),
      ),
    );
  }

  group('PlacesListScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('places_list_screen')), findsOneWidget);
    });

    testWidgets('displays category chips section with Tous chip', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
      ));
      await tester.pump();

      // The "Tous" chip should always be visible
      expect(find.byKey(const Key('category_filter_tous')), findsOneWidget);
      expect(find.text('Tous'), findsOneWidget);
    });

    testWidgets('sort dropdown is visible', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
        sortBy: 'created_at',
      ));
      await tester.pump();

      expect(find.byKey(const Key('sort_dropdown')), findsOneWidget);
      expect(find.text('Plus récents'), findsOneWidget);
    });

    testWidgets('sort dropdown opens and shows options', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
        sortBy: 'created_at',
      ));
      await tester.pump();

      // Open dropdown
      await tester.tap(find.byKey(const Key('sort_dropdown')));
      await tester.pumpAndSettle();

      // Verify dropdown items exist
      expect(find.text('Mieux notés'), findsOneWidget);
    });

    testWidgets('displays empty state when no places', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: const PlacesState(places: [], total: 0),
      ));
      await tester.pump();

      expect(find.byKey(const Key('empty_places_state')), findsOneWidget);
      expect(find.text('Aucun lieu trouvé'), findsOneWidget);
    });

    testWidgets('displays place cards when places exist', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
      ));
      await tester.pump();

      // Scroll down to see cards
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -300),
      );
      await tester.pump();

      expect(find.byKey(const Key('places_list')), findsOneWidget);
    });

    testWidgets('displays results count', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 25),
      ));
      await tester.pump();

      expect(find.text('25 lieux trouvés'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: const PlacesState(isLoading: true),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('has pull-to-refresh', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
      ));
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('appbar has correct title', (tester) async {
      await tester.pumpWidget(createScreen(
        placesState: PlacesState(places: mockPlaces, total: 2),
      ));
      await tester.pump();

      expect(find.text('Explorer'), findsOneWidget);
    });
  });
}

class _MockPlacesNotifier extends PlacesNotifier {
  final PlacesState _mockState;

  _MockPlacesNotifier(Ref ref, this._mockState) : super(_MockPlaceRepository(), ref);

  @override
  PlacesState get state => _mockState;

  @override
  Future<void> loadPlaces() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> refresh() async {}
}

class _MockPlaceRepository implements PlaceRepository {
  @override
  Future<(Failure?, ApiResponse<List<Place>>?)> getPlaces({
    int? countryId,
    int? cityId,
    int? userId,
    PlaceCategory? category,
    String? search,
    String? status,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  }) async => (null, null);

  @override
  Future<(Failure?, Place?)> getPlaceBySlug(String slug) async => (null, null);

  @override
  Future<(Failure?, Place?)> createPlace(CreatePlaceRequest request) async => (null, null);
}
