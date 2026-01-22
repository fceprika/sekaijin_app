import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.id,
    required super.nameFr,
    required super.slug,
    required super.emoji,
    super.description,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      nameFr: json['name_fr'] as String? ?? json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_fr': nameFr,
      'slug': slug,
      'emoji': emoji,
      'description': description,
    };
  }
}
