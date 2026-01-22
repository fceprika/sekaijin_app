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
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article.categoryLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Summary
                  Text(
                    article.summary,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onBackground.withValues(alpha: 0.7),
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
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: article.author!.fullAvatarUrl != null
                              ? NetworkImage(article.author!.fullAvatarUrl!)
                              : null,
                          child: article.author!.fullAvatarUrl == null
                              ? Text(
                                  article.author!.displayName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            article.author!.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onBackground.withValues(alpha: 0.6),
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
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${article.readingTime} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onBackground.withValues(alpha: 0.6),
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
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.article,
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
