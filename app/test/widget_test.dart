import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pong_dang/main.dart';

void main() {
  testWidgets('Home screen shows punch button', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PongDangApp()));

    expect(find.text('퐁당'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
