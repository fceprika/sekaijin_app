import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place_review.dart';

class CompactReviewCard extends StatelessWidget {
  final PlaceReview review;
  final VoidCallback? onTap;
  final int index;

  const CompactReviewCard({
    super.key,
    required this.review,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: Key('compact_review_card_$index'),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Place name and rating
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.place?.title ?? 'Lieu inconnu',
                      key: Key('compact_review_place_$index'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Star rating
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) {
                      return Icon(
                        i < review.rating ? Icons.star : Icons.star_border,
                        size: 16,
                        color: i < review.rating
                            ? AppColors.rating
                            : theme.colorScheme.outline,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Comment preview
              Text(
                review.comment,
                key: Key('compact_review_comment_$index'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
