import 'package:flutter/material.dart';

const List<String> kFolderIconChoices = [
  '📁',
  '☕',
  '🧸',
  '🎀',
  '📸',
  '🌸',
  '⭐',
  '🎨',
];

/// T103 테마 팔레트(복숭아/민트/라벤더)에서 뽑은 폴더 색상 후보.
const List<String> kFolderColorChoices = [
  '#FFAB91',
  '#88D4AB',
  '#B8A9C9',
  '#D4A5A5',
  '#A8C69F',
  '#E07A5F',
];

Color folderColor(String? hex) {
  if (hex == null || hex.length != 7) return const Color(0xFFBDBDBD);
  return Color(int.parse(hex.substring(1), radix: 16) | 0xFF000000);
}

class FolderFormResult {
  final String name;
  final String iconEmoji;
  final String colorHex;
  const FolderFormResult({
    required this.name,
    required this.iconEmoji,
    required this.colorHex,
  });
}

/// Create/edit dialog for a folder's name, icon, and color (F4.1/F4.4).
class FolderFormDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialIconEmoji;
  final String? initialColorHex;

  const FolderFormDialog({
    super.key,
    required this.title,
    this.initialName,
    this.initialIconEmoji,
    this.initialColorHex,
  });

  @override
  State<FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends State<FolderFormDialog> {
  late final _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late String _iconEmoji = widget.initialIconEmoji ?? kFolderIconChoices.first;
  late String _colorHex = widget.initialColorHex ?? kFolderColorChoices.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(
      FolderFormResult(name: name, iconEmoji: _iconEmoji, colorHex: _colorHex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: '폴더 이름'),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            const Text('아이콘', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final icon in kFolderIconChoices)
                  ChoiceChip(
                    label: Text(icon, style: const TextStyle(fontSize: 18)),
                    selected: _iconEmoji == icon,
                    onSelected: (_) => setState(() => _iconEmoji = icon),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('색상', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final hex in kFolderColorChoices)
                  GestureDetector(
                    onTap: () => setState(() => _colorHex = hex),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: folderColor(hex),
                      child: _colorHex == hex
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(onPressed: _submit, child: const Text('저장')),
      ],
    );
  }
}
