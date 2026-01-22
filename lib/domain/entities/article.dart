import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import 'country.dart';
import 'user.dart';

enum ArticleCategory {
  temoignage('temoignage', 'Témoignage'),
  guidePratique('guide-pratique', 'Guide pratique'),
  travail('travail', 'Travail'),
  lifestyle('lifestyle', 'Lifestyle'),
  cuisine('cuisine', 'Cuisine');

  const ArticleCategory(this.slug, this.label);

  final String slug;
  final String label;

  static ArticleCategory fromString(String value) {
    return ArticleCategory.values.firstWhere(
      (category) => category.slug == value,
      orElse: () => ArticleCategory.temoignage,
    );
  }
}

class Article extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String category;
  final String? imageUrl;
  final int countryId;
  final int authorId;
  final String status;
  final bool isFeatured;
  final DateTime? publishedAt;
  final int likes;
  final int? readingTime;
  final DateTime createdAt;
  final Country? country;
  final User? author;

  const Article({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.countryId,
    required this.authorId,
    required this.status,
    this.isFeatured = false,
    this.publishedAt,
    this.likes = 0,
    this.readingTime,
    required this.createdAt,
    this.country,
    this.author,
  });

  String get categoryLabel {
    switch (category) {
      case 'temoignage':
        return 'Témoignage';
      case 'guide-pratique':
        return 'Guide pratique';
      case 'travail':
        return 'Travail';
      case 'lifestyle':
        return 'Lifestyle';
      case 'cuisine':
        return 'Cuisine';
      default:
        return category;
    }
  }

  String? get fullImageUrl {
    if (imageUrl == null) return null;
    if (imageUrl!.startsWith('http')) return imageUrl;
    final baseUrl = AppConfig.baseUrl.replaceAll('/api', '');
    return '$baseUrl/storage/$imageUrl';
  }

  @override
  List<Object?> get props => [id, slug];
}
