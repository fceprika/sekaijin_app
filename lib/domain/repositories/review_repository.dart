import '../../core/errors/failures.dart';
import '../../data/models/api_response.dart';
import '../entities/place_review.dart';

abstract class ReviewRepository {
  Future<(Failure?, ApiResponse<List<PlaceReview>>?)> getReviews(
    String placeSlug, {
    int page = 1,
    int perPage = 15,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  });

  Future<(Failure?, PlaceReview?)> createReview(
    String placeSlug, {
    required int rating,
    required String comment,
  });

  Future<(Failure?, PlaceReview?)> updateReview(
    String placeSlug,
    int reviewId, {
    required int rating,
    required String comment,
  });

  Future<Failure?> deleteReview(String placeSlug, int reviewId);
}
