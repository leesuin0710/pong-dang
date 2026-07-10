import 'dart:ui';

enum FramePreset { postcard, milkCarton, circle, square, polaroid, heart }

class FrameSpec {
  final FramePreset id;
  final String label;
  final String emoji;
  final double aspectRatio; // frame box width / height
  final bool hasBottomCaptionStrip;
  final Path Function(Size size) imageClipPath;

  const FrameSpec({
    required this.id,
    required this.label,
    required this.emoji,
    required this.aspectRatio,
    required this.imageClipPath,
    this.hasBottomCaptionStrip = false,
  });
}

Path _roundedRect(Size size, double radius) {
  return Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );
}

Path _oval(Size size) {
  return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
}

Path _milkCarton(Size size) {
  final w = size.width;
  final h = size.height;
  const r = 12.0;
  final peakY = h * 0.18;
  return Path()
    ..moveTo(0, peakY)
    ..lineTo(w / 2, 0)
    ..lineTo(w, peakY)
    ..lineTo(w, h - r)
    ..quadraticBezierTo(w, h, w - r, h)
    ..lineTo(r, h)
    ..quadraticBezierTo(0, h, 0, h - r)
    ..close();
}

Path _polaroidImage(Size size) {
  final w = size.width;
  final imgH = size.height * 0.78;
  return Path()
    ..addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, w, imgH),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
    );
}

Path _heart(Size size) {
  final w = size.width;
  final h = size.height;
  return Path()
    ..moveTo(w / 2, h * 0.25)
    ..cubicTo(w * 0.1, -h * 0.1, -w * 0.1, h * 0.45, w / 2, h * 0.9)
    ..cubicTo(w * 1.1, h * 0.45, w * 0.9, -h * 0.1, w / 2, h * 0.25)
    ..close();
}

const List<FrameSpec> kFrameSpecs = [
  FrameSpec(
    id: FramePreset.postcard,
    label: '엽서',
    emoji: '💌',
    aspectRatio: 3 / 2,
    imageClipPath: _roundedRectPostcard,
  ),
  FrameSpec(
    id: FramePreset.milkCarton,
    label: '우유곽',
    emoji: '🥛',
    aspectRatio: 0.8,
    imageClipPath: _milkCarton,
  ),
  FrameSpec(
    id: FramePreset.circle,
    label: '원형',
    emoji: '⚪',
    aspectRatio: 1,
    imageClipPath: _oval,
  ),
  FrameSpec(
    id: FramePreset.square,
    label: '사각',
    emoji: '⬜',
    aspectRatio: 1,
    imageClipPath: _roundedRectSquare,
  ),
  FrameSpec(
    id: FramePreset.polaroid,
    label: '폴라로이드',
    emoji: '📸',
    aspectRatio: 0.85,
    imageClipPath: _polaroidImage,
    hasBottomCaptionStrip: true,
  ),
  FrameSpec(
    id: FramePreset.heart,
    label: '하트',
    emoji: '💖',
    aspectRatio: 1,
    imageClipPath: _heart,
  ),
];

Path _roundedRectPostcard(Size size) => _roundedRect(size, 16);
Path _roundedRectSquare(Size size) => _roundedRect(size, 8);
