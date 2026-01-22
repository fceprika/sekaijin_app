import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/theme.dart';
import '../../providers/events_provider.dart';

class EventDetailScreen extends ConsumerWidget {
  final String slug;

  const EventDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(slug));

    return Scaffold(
      key: const Key('event_detail_screen'),
      body: eventAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(context, error.toString()),
        data: (event) {
          if (event == null) {
            return _buildErrorState(context, 'Événement non trouvé');
          }

          return CustomScrollView(
            slivers: [
              // Hero image with app bar
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      event.fullImageUrl != null
                          ? Image.network(
                              event.fullImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildImagePlaceholder();
                              },
                            )
                          : _buildImagePlaceholder(),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                      // Online/Presentiel badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: event.isOnline
                              ? AppColors.secondary
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              event.isOnline ? Icons.videocam : Icons.location_on,
                              size: 16,
                              color: AppColors.onPrimary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              event.isOnline ? 'En ligne' : 'Présentiel',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        event.title,
                        key: const Key('event_title'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Date & Time
                      Container(
                        key: const Key('event_date_time'),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 24,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                event.formattedDate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Location
                      Container(
                        key: const Key('event_location_info'),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.onBackground.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  event.isOnline ? Icons.videocam : Icons.place,
                                  size: 24,
                                  color: AppColors.onBackground.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.isOnline
                                            ? 'En ligne'
                                            : (event.location ?? 'Lieu à confirmer'),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onBackground,
                                        ),
                                      ),
                                      if (!event.isOnline && event.address != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          event.address!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.onBackground.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Action button for location
                            if (event.isOnline && event.onlineLink != null)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _launchUrl(event.onlineLink!),
                                  icon: const Icon(Icons.open_in_new, size: 18),
                                  label: const Text('Rejoindre'),
                                ),
                              )
                            else if (!event.isOnline && event.googleMapsUrl != null)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _launchUrl(event.googleMapsUrl!),
                                  icon: const Icon(Icons.map, size: 18),
                                  label: const Text('Voir sur Maps'),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Organizer info
                      if (event.organizer != null)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              backgroundImage: event.organizer!.fullAvatarUrl != null
                                  ? NetworkImage(event.organizer!.fullAvatarUrl!)
                                  : null,
                              child: event.organizer!.fullAvatarUrl == null
                                  ? Text(
                                      event.organizer!.displayName[0].toUpperCase(),
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
                                const Text(
                                  'Organisé par',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.onBackground,
                                  ),
                                ),
                                Text(
                                  event.organizer!.displayName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Participants
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.onBackground.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  size: 24,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  event.maxParticipants != null
                                      ? '${event.currentParticipants}/${event.maxParticipants} participants'
                                      : '${event.currentParticipants} participants',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onBackground,
                                  ),
                                ),
                              ],
                            ),
                            if (event.maxParticipants != null) ...[
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: event.currentParticipants / event.maxParticipants!,
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    event.isFull ? AppColors.error : AppColors.primary,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: event.isFree
                              ? AppColors.secondary.withValues(alpha: 0.1)
                              : AppColors.rating.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              event.isFree ? Icons.check_circle : Icons.euro,
                              size: 24,
                              color: event.isFree
                                  ? AppColors.secondary
                                  : AppColors.rating,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              event.isFree
                                  ? 'Gratuit'
                                  : '${event.price.toStringAsFixed(0)} euros',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: event.isFree
                                    ? AppColors.secondary
                                    : AppColors.rating,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        key: const Key('event_description'),
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppColors.onBackground.withValues(alpha: 0.8),
                        ),
                      ),

                      // Full description
                      if (event.fullDescription != null &&
                          event.fullDescription!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          event.fullDescription!,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.onBackground.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: event.isPast || event.isFull ? null : () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: event.isPast
                                ? AppColors.onBackground.withValues(alpha: 0.3)
                                : (event.isFull ? AppColors.error : AppColors.primary),
                          ),
                          child: Text(
                            event.isPast
                                ? 'Passé'
                                : (event.isFull ? 'Complet' : "S'inscrire"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
          Icons.event,
          size: 64,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
