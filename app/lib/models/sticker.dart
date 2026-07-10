import 'dart:ui';

class StickerItem {
  final String id;
  final String emoji;
  Offset position;
  double scale;
  double rotation;

  StickerItem({
    required this.id,
    required this.emoji,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}
