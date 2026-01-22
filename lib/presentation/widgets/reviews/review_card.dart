import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place_review.dart';
import '../common/rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final PlaceReview review;
  final int index;

  const ReviewCard({
    super.key,
    required this.review,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.onBackground.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  review.user?.name.isNotEmpty == true
                      ? review.user!.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key: Key('review_user_name_$index'),
                      review.user?.name ?? 'Utilisateur anonyme',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      key: Key('review_date_$index'),
                      _formatRelativeTime(review.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onBackground.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              RatingStars(
                key: Key('review_rating_$index'),
                rating: review.rating.toDouble(),
                size: 14,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            key: Key('review_comment_$index'),
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onBackground.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return "A l'instant";
        }
        return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
      }
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years an${years > 1 ? 's' : ''}';
    }
  }
}
