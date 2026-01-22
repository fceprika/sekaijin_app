import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/cards/news_card.dart';
import '../../widgets/cards/place_card.dart';
import '../../widgets/common/country_selector.dart';
import '../../widgets/common/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final homeDataAsync = ref.watch(homeDataProvider);

    String username = 'Utilisateur';
    if (authState is AuthAuthenticated) {
      username = authState.user.displayName;
    }

    return Scaffold(
      key: const Key('home_screen'),
      body: SafeArea(
        child: RefreshIndicator(
          key: const Key('home_scroll_view'),
          onRefresh: () async {
            ref.invalidate(homeDataProvider);
            await ref.read(homeDataProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                _WelcomeSection(key: const Key('welcome_section'), username: username),
                const SizedBox(height: 24),

                // Search bar
                const _SearchBar(key: Key('search_bar')),
                const SizedBox(height: 24),

                // Country selector
                const CountrySelector(),
                const SizedBox(height: 32),

                // News section
                homeDataAsync.when(
                  data: (data) => _NewsSection(
                    key: const Key('news_section'),
                    news: data.latestNews,
                  ),
                  loading: () => const _NewsLoadingSection(),
                  error: (error, stack) => _ErrorSection(
                    message: 'Impossible de charger les actualités',
                    onRetry: () => ref.invalidate(homeDataProvider),
                  ),
                ),
                const SizedBox(height: 32),

                // Popular places section
                homeDataAsync.when(
                  data: (data) => _PopularPlacesSection(
                    key: const Key('popular_places_section'),
                    places: data.popularPlaces,
                  ),
                  loading: () => const _PlacesLoadingSection(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final String username;

  const _WelcomeSection({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue,',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onBackground.withValues(alpha: 0.7),
                    ),
              ),
              Text(
                '$username!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(
            Icons.person,
            size: 28,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: 'Rechercher...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _NewsSection extends StatelessWidget {
  final List<NewsCardData> news;

  const _NewsSection({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Dernières actualités',
          onSeeAll: () {},
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: news.length,
            itemBuilder: (context, index) {
              return NewsCard(
                key: Key('news_card_$index'),
                data: news[index],
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NewsLoadingSection extends StatelessWidget {
  const _NewsLoadingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Dernières actualités'),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PopularPlacesSection extends StatelessWidget {
  final List<PlaceCardData> places;

  const _PopularPlacesSection({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Lieux populaires',
          onSeeAll: () {},
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: places.length,
          itemBuilder: (context, index) {
            return PlaceCard(
              key: Key('place_card_$index'),
              data: places[index],
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}

class _PlacesLoadingSection extends StatelessWidget {
  const _PlacesLoadingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Lieux populaires'),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorSection({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 48,
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
    );
  }
}
