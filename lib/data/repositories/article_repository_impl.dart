import 'package:dio/dio.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/remote/article_remote_datasource.dart';
import '../models/api_response.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource _remoteDatasource;

  ArticleRepositoryImpl(this._remoteDatasource);

  @override
  Future<(Failure?, ApiResponse<List<Article>>?)> getArticles({
    int? countryId,
    String? category,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _remoteDatasource.getArticles(
        countryId: countryId,
        category: category,
        page: page,
        perPage: perPage,
      );

      return (null, response as ApiResponse<List<Article>>);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<(Failure?, Article?)> getArticleBySlug(String slug) async {
    try {
      final article = await _remoteDatasource.getArticleBySlug(slug);
      return (null, article);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
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

      if (statusCode == 404) {
        return const ServerFailure(message: 'Article non trouvé');
      }

      return ServerFailure(message: message);
    }

    return const ServerFailure(message: 'Une erreur inattendue est survenue');
  }
}
