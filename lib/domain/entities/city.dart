import 'package:equatable/equatable.dart';

import 'country.dart';

class City extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int countryId;
  final double? latitude;
  final double? longitude;
  final bool isMajor;
  final int order;
  final String? description;
  final Country? country;

  const City({
    required this.id,
    required this.name,
    required this.slug,
    required this.countryId,
    this.latitude,
    this.longitude,
    this.isMajor = false,
    this.order = 0,
    this.description,
    this.country,
  });

  @override
  List<Object?> get props => [id, slug];
}
