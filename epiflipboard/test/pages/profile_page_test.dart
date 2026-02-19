import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/profile.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ProfilePage displays loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
