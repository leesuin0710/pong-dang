import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/collection_repository.dart';
import '../../models/folder.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/folder_form_dialog.dart';
import 'folder_detail_screen.dart';

class FolderListScreen extends ConsumerStatefulWidget {
  const FolderListScreen({super.key});

  @override
  ConsumerState<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends ConsumerState<FolderListScreen> {
  late Future<List<_FolderRow>> _foldersFuture;

  @override
  void initState() {
    super.initState();
    _foldersFuture = _load();
  }

  Future<List<_FolderRow>> _load() async {
    final repo = ref.read(collectionRepositoryProvider);
    final folders = await repo.listFolders();
    final rows = <_FolderRow>[];
    for (final folder in folders) {
      rows.add(_FolderRow(folder: folder, stats: await repo.getFolderStats(folder.id)));
    }
    return rows;
  }

  void _reload() => setState(() {
    _foldersFuture = _load();
  });

  Future<void> _createFolder() async {
    final result = await showDialog<FolderFormResult>(
      context: context,
      builder: (_) => const FolderFormDialog(title: '새 폴더 만들기'),
    );
    if (result == null) return;
    await ref.read(collectionRepositoryProvider).createFolder(
      name: result.name,
      iconEmoji: result.iconEmoji,
      colorHex: result.colorHex,
    );
    _reload();
  }

  Future<void> _openFolder(Folder folder) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FolderDetailScreen(folder: folder)),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_FolderRow>>(
      future: _foldersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (rows.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    '아직 만든 폴더가 없습니다.\n아래에서 새 폴더를 만들어보세요.',
                    textAlign: TextAlign.center,
                  ),
                ),
              for (final row in rows)
                _FolderTile(row: row, onTap: () => _openFolder(row.folder)),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('+ 새 폴더 만들기'),
                onTap: _createFolder,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FolderRow {
  final Folder folder;
  final FolderStats stats;
  const _FolderRow({required this.folder, required this.stats});
}

class _FolderTile extends StatelessWidget {
  final _FolderRow row;
  final VoidCallback onTap;
  const _FolderTile({required this.row, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final folder = row.folder;
    final stats = row.stats;
    final subtitle = stats.itemCount == 0
        ? '비어있음'
        : '아이템 ${stats.itemCount}개'
              '${stats.subfolderCount > 0 ? ' · 서브폴더 ${stats.subfolderCount}개' : ''}'
              '${stats.lastAddedAt != null ? ' · 최근 ${DateFormat('yyyy.MM.dd').format(stats.lastAddedAt!)}' : ''}';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: folderColor(folder.colorHex),
        child: Text(folder.iconEmoji ?? '📁'),
      ),
      title: Text(folder.name),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
