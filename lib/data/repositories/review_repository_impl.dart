import 'package:dio/dio.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/place_review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/remote/review_remote_datasource.dart';
import '../models/api_response.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDatasource _remoteDatasource;

  ReviewRepositoryImpl(this._remoteDatasource);

  @override
  Future<(Failure?, ApiResponse<List<PlaceReview>>?)> getReviews(
    String placeSlug, {
    int page = 1,
    int perPage = 15,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _remoteDatasource.getReviews(
        placeSlug,
        page: page,
        perPage: perPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      return (null, response as ApiResponse<List<PlaceReview>>);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<(Failure?, ApiResponse<List<PlaceReview>>?)> getUserReviews(
    int userId, {
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _remoteDatasource.getUserReviews(
        userId,
        page: page,
        perPage: perPage,
      );

      return (null, response as ApiResponse<List<PlaceReview>>);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<(Failure?, PlaceReview?)> createReview(
    String placeSlug, {
    required int rating,
    required String comment,
  }) async {
    try {
      final review = await _remoteDatasource.createReview(
        placeSlug,
        rating: rating,
        comment: comment,
      );
      return (null, review);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<(Failure?, PlaceReview?)> updateReview(
    String placeSlug,
    int reviewId, {
    required int rating,
    required String comment,
  }) async {
    try {
      final review = await _remoteDatasource.updateReview(
        placeSlug,
        reviewId,
        rating: rating,
        comment: comment,
      );
      return (null, review);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<Failure?> deleteReview(String placeSlug, int reviewId) async {
    try {
      await _remoteDatasource.deleteReview(placeSlug, reviewId);
      return null;
    } on DioException catch (e) {
      return _handleDioError(e);
    } on ServerException catch (e) {
      return ServerFailure(message: e.message);
    } catch (e) {
      return const ServerFailure(message: 'Une erreur inattendue est survenue');
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure(message: 'Connexion au serveur expirée');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(message: 'Impossible de se connecter au serveur');
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      String message = 'Une erreur est survenue';
      if (data is Map<String, dynamic> && data['message'] != null) {
        message = data['message'] as String;
      }

      if (statusCode == 409) {
        return const ServerFailure(message: 'Vous avez déjà publié un avis pour ce lieu');
      }

      if (statusCode == 404) {
        return const ServerFailure(message: 'Avis non trouvé');
      }

      if (statusCode == 403) {
        return const ServerFailure(message: 'Vous n\'êtes pas autorisé à effectuer cette action');
      }

      return ServerFailure(message: message);
    }

    return const ServerFailure(message: 'Une erreur inattendue est survenue');
  }
}
