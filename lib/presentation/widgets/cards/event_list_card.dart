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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
        child: Opacity(
          opacity: event.isPast ? 0.6 : 1.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outline),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                blurRadius: 18,
                offset: const Offset(0, 8),
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
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
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
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.isOnline
                                  ? 'En ligne'
                                  : (event.location ?? 'Lieu à confirmer'),
                              key: Key('event_location_$index'),
                              style: textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
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
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${event.currentParticipants}/${event.maxParticipants}',
                              style: textTheme.bodySmall?.copyWith(
                                color: event.isFull
                                    ? AppColors.error
                                    : scheme.onSurfaceVariant,
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
                        _buildBadge('Passé', scheme.onSurfaceVariant),
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
        gradient: event.isPast ? null : AppGradients.accent,
        color: event.isPast ? AppColors.surfaceVariant : null,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
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
                  ? AppColors.onSurfaceVariant
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
        borderRadius: BorderRadius.circular(10),
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
            ? AppColors.secondary.withValues(alpha: 0.12)
            : AppColors.rating.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
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
