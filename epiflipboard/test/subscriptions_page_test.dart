import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/pages/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('SubscriptionsPage displays main widgets', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MaterialApp(home: SubscriptionsPage()));
      expect(find.byType(SubscriptionsPage), findsOneWidget);
    });
  });
}
