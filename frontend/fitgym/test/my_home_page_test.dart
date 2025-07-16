import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitgym/main.dart';

void main() {
  testWidgets('Counter increments when FAB is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyHomePage(title: 'Test Counter'),
    ));

    // Verify counter starts at 0
    expect(find.text('0'), findsOneWidget);

    // Tap the FloatingActionButton
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify counter increments to 1
    expect(find.text('1'), findsOneWidget);
  });
}
