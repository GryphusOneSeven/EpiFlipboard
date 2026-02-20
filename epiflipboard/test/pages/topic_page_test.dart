import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/topic.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('TopicPage displays main widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TopicPage()));
    expect(find.byType(TopicPage), findsOneWidget);
  });
}
