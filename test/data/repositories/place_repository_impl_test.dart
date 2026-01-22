import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/datasources/remote/place_remote_datasource.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/data/models/create_place_request.dart';
import 'package:sekaijin_app/data/models/place_model.dart';
import 'package:sekaijin_app/data/repositories/place_repository_impl.dart';
import 'package:sekaijin_app/domain/entities/place.dart';

void main() {
  group('PlaceRepositoryImpl', () {
    late PlaceRepositoryImpl repository;
    late _MockPlaceRemoteDatasource mockDatasource;

    setUp(() {
      mockDatasource = _MockPlaceRemoteDatasource();
      repository = PlaceRepositoryImpl(mockDatasource);
    });

    group('getPlaces', () {
      test('returns paginated response on success', () async {
        final mockPlaces = [
          PlaceModel(
            id: 1,
            title: 'Test Place',
            slug: 'test-place',
            description: 'Description',
            userId: 1,
            cityId: 1,
            category: PlaceCategory.restaurants,
            googleMapsUrl: 'https://maps.google.com',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        mockDatasource.placesResponse = ApiResponse(
          success: true,
          message: 'Success',
          data: mockPlaces,
          pagination: const PaginationInfo(
            currentPage: 1,
            perPage: 15,
            total: 1,
            lastPage: 1,
            hasMorePages: false,
          ),
        );

        final (failure, response) = await repository.getPlaces();

        expect(failure, isNull);
        expect(response, isNotNull);
        expect(response!.data, isNotNull);
        expect(response.data!.length, 1);
        expect(response.data!.first.title, 'Test Place');
      });

      test('returns failure on network error', () async {
        mockDatasource.shouldThrowNetworkError = true;

        final (failure, response) = await repository.getPlaces();

        expect(failure, isNotNull);
        expect(failure, isA<NetworkFailure>());
        expect(response, isNull);
      });

      test('returns failure on server error', () async {
        mockDatasource.shouldThrowServerError = true;

        final (failure, response) = await repository.getPlaces();

        expect(failure, isNotNull);
        expect(failure, isA<ServerFailure>());
        expect(response, isNull);
      });

      test('passes filter parameters correctly', () async {
        mockDatasource.placesResponse = const ApiResponse(
          success: true,
          message: 'Success',
          data: <PlaceModel>[],
        );

        await repository.getPlaces(
          cityId: 5,
          category: PlaceCategory.restaurants,
          sortBy: 'rating_average',
          sortOrder: 'desc',
          page: 2,
        );

        expect(mockDatasource.lastCityId, 5);
        expect(mockDatasource.lastCategory, PlaceCategory.restaurants);
        expect(mockDatasource.lastSortBy, 'rating_average');
        expect(mockDatasource.lastSortOrder, 'desc');
        expect(mockDatasource.lastPage, 2);
      });
    });

    group('getPlaceBySlug', () {
      test('returns place on success', () async {
        mockDatasource.placeResponse = PlaceModel(
          id: 1,
          title: 'Test Place',
          slug: 'test-place',
          description: 'Description',
          userId: 1,
          cityId: 1,
          category: PlaceCategory.restaurants,
          googleMapsUrl: 'https://maps.google.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final (failure, place) = await repository.getPlaceBySlug('test-place');

        expect(failure, isNull);
        expect(place, isNotNull);
        expect(place!.title, 'Test Place');
        expect(place.slug, 'test-place');
      });

      test('returns failure when place not found', () async {
        mockDatasource.shouldThrow404 = true;

        final (failure, place) = await repository.getPlaceBySlug('not-found');

        expect(failure, isNotNull);
        expect(failure!.message, 'Lieu non trouvé');
        expect(place, isNull);
      });
    });
  });
}

class _MockPlaceRemoteDatasource implements PlaceRemoteDatasource {
  ApiResponse<List<PlaceModel>>? placesResponse;
  PlaceModel? placeResponse;
  bool shouldThrowNetworkError = false;
  bool shouldThrowServerError = false;
  bool shouldThrow404 = false;

  int? lastCityId;
  PlaceCategory? lastCategory;
  String? lastSortBy;
  String? lastSortOrder;
  int? lastPage;

  @override
  Future<ApiResponse<List<PlaceModel>>> getPlaces({
    int? countryId,
    int? cityId,
    PlaceCategory? category,
    String? search,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  }) async {
    lastCityId = cityId;
    lastCategory = category;
    lastSortBy = sortBy;
    lastSortOrder = sortOrder;
    lastPage = page;

    if (shouldThrowNetworkError) {
      throw DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: '/places'),
      );
    }

    if (shouldThrowServerError) {
      throw DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 500,
          data: {'message': 'Server error'},
          requestOptions: RequestOptions(path: '/places'),
        ),
        requestOptions: RequestOptions(path: '/places'),
      );
    }

    return placesResponse ?? const ApiResponse(
      success: true,
      message: 'Success',
      data: <PlaceModel>[],
    );
  }

  @override
  Future<PlaceModel> getPlaceBySlug(String slug) async {
    if (shouldThrow404) {
      throw DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          data: {'message': 'Not found'},
          requestOptions: RequestOptions(path: '/places/$slug'),
        ),
        requestOptions: RequestOptions(path: '/places/$slug'),
      );
    }

    return placeResponse!;
  }

  @override
  Future<PlaceModel> createPlace(CreatePlaceRequest request) async {
    throw UnimplementedError();
  }
}
