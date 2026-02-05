import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/place_remote_datasource.dart';
import '../../data/repositories/place_repository_impl.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';
import 'auth_provider.dart';
import 'paged_state.dart';

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

// Places notifier
class PlacesNotifier extends PagedNotifier<Place> {
  final Ref _ref;

  PlacesNotifier(PlaceRepository repository, this._ref)
      : super(
          (page) => repository.getPlaces(
            category: _ref.read(placeCategoryFilterProvider),
            cityId: _ref.read(placeCityFilterProvider),
            sortBy: _ref.read(placeSortProvider),
            sortOrder: _ref.read(placeSortOrderProvider),
            page: page,
          ),
        ) {
    _init();
  }

  void _init() {
    // Listen to filter changes
    _ref.listen(placeCategoryFilterProvider, (_, __) => refresh());
    _ref.listen(placeCityFilterProvider, (_, __) => refresh());
    _ref.listen(placeSortProvider, (_, __) => refresh());
    _ref.listen(placeSortOrderProvider, (_, __) => refresh());

    // Initial load
    loadInitial();
  }
}

// Places provider
final placesProvider = StateNotifierProvider<PlacesNotifier, PagedState<Place>>((ref) {
  final repository = ref.watch(placeRepositoryProvider);
  return PlacesNotifier(repository, ref);
});
