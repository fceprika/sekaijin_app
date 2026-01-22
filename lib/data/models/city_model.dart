import '../../domain/entities/city.dart';
import '../../domain/entities/country.dart';
import 'country_model.dart';

class CityModel extends City {
  const CityModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.countryId,
    super.latitude,
    super.longitude,
    super.isMajor,
    super.order,
    super.description,
    super.country,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    Country? country;
    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country'] as Map<String, dynamic>);
    }

    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      countryId: json['country_id'] as int? ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isMajor: json['is_major'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
      description: json['description'] as String?,
      country: country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'country_id': countryId,
      'latitude': latitude,
      'longitude': longitude,
      'is_major': isMajor,
      'order': order,
      'description': description,
    };
  }
}
