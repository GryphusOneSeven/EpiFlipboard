import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/notifications.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('NotificationsPage displays main widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotificationsPage()));
    expect(find.byType(NotificationsPage), findsOneWidget);
  });
}
