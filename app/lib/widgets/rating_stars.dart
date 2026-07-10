import 'package:flutter/material.dart';

/// Read-only when [onChanged] is null, otherwise tappable 1~[max] stars.
class RatingStars extends StatelessWidget {
  final int rating;
  final int max;
  final double size;
  final ValueChanged<int>? onChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.max = 5,
    this.size = 24,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        final filled = index < rating;
        final icon = Icon(
          filled ? Icons.star : Icons.star_border,
          size: size,
          color: filled ? Colors.amber : Colors.grey,
        );
        if (onChanged == null) return icon;
        return InkWell(
          onTap: () => onChanged!(index + 1),
          customBorder: const CircleBorder(),
          child: Padding(padding: const EdgeInsets.all(2), child: icon),
        );
      }),
    );
  }
}
