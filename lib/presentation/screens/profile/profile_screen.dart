import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/cards/compact_place_card.dart';
import '../../widgets/cards/compact_review_card.dart';
import '../../widgets/cards/stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _showLogoutConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final profileStats = ref.watch(profileStatsProvider);
    final myPlaces = ref.watch(myPlacesProvider);
    final myReviews = ref.watch(myReviewsProvider);
    final theme = Theme.of(context);

    String displayName = 'Utilisateur';
    String? email;

    if (authState is AuthAuthenticated) {
      displayName = authState.user.displayName;
      email = authState.user.email;
    }

    return Scaffold(
      key: const Key('profile_screen'),
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('logout_button'),
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myPlacesProvider);
          ref.invalidate(myReviewsProvider);
        },
        child: SingleChildScrollView(
          key: const Key('profile_scroll_view'),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User info section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const CircleAvatar(
                      key: Key('profile_avatar'),
                      radius: 48,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,
                      key: const Key('profile_display_name'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        email,
                        key: const Key('profile_email'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Stats section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: profileStats.when(
                  loading: () => const Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (stats) => Row(
                    key: const Key('profile_stats'),
                    children: [
                      Expanded(
                        child: StatCard(
                          key: const Key('stat_places'),
                          label: 'Lieux ajoutés',
                          value: stats.placesCount.toString(),
                          icon: Icons.place_outlined,
                          onTap: () => context.push('/profile/places'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          key: const Key('stat_reviews'),
                          label: 'Avis publiés',
                          value: stats.reviewsCount.toString(),
                          icon: Icons.rate_review_outlined,
                          onTap: () => context.push('/profile/reviews'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // My places section
              _buildSectionHeader(
                context,
                title: 'Mes lieux',
                onSeeAll: () => context.push('/profile/places'),
              ),
              myPlaces.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Erreur: $error',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
                data: (places) {
                  if (places.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aucun lieu ajouté',
                              key: const Key('no_places_message'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final displayPlaces = places.take(3).toList();
                  return Column(
                    key: const Key('my_places_list'),
                    children: displayPlaces.asMap().entries.map((entry) {
                      final place = entry.value;
                      return CompactPlaceCard(
                        place: place,
                        index: entry.key,
                        onTap: () => context.push('/places/${place.slug}'),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),

              // My reviews section
              _buildSectionHeader(
                context,
                title: 'Mes avis',
                onSeeAll: () => context.push('/profile/reviews'),
              ),
              myReviews.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Erreur: $error',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aucun avis publié',
                              key: const Key('no_reviews_message'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final displayReviews = reviews.take(3).toList();
                  return Column(
                    key: const Key('my_reviews_list'),
                    children: displayReviews.asMap().entries.map((entry) {
                      final review = entry.value;
                      return CompactReviewCard(
                        review: review,
                        index: entry.key,
                        onTap: review.place != null
                            ? () => context.push('/places/${review.place!.slug}')
                            : null,
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    VoidCallback? onSeeAll,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('Voir tout'),
            ),
        ],
      ),
    );
  }
}
