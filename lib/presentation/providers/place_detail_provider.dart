import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/place.dart';
import 'places_provider.dart';

final placeDetailProvider = FutureProvider.family<Place, String>((ref, slug) async {
  final repository = ref.watch(placeRepositoryProvider);

  final (failure, place) = await repository.getPlaceBySlug(slug);

  if (failure != null) {
    throw Exception(failure.message);
  }

  if (place == null) {
    throw Exception('Lieu non trouvé');
  }

  return place;
});
