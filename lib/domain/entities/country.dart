import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final int id;
  final String nameFr;
  final String slug;
  final String emoji;
  final String? description;

  const Country({
    required this.id,
    required this.nameFr,
    required this.slug,
    required this.emoji,
    this.description,
  });

  @override
  List<Object?> get props => [id, slug];
}
