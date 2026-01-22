import '../../domain/entities/city.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_review.dart';
import '../../domain/entities/user.dart';
import 'city_model.dart';
import 'place_review_model.dart';
import 'user_model.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    super.seoContent,
    required super.userId,
    required super.cityId,
    required super.category,
    required super.googleMapsUrl,
    super.googlePlaceId,
    super.address,
    super.latitude,
    super.longitude,
    super.imageUrl,
    super.imageUrl2,
    super.imageUrl3,
    super.menuUrl,
    super.websiteUrl,
    super.youtubeUrl,
    super.wifiSpeed,
    super.ratingAverage,
    super.reviewsCount,
    super.status,
    super.rejectionReason,
    super.isFeatured,
    required super.createdAt,
    required super.updatedAt,
    super.user,
    super.city,
    super.reviews,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    User? user;
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }

    City? city;
    if (json['city'] != null) {
      city = CityModel.fromJson(json['city'] as Map<String, dynamic>);
    }

    List<PlaceReview>? reviews;
    if (json['reviews'] != null) {
      reviews = (json['reviews'] as List)
          .map((r) => PlaceReviewModel.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    final categoryString = json['category'] as String? ?? 'restaurants';
    final statusString = json['status'] as String? ?? 'pending';

    return PlaceModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      seoContent: json['seo_content'] as String?,
      userId: json['user_id'] as int? ?? 0,
      cityId: json['city_id'] as int? ?? 0,
      category: PlaceCategory.fromString(categoryString),
      googleMapsUrl: json['google_maps_url'] as String? ?? '',
      googlePlaceId: json['google_place_id'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
      imageUrl2: json['image_url_2'] as String?,
      imageUrl3: json['image_url_3'] as String?,
      menuUrl: json['menu_url'] as String?,
      websiteUrl: json['website_url'] as String?,
      youtubeUrl: json['youtube_url'] as String?,
      wifiSpeed: json['wifi_speed'] as int?,
      ratingAverage: (json['rating_average'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      status: PlaceStatus.fromString(statusString),
      rejectionReason: json['rejection_reason'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      user: user,
      city: city,
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'seo_content': seoContent,
      'user_id': userId,
      'city_id': cityId,
      'category': category.slug,
      'google_maps_url': googleMapsUrl,
      'google_place_id': googlePlaceId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
      'image_url_2': imageUrl2,
      'image_url_3': imageUrl3,
      'menu_url': menuUrl,
      'website_url': websiteUrl,
      'youtube_url': youtubeUrl,
      'wifi_speed': wifiSpeed,
      'rating_average': ratingAverage,
      'reviews_count': reviewsCount,
      'status': status.value,
      'rejection_reason': rejectionReason,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
