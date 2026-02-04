import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/place.dart';
import '../../domain/entities/article.dart';
import '../widgets/cards/news_card.dart';
import '../widgets/cards/place_card.dart';
import 'articles_provider.dart';
import 'places_provider.dart';

class HomeData {
  final List<NewsCardData> latestNews;
  final List<PlaceCardData> popularPlaces;

  const HomeData({
    required this.latestNews,
    required this.popularPlaces,
  });
}

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final link = ref.keepAlive();
  Timer? timer;
  timer = Timer(const Duration(minutes: 10), link.close);
  ref.onDispose(() => timer?.cancel());

  final articlesRepository = ref.watch(articleRepositoryProvider);
  final placesRepository = ref.watch(placeRepositoryProvider);

  final results = await Future.wait([
    articlesRepository.getArticles(page: 1, perPage: 5),
    placesRepository.getPlaces(page: 1, perPage: 4),
  ]);

  final (articlesFailure, articlesResponse) = results[0];
  final (placesFailure, placesResponse) = results[1];

  if (articlesFailure != null && placesFailure != null) {
    throw Exception('Impossible de charger les données d\'accueil');
  }

  final latestNews = ((articlesResponse?.data ?? []) as List<Article>)
      .map(_mapArticleToNewsCard)
      .toList();

  final popularPlaces = ((placesResponse?.data ?? []) as List<Place>)
      .map(_mapPlaceToCard)
      .toList();

  return HomeData(
    latestNews: latestNews,
    popularPlaces: popularPlaces,
  );
});

NewsCardData _mapArticleToNewsCard(Article article) {
  return NewsCardData(
    id: article.id.toString(),
    title: article.title,
    category: article.categoryLabel,
    imageUrl: article.fullImageUrl ?? '',
    date: article.publishedAt ?? article.createdAt,
  );
}

PlaceCardData _mapPlaceToCard(Place place) {
  final locationParts = <String>[];
  if (place.city?.name.isNotEmpty == true) {
    locationParts.add(place.city!.name);
  }
  if (place.city?.country?.nameFr.isNotEmpty == true) {
    locationParts.add(place.city!.country!.nameFr);
  }
  final location = locationParts.isEmpty ? (place.address ?? '') : locationParts.join(', ');

  final imageUrl = place.imageUrls.isNotEmpty ? place.imageUrls.first : '';

  return PlaceCardData(
    id: place.id.toString(),
    title: place.title,
    category: place.category.label,
    location: location,
    imageUrl: imageUrl,
    rating: place.ratingAverage,
    categoryIcon: _categoryIcon(place.category),
  );
}

IconData _categoryIcon(PlaceCategory category) {
  switch (category) {
    case PlaceCategory.locationScooters:
      return Icons.electric_scooter;
    case PlaceCategory.espacesTravail:
      return Icons.work_outline;
    case PlaceCategory.centresSportifs:
      return Icons.fitness_center;
    case PlaceCategory.restaurants:
      return Icons.restaurant;
    case PlaceCategory.spaMassage:
      return Icons.spa;
  }
}
