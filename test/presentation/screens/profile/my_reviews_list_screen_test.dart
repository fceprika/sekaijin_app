import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/domain/entities/place_review.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/auth_repository.dart';
import 'package:sekaijin_app/domain/repositories/review_repository.dart';
import 'package:sekaijin_app/presentation/providers/auth_provider.dart';
import 'package:sekaijin_app/presentation/providers/profile_provider.dart';
import 'package:sekaijin_app/services/auth_service.dart';
import 'package:sekaijin_app/presentation/providers/reviews_provider.dart';
import 'package:sekaijin_app/presentation/screens/profile/my_reviews_list_screen.dart';

void main() {
  final mockUser = User(
    id: 1,
    name: 'Test User',
    nameSlug: 'test-user',
    email: 'test@example.com',
    createdAt: DateTime.now(),
  );

  final mockReviews = [
    PlaceReview(
      id: 1,
      placeId: 1,
      userId: 1,
      comment: 'Great place with amazing food!',
      rating: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      place: const ReviewPlace(
        id: 1,
        title: 'Test Restaurant',
        slug: 'test-restaurant',
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
        title: 'Coworking Space',
        slug: 'coworking-space',
      ),
    ),
    PlaceReview(
      id: 3,
      placeId: 3,
      userId: 1,
      comment: 'Good service',
      rating: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      place: const ReviewPlace(
        id: 3,
        title: 'Spa Center',
        slug: 'spa-center',
      ),
    ),
  ];

  Widget createScreen({
    List<PlaceReview>? reviews,
    bool isLoading = false,
    String? error,
  }) {
    final mockAuthRepository = _MockAuthRepository(mockUser);
    return ProviderScope(
      overrides: [
        authStateProvider.overrideWith((ref) {
          final notifier = AuthNotifier(mockAuthRepository, AuthService());
          notifier.setAuthenticated(mockUser);
          return notifier;
        }),
        reviewRepositoryProvider.overrideWithValue(_MockReviewRepository()),
        myReviewsProvider.overrideWith((ref) {
          if (error != null) {
            throw Exception(error);
          }
          return Future.value(reviews ?? mockReviews);
        }),
      ],
      child: const MaterialApp(
        home: MyReviewsListScreen(),
      ),
    );
  }

  group('MyReviewsListScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('my_reviews_list_screen')), findsOneWidget);
    });

    testWidgets('displays app bar with title', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Mes avis'), findsOneWidget);
    });

    testWidgets('displays review cards', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('compact_review_card_0')), findsOneWidget);
      expect(find.byKey(const Key('compact_review_card_1')), findsOneWidget);
      expect(find.byKey(const Key('compact_review_card_2')), findsOneWidget);
    });

    testWidgets('displays place names in reviews', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Test Restaurant'), findsOneWidget);
      expect(find.text('Coworking Space'), findsOneWidget);
    });

    testWidgets('displays review comments', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Great place with amazing food!'), findsOneWidget);
    });

    testWidgets('displays empty state when no reviews', (tester) async {
      await tester.pumpWidget(createScreen(reviews: []));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_reviews_message')), findsOneWidget);
      expect(
        find.text('Partagez votre expérience sur les lieux que vous avez visités !'),
        findsOneWidget,
      );
    });

    testWidgets('displays explore button in empty state', (tester) async {
      await tester.pumpWidget(createScreen(reviews: []));
      await tester.pumpAndSettle();

      expect(find.text('Explorer les lieux'), findsOneWidget);
    });

    testWidgets('has RefreshIndicator', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('displays reviews list', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reviews_list')), findsOneWidget);
    });

    testWidgets('displays star ratings', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Should find star icons
      expect(find.byIcon(Icons.star), findsWidgets);
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
