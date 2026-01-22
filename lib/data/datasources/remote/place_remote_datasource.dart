import 'package:dio/dio.dart';

import '../../../domain/entities/place.dart';
import '../../models/api_response.dart';
import '../../models/create_place_request.dart';
import '../../models/place_model.dart';

abstract class PlaceRemoteDatasource {
  Future<ApiResponse<List<PlaceModel>>> getPlaces({
    int? countryId,
    int? cityId,
    int? userId,
    PlaceCategory? category,
    String? search,
    String? status,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  });

  Future<PlaceModel> getPlaceBySlug(String slug);

  Future<PlaceModel> createPlace(CreatePlaceRequest request);
}

class PlaceRemoteDatasourceImpl implements PlaceRemoteDatasource {
  final Dio _dio;

  PlaceRemoteDatasourceImpl(this._dio);

  @override
  Future<ApiResponse<List<PlaceModel>>> getPlaces({
    int? countryId,
    int? cityId,
    int? userId,
    PlaceCategory? category,
    String? search,
    String? status,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParams = <String, dynamic>{
      'sort_by': sortBy,
      'sort_order': sortOrder,
      'page': page,
      'per_page': perPage,
    };

    // Only add status filter if not fetching by user_id (user wants to see all their places)
    if (userId != null) {
      queryParams['user_id'] = userId;
    } else {
      queryParams['status'] = status ?? 'approved';
    }

    if (countryId != null) queryParams['country_id'] = countryId;
    if (cityId != null) queryParams['city_id'] = cityId;
    if (category != null) queryParams['category'] = category.slug;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _dio.get(
      '/places',
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        if (data is List) {
          return data
              .map((item) => PlaceModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <PlaceModel>[];
      },
    );
  }

  @override
  Future<PlaceModel> getPlaceBySlug(String slug) async {
    final response = await _dio.get('/places/$slug');
    final data = response.data as Map<String, dynamic>;

    if (data['data'] != null) {
      return PlaceModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    return PlaceModel.fromJson(data);
  }

  @override
  Future<PlaceModel> createPlace(CreatePlaceRequest request) async {
    final formData = await request.toFormData();

    final response = await _dio.post(
      '/places',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    final data = response.data as Map<String, dynamic>;

    if (data['data'] != null) {
      return PlaceModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    return PlaceModel.fromJson(data);
  }
}
