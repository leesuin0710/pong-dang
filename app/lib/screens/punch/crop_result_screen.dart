import 'dart:typed_data';

import 'package:flutter/material.dart';

class CropResultScreen extends StatelessWidget {
  final Uint8List pngBytes;
  const CropResultScreen({super.key, required this.pngBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('크롭 결과 (T202 검증)')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: _CheckerboardBackground(
                    child: Image.memory(pngBytes, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '투명 배경 PNG로 정상 크롭됐는지 확인용 화면입니다.\n등록 폼(태그/별점/메모)은 T302에서 구현 예정입니다.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).popUntil((route) => route.isFirst),
                  child: const Text('홈으로'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckerboardBackground extends StatelessWidget {
  final Widget child;
  const _CheckerboardBackground({required this.child});

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
