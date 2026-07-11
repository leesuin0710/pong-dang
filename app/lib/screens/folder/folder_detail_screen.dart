import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/collection_item.dart';
import '../../models/folder.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/collection_grid_view.dart';
import '../../widgets/folder_form_dialog.dart';
import '../../widgets/folder_picker.dart';
import '../detail/item_detail_screen.dart';

class FolderDetailScreen extends ConsumerStatefulWidget {
  final Folder folder;
  const FolderDetailScreen({super.key, required this.folder});

  @override
  ConsumerState<FolderDetailScreen> createState() =>
      _FolderDetailScreenState();
}

class _FolderDetailScreenState extends ConsumerState<FolderDetailScreen> {
  late Folder _folder = widget.folder;
  late Future<(List<Folder>, List<CollectionItem>)> _dataFuture;
  bool get _canHaveSubfolders => _folder.parentId == null;

  @override
  void initState() {
    super.initState();
    _dataFuture = _load();
  }

  Future<(List<Folder>, List<CollectionItem>)> _load() async {
    final repo = ref.read(collectionRepositoryProvider);
    final subfolders = _canHaveSubfolders
        ? await repo.listFolders(parentId: _folder.id)
        : <Folder>[];
    final items = await repo.listItems(folderId: _folder.id);
    return (subfolders, items);
  }

  void _reload() => setState(() {
    _dataFuture = _load();
  });

  Future<void> _addSubfolder() async {
    final result = await showDialog<FolderFormResult>(
      context: context,
      builder: (_) => const FolderFormDialog(title: '서브폴더 추가'),
    );
    if (result == null) return;
    await ref.read(collectionRepositoryProvider).createFolder(
      name: result.name,
      parentId: _folder.id,
      iconEmoji: result.iconEmoji,
      colorHex: result.colorHex,
    );
    _reload();
  }

  Future<void> _editFolder() async {
    final result = await showDialog<FolderFormResult>(
      context: context,
      builder: (_) => FolderFormDialog(
        title: '폴더 편집',
        initialName: _folder.name,
        initialIconEmoji: _folder.iconEmoji,
        initialColorHex: _folder.colorHex,
      ),
    );
    if (result == null) return;
    await ref
        .read(collectionRepositoryProvider)
        .updateFolder(
          _folder.id,
          name: result.name,
          iconEmoji: result.iconEmoji,
          colorHex: result.colorHex,
        );
    setState(() {
      _folder = Folder(
        id: _folder.id,
        name: result.name,
        parentId: _folder.parentId,
        iconEmoji: result.iconEmoji,
        colorHex: result.colorHex,
        createdAt: _folder.createdAt,
      );
    });
  }

  Future<void> _mergeInto() async {
    final repo = ref.read(collectionRepositoryProvider);
    final allFolders = await repo.listAllFolders();
    if (!mounted) return;
    final targetId = await showFolderPickerSheet(
      context,
      allFolders: allFolders,
      excludeFolderId: _folder.id,
      includeUnclassified: false,
      title: '"${_folder.name}"을(를) 병합할 폴더 선택',
    );
    if (targetId == null || !mounted) return;
    await repo.mergeFolders(sourceId: _folder.id, targetId: targetId);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _deleteFolder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('폴더를 삭제할까요?'),
        content: Text(
          '"${_folder.name}" 폴더를 삭제하면 ${_canHaveSubfolders ? '서브폴더와 ' : ''}'
          '안의 아이템은 미분류로 남고, 폴더 자체는 되돌릴 수 없습니다.',
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
    if (confirmed != true) return;
    await ref.read(collectionRepositoryProvider).deleteFolder(_folder.id);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _openItem(CollectionItem item) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
    );
    if (changed == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_folder.iconEmoji ?? '📁'),
            const SizedBox(width: 8),
            Flexible(child: Text(_folder.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _editFolder,
            icon: const Icon(Icons.edit_outlined),
            tooltip: '편집',
          ),
          IconButton(
            onPressed: _mergeInto,
            icon: const Icon(Icons.merge_type),
            tooltip: '다른 폴더로 병합',
          ),
          IconButton(
            onPressed: _deleteFolder,
            icon: const Icon(Icons.delete_outline),
            tooltip: '삭제',
          ),
        ],
      ),
      body: FutureBuilder<(List<Folder>, List<CollectionItem>)>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final (subfolders, items) = snapshot.data!;
          return Column(
            children: [
              if (_canHaveSubfolders)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final sub in subfolders)
                        ActionChip(
                          avatar: Text(sub.iconEmoji ?? '📁'),
                          label: Text(sub.name),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    FolderDetailScreen(folder: sub),
                              ),
                            );
                            _reload();
                          },
                        ),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text('서브폴더 추가'),
                        onPressed: _addSubfolder,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: CollectionGridView(
                  items: items,
                  emptyMessage: '이 폴더에는 아직 아이템이 없습니다.',
                  onTapItem: _openItem,
                  onRefresh: () async => _reload(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
