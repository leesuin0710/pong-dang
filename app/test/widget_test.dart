import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:pong_dang/data/collection_repository.dart';
import 'package:pong_dang/data/db/app_database.dart';
import 'package:pong_dang/data/deco_repository.dart';
import 'package:pong_dang/main.dart';
import 'package:pong_dang/providers/repository_providers.dart';

void main() {
  testWidgets('Home screen shows punch button', (WidgetTester tester) async {
    // sqflite_common_ffi talks to a background isolate, which needs a real
    // (not fake-clock) async zone to ever resolve inside testWidgets.
    await tester.runAsync(() async {
      sqfliteFfiInit();
      final appDb = await AppDatabase.open(
        path: ':memory:',
        factory: databaseFactoryFfi,
      );
      final repository = CollectionRepository(appDb);
      final decoRepository = DecoRepository(appDb);
      addTearDown(appDb.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            collectionRepositoryProvider.overrideWithValue(repository),
            decoRepositoryProvider.overrideWithValue(decoRepository),
          ],
          child: const PongDangApp(),
        ),
      );
      // Let the real ffi/isolate-backed listItems() query resolve before
      // pumping again — pumpAndSettle's fake clock never observes it.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
    });

    expect(find.text('퐁당'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
