import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/results.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SearchResultsPage displays main widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchResultsPage(query: 'test')));
    expect(find.byType(SearchResultsPage), findsOneWidget);
  });
}
