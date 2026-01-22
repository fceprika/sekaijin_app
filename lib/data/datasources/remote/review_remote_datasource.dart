import 'package:dio/dio.dart';

import '../../models/api_response.dart';
import '../../models/place_review_model.dart';

abstract class ReviewRemoteDatasource {
  Future<ApiResponse<List<PlaceReviewModel>>> getReviews(
    String placeSlug, {
    int page = 1,
    int perPage = 15,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  });

  Future<PlaceReviewModel> createReview(
    String placeSlug, {
    required int rating,
    required String comment,
  });

  Future<PlaceReviewModel> updateReview(
    String placeSlug,
    int reviewId, {
    required int rating,
    required String comment,
  });

  Future<void> deleteReview(String placeSlug, int reviewId);
}

class ReviewRemoteDatasourceImpl implements ReviewRemoteDatasource {
  final Dio _dio;

  ReviewRemoteDatasourceImpl(this._dio);

  @override
  Future<ApiResponse<List<PlaceReviewModel>>> getReviews(
    String placeSlug, {
    int page = 1,
    int perPage = 15,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };

    final response = await _dio.get(
      '/places/$placeSlug/reviews',
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        if (data is List) {
          return data
              .map((item) => PlaceReviewModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <PlaceReviewModel>[];
      },
    );
  }

  @override
  Future<PlaceReviewModel> createReview(
    String placeSlug, {
    required int rating,
    required String comment,
  }) async {
    final response = await _dio.post(
      '/places/$placeSlug/reviews',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );

    final data = response.data as Map<String, dynamic>;

    if (data['data'] != null) {
      return PlaceReviewModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    return PlaceReviewModel.fromJson(data);
  }

  @override
  Future<PlaceReviewModel> updateReview(
    String placeSlug,
    int reviewId, {
    required int rating,
    required String comment,
  }) async {
    final response = await _dio.put(
      '/places/$placeSlug/reviews/$reviewId',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );

    final data = response.data as Map<String, dynamic>;

    if (data['data'] != null) {
      return PlaceReviewModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    return PlaceReviewModel.fromJson(data);
  }

  @override
  Future<void> deleteReview(String placeSlug, int reviewId) async {
    await _dio.delete('/places/$placeSlug/reviews/$reviewId');
  }
}
