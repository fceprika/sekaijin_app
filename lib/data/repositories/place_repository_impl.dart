import 'package:dio/dio.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/remote/place_remote_datasource.dart';
import '../models/api_response.dart';
import '../models/create_place_request.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDatasource _remoteDatasource;

  PlaceRepositoryImpl(this._remoteDatasource);

  @override
  Future<(Failure?, ApiResponse<List<Place>>?)> getPlaces({
    int? countryId,
    int? cityId,
    PlaceCategory? category,
    String? search,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _remoteDatasource.getPlaces(
        countryId: countryId,
        cityId: cityId,
        category: category,
        search: search,
        sortBy: sortBy,
        sortOrder: sortOrder,
        page: page,
        perPage: perPage,
      );

      return (null, response as ApiResponse<List<Place>>);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }

  @override
  Future<(Failure?, Place?)> getPlaceBySlug(String slug) async {
    try {
      final place = await _remoteDatasource.getPlaceBySlug(slug);
      return (null, place);
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
        return const ServerFailure(message: 'Lieu non trouvé');
      }

      return ServerFailure(message: message);
    }

    return const ServerFailure(message: 'Une erreur inattendue est survenue');
  }

  @override
  Future<(Failure?, Place?)> createPlace(CreatePlaceRequest request) async {
    try {
      final place = await _remoteDatasource.createPlace(request);
      return (null, place);
    } on DioException catch (e) {
      return (_handleDioError(e), null);
    } on ServerException catch (e) {
      return (ServerFailure(message: e.message), null);
    } catch (e) {
      return (const ServerFailure(message: 'Une erreur inattendue est survenue'), null);
    }
  }
}
