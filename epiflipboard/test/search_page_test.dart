import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('SearchPage displays main widgets', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MaterialApp(home: SearchPage()));
      expect(find.byType(SearchPage), findsOneWidget);
    });
  });
}
