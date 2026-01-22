import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../../../core/config/theme.dart';
import '../../providers/articles_provider.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final String slug;

  const ArticleDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(slug));

    return Scaffold(
      key: const Key('article_detail_screen'),
      body: articleAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(context, error.toString()),
        data: (article) {
          if (article == null) {
            return _buildErrorState(context, 'Article non trouvé');
          }

          return CustomScrollView(
            slivers: [
              // Hero image with app bar
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: article.fullImageUrl != null
                      ? Image.network(
                          article.fullImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        )
                      : _buildImagePlaceholder(),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge + Country flag
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              article.categoryLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          if (article.country != null) ...[
                            const SizedBox(width: 12),
                            Text(
                              article.country!.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              article.country!.nameFr,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.onBackground.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        article.title,
                        key: const Key('article_title'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Author info
                      if (article.author != null)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              backgroundImage: article.author!.fullAvatarUrl != null
                                  ? NetworkImage(article.author!.fullAvatarUrl!)
                                  : null,
                              child: article.author!.fullAvatarUrl == null
                                  ? Text(
                                      article.author!.displayName[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.author!.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onBackground,
                                  ),
                                ),
                                if (article.publishedAt != null)
                                  Text(
                                    'Publié le ${DateFormat('d MMMM yyyy', 'fr_FR').format(article.publishedAt!)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.onBackground.withValues(alpha: 0.6),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Reading time
                      if (article.readingTime != null)
                        Container(
                          key: const Key('reading_time'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.onBackground.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: AppColors.onBackground.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${article.readingTime} min de lecture',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.onBackground.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Content
                      Html(
                        key: const Key('article_content'),
                        data: article.content,
                        style: {
                          'body': Style(
                            fontSize: FontSize(16),
                            lineHeight: const LineHeight(1.6),
                            color: AppColors.onBackground,
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          'p': Style(
                            margin: Margins.only(bottom: 16),
                          ),
                          'h1': Style(
                            fontSize: FontSize(24),
                            fontWeight: FontWeight.bold,
                            margin: Margins.only(top: 24, bottom: 12),
                          ),
                          'h2': Style(
                            fontSize: FontSize(20),
                            fontWeight: FontWeight.bold,
                            margin: Margins.only(top: 20, bottom: 10),
                          ),
                          'h3': Style(
                            fontSize: FontSize(18),
                            fontWeight: FontWeight.bold,
                            margin: Margins.only(top: 16, bottom: 8),
                          ),
                          'ul': Style(
                            margin: Margins.only(bottom: 16),
                          ),
                          'ol': Style(
                            margin: Margins.only(bottom: 16),
                          ),
                          'li': Style(
                            margin: Margins.only(bottom: 4),
                          ),
                          'a': Style(
                            color: AppColors.primary,
                            textDecoration: TextDecoration.underline,
                          ),
                          'blockquote': Style(
                            padding: HtmlPaddings.only(left: 16),
                            border: const Border(
                              left: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                            ),
                            fontStyle: FontStyle.italic,
                            color: AppColors.onBackground.withValues(alpha: 0.8),
                          ),
                          'img': Style(
                            margin: Margins.symmetric(vertical: 16),
                          ),
                        },
                      ),
                      const SizedBox(height: 24),

                      // Likes count
                      if (article.likes > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.error.withValues(alpha: 0.8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${article.likes} j\'aime',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.onBackground.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onBackground,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackground.withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.article,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
