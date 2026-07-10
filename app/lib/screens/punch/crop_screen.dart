import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../models/frame_type.dart';
import '../../widgets/frame_clipper.dart';
import 'crop_result_screen.dart';

class CropScreen extends StatefulWidget {
  final Uint8List imageBytes;
  const CropScreen({super.key, required this.imageBytes});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  FrameSpec _spec = kFrameSpecs.first;

  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _startScale = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _startScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_startScale * details.scale).clamp(0.5, 4.0);
      _offset += details.focalPointDelta;
    });
  }

  Future<void> _onDone() async {
    final renderObject = _boundaryKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return;

    final image = await renderObject.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null || !mounted) return;
    final pngBytes = byteData.buffer.asUint8List();

    HapticFeedback.mediumImpact();

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CropResultScreen(pngBytes: pngBytes)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const CloseButton(),
        title: const Text('크롭'),
        actions: [
          TextButton(
            onPressed: _onDone,
            child: const Text('완료', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth - 32;
                  final maxH = constraints.maxHeight - 32;
                  double w = maxW;
                  double h = w / _spec.aspectRatio;
                  if (h > maxH) {
                    h = maxH;
                    w = h * _spec.aspectRatio;
                  }
                  return RepaintBoundary(
                    key: _boundaryKey,
                    child: SizedBox(
                      width: w,
                      height: h,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipPath(
                              clipper: FrameClipper(_spec),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..translateByDouble(
                                    _offset.dx,
                                    _offset.dy,
                                    0,
                                    1,
                                  )
                                  ..scaleByDouble(_scale, _scale, 1, 1),
                                child: Image.memory(
                                  widget.imageBytes,
                                  fit: BoxFit.cover,
                                  width: w,
                                  height: h,
                                ),
                              ),
                            ),
                          ),
                          if (_spec.hasBottomCaptionStrip)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: h * 0.22,
                              child: Container(color: Colors.white),
                            ),
                          Positioned.fill(
                            child: CustomPaint(
                              painter: FrameBorderPainter(_spec),
                            ),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onScaleStart: _onScaleStart,
                              onScaleUpdate: _onScaleUpdate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _FrameSelector(
            selected: _spec,
            onSelect: (spec) => setState(() => _spec = spec),
          ),
        ],
      ),
    );
  }
}

class _FrameSelector extends StatelessWidget {
  final FrameSpec selected;
  final ValueChanged<FrameSpec> onSelect;

  const _FrameSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: kFrameSpecs.map((spec) {
          final isSelected = spec.id == selected.id;
          return GestureDetector(
            onTap: () => onSelect(spec),
            child: Container(
              width: 68,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white38,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(spec.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    spec.label,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
