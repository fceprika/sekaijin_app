import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/event.dart';
import '../../providers/events_provider.dart';
import '../../widgets/cards/event_list_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/common/loading_shimmer.dart';

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

            final event = state.items[index];
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
      itemBuilder: (context, index) => const EventCardShimmer(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState.noEvents();
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return ErrorState(
      message: error,
      onRetry: () => ref.read(eventsListProvider.notifier).refresh(),
    );
  }
}
