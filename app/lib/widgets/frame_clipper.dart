import 'package:flutter/material.dart';

import '../models/frame_type.dart';

class FrameClipper extends CustomClipper<Path> {
  final FrameSpec spec;
  const FrameClipper(this.spec);

  @override
  Path getClip(Size size) => spec.imageClipPath(size);

  @override
  bool shouldReclip(covariant FrameClipper oldClipper) =>
      oldClipper.spec.id != spec.id;
}

class FrameBorderPainter extends CustomPainter {
  final FrameSpec spec;
  const FrameBorderPainter(this.spec);

  @override
  void paint(Canvas canvas, Size size) {
    final path = spec.imageClipPath(size);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FrameBorderPainter oldDelegate) =>
      oldDelegate.spec.id != spec.id;
}
