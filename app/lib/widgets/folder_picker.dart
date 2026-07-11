import 'package:flutter/material.dart';

import '../models/folder.dart';
import 'folder_form_dialog.dart';

/// Bottom sheet listing every folder (root, then its subfolders indented)
/// so the caller can pick one.
///
/// Returns the chosen folder id, `''` (empty string) if "미분류" was picked,
/// or `null` if the sheet was dismissed without a choice — callers must
/// treat `null` as "no change", not as "clear the folder", or dismissing
/// the sheet would silently wipe out an existing selection.
Future<String?> showFolderPickerSheet(
  BuildContext context, {
  required List<Folder> allFolders,
  String? excludeFolderId,
  bool includeUnclassified = true,
  String title = '폴더 선택',
}) {
  final roots = allFolders
      .where((f) => f.parentId == null && f.id != excludeFolderId)
      .toList();

  Widget folderTile(Folder folder, {double indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: ListTile(
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: folderColor(folder.colorHex),
          child: Text(
            folder.iconEmoji ?? '📁',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        title: Text(folder.name),
        onTap: () => Navigator.of(context).pop(folder.id),
      ),
    );
  }

  return showModalBottomSheet<String?>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              if (includeUnclassified)
                ListTile(
                  leading: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.close, size: 16),
                  ),
                  title: const Text('미분류'),
                  onTap: () => Navigator.of(context).pop(''),
                ),
              if (roots.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Text('아직 만든 폴더가 없습니다.'),
                ),
              for (final root in roots) ...[
                folderTile(root),
                for (final child in allFolders.where(
                  (f) => f.parentId == root.id && f.id != excludeFolderId,
                ))
                  folderTile(child, indent: 32),
              ],
            ],
          ),
        ),
      );
    },
  );
}
