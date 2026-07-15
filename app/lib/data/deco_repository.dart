import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/deco_entry.dart';
import 'db/app_database.dart';

const _uuid = Uuid();

/// Entry-level CRUD for the F7-CALENDAR / F8-DECO 다꾸 feature (T401).
/// Placement (sticker/text) CRUD lands with T402, once the deco canvas
/// screen actually needs to read/write `deco_placements`.
class DecoRepository {
  DecoRepository(this._appDb);
  final AppDatabase _appDb;
  Database get _db => _appDb.db;

  Future<DecoEntry> createEntry(DateTime date) async {
    final now = DateTime.now();
    final entry = DecoEntry(
      id: _uuid.v4(),
      date: date,
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('deco_entries', entry.toRow());
    return entry;
  }

  Future<List<DecoEntry>> listEntriesForDate(DateTime date) async {
    final rows = await _db.query(
      'deco_entries',
      where: 'date = ?',
      whereArgs: [DecoEntry.dateKey(date)],
      orderBy: 'created_at ASC',
    );
    return [for (final row in rows) DecoEntry.fromRow(row)];
  }

  /// Entries for the whole month containing [monthAnchor], grouped by
  /// `date` key (see [DecoEntry.dateKey]) — one query for the calendar
  /// grid instead of one per day cell.
  Future<Map<String, List<DecoEntry>>> listEntriesGroupedByDateInMonth(
    DateTime monthAnchor,
  ) async {
    final start = DateTime(monthAnchor.year, monthAnchor.month, 1);
    final end = DateTime(monthAnchor.year, monthAnchor.month + 1, 1);
    final rows = await _db.query(
      'deco_entries',
      where: 'date >= ? AND date < ?',
      whereArgs: [DecoEntry.dateKey(start), DecoEntry.dateKey(end)],
      orderBy: 'date ASC, created_at ASC',
    );

    final grouped = <String, List<DecoEntry>>{};
    for (final row in rows) {
      final dateKey = row['date'] as String;
      grouped.putIfAbsent(dateKey, () => []).add(DecoEntry.fromRow(row));
    }
    return grouped;
  }
}
