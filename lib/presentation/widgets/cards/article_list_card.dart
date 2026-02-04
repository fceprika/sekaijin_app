import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/article.dart';

class ArticleListCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const ArticleListCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: article.fullImageUrl != null
                    ? Image.network(
                        article.fullImageUrl!,
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
                  // Category badge + Country flag
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          article.categoryLabel,
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      if (article.country != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          article.country!.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    article.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Summary
                  Text(
                    article.summary,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Author and reading time
                  Row(
                    children: [
                      // Author
                      if (article.author != null) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: scheme.primary.withValues(alpha: 0.12),
                          backgroundImage: article.author!.fullAvatarUrl != null
                              ? NetworkImage(article.author!.fullAvatarUrl!)
                              : null,
                          child: article.author!.fullAvatarUrl == null
                              ? Text(
                                  article.author!.displayName[0].toUpperCase(),
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: scheme.primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            article.author!.displayName,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      // Reading time
                      if (article.readingTime != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.readingTime} min',
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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
      decoration: const BoxDecoration(gradient: AppGradients.hero),
      child: const Center(
        child: Icon(
          Icons.article,
          size: 48,
          color: AppColors.tertiary,
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
