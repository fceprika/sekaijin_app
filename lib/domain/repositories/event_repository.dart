import '../../core/errors/failures.dart';
import '../../data/models/api_response.dart';
import '../entities/event.dart';

abstract class EventRepository {
  Future<(Failure?, ApiResponse<List<Event>>?)> getEvents({
    int? countryId,
    bool? isOnline,
    bool? upcoming,
    int page = 1,
    int perPage = 15,
  });

  Future<(Failure?, Event?)> getEventBySlug(String slug);
}
