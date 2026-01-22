import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place.dart';

class PlaceListCard extends StatelessWidget {
  final Place place;
  final VoidCallback? onTap;

  const PlaceListCard({
    super.key,
    required this.place,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: place.imageUrls.isNotEmpty
                    ? Image.network(
                        place.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildLoadingImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${place.category.emoji} ${place.category.label}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    place.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Location
                  if (place.city != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.city!.name,
                            style: TextStyle(
                              fontSize: 14,
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
                        if (place.ratingAverage >= starValue) {
                          return const Icon(Icons.star, size: 16, color: Colors.amber);
                        } else if (place.ratingAverage >= starValue - 0.5) {
                          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
                        } else {
                          return Icon(Icons.star_border, size: 16, color: Colors.amber.shade200);
                        }
                      }),
                      const SizedBox(width: 8),
                      Text(
                        place.ratingAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${place.reviewsCount} avis)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onBackground.withValues(alpha: 0.6),
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

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.place,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
