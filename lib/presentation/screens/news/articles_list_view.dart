import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/article.dart';
import '../../providers/articles_provider.dart';
import '../../widgets/cards/article_list_card.dart';

class ArticlesListView extends ConsumerWidget {
  const ArticlesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesState = ref.watch(articlesListProvider);
    final selectedCategory = ref.watch(articleCategoryFilterProvider);

    return Scaffold(
      key: const Key('articles_list'),
      body: Column(
        children: [
          // Category filter chips
          _buildCategoryChips(context, ref, selectedCategory),
          // Articles list
          Expanded(
            child: _buildArticlesList(context, ref, articlesState),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(
    BuildContext context,
    WidgetRef ref,
    String? selectedCategory,
  ) {
    final categories = [
      (null, 'Tous'),
      ('temoignage', 'Témoignage'),
      ('guide-pratique', 'Guide pratique'),
      ('travail', 'Travail'),
      ('lifestyle', 'Lifestyle'),
      ('cuisine', 'Cuisine'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((category) {
            final isSelected = selectedCategory == category.$1;
            final chipKey = category.$1 == null
                ? 'category_tous'
                : 'category_${category.$1}';

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                key: Key(chipKey),
                label: Text(category.$2),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(articleCategoryFilterProvider.notifier).state =
                      category.$1;
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.onBackground,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildArticlesList(
    BuildContext context,
    WidgetRef ref,
    ArticlesState state,
  ) {
    if (state.isLoading && state.articles.isEmpty) {
      return _buildLoadingShimmer();
    }

    if (state.error != null && state.articles.isEmpty) {
      return _buildErrorState(context, ref, state.error!);
    }

    if (state.articles.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(articlesListProvider.notifier).refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              ref.read(articlesListProvider.notifier).loadMore();
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.articles.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.articles.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final article = state.articles[index];
            return ArticleListCard(
              key: Key('article_card_$index'),
              article: article,
              onTap: () => _navigateToDetail(context, article),
            );
          },
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Article article) {
    context.push('/articles/${article.slug}');
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category placeholder
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title placeholder
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Summary placeholder
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 250,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: AppColors.onBackground.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun article',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onBackground.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Il n\'y a pas encore d\'articles dans cette catégorie',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onBackground.withValues(alpha: 0.4),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
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
              'Erreur de chargement',
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(articlesListProvider.notifier).refresh(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
