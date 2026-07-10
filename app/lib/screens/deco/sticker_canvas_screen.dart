import 'package:flutter/material.dart';

import '../../models/sticker.dart';

const _kStickerPalette = ['⭐', '🎀', '🍓', '🌸', '✨', '🩷', '🧸', '📎', '🍭', '☁️'];

class StickerCanvasScreen extends StatefulWidget {
  const StickerCanvasScreen({super.key});

  @override
  State<StickerCanvasScreen> createState() => _StickerCanvasScreenState();
}

class _StickerCanvasScreenState extends State<StickerCanvasScreen> {
  final List<StickerItem> _stickers = [];
  String? _selectedId;
  int _addCount = 0;
  Size _canvasSize = Size.zero;

  double _dragStartScale = 1.0;
  double _dragStartRotation = 0.0;

  void _addSticker(String emoji) {
    final base = _canvasSize.isEmpty
        ? const Offset(160, 160)
        : Offset(_canvasSize.width / 2, _canvasSize.height / 2);
    final stagger = Offset((_addCount % 5) * 14.0, (_addCount % 5) * 14.0);
    final item = StickerItem(
      id: 'sticker_${DateTime.now().microsecondsSinceEpoch}',
      emoji: emoji,
      position: base + stagger,
    );
    setState(() {
      _addCount++;
      _stickers.add(item);
      _selectedId = item.id;
    });
  }

  void _onScaleStart(StickerItem item, ScaleStartDetails details) {
    setState(() {
      _selectedId = item.id;
      _stickers.remove(item);
      _stickers.add(item);
      _dragStartScale = item.scale;
      _dragStartRotation = item.rotation;
    });
  }

  void _onScaleUpdate(StickerItem item, ScaleUpdateDetails details) {
    setState(() {
      item.position += details.focalPointDelta;
      item.scale = (_dragStartScale * details.scale).clamp(0.4, 3.0);
      item.rotation = _dragStartRotation + details.rotation;
    });
  }

  void _deleteSelected() {
    setState(() {
      _stickers.removeWhere((s) => s.id == _selectedId);
      _selectedId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다꾸 캔버스 (T203 검증)'),
        actions: [
          IconButton(
            onPressed: _stickers.isEmpty
                ? null
                : () => setState(() {
                    _stickers.clear();
                    _selectedId = null;
                  }),
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: '전체 삭제',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _canvasSize = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedId = null),
                  child: Container(
                    color: const Color(0xFFFFF3EE),
                    child: Stack(
                      children: [
                        for (final item in _stickers)
                          _StickerWidget(
                            key: ValueKey(item.id),
                            item: item,
                            isSelected: item.id == _selectedId,
                            onScaleStart: (d) => _onScaleStart(item, d),
                            onScaleUpdate: (d) => _onScaleUpdate(item, d),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedId != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton.icon(
                onPressed: _deleteSelected,
                icon: const Icon(Icons.delete_outline),
                label: const Text('선택 스티커 삭제'),
              ),
            ),
          _StickerPalette(onSelect: _addSticker),
        ],
      ),
    );
  }
}

class _StickerWidget extends StatelessWidget {
  final StickerItem item;
  final bool isSelected;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;

  const _StickerWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onScaleStart,
    required this.onScaleUpdate,
  });

  static const double _boxSize = 72;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.position.dx - _boxSize / 2,
      top: item.position.dy - _boxSize / 2,
      width: _boxSize,
      height: _boxSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        child: Transform.rotate(
          angle: item.rotation,
          child: Transform.scale(
            scale: item.scale,
            child: Container(
              alignment: Alignment.center,
              decoration: isSelected
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                    )
                  : null,
              child: Text(item.emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
        ),
      ),
    );
  }
}

class _StickerPalette extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const _StickerPalette({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: _kStickerPalette.map((emoji) {
          return GestureDetector(
            onTap: () => onSelect(emoji),
            child: Container(
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
