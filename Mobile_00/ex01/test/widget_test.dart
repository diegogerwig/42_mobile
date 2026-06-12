// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ex01/main.dart';

void main() {
  testWidgets('Text toggle smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial text is displayed.
    expect(find.text('A simple text'), findsOneWidget);
    expect(find.text('Hello World!'), findsNothing);

    // Tap the 'Click me' button and trigger a frame.
    await tester.tap(find.text('Click me'));
    await tester.pump();

    // Verify that the text has changed.
    expect(find.text('A simple text'), findsNothing);
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
