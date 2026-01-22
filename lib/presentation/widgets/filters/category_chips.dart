import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place.dart';
import '../../providers/places_provider.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(placeCategoryFilterProvider);

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "Tous" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              key: const Key('category_filter_tous'),
              label: const Text('Tous'),
              selected: selectedCategory == null,
              onSelected: (_) {
                ref.read(placeCategoryFilterProvider.notifier).state = null;
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selectedCategory == null
                    ? AppColors.primary
                    : AppColors.onBackground,
                fontWeight: selectedCategory == null
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          // Category chips
          ...PlaceCategory.values.map((category) {
            final isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                key: Key('category_filter_${category.slug}'),
                label: Text('${category.emoji} ${category.label}'),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(placeCategoryFilterProvider.notifier).state =
                      isSelected ? null : category;
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.onBackground,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
