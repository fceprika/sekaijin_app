import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/place.dart';
import '../../domain/entities/place_review.dart';
import 'auth_provider.dart';
import 'places_provider.dart';
import 'reviews_provider.dart';

// Profile stats
class ProfileStats {
  final int placesCount;
  final int reviewsCount;

  const ProfileStats({
    this.placesCount = 0,
    this.reviewsCount = 0,
  });
}

// My places provider - fetches current user's places
final myPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final authState = ref.watch(authStateProvider);

  if (authState is! AuthAuthenticated) {
    return [];
  }

  final userId = authState.user.id;
  final repository = ref.watch(placeRepositoryProvider);

  final (failure, response) = await repository.getPlaces(
    userId: userId,
    perPage: 100, // Get all user's places
  );

  if (failure != null) {
    throw Exception(failure.message);
  }

  return response?.data ?? [];
});

// My reviews provider - fetches current user's reviews
final myReviewsProvider = FutureProvider<List<PlaceReview>>((ref) async {
  final authState = ref.watch(authStateProvider);

  if (authState is! AuthAuthenticated) {
    return [];
  }

  final userId = authState.user.id;
  final repository = ref.watch(reviewRepositoryProvider);

  final (failure, response) = await repository.getUserReviews(
    userId,
    perPage: 100, // Get all user's reviews
  );

  if (failure != null) {
    throw Exception(failure.message);
  }

  return response?.data ?? [];
});

// Profile stats provider - computed from places and reviews
final profileStatsProvider = Provider<AsyncValue<ProfileStats>>((ref) {
  final placesAsync = ref.watch(myPlacesProvider);
  final reviewsAsync = ref.watch(myReviewsProvider);

  return placesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
    data: (places) => reviewsAsync.when(
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
      data: (reviews) => AsyncValue.data(ProfileStats(
        placesCount: places.length,
        reviewsCount: reviews.length,
      )),
    ),
  );
});
