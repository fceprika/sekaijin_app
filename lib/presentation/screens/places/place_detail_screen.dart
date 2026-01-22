import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place.dart';
import '../../providers/auth_provider.dart';
import '../../providers/place_detail_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/common/image_carousel.dart';
import '../../widgets/common/rating_stars.dart';
import '../../widgets/reviews/review_card.dart';

class PlaceDetailScreen extends ConsumerWidget {
  final String slug;

  const PlaceDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailProvider(slug));

    return Scaffold(
      key: const Key('place_detail_screen'),
      body: placeAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => _ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(placeDetailProvider(slug)),
        ),
        data: (place) => _PlaceDetailContent(place: place),
      ),
    );
  }
}

class _PlaceDetailContent extends ConsumerStatefulWidget {
  final Place place;

  const _PlaceDetailContent({required this.place});

  @override
  ConsumerState<_PlaceDetailContent> createState() => _PlaceDetailContentState();
}

class _PlaceDetailContentState extends ConsumerState<_PlaceDetailContent> {
  bool _isDescriptionExpanded = false;

  void _navigateToReviewForm() {
    final authState = ref.read(authStateProvider);
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connectez-vous pour donner votre avis'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final userReview = ref.read(userReviewProvider(widget.place.slug));

    context.push(
      '/places/${widget.place.slug}/review',
      extra: {
        'placeName': widget.place.title,
        'existingReview': userReview,
      },
    ).then((result) {
      if (result == true) {
        // Refresh place detail to get updated rating
        ref.invalidate(placeDetailProvider(widget.place.slug));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final userReview = ref.watch(userReviewProvider(place.slug));
    final authState = ref.watch(authStateProvider);

    return CustomScrollView(
      key: const Key('place_detail_scroll'),
      slivers: [
        // App bar with back button
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: ImageCarousel(
              key: const Key('image_carousel'),
              imageUrls: place.imageUrls,
              height: 250,
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${place.category.emoji} ${place.category.label}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  key: const Key('place_title'),
                  place.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                ),
                const SizedBox(height: 12),

                // Rating
                Row(
                  key: const Key('place_rating'),
                  children: [
                    RatingStars(
                      rating: place.ratingAverage,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      place.ratingAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
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
                const SizedBox(height: 8),

                // Creator info
                if (place.user != null)
                  Text(
                    'Ajouté par ${place.user!.name}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onBackground.withValues(alpha: 0.6),
                    ),
                  ),

                const Divider(height: 32),

                // Location section
                const _SectionTitle(title: 'Localisation'),
                const SizedBox(height: 12),
                if (place.address != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            place.address!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.onBackground.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (place.city != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 20,
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${place.city!.name}${place.city!.country != null ? ', ${place.city!.country!.nameFr}' : ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onBackground.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (place.googleMapsUrl.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const Key('google_maps_button'),
                      onPressed: () => _launchUrl(place.googleMapsUrl),
                      icon: const Icon(Icons.map),
                      label: const Text('Voir sur Google Maps'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                const Divider(height: 32),

                // Description section
                const _SectionTitle(title: 'Description'),
                const SizedBox(height: 12),
                Container(
                  key: const Key('place_description'),
                  child: _isDescriptionExpanded || place.description.length <= 300
                      ? Html(
                          data: place.description,
                          style: {
                            'body': Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              fontSize: FontSize(14),
                              color: AppColors.onBackground.withValues(alpha: 0.8),
                              lineHeight: const LineHeight(1.6),
                            ),
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Html(
                              data: '${place.description.substring(0, 300)}...',
                              style: {
                                'body': Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                  fontSize: FontSize(14),
                                  color: AppColors.onBackground.withValues(alpha: 0.8),
                                  lineHeight: const LineHeight(1.6),
                                ),
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isDescriptionExpanded = true;
                                });
                              },
                              child: const Text('Lire plus'),
                            ),
                          ],
                        ),
                ),

                // Info section
                if (_hasInfoSection(place)) ...[
                  const Divider(height: 32),
                  const _SectionTitle(title: 'Informations'),
                  const SizedBox(height: 12),
                  Container(
                    key: const Key('place_info_section'),
                    child: Column(
                      children: [
                        if (place.wifiSpeed != null)
                          _InfoRow(
                            icon: Icons.wifi,
                            label: 'Wifi',
                            value: '${place.wifiSpeed} Mbps',
                          ),
                        if (place.websiteUrl != null)
                          _InfoRow(
                            icon: Icons.language,
                            label: 'Site web',
                            value: 'Visiter',
                            onTap: () => _launchUrl(place.websiteUrl!),
                          ),
                        if (place.menuUrl != null)
                          _InfoRow(
                            icon: Icons.restaurant_menu,
                            label: 'Menu',
                            value: 'Voir le menu',
                            onTap: () => _launchUrl(place.menuUrl!),
                          ),
                        if (place.youtubeUrl != null)
                          _InfoRow(
                            icon: Icons.play_circle_outline,
                            label: 'Vidéo',
                            value: 'Voir la vidéo',
                            onTap: () => _launchUrl(place.youtubeUrl!),
                          ),
                      ],
                    ),
                  ),
                ],

                // Reviews section
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(title: 'Avis (${place.reviewsCount})'),
                    if (authState is AuthAuthenticated)
                      TextButton.icon(
                        key: const Key('add_review_button'),
                        onPressed: _navigateToReviewForm,
                        icon: Icon(
                          userReview != null ? Icons.edit : Icons.add,
                          size: 18,
                        ),
                        label: Text(userReview != null ? 'Modifier' : 'Avis'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // User's own review (shown separately at the top)
                if (userReview != null) ...[
                  Container(
                    key: const Key('user_review_section'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mon avis',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextButton(
                              onPressed: _navigateToReviewForm,
                              child: const Text('Modifier'),
                            ),
                          ],
                        ),
                        ReviewCard(
                          review: userReview,
                          index: 0,
                          showUser: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Other reviews
                Container(
                  key: const Key('reviews_section'),
                  child: place.reviews != null && place.reviews!.isNotEmpty
                      ? Column(
                          children: [
                            ...place.reviews!
                                .where((review) => userReview == null || review.id != userReview.id)
                                .take(3)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ReviewCard(
                                      review: entry.value,
                                      index: entry.key,
                                    ),
                                  ),
                                ),
                            if (place.reviews!.length > 3)
                              TextButton(
                                onPressed: () {
                                  // TODO: Navigate to all reviews
                                },
                                child: const Text('Voir tous les avis'),
                              ),
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  size: 48,
                                  color: AppColors.onBackground.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Aucun avis pour le moment',
                                  style: TextStyle(
                                    color: AppColors.onBackground.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (authState is AuthAuthenticated)
                                  TextButton(
                                    onPressed: _navigateToReviewForm,
                                    child: const Text('Soyez le premier à donner votre avis!'),
                                  )
                                else
                                  const Text(
                                    'Connectez-vous pour donner votre avis',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _hasInfoSection(Place place) {
    return place.wifiSpeed != null ||
        place.websiteUrl != null ||
        place.menuUrl != null ||
        place.youtubeUrl != null;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onBackground,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: onTap != null ? AppColors.primary : AppColors.onBackground,
                fontWeight: onTap != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
