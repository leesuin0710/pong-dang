import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/folder.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/checkerboard_background.dart';
import '../../widgets/folder_picker.dart';
import '../../widgets/rating_stars.dart';

const _uuid = Uuid();

class RegisterFormScreen extends ConsumerStatefulWidget {
  final Uint8List pngBytes;
  const RegisterFormScreen({super.key, required this.pngBytes});

  @override
  ConsumerState<RegisterFormScreen> createState() =>
      _RegisterFormScreenState();
}

class _RegisterFormScreenState extends ConsumerState<RegisterFormScreen> {
  final _tagController = TextEditingController();
  final _memoController = TextEditingController();
  final List<String> _labels = [];
  int _rating = 0;
  bool _saving = false;
  Folder? _selectedFolder;

  @override
  void dispose() {
    _tagController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickFolder() async {
    final repo = ref.read(collectionRepositoryProvider);
    final allFolders = await repo.listAllFolders();
    if (!mounted) return;
    final result = await showFolderPickerSheet(
      context,
      allFolders: allFolders,
      title: '폴더 선택',
    );
    if (result == null || !mounted) return; // dismissed — keep current pick
    setState(() {
      _selectedFolder = result.isEmpty
          ? null
          : allFolders.firstWhere((f) => f.id == result);
    });
  }

  void _addTagFromInput() {
    final text = _tagController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (!_labels.contains(text)) _labels.add(text);
      _tagController.clear();
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final id = _uuid.v4();
      final imageStorage = ref.read(imageStorageServiceProvider);
      final paths = await imageStorage.saveCroppedImage(widget.pngBytes, id);

      final repository = ref.read(collectionRepositoryProvider);
      await repository.createItem(
        id: id,
        imagePath: paths.originalPath,
        thumbnailPath: paths.thumbnailPath,
        rating: _rating,
        memo: _memoController.text.trim().isEmpty
            ? null
            : _memoController.text.trim(),
        labels: _labels,
        folderId: _selectedFolder?.id,
      );

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도감 등록'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: CheckerboardBackground(
                  child: Image.memory(widget.pngBytes, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('별점', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RatingStars(
              rating: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 24),
            const Text('태그', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                hintText: '태그 추가 후 엔터',
                isDense: true,
              ),
              onSubmitted: (_) => _addTagFromInput(),
            ),
            if (_labels.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final label in _labels)
                    Chip(
                      label: Text('#$label'),
                      onDeleted: () => setState(() => _labels.remove(label)),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Text('메모', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '한 줄 메모 또는 감상을 남겨보세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '폴더 (선택)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickFolder,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedFolder == null
                          ? '📁 미분류'
                          : '${_selectedFolder!.iconEmoji ?? '📁'} ${_selectedFolder!.name}',
                    ),
                    const Spacer(),
                    const Icon(Icons.expand_more),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
