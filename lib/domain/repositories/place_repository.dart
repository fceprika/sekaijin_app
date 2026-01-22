import '../../core/errors/failures.dart';
import '../../data/models/api_response.dart';
import '../entities/place.dart';

abstract class PlaceRepository {
  Future<(Failure?, ApiResponse<List<Place>>?)> getPlaces({
    int? countryId,
    int? cityId,
    PlaceCategory? category,
    String? search,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
    int page = 1,
    int perPage = 15,
  });

  Future<(Failure?, Place?)> getPlaceBySlug(String slug);
}
