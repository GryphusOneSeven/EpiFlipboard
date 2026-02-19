import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/article.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ArticlePage displays main widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ArticlePage()));
    expect(find.byType(ArticlePage), findsOneWidget);
  });
}
