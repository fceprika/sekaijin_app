import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/data/models/create_place_request.dart';
import 'package:sekaijin_app/domain/entities/place.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/auth_repository.dart';
import 'package:sekaijin_app/domain/repositories/place_repository.dart';
import 'package:sekaijin_app/presentation/providers/auth_provider.dart';
import 'package:sekaijin_app/presentation/providers/places_provider.dart';
import 'package:sekaijin_app/presentation/providers/profile_provider.dart';
import 'package:sekaijin_app/presentation/screens/profile/my_places_list_screen.dart';

void main() {
  final mockUser = User(
    id: 1,
    name: 'Test User',
    nameSlug: 'test-user',
    email: 'test@example.com',
    createdAt: DateTime.now(),
  );

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
      status: PlaceStatus.approved,
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
      category: PlaceCategory.espacesTravail,
      googleMapsUrl: 'https://maps.google.com',
      status: PlaceStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Place(
      id: 3,
      title: 'Test Place 3',
      slug: 'test-place-3',
      description: 'Description 3',
      userId: 1,
      cityId: 1,
      category: PlaceCategory.spaMassage,
      googleMapsUrl: 'https://maps.google.com',
      status: PlaceStatus.rejected,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Widget createScreen({
    List<Place>? places,
    bool isLoading = false,
    String? error,
  }) {
    final mockAuthRepository = _MockAuthRepository(mockUser);
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) {
          final notifier = AuthNotifier(mockAuthRepository);
          notifier.setAuthenticated(mockUser);
          return notifier;
        }),
        placeRepositoryProvider.overrideWithValue(_MockPlaceRepository()),
        myPlacesProvider.overrideWith((ref) {
          if (error != null) {
            throw Exception(error);
          }
          return Future.value(places ?? mockPlaces);
        }),
      ],
      child: const MaterialApp(
        home: MyPlacesListScreen(),
      ),
    );
  }

  group('MyPlacesListScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('my_places_list_screen')), findsOneWidget);
    });

    testWidgets('displays app bar with title', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mes lieux'), findsOneWidget);
    });

    testWidgets('displays place cards', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('compact_place_card_0')), findsOneWidget);
      expect(find.byKey(const Key('compact_place_card_1')), findsOneWidget);
      expect(find.byKey(const Key('compact_place_card_2')), findsOneWidget);
    });

    testWidgets('displays place titles', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Test Place 1'), findsOneWidget);
      expect(find.text('Test Place 2'), findsOneWidget);
    });

    testWidgets('displays status badges', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Approuvé'), findsOneWidget);
      expect(find.text('En attente'), findsOneWidget);
      expect(find.text('Refusé'), findsOneWidget);
    });

    testWidgets('displays empty state when no places', (tester) async {
      await tester.pumpWidget(createScreen(places: []));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_places_message')), findsOneWidget);
      expect(find.text('Commencez à partager vos bonnes adresses !'), findsOneWidget);
    });

    testWidgets('displays add place button in empty state', (tester) async {
      await tester.pumpWidget(createScreen(places: []));
      await tester.pumpAndSettle();

      expect(find.text('Ajouter un lieu'), findsOneWidget);
    });

    testWidgets('has floating action button', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_place_fab')), findsOneWidget);
    });

    testWidgets('has RefreshIndicator', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('displays places list', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('places_list')), findsOneWidget);
    });
  });
}

extension on AuthNotifier {
  void setAuthenticated(User user) {
    state = AuthAuthenticated(user);
  }
}

class _MockAuthRepository implements AuthRepository {
  final User mockUser;

  _MockAuthRepository(this.mockUser);

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<User?> getCurrentUser() async => mockUser;

  @override
  Future<(Failure?, User?)> login(String email, String password) async =>
      (null, mockUser);

  @override
  Future<(Failure?, void)> logout() async => (null, null);

  @override
  Future<(Failure?, User?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? countryResidence,
    String? interestCountry,
    required bool terms,
  }) async =>
      (null, mockUser);
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
  }) async =>
      (null, null);

  @override
  Future<(Failure?, Place?)> getPlaceBySlug(String slug) async => (null, null);

  @override
  Future<(Failure?, Place?)> createPlace(CreatePlaceRequest request) async =>
      (null, null);
}
