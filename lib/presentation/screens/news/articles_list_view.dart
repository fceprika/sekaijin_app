import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/article.dart';
import '../../providers/articles_provider.dart';
import '../../widgets/cards/article_list_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/common/loading_shimmer.dart';

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
    if (state.isLoading && state.items.isEmpty) {
      return _buildLoadingShimmer();
    }

    if (state.error != null && state.items.isEmpty) {
      return _buildErrorState(context, ref, state.error!);
    }

    if (state.items.isEmpty) {
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
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final article = state.items[index];
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
      itemBuilder: (context, index) => const ArticleCardShimmer(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState.noArticles();
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return ErrorState(
      message: error,
      onRetry: () => ref.read(articlesListProvider.notifier).refresh(),
    );
  }
}
