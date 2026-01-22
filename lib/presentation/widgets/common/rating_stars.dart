import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 16,
    this.filledColor = Colors.amber,
    Color? emptyColor,
  }) : emptyColor = emptyColor ?? const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starValue = index + 1;

        if (rating >= starValue) {
          return Icon(
            Icons.star,
            size: size,
            color: filledColor,
          );
        } else if (rating >= starValue - 0.5) {
          return Icon(
            Icons.star_half,
            size: size,
            color: filledColor,
          );
        } else {
          return Icon(
            Icons.star_border,
            size: size,
            color: emptyColor,
          );
        }
      }),
    );
  }
}
