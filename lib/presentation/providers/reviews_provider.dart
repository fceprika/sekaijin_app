import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/review_remote_datasource.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/place_review.dart';
import '../../domain/repositories/review_repository.dart';
import 'auth_provider.dart';

// Datasource provider
final reviewRemoteDatasourceProvider = Provider<ReviewRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ReviewRemoteDatasourceImpl(apiService.dio);
});

// Repository provider
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final remoteDatasource = ref.watch(reviewRemoteDatasourceProvider);
  return ReviewRepositoryImpl(remoteDatasource);
});

// Place reviews provider
final placeReviewsProvider =
    FutureProvider.family<List<PlaceReview>, String>((ref, placeSlug) async {
  final repository = ref.watch(reviewRepositoryProvider);

  final (failure, response) = await repository.getReviews(placeSlug);

  if (failure != null) {
    throw Exception(failure.message);
  }

  return response?.data ?? [];
});

// User's review for a place
final userReviewProvider =
    Provider.family<PlaceReview?, String>((ref, placeSlug) {
  final authState = ref.watch(authStateProvider);
  if (authState is! AuthAuthenticated) return null;

  final reviewsAsync = ref.watch(placeReviewsProvider(placeSlug));
  final currentUserId = authState.user.id;

  return reviewsAsync.whenOrNull(
    data: (reviews) {
      try {
        return reviews.firstWhere((review) => review.userId == currentUserId);
      } catch (_) {
        return null;
      }
    },
  );
});

// Review form state
class ReviewFormState {
  final int rating;
  final String comment;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;

  const ReviewFormState({
    this.rating = 0,
    this.comment = '',
    this.isSubmitting = false,
    this.error,
    this.successMessage,
  });

  ReviewFormState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return ReviewFormState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  bool get isValid => rating > 0 && comment.trim().isNotEmpty;
}

// Review form notifier
class ReviewFormNotifier extends StateNotifier<ReviewFormState> {
  final Ref _ref;
  final String placeSlug;
  final PlaceReview? existingReview;

  ReviewFormNotifier(this._ref, this.placeSlug, this.existingReview)
      : super(ReviewFormState(
          rating: existingReview?.rating ?? 0,
          comment: existingReview?.comment ?? '',
        ));

  void setRating(int value) {
    state = state.copyWith(rating: value, clearError: true);
  }

  void setComment(String value) {
    state = state.copyWith(comment: value, clearError: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearSuccessMessage() {
    state = state.copyWith(clearSuccessMessage: true);
  }

  Future<bool> submit() async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final repository = _ref.read(reviewRepositoryProvider);

      if (existingReview != null) {
        // Update existing review
        final (failure, _) = await repository.updateReview(
          placeSlug,
          existingReview!.id,
          rating: state.rating,
          comment: state.comment.trim(),
        );

        if (failure != null) {
          state = state.copyWith(
            isSubmitting: false,
            error: failure.message,
          );
          return false;
        }

        state = state.copyWith(
          isSubmitting: false,
          successMessage: 'Avis mis à jour',
        );
      } else {
        // Create new review
        final (failure, _) = await repository.createReview(
          placeSlug,
          rating: state.rating,
          comment: state.comment.trim(),
        );

        if (failure != null) {
          state = state.copyWith(
            isSubmitting: false,
            error: failure.message,
          );
          return false;
        }

        state = state.copyWith(
          isSubmitting: false,
          successMessage: 'Avis ajouté avec succès',
        );
      }

      // Invalidate reviews to refresh the list
      _ref.invalidate(placeReviewsProvider(placeSlug));

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Une erreur inattendue est survenue',
      );
      return false;
    }
  }

  Future<bool> delete() async {
    if (existingReview == null) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final repository = _ref.read(reviewRepositoryProvider);

      final failure = await repository.deleteReview(placeSlug, existingReview!.id);

      if (failure != null) {
        state = state.copyWith(
          isSubmitting: false,
          error: failure.message,
        );
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'Avis supprimé',
      );

      // Invalidate reviews to refresh the list
      _ref.invalidate(placeReviewsProvider(placeSlug));

      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Une erreur inattendue est survenue',
      );
      return false;
    }
  }
}

// Review form provider factory
final reviewFormProvider = StateNotifierProvider.autoDispose
    .family<ReviewFormNotifier, ReviewFormState, ({String placeSlug, PlaceReview? existingReview})>(
  (ref, params) => ReviewFormNotifier(ref, params.placeSlug, params.existingReview),
);
