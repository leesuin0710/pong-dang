import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/collection_item.dart';
import '../models/folder.dart';
import 'db/app_database.dart';

const _uuid = Uuid();

enum ItemSortOrder { newest, ratingDesc }

/// Data-access layer over [AppDatabase] covering the F2/F3 registry +
/// viewer flows. Search (F3.5) is not implemented yet.
class CollectionRepository {
  CollectionRepository(this._appDb);
  final AppDatabase _appDb;
  Database get _db => _appDb.db;

  Future<Folder> createFolder({
    required String name,
    String? parentId,
    String? iconEmoji,
    String? colorHex,
  }) async {
    final folder = Folder(
      id: _uuid.v4(),
      name: name,
      parentId: parentId,
      iconEmoji: iconEmoji,
      colorHex: colorHex,
      createdAt: DateTime.now(),
    );
    await _db.insert('folders', folder.toRow());
    return folder;
  }

  Future<CollectionItem> createItem({
    String? id,
    required String imagePath,
    required String thumbnailPath,
    int rating = 0,
    String? memo,
    String? folderId,
    List<String> labels = const [],
  }) async {
    final itemId = id ?? _uuid.v4();
    final createdAt = DateTime.now();

    return _db.transaction((txn) async {
      final maxDocNumber =
          Sqflite.firstIntValue(
            await txn.rawQuery('SELECT MAX(doc_number) FROM items'),
          ) ??
          0;
      final docNumber = maxDocNumber + 1;

      final item = CollectionItem(
        id: itemId,
        docNumber: docNumber,
        imagePath: imagePath,
        thumbnailPath: thumbnailPath,
        rating: rating,
        memo: memo,
        createdAt: createdAt,
        folderId: folderId,
        labels: labels,
      );
      await txn.insert('items', item.toRow());

      for (final rawLabel in labels) {
        final labelName = rawLabel.trim();
        if (labelName.isEmpty) continue;
        final labelId = await _upsertLabel(txn, labelName);
        await txn.insert('item_labels', {
          'item_id': itemId,
          'label_id': labelId,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      return item;
    });
  }

  Future<String> _upsertLabel(DatabaseExecutor txn, String name) async {
    final existing = await txn.query(
      'labels',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    if (existing.isNotEmpty) return existing.first['id'] as String;

    final id = _uuid.v4();
    await txn.insert('labels', {'id': id, 'name': name});
    return id;
  }

  Future<List<CollectionItem>> listItems({
    String? folderId,
    ItemSortOrder sortBy = ItemSortOrder.newest,
  }) async {
    final where = folderId == null ? null : 'items.folder_id = ?';
    final whereArgs = folderId == null ? null : [folderId];
    final orderBy = switch (sortBy) {
      ItemSortOrder.newest => 'doc_number DESC',
      ItemSortOrder.ratingDesc => 'rating DESC, doc_number DESC',
    };

    final rows = await _db.query(
      'items',
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    final items = <CollectionItem>[];
    for (final row in rows) {
      final labelRows = await _db.rawQuery(
        '''
        SELECT labels.name AS name
        FROM item_labels
        JOIN labels ON labels.id = item_labels.label_id
        WHERE item_labels.item_id = ?
        ORDER BY labels.name
        ''',
        [row['id']],
      );
      items.add(
        CollectionItem.fromRow(
          row,
          labels: [for (final l in labelRows) l['name'] as String],
        ),
      );
    }
    return items;
  }

  Future<void> deleteItem(String id) async {
    await _db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
