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

  test('deleteItem removes the row and its label links', () async {
    final item = await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      labels: ['카페'],
    );

    await repo.deleteItem(item.id);

    expect(await repo.listItems(), isEmpty);
    final linkRows = await appDb.db.query(
      'item_labels',
      where: 'item_id = ?',
      whereArgs: [item.id],
    );
    expect(linkRows, isEmpty);
  });

  test('listItems sorts by rating when requested', () async {
    await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      rating: 2,
    );
    await repo.createItem(
      imagePath: '/b.png',
      thumbnailPath: '/b_t.png',
      rating: 5,
    );
    await repo.createItem(
      imagePath: '/c.png',
      thumbnailPath: '/c_t.png',
      rating: 3,
    );

    final byRating = await repo.listItems(sortBy: ItemSortOrder.ratingDesc);
    expect(byRating.map((e) => e.rating).toList(), [5, 3, 2]);
  });

  test('listFolders separates root folders from subfolders', () async {
    final root = await repo.createFolder(name: '카페');
    await repo.createFolder(name: '스타벅스', parentId: root.id);
    await repo.createFolder(name: '빈티지');

    final roots = await repo.listFolders();
    expect(roots.map((f) => f.name).toSet(), {'카페', '빈티지'});

    final subfolders = await repo.listFolders(parentId: root.id);
    expect(subfolders, hasLength(1));
    expect(subfolders.single.name, '스타벅스');

    expect(await repo.listAllFolders(), hasLength(3));
  });

  test('getFolderStats reports item/subfolder counts and last added date', () async {
    final root = await repo.createFolder(name: '카페');
    await repo.createFolder(name: '스타벅스', parentId: root.id);
    await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      folderId: root.id,
    );
    final second = await repo.createItem(
      imagePath: '/b.png',
      thumbnailPath: '/b_t.png',
      folderId: root.id,
    );

    final stats = await repo.getFolderStats(root.id);
    expect(stats.itemCount, 2);
    expect(stats.subfolderCount, 1);
    expect(
      stats.lastAddedAt!.millisecondsSinceEpoch,
      second.createdAt.millisecondsSinceEpoch,
    );
  });

  test('updateFolder changes only the provided fields', () async {
    final folder = await repo.createFolder(
      name: '카페',
      iconEmoji: '☕',
      colorHex: '#FFAB91',
    );

    await repo.updateFolder(folder.id, name: '카페 컬렉션');

    final updated = await repo.getFolder(folder.id);
    expect(updated!.name, '카페 컬렉션');
    expect(updated.iconEmoji, '☕'); // untouched
    expect(updated.colorHex, '#FFAB91'); // untouched
  });

  test('deleteFolder cascades to subfolders and unclassifies their items', () async {
    final root = await repo.createFolder(name: '카페');
    final sub = await repo.createFolder(name: '스타벅스', parentId: root.id);
    final item = await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      folderId: sub.id,
    );

    await repo.deleteFolder(root.id);

    expect(await repo.getFolder(root.id), isNull);
    expect(await repo.getFolder(sub.id), isNull);
    final items = await repo.listItems();
    expect(items.single.id, item.id);
    expect(items.single.folderId, isNull);
  });

  test('mergeFolders moves items into the target and removes the source', () async {
    final source = await repo.createFolder(name: '카페');
    final target = await repo.createFolder(name: '빈티지');
    final item = await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
      folderId: source.id,
    );

    await repo.mergeFolders(sourceId: source.id, targetId: target.id);

    expect(await repo.getFolder(source.id), isNull);
    final targetItems = await repo.listItems(folderId: target.id);
    expect(targetItems.single.id, item.id);
  });

  test('moveItemToFolder updates an item\'s folder', () async {
    final folder = await repo.createFolder(name: '카페');
    final item = await repo.createItem(
      imagePath: '/a.png',
      thumbnailPath: '/a_t.png',
    );

    await repo.moveItemToFolder(item.id, folder.id);
    expect((await repo.listItems(folderId: folder.id)).single.id, item.id);

    await repo.moveItemToFolder(item.id, null);
    expect(await repo.listItems(folderId: folder.id), isEmpty);
  });
}
