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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.place,
                      size: 40,
                      color: AppColors.primary,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      data.categoryIcon,
                      size: 16,
                      color: AppColors.primary,
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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
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
                        color: AppColors.onBackground.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onBackground.withValues(alpha: 0.6),
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
                          return const Icon(Icons.star, size: 14, color: Colors.amber);
                        } else if (data.rating >= starValue - 0.5) {
                          return const Icon(Icons.star_half, size: 14, color: Colors.amber);
                        } else {
                          return Icon(Icons.star_border, size: 14, color: Colors.amber.shade200);
                        }
                      }),
                      const SizedBox(width: 4),
                      Text(
                        data.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
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
