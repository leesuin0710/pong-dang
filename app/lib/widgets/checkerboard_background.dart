import 'package:flutter/material.dart';

/// Grey checkerboard behind transparent-PNG previews.
class CheckerboardBackground extends StatelessWidget {
  final Widget child;
  const CheckerboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFFBDBDBD)),
      child: CustomPaint(painter: _CheckerPainter(), child: child),
    );
  }
}

class _CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cell = 12.0;
    final paint = Paint()..color = const Color(0xFFE0E0E0);
    for (double y = 0; y < size.height; y += cell) {
      for (double x = 0; x < size.width; x += cell) {
        final isEven = ((x / cell).round() + (y / cell).round()) % 2 == 0;
        if (isEven) {
          canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CheckerPainter oldDelegate) => false;
}
