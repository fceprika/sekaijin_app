import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class PlaceCardData {
  final String id;
  final String title;
  final String category;
  final String location;
  final String imageUrl;
  final double rating;
  final IconData categoryIcon;

  const PlaceCardData({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.rating,
    this.categoryIcon = Icons.place,
  });
}

class PlaceCard extends StatelessWidget {
  final PlaceCardData data;
  final VoidCallback? onTap;

  const PlaceCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with category icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(gradient: AppGradients.hero),
                    child: Icon(
                      Icons.place,
                      size: 40,
                      color: scheme.primary,
                    ),
                  ),
                ),
                // Category icon badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.outline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      data.categoryIcon,
                      size: 16,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    data.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final starValue = index + 1;
                        if (data.rating >= starValue) {
                          return const Icon(Icons.star, size: 14, color: AppColors.rating);
                        } else if (data.rating >= starValue - 0.5) {
                          return const Icon(Icons.star_half, size: 14, color: AppColors.rating);
                        } else {
                          return Icon(Icons.star_border, size: 14, color: AppColors.rating.withValues(alpha: 0.4));
                        }
                      }),
                      const SizedBox(width: 4),
                      Text(
                        data.rating.toStringAsFixed(1),
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
