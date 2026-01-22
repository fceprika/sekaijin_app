import 'package:equatable/equatable.dart';

import 'user.dart';

class ReviewPlace {
  final int id;
  final String title;
  final String slug;
  final String? imageUrl;

  const ReviewPlace({
    required this.id,
    required this.title,
    required this.slug,
    this.imageUrl,
  });
}

class PlaceReview extends Equatable {
  final int id;
  final int placeId;
  final int userId;
  final String comment;
  final int rating;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final ReviewPlace? place;

  const PlaceReview({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.comment,
    required this.rating,
    this.isApproved = false,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.place,
  });

  @override
  List<Object?> get props => [id, placeId, userId];
}
