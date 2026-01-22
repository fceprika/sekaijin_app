import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/place_remote_datasource.dart';
import '../../data/repositories/place_repository_impl.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import 'auth_provider.dart';

// Filter providers
final placeCategoryFilterProvider = StateProvider<PlaceCategory?>((ref) => null);
final placeCityFilterProvider = StateProvider<int?>((ref) => null);
final placeSortProvider = StateProvider<String>((ref) => 'created_at');
final placeSortOrderProvider = StateProvider<String>((ref) => 'desc');

// Datasource and repository providers
final placeRemoteDatasourceProvider = Provider<PlaceRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PlaceRemoteDatasourceImpl(apiService.dio);
});

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  final remoteDatasource = ref.watch(placeRemoteDatasourceProvider);
  return PlaceRepositoryImpl(remoteDatasource);
});

// Places state
class PlacesState {
  final List<Place> places;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int total;
  final String? error;

  const PlacesState({
    this.places = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.total = 0,
    this.error,
  });

  PlacesState copyWith({
    List<Place>? places,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    int? total,
    String? error,
  }) {
    return PlacesState(
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      error: error,
    );
  }
}

// Places notifier
class PlacesNotifier extends StateNotifier<PlacesState> {
  final PlaceRepository _repository;
  final Ref _ref;

  PlacesNotifier(this._repository, this._ref) : super(const PlacesState()) {
    _init();
  }

  void _init() {
    // Listen to filter changes
    _ref.listen(placeCategoryFilterProvider, (_, __) => refresh());
    _ref.listen(placeCityFilterProvider, (_, __) => refresh());
    _ref.listen(placeSortProvider, (_, __) => refresh());
    _ref.listen(placeSortOrderProvider, (_, __) => refresh());

    // Initial load
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final category = _ref.read(placeCategoryFilterProvider);
    final cityId = _ref.read(placeCityFilterProvider);
    final sortBy = _ref.read(placeSortProvider);
    final sortOrder = _ref.read(placeSortOrderProvider);

    final (failure, response) = await _repository.getPlaces(
      category: category,
      cityId: cityId,
      sortBy: sortBy,
      sortOrder: sortOrder,
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
        places: response.data ?? [],
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

    final category = _ref.read(placeCategoryFilterProvider);
    final cityId = _ref.read(placeCityFilterProvider);
    final sortBy = _ref.read(placeSortProvider);
    final sortOrder = _ref.read(placeSortOrderProvider);
    final nextPage = state.currentPage + 1;

    final (failure, response) = await _repository.getPlaces(
      category: category,
      cityId: cityId,
      sortBy: sortBy,
      sortOrder: sortOrder,
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
      final newPlaces = <Place>[...state.places, ...(response.data ?? [])];
      state = state.copyWith(
        places: newPlaces,
        isLoadingMore: false,
        currentPage: response.pagination?.currentPage ?? nextPage,
        hasMore: response.pagination?.hasMorePages ?? false,
      );
    }
  }

  Future<void> refresh() async {
    state = const PlacesState();
    await loadPlaces();
  }
}

// Places provider
final placesProvider = StateNotifierProvider<PlacesNotifier, PlacesState>((ref) {
  final repository = ref.watch(placeRepositoryProvider);
  return PlacesNotifier(repository, ref);
});
