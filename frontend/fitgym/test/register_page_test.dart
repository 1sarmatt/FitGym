import 'package:fitgym/src/features/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fitgym/l10n/app_localizations.dart';

Widget _wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')], // adjust if testing other locales
    home: child,
  );
}

void main() {
  testWidgets('RegisterPage renders all fields', (WidgetTester tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(const RegisterPage()));

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    });

    testWidgets('Validation shows error for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(const RegisterPage()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump(); // trigger validation

    expect(find.textContaining('enter'), findsWidgets);
    });

    testWidgets('Shows error if passwords do not match', (WidgetTester tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(const RegisterPage()));

    await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'abc123');
    await tester.enterText(find.byKey(const Key('confirmPasswordField')), 'xyz456');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pump();

    expect(find.textContaining('do not match'), findsOneWidget);
    });
}
