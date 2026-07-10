class Folder {
  final String id;
  final String name;
  final String? parentId; // null이면 루트(대분류) 폴더
  final String? iconEmoji;
  final String? colorHex;
  final DateTime createdAt;

  const Folder({
    required this.id,
    required this.name,
    this.parentId,
    this.iconEmoji,
    this.colorHex,
    required this.createdAt,
  });

  Map<String, Object?> toRow() => {
    'id': id,
    'name': name,
    'parent_id': parentId,
    'icon_emoji': iconEmoji,
    'color_hex': colorHex,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory Folder.fromRow(Map<String, Object?> row) => Folder(
    id: row['id'] as String,
    name: row['name'] as String,
    parentId: row['parent_id'] as String?,
    iconEmoji: row['icon_emoji'] as String?,
    colorHex: row['color_hex'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
  );
}
