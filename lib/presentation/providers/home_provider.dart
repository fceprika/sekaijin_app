import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/cards/news_card.dart';
import '../widgets/cards/place_card.dart';

class HomeData {
  final List<NewsCardData> latestNews;
  final List<PlaceCardData> popularPlaces;

  const HomeData({
    required this.latestNews,
    required this.popularPlaces,
  });
}

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 800));

  // Mock data for development
  final latestNews = [
    NewsCardData(
      id: '1',
      title: 'Les meilleurs temples à visiter à Kyoto cette saison',
      category: 'Culture',
      imageUrl: 'https://example.com/kyoto.jpg',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NewsCardData(
      id: '2',
      title: 'Guide complet de la street food à Bangkok',
      category: 'Gastronomie',
      imageUrl: 'https://example.com/bangkok.jpg',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NewsCardData(
      id: '3',
      title: 'Découverte des rizières en terrasses du Vietnam',
      category: 'Nature',
      imageUrl: 'https://example.com/vietnam.jpg',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NewsCardData(
      id: '4',
      title: 'Festival des lanternes: dates et lieux 2024',
      category: 'Événement',
      imageUrl: 'https://example.com/lantern.jpg',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NewsCardData(
      id: '5',
      title: 'Les secrets de la Grande Muraille de Chine',
      category: 'Histoire',
      imageUrl: 'https://example.com/wall.jpg',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final popularPlaces = [
    const PlaceCardData(
      id: '1',
      title: 'Temple Sensoji',
      category: 'Temple',
      location: 'Tokyo, Japon',
      imageUrl: 'https://example.com/sensoji.jpg',
      rating: 4.8,
      categoryIcon: Icons.temple_buddhist,
    ),
    const PlaceCardData(
      id: '2',
      title: 'Marché flottant',
      category: 'Marché',
      location: 'Bangkok, Thaïlande',
      imageUrl: 'https://example.com/market.jpg',
      rating: 4.5,
      categoryIcon: Icons.store,
    ),
    const PlaceCardData(
      id: '3',
      title: 'Baie d\'Ha Long',
      category: 'Nature',
      location: 'Quang Ninh, Vietnam',
      imageUrl: 'https://example.com/halong.jpg',
      rating: 4.9,
      categoryIcon: Icons.landscape,
    ),
    const PlaceCardData(
      id: '4',
      title: 'Cité Interdite',
      category: 'Monument',
      location: 'Pékin, Chine',
      imageUrl: 'https://example.com/forbidden.jpg',
      rating: 4.7,
      categoryIcon: Icons.account_balance,
    ),
  ];

  return HomeData(
    latestNews: latestNews,
    popularPlaces: popularPlaces,
  );
});
