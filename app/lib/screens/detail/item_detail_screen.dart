import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/collection_item.dart';
import '../../providers/repository_providers.dart';
import '../../services/image_storage_service.dart';
import '../../widgets/rating_stars.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final CollectionItem item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  bool _deleting = false;

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제할까요?'),
        content: Text(
          'No.${widget.item.docNumber.toString().padLeft(3, '0')} 항목을 삭제하면 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    final repository = ref.read(collectionRepositoryProvider);
    final imageStorage = ref.read(imageStorageServiceProvider);
    await repository.deleteItem(widget.item.id);
    await imageStorage.deleteImages(
      SavedImagePaths(
        originalPath: widget.item.imagePath,
        thumbnailPath: widget.item.thumbnailPath,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text('No.${item.docNumber.toString().padLeft(3, '0')}'),
        actions: [
          IconButton(
            onPressed: _deleting ? null : _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            tooltip: '삭제',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Image.file(File(item.imagePath), fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingStars(rating: item.rating),
                  const SizedBox(height: 16),
                  if (item.labels.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final label in item.labels)
                          Chip(label: Text('#$label')),
                      ],
                    ),
                  if (item.memo != null && item.memo!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(item.memo!, style: const TextStyle(fontSize: 16)),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    DateFormat('yyyy.MM.dd HH:mm').format(item.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
