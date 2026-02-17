import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('HomePage displays main widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    expect(find.byType(HomePage), findsOneWidget);
  });
}
