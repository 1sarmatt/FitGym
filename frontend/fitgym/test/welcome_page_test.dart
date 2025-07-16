import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitgym/src/welcome_page.dart'; 

void main() {
  testWidgets('WelcomePage shows UI components', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: WelcomePage(),
    ));

    expect(find.text('Welcome to FitGym!'), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
