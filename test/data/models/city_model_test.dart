import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/data/models/city_model.dart';

void main() {
  group('CityModel', () {
    test('fromJson creates valid CityModel with all fields', () {
      final json = {
        'id': 1,
        'name': 'Bangkok',
        'slug': 'bangkok',
        'country_id': 1,
        'latitude': 13.7563,
        'longitude': 100.5018,
        'is_major': true,
        'order': 1,
        'description': 'Capital city of Thailand',
      };

      final city = CityModel.fromJson(json);

      expect(city.id, 1);
      expect(city.name, 'Bangkok');
      expect(city.slug, 'bangkok');
      expect(city.countryId, 1);
      expect(city.latitude, 13.7563);
      expect(city.longitude, 100.5018);
      expect(city.isMajor, true);
      expect(city.order, 1);
      expect(city.description, 'Capital city of Thailand');
    });

    test('fromJson handles nested country object', () {
      final json = {
        'id': 1,
        'name': 'Bangkok',
        'slug': 'bangkok',
        'country_id': 1,
        'country': {
          'id': 1,
          'name_fr': 'Thaïlande',
          'slug': 'thailande',
          'emoji': '🇹🇭',
          'description': 'Kingdom of Thailand',
        },
      };

      final city = CityModel.fromJson(json);

      expect(city.country, isNotNull);
      expect(city.country!.id, 1);
      expect(city.country!.nameFr, 'Thaïlande');
      expect(city.country!.slug, 'thailande');
      expect(city.country!.emoji, '🇹🇭');
      expect(city.country!.description, 'Kingdom of Thailand');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 2,
        'name': 'Chiang Mai',
        'slug': 'chiang-mai',
        'country_id': 1,
      };

      final city = CityModel.fromJson(json);

      expect(city.id, 2);
      expect(city.name, 'Chiang Mai');
      expect(city.latitude, isNull);
      expect(city.longitude, isNull);
      expect(city.isMajor, false);
      expect(city.order, 0);
      expect(city.description, isNull);
      expect(city.country, isNull);
    });

    test('fromJson handles null country_id', () {
      final json = {
        'id': 1,
        'name': 'Test City',
        'slug': 'test-city',
      };

      final city = CityModel.fromJson(json);

      expect(city.countryId, 0);
    });

    test('toJson produces valid JSON', () {
      final json = {
        'id': 1,
        'name': 'Bangkok',
        'slug': 'bangkok',
        'country_id': 1,
        'latitude': 13.7563,
        'longitude': 100.5018,
        'is_major': true,
        'order': 1,
        'description': 'Capital of Thailand',
      };

      final city = CityModel.fromJson(json);
      final outputJson = city.toJson();

      expect(outputJson['id'], 1);
      expect(outputJson['name'], 'Bangkok');
      expect(outputJson['slug'], 'bangkok');
      expect(outputJson['country_id'], 1);
      expect(outputJson['latitude'], 13.7563);
      expect(outputJson['longitude'], 100.5018);
      expect(outputJson['is_major'], true);
      expect(outputJson['order'], 1);
      expect(outputJson['description'], 'Capital of Thailand');
    });

    test('CityModel equality works correctly', () {
      final city1 = CityModel.fromJson(const {
        'id': 1,
        'name': 'Bangkok',
        'slug': 'bangkok',
        'country_id': 1,
      });

      final city2 = CityModel.fromJson(const {
        'id': 1,
        'name': 'Bangkok Updated',
        'slug': 'bangkok',
        'country_id': 1,
      });

      final city3 = CityModel.fromJson(const {
        'id': 2,
        'name': 'Bangkok',
        'slug': 'bangkok-2',
        'country_id': 1,
      });

      // Same id and slug should be equal
      expect(city1, equals(city2));

      // Different id or slug should not be equal
      expect(city1, isNot(equals(city3)));
    });
  });
}
