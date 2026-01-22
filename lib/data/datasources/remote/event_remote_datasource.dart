import 'package:dio/dio.dart';

import '../../models/api_response.dart';
import '../../models/event_model.dart';

abstract class EventRemoteDatasource {
  Future<ApiResponse<List<EventModel>>> getEvents({
    int? countryId,
    bool? isOnline,
    bool? upcoming,
    int page = 1,
    int perPage = 15,
  });

  Future<EventModel> getEventBySlug(String slug);
}

class EventRemoteDatasourceImpl implements EventRemoteDatasource {
  final Dio _dio;

  EventRemoteDatasourceImpl(this._dio);

  @override
  Future<ApiResponse<List<EventModel>>> getEvents({
    int? countryId,
    bool? isOnline,
    bool? upcoming,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParams = <String, dynamic>{
      'status': 'published',
      'page': page,
      'per_page': perPage,
    };

    if (countryId != null) queryParams['country_id'] = countryId;
    if (isOnline != null) queryParams['is_online'] = isOnline ? 1 : 0;
    if (upcoming != null && upcoming) queryParams['upcoming'] = 1;

    final response = await _dio.get(
      '/events',
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        if (data is List) {
          return data
              .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <EventModel>[];
      },
    );
  }

  @override
  Future<EventModel> getEventBySlug(String slug) async {
    final response = await _dio.get('/events/$slug');
    final data = response.data as Map<String, dynamic>;

    if (data['data'] != null) {
      return EventModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    return EventModel.fromJson(data);
  }
}
