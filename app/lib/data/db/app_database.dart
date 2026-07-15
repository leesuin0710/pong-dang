import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'schema.dart';

class AppDatabase {
  AppDatabase._(this.db);
  final Database db;

  /// The plain `sqflite` plugin only ships platform channels for
  /// Android/iOS/macOS. On Windows/Linux desktop it must be swapped for the
  /// `sqflite_common_ffi` factory before [openDefault] is called.
  static void useFfiFactoryOnDesktop() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

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
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            for (final statement in kV2CreateTableStatements) {
              await db.execute(statement);
            }
          }
        },
      ),
    );
    return AppDatabase._(db);
  }

  /// Opens (or creates) `pongdang.db` under the app's documents directory.
  /// Only valid on platforms with a real sqflite factory (Android/iOS/
  /// desktop) — not Flutter Web. On desktop, call [useFfiFactoryOnDesktop]
  /// first.
  static Future<AppDatabase> openDefault() async {
    final dir = await getApplicationDocumentsDirectory();
    return open(path: p.join(dir.path, 'pongdang.db'));
  }

  Future<void> close() => db.close();
}
