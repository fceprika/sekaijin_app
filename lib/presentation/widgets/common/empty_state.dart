import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      key: const Key('empty_state'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.secondary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              key: const Key('empty_state_title'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              key: const Key('empty_state_message'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackground.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('empty_state_action'),
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Predefined empty states for places
  static Widget noPlaces() {
    return const EmptyState(
      key: Key('empty_places_state'),
      icon: Icons.place_outlined,
      title: 'Aucun lieu',
      message: 'Aucun lieu ne correspond à vos filtres.',
    );
  }

  // Predefined empty states for news
  static Widget noNews() {
    return const EmptyState(
      key: Key('empty_news_state'),
      icon: Icons.newspaper_outlined,
      title: 'Aucune actualité',
      message: 'Aucune actualité pour le moment.',
    );
  }

  // Predefined empty states for articles
  static Widget noArticles() {
    return const EmptyState(
      key: Key('empty_articles_state'),
      icon: Icons.article_outlined,
      title: 'Aucun article',
      message: 'Aucun article disponible pour le moment.',
    );
  }

  // Predefined empty states for events
  static Widget noEvents() {
    return const EmptyState(
      key: Key('empty_events_state'),
      icon: Icons.event_outlined,
      title: 'Aucun événement',
      message: 'Aucun événement à venir pour le moment.',
    );
  }

  // Predefined empty states for reviews
  static Widget noReviews() {
    return const EmptyState(
      key: Key('empty_reviews_state'),
      icon: Icons.star_outline,
      title: 'Aucun avis',
      message: 'Soyez le premier à donner votre avis !',
    );
  }

  // Predefined empty states for my places
  static Widget myPlacesEmpty({VoidCallback? onAddPlace}) {
    return EmptyState(
      key: const Key('empty_my_places_state'),
      icon: Icons.add_location_outlined,
      title: 'Aucun lieu ajouté',
      message: 'Vous n\'avez pas encore ajouté de lieu.',
      actionText: onAddPlace != null ? 'Ajouter un lieu' : null,
      onAction: onAddPlace,
    );
  }

  // Predefined empty states for my reviews
  static Widget myReviewsEmpty({VoidCallback? onExplore}) {
    return EmptyState(
      key: const Key('empty_my_reviews_state'),
      icon: Icons.rate_review_outlined,
      title: 'Aucun avis donné',
      message: 'Vous n\'avez pas encore donné d\'avis.',
      actionText: onExplore != null ? 'Explorer les lieux' : null,
      onAction: onExplore,
    );
  }

  // Generic search empty state
  static Widget noSearchResults() {
    return const EmptyState(
      key: Key('empty_search_state'),
      icon: Icons.search_off,
      title: 'Aucun résultat',
      message: 'Essayez avec d\'autres termes de recherche.',
    );
  }
}
