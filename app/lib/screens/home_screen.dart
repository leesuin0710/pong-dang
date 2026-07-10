import 'package:flutter/material.dart';

import 'punch/image_select_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('퐁당')),
      body: const Center(
        child: Text(
          '도감 그리드는 T302에서 구현 예정입니다.\n오른쪽 아래 + 버튼으로 펀치 모드를 테스트해보세요.',
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ImageSelectScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
