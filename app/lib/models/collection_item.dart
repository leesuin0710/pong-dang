class CollectionItem {
  final String id;
  final int docNumber; // 도감 번호 (No.001)
  final String imagePath;
  final String thumbnailPath;
  final int rating; // 0(미평가)~5
  final String? memo;
  final DateTime createdAt;
  final String? folderId; // null이면 미분류
  final List<String> labels;

  const CollectionItem({
    required this.id,
    required this.docNumber,
    required this.imagePath,
    required this.thumbnailPath,
    this.rating = 0,
    this.memo,
    required this.createdAt,
    this.folderId,
    this.labels = const [],
  });

  Map<String, Object?> toRow() => {
    'id': id,
    'doc_number': docNumber,
    'image_path': imagePath,
    'thumbnail_path': thumbnailPath,
    'rating': rating,
    'memo': memo,
    'created_at': createdAt.millisecondsSinceEpoch,
    'folder_id': folderId,
  };

  factory CollectionItem.fromRow(
    Map<String, Object?> row, {
    List<String> labels = const [],
  }) => CollectionItem(
    id: row['id'] as String,
    docNumber: row['doc_number'] as int,
    imagePath: row['image_path'] as String,
    thumbnailPath: row['thumbnail_path'] as String,
    rating: row['rating'] as int,
    memo: row['memo'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
    folderId: row['folder_id'] as String?,
    labels: labels,
  );
}
