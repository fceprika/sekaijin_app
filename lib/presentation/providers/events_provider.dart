import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/event_remote_datasource.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import 'auth_provider.dart';
import 'paged_state.dart';

// Filter providers
final eventOnlineFilterProvider = StateProvider<bool?>((ref) => null);
final eventUpcomingFilterProvider = StateProvider<bool>((ref) => true);

// Datasource and repository providers
final eventRemoteDatasourceProvider = Provider<EventRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EventRemoteDatasourceImpl(apiService.dio);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final remoteDatasource = ref.watch(eventRemoteDatasourceProvider);
  return EventRepositoryImpl(remoteDatasource);
});

// Events notifier
class EventsNotifier extends PagedNotifier<Event> {
  final Ref _ref;

  EventsNotifier(EventRepository repository, this._ref)
      : super(
          (page) => repository.getEvents(
            isOnline: _ref.read(eventOnlineFilterProvider),
            upcoming: _ref.read(eventUpcomingFilterProvider),
            page: page,
          ),
        ) {
    _init();
  }

  void _init() {
    // Listen to filter changes
    _ref.listen(eventOnlineFilterProvider, (_, __) => refresh());
    _ref.listen(eventUpcomingFilterProvider, (_, __) => refresh());

    // Initial load
    loadInitial();
  }
}

// Events list provider
final eventsListProvider = StateNotifierProvider<EventsNotifier, PagedState<Event>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EventsNotifier(repository, ref);
});

// Event detail provider
final eventDetailProvider = FutureProvider.family<Event?, String>((ref, slug) async {
  final repository = ref.watch(eventRepositoryProvider);
  final (failure, event) = await repository.getEventBySlug(slug);

  if (failure != null) {
    throw Exception(failure.message);
  }

  return event;
});
