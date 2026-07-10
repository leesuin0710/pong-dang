import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/collection_repository.dart';
import 'data/db/app_database.dart';
import 'providers/repository_providers.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.useFfiFactoryOnDesktop();

  final appDatabase = await AppDatabase.openDefault();
  final repository = CollectionRepository(appDatabase);

  runApp(
    ProviderScope(
      overrides: [collectionRepositoryProvider.overrideWithValue(repository)],
      child: const PongDangApp(),
    ),
  );
}

class PongDangApp extends StatelessWidget {
  const PongDangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '퐁당',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFAB91)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
