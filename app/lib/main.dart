import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: PongDangApp()));
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
