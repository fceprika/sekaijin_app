import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/cards/compact_review_card.dart';

class MyReviewsListScreen extends ConsumerWidget {
  const MyReviewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myReviews = ref.watch(myReviewsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      key: const Key('my_reviews_list_screen'),
      appBar: AppBar(
        title: const Text('Mes avis'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myReviewsProvider);
        },
        child: myReviews.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: $error',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(myReviewsProvider),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun avis publié',
                      key: const Key('empty_reviews_message'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Partagez votre expérience sur les lieux que vous avez visités !',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/places'),
                      icon: const Icon(Icons.explore),
                      label: const Text('Explorer les lieux'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              key: const Key('reviews_list'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return CompactReviewCard(
                  review: review,
                  index: index,
                  onTap: review.place != null
                      ? () => context.push('/places/${review.place!.slug}')
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
