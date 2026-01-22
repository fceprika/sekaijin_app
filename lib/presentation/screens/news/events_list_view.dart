import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/event.dart';
import '../../providers/events_provider.dart';
import '../../widgets/cards/event_list_card.dart';

class EventsListView extends ConsumerWidget {
  const EventsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsListProvider);
    final onlineFilter = ref.watch(eventOnlineFilterProvider);

    return Scaffold(
      key: const Key('events_list'),
      body: Column(
        children: [
          // Filter toggles
          _buildFilterToggles(context, ref, onlineFilter),
          // Events list
          Expanded(
            child: _buildEventsList(context, ref, eventsState),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterToggles(
    BuildContext context,
    WidgetRef ref,
    bool? onlineFilter,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            key: 'event_filter_all',
            label: 'Tous',
            isSelected: onlineFilter == null,
            onTap: () {
              ref.read(eventOnlineFilterProvider.notifier).state = null;
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            key: 'event_filter_online',
            label: 'En ligne',
            isSelected: onlineFilter == true,
            onTap: () {
              ref.read(eventOnlineFilterProvider.notifier).state = true;
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            key: 'event_filter_presentiel',
            label: 'Présentiel',
            isSelected: onlineFilter == false,
            onTap: () {
              ref.read(eventOnlineFilterProvider.notifier).state = false;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String key,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        key: Key(key),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.onPrimary : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList(
    BuildContext context,
    WidgetRef ref,
    EventsState state,
  ) {
    if (state.isLoading && state.events.isEmpty) {
      return _buildLoadingShimmer();
    }

    if (state.error != null && state.events.isEmpty) {
      return _buildErrorState(context, ref, state.error!);
    }

    if (state.events.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(eventsListProvider.notifier).refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              ref.read(eventsListProvider.notifier).loadMore();
            }
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.events.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.events.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final event = state.events[index];
            return EventListCard(
              key: Key('event_card_$index'),
              event: event,
              index: index,
              onTap: () => _navigateToDetail(context, event),
            );
          },
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Event event) {
    context.push('/events/${event.slug}');
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date block placeholder
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              // Content placeholder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
            Icons.event_busy,
            size: 64,
            color: AppColors.onBackground.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun événement à venir',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onBackground.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revenez bientôt pour découvrir de nouveaux événements',
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
              onPressed: () => ref.read(eventsListProvider.notifier).refresh(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
