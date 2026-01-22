import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/event.dart';

class EventListCard extends StatelessWidget {
  final Event event;
  final int index;
  final VoidCallback? onTap;

  const EventListCard({
    super.key,
    required this.event,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: event.isPast ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date block
              _buildDateBlock(),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event.title,
                        key: Key('event_title_$index'),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Location
                      Row(
                        children: [
                          Icon(
                            event.isOnline ? Icons.videocam : Icons.location_on,
                            size: 14,
                            color: AppColors.onBackground.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.isOnline
                                  ? 'En ligne'
                                  : (event.location ?? 'Lieu à confirmer'),
                              key: Key('event_location_$index'),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onBackground.withValues(alpha: 0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Badges row
                      Row(
                        children: [
                          // Online/Presentiel badge
                          _buildBadge(
                            event.isOnline ? 'En ligne' : 'Présentiel',
                            event.isOnline
                                ? AppColors.secondary
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          // Participants
                          if (event.maxParticipants != null) ...[
                            Icon(
                              Icons.people,
                              size: 14,
                              color: AppColors.onBackground.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event.currentParticipants}/${event.maxParticipants}',
                              style: TextStyle(
                                fontSize: 12,
                                color: event.isFull
                                    ? AppColors.error
                                    : AppColors.onBackground.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Price
                          _buildPriceBadge(),
                        ],
                      ),
                      // Past badge
                      if (event.isPast) ...[
                        const SizedBox(height: 8),
                        _buildBadge('Passé', AppColors.onBackground.withValues(alpha: 0.5)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBlock() {
    final day = event.startDate.day.toString();
    final month = DateFormat('MMM', 'fr_FR').format(event.startDate).toUpperCase();

    return Container(
      key: Key('event_date_$index'),
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: event.isPast
            ? AppColors.onBackground.withValues(alpha: 0.1)
            : AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: event.isPast ? AppColors.onBackground : AppColors.onPrimary,
            ),
          ),
          Text(
            month,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: event.isPast
                  ? AppColors.onBackground.withValues(alpha: 0.7)
                  : AppColors.onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPriceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: event.isFree
            ? AppColors.secondary.withValues(alpha: 0.1)
            : AppColors.rating.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        event.isFree ? 'Gratuit' : '${event.price.toStringAsFixed(0)}€',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: event.isFree ? AppColors.secondary : AppColors.rating,
        ),
      ),
    );
  }
}
