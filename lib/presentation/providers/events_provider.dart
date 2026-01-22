import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/event_remote_datasource.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import 'auth_provider.dart';

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

// Events state
class EventsState {
  final List<Event> events;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int total;
  final String? error;

  const EventsState({
    this.events = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.total = 0,
    this.error,
  });

  EventsState copyWith({
    List<Event>? events,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    int? total,
    String? error,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      error: error,
    );
  }
}

// Events notifier
class EventsNotifier extends StateNotifier<EventsState> {
  final EventRepository _repository;
  final Ref _ref;

  EventsNotifier(this._repository, this._ref) : super(const EventsState()) {
    _init();
  }

  void _init() {
    // Listen to filter changes
    _ref.listen(eventOnlineFilterProvider, (_, __) => refresh());
    _ref.listen(eventUpcomingFilterProvider, (_, __) => refresh());

    // Initial load
    loadEvents();
  }

  Future<void> loadEvents() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final isOnline = _ref.read(eventOnlineFilterProvider);
    final upcoming = _ref.read(eventUpcomingFilterProvider);

    final (failure, response) = await _repository.getEvents(
      isOnline: isOnline,
      upcoming: upcoming,
      page: 1,
    );

    if (failure != null) {
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
      );
      return;
    }

    if (response != null) {
      state = state.copyWith(
        events: response.data ?? [],
        isLoading: false,
        currentPage: response.pagination?.currentPage ?? 1,
        hasMore: response.pagination?.hasMorePages ?? false,
        total: response.pagination?.total ?? 0,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    final isOnline = _ref.read(eventOnlineFilterProvider);
    final upcoming = _ref.read(eventUpcomingFilterProvider);
    final nextPage = state.currentPage + 1;

    final (failure, response) = await _repository.getEvents(
      isOnline: isOnline,
      upcoming: upcoming,
      page: nextPage,
    );

    if (failure != null) {
      state = state.copyWith(
        isLoadingMore: false,
        error: failure.message,
      );
      return;
    }

    if (response != null) {
      final newEvents = <Event>[...state.events, ...(response.data ?? [])];
      state = state.copyWith(
        events: newEvents,
        isLoadingMore: false,
        currentPage: response.pagination?.currentPage ?? nextPage,
        hasMore: response.pagination?.hasMorePages ?? false,
      );
    }
  }

  Future<void> refresh() async {
    state = const EventsState();
    await loadEvents();
  }
}

// Events list provider
final eventsListProvider = StateNotifierProvider<EventsNotifier, EventsState>((ref) {
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
