/// One 다꾸 page for a given calendar day. Multiple entries may share the
/// same [date] — a day can hold several pages (spec T401 v0.2).
class DecoEntry {
  final String id;
  final DateTime date; // date-only (time component ignored)
  final DateTime createdAt;
  final DateTime updatedAt;

  const DecoEntry({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Map<String, Object?> toRow() => {
    'id': id,
    'date': dateKey(date),
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
  };

  factory DecoEntry.fromRow(Map<String, Object?> row) => DecoEntry(
    id: row['id'] as String,
    date: DateTime.parse(row['date'] as String),
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
  );
}
