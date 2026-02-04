import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/data/models/create_place_request.dart';
import 'package:sekaijin_app/domain/entities/place.dart';
import 'package:sekaijin_app/domain/entities/place_review.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/auth_repository.dart';
import 'package:sekaijin_app/domain/repositories/place_repository.dart';
import 'package:sekaijin_app/domain/repositories/review_repository.dart';
import 'package:sekaijin_app/presentation/providers/auth_provider.dart';
import 'package:sekaijin_app/presentation/providers/places_provider.dart';
import 'package:sekaijin_app/services/auth_service.dart';
import 'package:sekaijin_app/presentation/providers/profile_provider.dart';
import 'package:sekaijin_app/presentation/providers/reviews_provider.dart';
import 'package:sekaijin_app/presentation/screens/profile/profile_screen.dart';

void main() {
  final mockUser = User(
    id: 1,
    name: 'Test User',
    nameSlug: 'test-user',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
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
  ];

  final mockReviews = [
    PlaceReview(
      id: 1,
      placeId: 1,
      userId: 1,
      comment: 'Great place!',
      rating: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      place: const ReviewPlace(
        id: 1,
        title: 'Test Place 1',
        slug: 'test-place-1',
      ),
    ),
    PlaceReview(
      id: 2,
      placeId: 2,
      userId: 1,
      comment: 'Nice atmosphere',
      rating: 4,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      place: const ReviewPlace(
        id: 2,
        title: 'Test Place 2',
        slug: 'test-place-2',
      ),
    ),
  ];

  Widget createScreen({
    List<Place>? places,
    List<PlaceReview>? reviews,
    bool isLoading = false,
  }) {
    final mockAuthRepository = _MockAuthRepository(mockUser);
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) {
          final notifier = AuthNotifier(mockAuthRepository, AuthService());
          notifier.setAuthenticated(mockUser);
          return notifier;
        }),
        placeRepositoryProvider.overrideWithValue(_MockPlaceRepository()),
        reviewRepositoryProvider.overrideWithValue(_MockReviewRepository()),
        myPlacesProvider.overrideWith((ref) {
          if (isLoading) {
            return Future.value(<Place>[]);
          }
          return Future.value(places ?? mockPlaces);
        }),
        myReviewsProvider.overrideWith((ref) {
          if (isLoading) {
            return Future.value(<PlaceReview>[]);
          }
          return Future.value(reviews ?? mockReviews);
        }),
      ],
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_screen')), findsOneWidget);
    });

    testWidgets('displays user name', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_display_name')), findsOneWidget);
    });

    testWidgets('displays user email', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_email')), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('displays profile avatar', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_avatar')), findsOneWidget);
    });

    testWidgets('displays logout button', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('logout_button')), findsOneWidget);
    });

    testWidgets('displays stat cards', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('stat_places')), findsOneWidget);
      expect(find.byKey(const Key('stat_reviews')), findsOneWidget);
    });

    testWidgets('displays places count in stat card', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('2'), findsWidgets); // 2 places and 2 reviews
    });

    testWidgets('displays my places section', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mes lieux'), findsOneWidget);
    });

    testWidgets('displays my reviews section', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mes avis'), findsOneWidget);
    });

    testWidgets('displays place cards', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('compact_place_card_0')), findsOneWidget);
    });

    testWidgets('displays review cards', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Scroll down to see reviews
      await tester.drag(
        find.byKey(const Key('profile_scroll_view')),
        const Offset(0, -300),
      );
      await tester.pump();

      expect(find.byKey(const Key('compact_review_card_0')), findsOneWidget);
    });

    testWidgets('displays empty state for places when empty', (tester) async {
      await tester.pumpWidget(createScreen(places: []));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('no_places_message')), findsOneWidget);
    });

    testWidgets('displays empty state for reviews when empty', (tester) async {
      await tester.pumpWidget(createScreen(reviews: []));
      await tester.pumpAndSettle();

      // Scroll down to see reviews section
      await tester.drag(
        find.byKey(const Key('profile_scroll_view')),
        const Offset(0, -200),
      );
      await tester.pump();

      expect(find.byKey(const Key('no_reviews_message')), findsOneWidget);
    });

    testWidgets('shows logout confirmation dialog', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('Déconnexion'), findsWidgets);
      expect(find.text('Êtes-vous sûr de vouloir vous déconnecter ?'), findsOneWidget);
    });

    testWidgets('has RefreshIndicator', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('displays Voir tout buttons', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Voir tout'), findsWidgets);
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

class _MockReviewRepository implements ReviewRepository {
  @override
  Future<(Failure?, ApiResponse<List<PlaceReview>>?)> getReviews(
    String placeSlug, {
    int page = 1,
    int perPage = 15,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async =>
      (null, null);

  @override
  Future<(Failure?, ApiResponse<List<PlaceReview>>?)> getUserReviews(
    int userId, {
    int page = 1,
    int perPage = 15,
  }) async =>
      (null, null);

  @override
  Future<(Failure?, PlaceReview?)> createReview(
    String placeSlug, {
    required int rating,
    required String comment,
  }) async =>
      (null, null);

  @override
  Future<(Failure?, PlaceReview?)> updateReview(
    String placeSlug,
    int reviewId, {
    required int rating,
    required String comment,
  }) async =>
      (null, null);

  @override
  Future<Failure?> deleteReview(String placeSlug, int reviewId) async => null;
}
