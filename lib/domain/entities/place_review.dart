import 'package:equatable/equatable.dart';

import 'user.dart';

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
  });

  @override
  List<Object?> get props => [id, placeId, userId];
}
