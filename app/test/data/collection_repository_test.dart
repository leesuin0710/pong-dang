import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pong_dang/data/collection_repository.dart';
import 'package:pong_dang/data/db/app_database.dart';

void main() {
  sqfliteFfiInit();

  late AppDatabase appDb;
  late CollectionRepository repo;

  setUp(() async {
    appDb = await AppDatabase.open(
      path: ':memory:',
      factory: databaseFactoryFfi,
    );
    repo = CollectionRepository(appDb);
  });

  tearDown(() async {
    await appDb.close();
  });

  test('creates folders and items with sequential doc numbers', () async {
    final folder = await repo.createFolder(name: '카페');
    final item1 = await repo.createItem(
      imagePath: '/img/1.png',
      thumbnailPath: '/thumb/1.png',
      rating: 5,
      memo: '첫 수집',
      folderId: folder.id,
      labels: ['카페', '빈티지'],
    );
    final item2 = await repo.createItem(
      imagePath: '/img/2.png',
      thumbnailPath: '/thumb/2.png',
      labels: ['카페'],
    );

    expect(item1.docNumber, 1);
    expect(item2.docNumber, 2);

    final items = await repo.listItems();
    expect(items, hasLength(2));
    expect(items.first.docNumber, 2); // doc_number DESC

    final folderItems = await repo.listItems(folderId: folder.id);
    expect(folderItems, hasLength(1));
    expect(folderItems.single.labels, containsAll(['카페', '빈티지']));
  });

  test('reuses an existing label row instead of duplicating it', () async {
    await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      labels: ['카페'],
    );
    await repo.createItem(
      imagePath: '/b.png',
      thumbnailPath: '/b_t.png',
      labels: ['카페'],
    );

    final labelRows = await appDb.db.query('labels');
    expect(labelRows, hasLength(1));
  });

  test('deleting a folder detaches its items instead of deleting them', () async {
    final folder = await repo.createFolder(name: '카페');
    final item = await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      folderId: folder.id,
    );

    await appDb.db.delete('folders', where: 'id = ?', whereArgs: [folder.id]);

    final remaining = await repo.listItems();
    expect(remaining, hasLength(1));
    expect(remaining.single.id, item.id);
    expect(remaining.single.folderId, isNull);
  });
}
