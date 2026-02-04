import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place_review.dart';
import '../common/rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final PlaceReview review;
  final int index;
  final bool showUser;

  const ReviewCard({
    super.key,
    required this.review,
    required this.index,
    this.showUser = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              if (showUser) ...[
                CircleAvatar(
                  radius: 20,
                  backgroundColor: scheme.primary.withValues(alpha: 0.12),
                  child: Text(
                    review.user?.name.isNotEmpty == true
                        ? review.user!.name[0].toUpperCase()
                        : '?',
                    style: textTheme.labelLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showUser)
                      Text(
                        key: Key('review_user_name_$index'),
                        review.user?.name ?? 'Utilisateur anonyme',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                    if (showUser) const SizedBox(height: 2),
                    Text(
                      key: Key('review_date_$index'),
                      _formatRelativeTime(review.createdAt),
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
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
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
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
