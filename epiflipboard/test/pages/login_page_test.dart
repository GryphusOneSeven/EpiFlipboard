import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('LoginPage displays login form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
