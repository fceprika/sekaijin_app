import 'package:dio/dio.dart';

import '../../../domain/entities/place.dart';
import '../../models/api_response.dart';
import '../../models/place_model.dart';

abstract class PlaceRemoteDatasource {
  Future<ApiResponse<List<PlaceModel>>> getPlaces({
    int? countryId,
    int? cityId,
    PlaceCategory? category,
    String? search,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  });

  Future<PlaceModel> getPlaceBySlug(String slug);
}

class PlaceRemoteDatasourceImpl implements PlaceRemoteDatasource {
  final Dio _dio;

  PlaceRemoteDatasourceImpl(this._dio);

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
    final queryParams = <String, dynamic>{
      'status': 'approved',
      'sort_by': sortBy,
      'sort_order': sortOrder,
      'page': page,
      'per_page': perPage,
    };

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
}
