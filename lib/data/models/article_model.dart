import '../../domain/entities/article.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/user.dart';
import 'country_model.dart';
import 'user_model.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.summary,
    required super.content,
    required super.category,
    super.imageUrl,
    required super.countryId,
    required super.authorId,
    required super.status,
    super.isFeatured,
    super.publishedAt,
    super.likes,
    super.readingTime,
    required super.createdAt,
    super.country,
    super.author,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    Country? country;
    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country'] as Map<String, dynamic>);
    }

    User? author;
    if (json['author'] != null) {
      author = UserModel.fromJson(json['author'] as Map<String, dynamic>);
    } else if (json['user'] != null) {
      author = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }

    return ArticleModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? 'temoignage',
      imageUrl: json['image_url'] as String?,
      countryId: json['country_id'] as int? ?? 0,
      authorId: json['author_id'] as int? ?? json['user_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'draft',
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      publishedAt: _parseDateTime(json['published_at']),
      likes: json['likes'] as int? ?? 0,
      readingTime: json['reading_time'] as int?,
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      country: country,
      author: author,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      'country_id': countryId,
      'author_id': authorId,
      'status': status,
      'is_featured': isFeatured,
      'published_at': publishedAt?.toIso8601String(),
      'likes': likes,
      'reading_time': readingTime,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
