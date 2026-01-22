import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/data/models/place_model.dart';
import 'package:sekaijin_app/domain/entities/place.dart';

void main() {
  group('PlaceModel', () {
    test('fromJson creates valid PlaceModel with all fields', () {
      final json = {
        'id': 1,
        'title': 'Test Place',
        'slug': 'test-place',
        'description': 'A test place description',
        'seo_content': 'SEO content here',
        'user_id': 10,
        'city_id': 5,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com/test',
        'google_place_id': 'ChIJ123456',
        'address': '123 Test Street',
        'latitude': 13.7563,
        'longitude': 100.5018,
        'image_url': 'places/image1.jpg',
        'image_url_2': 'places/image2.jpg',
        'image_url_3': 'places/image3.jpg',
        'menu_url': 'https://example.com/menu',
        'website_url': 'https://example.com',
        'youtube_url': 'https://youtube.com/watch?v=123',
        'wifi_speed': 50,
        'rating_average': 4.5,
        'reviews_count': 25,
        'status': 'approved',
        'rejection_reason': null,
        'is_featured': true,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-20T14:00:00.000Z',
      };

      final place = PlaceModel.fromJson(json);

      expect(place.id, 1);
      expect(place.title, 'Test Place');
      expect(place.slug, 'test-place');
      expect(place.description, 'A test place description');
      expect(place.seoContent, 'SEO content here');
      expect(place.userId, 10);
      expect(place.cityId, 5);
      expect(place.category, PlaceCategory.restaurants);
      expect(place.googleMapsUrl, 'https://maps.google.com/test');
      expect(place.googlePlaceId, 'ChIJ123456');
      expect(place.address, '123 Test Street');
      expect(place.latitude, 13.7563);
      expect(place.longitude, 100.5018);
      expect(place.imageUrl, 'places/image1.jpg');
      expect(place.imageUrl2, 'places/image2.jpg');
      expect(place.imageUrl3, 'places/image3.jpg');
      expect(place.menuUrl, 'https://example.com/menu');
      expect(place.websiteUrl, 'https://example.com');
      expect(place.youtubeUrl, 'https://youtube.com/watch?v=123');
      expect(place.wifiSpeed, 50);
      expect(place.ratingAverage, 4.5);
      expect(place.reviewsCount, 25);
      expect(place.status, PlaceStatus.approved);
      expect(place.rejectionReason, isNull);
      expect(place.isFeatured, true);
    });

    test('category enum conversion works for all categories', () {
      final categories = [
        ('location-scooters', PlaceCategory.locationScooters),
        ('espaces-travail', PlaceCategory.espacesTravail),
        ('centres-sportifs', PlaceCategory.centresSportifs),
        ('restaurants', PlaceCategory.restaurants),
        ('spa-massage', PlaceCategory.spaMassage),
      ];

      for (final (slug, expected) in categories) {
        final json = _createMinimalJson(category: slug);
        final place = PlaceModel.fromJson(json);
        expect(place.category, expected);
      }
    });

    test('category enum defaults to restaurants for unknown value', () {
      final json = _createMinimalJson(category: 'unknown-category');
      final place = PlaceModel.fromJson(json);
      expect(place.category, PlaceCategory.restaurants);
    });

    test('status enum conversion works for all statuses', () {
      final statuses = [
        ('pending', PlaceStatus.pending),
        ('approved', PlaceStatus.approved),
        ('rejected', PlaceStatus.rejected),
      ];

      for (final (value, expected) in statuses) {
        final json = _createMinimalJson(status: value);
        final place = PlaceModel.fromJson(json);
        expect(place.status, expected);
      }
    });

    test('status enum defaults to pending for unknown value', () {
      final json = _createMinimalJson(status: 'unknown-status');
      final place = PlaceModel.fromJson(json);
      expect(place.status, PlaceStatus.pending);
    });

    test('imageUrls getter returns correct URLs for relative paths', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'slug': 'test',
        'description': 'Test',
        'user_id': 1,
        'city_id': 1,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com',
        'image_url': 'places/image1.jpg',
        'image_url_2': 'places/image2.jpg',
        'image_url_3': 'places/image3.jpg',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final place = PlaceModel.fromJson(json);
      final urls = place.imageUrls;

      expect(urls.length, 3);
      expect(urls[0], contains('/storage/places/image1.jpg'));
      expect(urls[1], contains('/storage/places/image2.jpg'));
      expect(urls[2], contains('/storage/places/image3.jpg'));
    });

    test('imageUrls getter returns URLs unchanged for http paths', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'slug': 'test',
        'description': 'Test',
        'user_id': 1,
        'city_id': 1,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com',
        'image_url': 'https://example.com/image1.jpg',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final place = PlaceModel.fromJson(json);
      final urls = place.imageUrls;

      expect(urls.length, 1);
      expect(urls[0], 'https://example.com/image1.jpg');
    });

    test('imageUrls getter returns empty list when no images', () {
      final json = _createMinimalJson();
      final place = PlaceModel.fromJson(json);

      expect(place.imageUrls, isEmpty);
    });

    test('handles missing optional fields', () {
      final json = {
        'id': 1,
        'title': 'Minimal Place',
        'slug': 'minimal-place',
        'description': 'Description',
        'user_id': 1,
        'city_id': 1,
        'google_maps_url': 'https://maps.google.com',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final place = PlaceModel.fromJson(json);

      expect(place.id, 1);
      expect(place.title, 'Minimal Place');
      expect(place.category, PlaceCategory.restaurants);
      expect(place.status, PlaceStatus.pending);
      expect(place.seoContent, isNull);
      expect(place.googlePlaceId, isNull);
      expect(place.address, isNull);
      expect(place.latitude, isNull);
      expect(place.longitude, isNull);
      expect(place.imageUrl, isNull);
      expect(place.imageUrl2, isNull);
      expect(place.imageUrl3, isNull);
      expect(place.menuUrl, isNull);
      expect(place.websiteUrl, isNull);
      expect(place.youtubeUrl, isNull);
      expect(place.wifiSpeed, isNull);
      expect(place.ratingAverage, 0.0);
      expect(place.reviewsCount, 0);
      expect(place.isFeatured, false);
      expect(place.user, isNull);
      expect(place.city, isNull);
      expect(place.reviews, isNull);
    });

    test('handles nested user object', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'slug': 'test',
        'description': 'Test',
        'user_id': 10,
        'city_id': 1,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
        'user': {
          'id': 10,
          'name': 'Test User',
          'name_slug': 'test-user',
          'email': 'test@test.com',
          'created_at': '2024-01-01T00:00:00.000Z',
        },
      };

      final place = PlaceModel.fromJson(json);

      expect(place.user, isNotNull);
      expect(place.user!.id, 10);
      expect(place.user!.name, 'Test User');
    });

    test('handles nested city object', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'slug': 'test',
        'description': 'Test',
        'user_id': 1,
        'city_id': 5,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
        'city': {
          'id': 5,
          'name': 'Bangkok',
          'slug': 'bangkok',
          'country_id': 1,
        },
      };

      final place = PlaceModel.fromJson(json);

      expect(place.city, isNotNull);
      expect(place.city!.id, 5);
      expect(place.city!.name, 'Bangkok');
    });

    test('handles nested reviews list', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'slug': 'test',
        'description': 'Test',
        'user_id': 1,
        'city_id': 1,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
        'reviews': [
          {
            'id': 1,
            'place_id': 1,
            'user_id': 2,
            'comment': 'Great place!',
            'rating': 5,
            'is_approved': true,
            'created_at': '2024-01-15T00:00:00.000Z',
            'updated_at': '2024-01-15T00:00:00.000Z',
          },
        ],
      };

      final place = PlaceModel.fromJson(json);

      expect(place.reviews, isNotNull);
      expect(place.reviews!.length, 1);
      expect(place.reviews![0].comment, 'Great place!');
      expect(place.reviews![0].rating, 5);
    });

    test('toJson produces valid JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Place',
        'slug': 'test-place',
        'description': 'Description',
        'user_id': 1,
        'city_id': 1,
        'category': 'restaurants',
        'google_maps_url': 'https://maps.google.com',
        'rating_average': 4.5,
        'reviews_count': 10,
        'status': 'approved',
        'is_featured': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final place = PlaceModel.fromJson(json);
      final outputJson = place.toJson();

      expect(outputJson['id'], 1);
      expect(outputJson['title'], 'Test Place');
      expect(outputJson['category'], 'restaurants');
      expect(outputJson['status'], 'approved');
      expect(outputJson['rating_average'], 4.5);
      expect(outputJson['is_featured'], true);
    });
  });

  group('PlaceCategory', () {
    test('has correct properties for each value', () {
      expect(PlaceCategory.locationScooters.slug, 'location-scooters');
      expect(PlaceCategory.locationScooters.label, 'Location de scooters');
      expect(PlaceCategory.locationScooters.emoji, '🛵');

      expect(PlaceCategory.espacesTravail.slug, 'espaces-travail');
      expect(PlaceCategory.espacesTravail.label, 'Espaces de travail');
      expect(PlaceCategory.espacesTravail.emoji, '💼');

      expect(PlaceCategory.centresSportifs.slug, 'centres-sportifs');
      expect(PlaceCategory.centresSportifs.label, 'Centres sportifs');
      expect(PlaceCategory.centresSportifs.emoji, '🏋️');

      expect(PlaceCategory.restaurants.slug, 'restaurants');
      expect(PlaceCategory.restaurants.label, 'Restaurants');
      expect(PlaceCategory.restaurants.emoji, '🍜');

      expect(PlaceCategory.spaMassage.slug, 'spa-massage');
      expect(PlaceCategory.spaMassage.label, 'Spa & Massage');
      expect(PlaceCategory.spaMassage.emoji, '💆');
    });
  });
}

Map<String, dynamic> _createMinimalJson({
  String? category,
  String? status,
}) {
  return {
    'id': 1,
    'title': 'Test',
    'slug': 'test',
    'description': 'Test',
    'user_id': 1,
    'city_id': 1,
    'category': category ?? 'restaurants',
    'google_maps_url': 'https://maps.google.com',
    'status': status ?? 'pending',
    'created_at': '2024-01-01T00:00:00.000Z',
    'updated_at': '2024-01-01T00:00:00.000Z',
  };
}
