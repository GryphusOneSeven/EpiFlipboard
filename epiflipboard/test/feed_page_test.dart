import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/feed.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('FeedPage displays main widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: FeedPage()));
    expect(find.byType(FeedPage), findsOneWidget);
  });
}
