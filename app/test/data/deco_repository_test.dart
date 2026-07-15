import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pong_dang/data/db/app_database.dart';
import 'package:pong_dang/data/deco_repository.dart';

void main() {
  sqfliteFfiInit();

  late AppDatabase appDb;
  late DecoRepository repo;

  setUp(() async {
    appDb = await AppDatabase.open(
      path: ':memory:',
      factory: databaseFactoryFfi,
    );
    repo = DecoRepository(appDb);
  });

  tearDown(() async {
    await appDb.close();
  });

  test('creates multiple entries for the same date', () async {
    final date = DateTime(2026, 7, 11);
    final first = await repo.createEntry(date);
    final second = await repo.createEntry(date);

    final entries = await repo.listEntriesForDate(date);
    expect(entries.map((e) => e.id).toSet(), {first.id, second.id});
  });

  test('listEntriesForDate only returns that exact date', () async {
    await repo.createEntry(DateTime(2026, 7, 11));
    await repo.createEntry(DateTime(2026, 7, 12));

    final entries = await repo.listEntriesForDate(DateTime(2026, 7, 11));
    expect(entries, hasLength(1));
  });

  test('groups entries by date within the requested month only', () async {
    await repo.createEntry(DateTime(2026, 7, 1));
    await repo.createEntry(DateTime(2026, 7, 1)); // same day, 2nd entry
    await repo.createEntry(DateTime(2026, 7, 31));
    await repo.createEntry(DateTime(2026, 6, 30)); // previous month
    await repo.createEntry(DateTime(2026, 8, 1)); // next month

    final grouped = await repo.listEntriesGroupedByDateInMonth(
      DateTime(2026, 7, 15),
    );

    expect(grouped.keys.toSet(), {'2026-07-01', '2026-07-31'});
    expect(grouped['2026-07-01'], hasLength(2));
    expect(grouped['2026-07-31'], hasLength(1));
  });
}
