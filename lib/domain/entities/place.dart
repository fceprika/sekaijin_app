import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import 'city.dart';
import 'place_review.dart';
import 'user.dart';

enum PlaceCategory {
  locationScooters('location-scooters', 'Location de scooters', '🛵'),
  espacesTravail('espaces-travail', 'Espaces de travail', '💼'),
  centresSportifs('centres-sportifs', 'Centres sportifs', '🏋️'),
  restaurants('restaurants', 'Restaurants', '🍜'),
  spaMassage('spa-massage', 'Spa & Massage', '💆');

  const PlaceCategory(this.slug, this.label, this.emoji);

  final String slug;
  final String label;
  final String emoji;

  static PlaceCategory fromString(String value) {
    return PlaceCategory.values.firstWhere(
      (category) => category.slug == value,
      orElse: () => PlaceCategory.restaurants,
    );
  }
}

enum PlaceStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const PlaceStatus(this.value);

  final String value;

  static PlaceStatus fromString(String value) {
    return PlaceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PlaceStatus.pending,
    );
  }
}

class Place extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String description;
  final String? seoContent;
  final int userId;
  final int cityId;
  final PlaceCategory category;
  final String googleMapsUrl;
  final String? googlePlaceId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String? imageUrl2;
  final String? imageUrl3;
  final String? menuUrl;
  final String? websiteUrl;
  final String? youtubeUrl;
  final int? wifiSpeed;
  final double ratingAverage;
  final int reviewsCount;
  final PlaceStatus status;
  final String? rejectionReason;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final City? city;
  final List<PlaceReview>? reviews;

  const Place({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    this.seoContent,
    required this.userId,
    required this.cityId,
    required this.category,
    required this.googleMapsUrl,
    this.googlePlaceId,
    this.address,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.imageUrl2,
    this.imageUrl3,
    this.menuUrl,
    this.websiteUrl,
    this.youtubeUrl,
    this.wifiSpeed,
    this.ratingAverage = 0.0,
    this.reviewsCount = 0,
    this.status = PlaceStatus.pending,
    this.rejectionReason,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.city,
    this.reviews,
  });

  List<String> get imageUrls {
    final baseUrl = AppConfig.baseUrl.replaceAll('/api', '');
    final urls = <String>[];

    String buildUrl(String? path) {
      if (path == null) return '';
      if (path.startsWith('http')) return path;
      return '$baseUrl/storage/$path';
    }

    if (imageUrl != null) urls.add(buildUrl(imageUrl));
    if (imageUrl2 != null) urls.add(buildUrl(imageUrl2));
    if (imageUrl3 != null) urls.add(buildUrl(imageUrl3));

    return urls;
  }

  @override
  List<Object?> get props => [id, slug];
}
