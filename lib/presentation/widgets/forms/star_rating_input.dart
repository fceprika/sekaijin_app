import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class StarRatingInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;
  final bool enabled;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 40,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isSelected = starNumber <= rating;

        return GestureDetector(
          onTap: enabled ? () => onChanged(starNumber) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                size: size,
                color: isSelected
                    ? AppColors.rating
                    : AppColors.onBackground.withValues(alpha: 0.3),
              ),
            ),
          ),
        );
      }),
    );
  }
}
