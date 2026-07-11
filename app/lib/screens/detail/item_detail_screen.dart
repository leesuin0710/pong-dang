import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/collection_item.dart';
import '../../models/folder.dart';
import '../../providers/repository_providers.dart';
import '../../services/image_storage_service.dart';
import '../../widgets/folder_picker.dart';
import '../../widgets/rating_stars.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final CollectionItem item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  late CollectionItem _item = widget.item;
  Folder? _folder;
  bool _loadingFolder = false;
  bool _deleting = false;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _loadFolder();
  }

  Future<void> _loadFolder() async {
    final folderId = _item.folderId;
    if (folderId == null) {
      setState(() => _folder = null);
      return;
    }
    setState(() => _loadingFolder = true);
    final folder = await ref
        .read(collectionRepositoryProvider)
        .getFolder(folderId);
    if (!mounted) return;
    setState(() {
      _folder = folder;
      _loadingFolder = false;
    });
  }

  Future<void> _moveFolder() async {
    final repo = ref.read(collectionRepositoryProvider);
    final allFolders = await repo.listAllFolders();
    if (!mounted) return;
    final result = await showFolderPickerSheet(
      context,
      allFolders: allFolders,
      title: '폴더로 이동',
    );
    if (result == null || !mounted) return; // dismissed — keep current folder

    final newFolderId = result.isEmpty ? null : result;
    await repo.moveItemToFolder(_item.id, newFolderId);
    setState(() {
      _item = _item.copyWithFolderId(newFolderId);
      _changed = true;
    });
    _loadFolder();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제할까요?'),
        content: Text(
          'No.${_item.docNumber.toString().padLeft(3, '0')} 항목을 삭제하면 되돌릴 수 없습니다.',
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
    await repository.deleteItem(_item.id);
    await imageStorage.deleteImages(
      SavedImagePaths(
        originalPath: _item.imagePath,
        thumbnailPath: _item.thumbnailPath,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
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
                  child: Image.file(
                    File(item.imagePath),
                    fit: BoxFit.contain,
                  ),
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
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _loadingFolder ? null : _moveFolder,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _folder == null
                                  ? '📁 미분류'
                                  : '${_folder!.iconEmoji ?? '📁'} ${_folder!.name}',
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
