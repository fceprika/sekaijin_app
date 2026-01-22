import '../../domain/entities/place_review.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

class PlaceReviewModel extends PlaceReview {
  const PlaceReviewModel({
    required super.id,
    required super.placeId,
    required super.userId,
    required super.comment,
    required super.rating,
    super.isApproved,
    required super.createdAt,
    required super.updatedAt,
    super.user,
  });

  factory PlaceReviewModel.fromJson(Map<String, dynamic> json) {
    User? user;
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }

    return PlaceReviewModel(
      id: json['id'] as int,
      placeId: json['place_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'user_id': userId,
      'comment': comment,
      'rating': rating,
      'is_approved': isApproved,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
