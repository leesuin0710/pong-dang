import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'schema.dart';

class AppDatabase {
  AppDatabase._(this.db);
  final Database db;

  /// Opens the DB at [path] using [factory] (defaults to the platform's
  /// sqflite factory). Tests inject `sqflite_common_ffi`'s factory with an
  /// in-memory path since the plain `sqflite` plugin needs a real platform.
  static Future<AppDatabase> open({
    required String path,
    DatabaseFactory? factory,
  }) async {
    final dbFactory = factory ?? databaseFactory;
    final db = await dbFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: kSchemaVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          for (final statement in kCreateTableStatements) {
            await db.execute(statement);
          }
        },
      ),
    );
    return AppDatabase._(db);
  }

  /// Opens (or creates) `pongdang.db` in the app's default database
  /// directory. Only valid on platforms with a real sqflite factory
  /// (Android/iOS/desktop) — not Flutter Web.
  static Future<AppDatabase> openDefault() async {
    final dir = await getDatabasesPath();
    return open(path: p.join(dir, 'pongdang.db'));
  }

  Future<void> close() => db.close();
}
