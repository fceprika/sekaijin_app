import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/datasources/remote/review_remote_datasource.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/data/models/place_review_model.dart';
import 'package:sekaijin_app/data/repositories/review_repository_impl.dart';

class _MockReviewRemoteDatasource implements ReviewRemoteDatasource {
  bool shouldThrowError = false;
  int? errorStatusCode;
  String? errorMessage;
  List<PlaceReviewModel> reviews = [];
  PlaceReviewModel? reviewToReturn;

  @override
  Future<ApiResponse<List<PlaceReviewModel>>> getReviews(
    String placeSlug, {
    int page = 1,
    int perPage = 15,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    if (shouldThrowError) {
      throw _createDioError(errorStatusCode ?? 500, errorMessage ?? 'Error');
    }
    return ApiResponse(
      success: true,
      message: 'Success',
      data: reviews,
      pagination: const PaginationInfo(
        currentPage: 1,
        lastPage: 1,
        perPage: 15,
        total: 0,
        hasMorePages: false,
      ),
    );
  }

  @override
  Future<PlaceReviewModel> createReview(
    String placeSlug, {
    required int rating,
    required String comment,
  }) async {
    if (shouldThrowError) {
      throw _createDioError(errorStatusCode ?? 500, errorMessage ?? 'Error');
    }
    return reviewToReturn!;
  }

  @override
  Future<PlaceReviewModel> updateReview(
    String placeSlug,
    int reviewId, {
    required int rating,
    required String comment,
  }) async {
    if (shouldThrowError) {
      throw _createDioError(errorStatusCode ?? 500, errorMessage ?? 'Error');
    }
    return reviewToReturn!;
  }

  @override
  Future<void> deleteReview(String placeSlug, int reviewId) async {
    if (shouldThrowError) {
      throw _createDioError(errorStatusCode ?? 500, errorMessage ?? 'Error');
    }
  }

  DioException _createDioError(int statusCode, String message) {
    return DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: statusCode,
        data: {'message': message},
      ),
      type: DioExceptionType.badResponse,
    );
  }
}

void main() {
  late ReviewRepositoryImpl repository;
  late _MockReviewRemoteDatasource mockDatasource;

  setUp(() {
    mockDatasource = _MockReviewRemoteDatasource();
    repository = ReviewRepositoryImpl(mockDatasource);
  });

  group('ReviewRepositoryImpl', () {
    group('getReviews', () {
      test('returns reviews on success', () async {
        mockDatasource.reviews = [
          PlaceReviewModel(
            id: 1,
            userId: 1,
            placeId: 1,
            rating: 5,
            comment: 'Great place!',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        final (failure, response) = await repository.getReviews('test-slug');

        expect(failure, isNull);
        expect(response, isNotNull);
        expect(response!.data!.length, equals(1));
      });

      test('returns failure on error', () async {
        mockDatasource.shouldThrowError = true;
        mockDatasource.errorStatusCode = 500;
        mockDatasource.errorMessage = 'Server error';

        final (failure, response) = await repository.getReviews('test-slug');

        expect(failure, isNotNull);
        expect(response, isNull);
      });
    });

    group('createReview', () {
      test('returns review on success', () async {
        mockDatasource.reviewToReturn = PlaceReviewModel(
          id: 1,
          userId: 1,
          placeId: 1,
          rating: 5,
          comment: 'Great place!',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final (failure, review) = await repository.createReview(
          'test-slug',
          rating: 5,
          comment: 'Great place!',
        );

        expect(failure, isNull);
        expect(review, isNotNull);
        expect(review!.rating, equals(5));
      });

      test('returns specific failure for 409 conflict', () async {
        mockDatasource.shouldThrowError = true;
        mockDatasource.errorStatusCode = 409;

        final (failure, review) = await repository.createReview(
          'test-slug',
          rating: 5,
          comment: 'Great place!',
        );

        expect(failure, isNotNull);
        expect(failure, isA<ServerFailure>());
        expect(failure!.message, contains('déjà publié un avis'));
        expect(review, isNull);
      });

      test('returns specific failure for 404 not found', () async {
        mockDatasource.shouldThrowError = true;
        mockDatasource.errorStatusCode = 404;

        final (failure, review) = await repository.createReview(
          'test-slug',
          rating: 5,
          comment: 'Great place!',
        );

        expect(failure, isNotNull);
        expect(failure!.message, contains('non trouvé'));
        expect(review, isNull);
      });

      test('returns specific failure for 403 forbidden', () async {
        mockDatasource.shouldThrowError = true;
        mockDatasource.errorStatusCode = 403;

        final (failure, review) = await repository.createReview(
          'test-slug',
          rating: 5,
          comment: 'Great place!',
        );

        expect(failure, isNotNull);
        expect(failure!.message, contains('pas autorisé'));
        expect(review, isNull);
      });
    });

    group('updateReview', () {
      test('returns updated review on success', () async {
        mockDatasource.reviewToReturn = PlaceReviewModel(
          id: 1,
          userId: 1,
          placeId: 1,
          rating: 4,
          comment: 'Updated comment',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final (failure, review) = await repository.updateReview(
          'test-slug',
          1,
          rating: 4,
          comment: 'Updated comment',
        );

        expect(failure, isNull);
        expect(review, isNotNull);
        expect(review!.rating, equals(4));
        expect(review.comment, equals('Updated comment'));
      });
    });

    group('deleteReview', () {
      test('returns null on success', () async {
        final failure = await repository.deleteReview('test-slug', 1);

        expect(failure, isNull);
      });

      test('returns failure on error', () async {
        mockDatasource.shouldThrowError = true;
        mockDatasource.errorStatusCode = 404;

        final failure = await repository.deleteReview('test-slug', 1);

        expect(failure, isNotNull);
      });
    });
  });
}
