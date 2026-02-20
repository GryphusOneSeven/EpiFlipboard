import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:epiflipboard/pages/home.dart';

void main() {
  group('HomePage Widget Tests', () {

    testWidgets('Affiche FeedPage par défaut', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {

        await tester.pumpWidget(
          const MaterialApp(
            home: HomePage(),
          ),
        );

        // Vérifie que le premier item est sélectionné
        final bottomNav =
            tester.widget<BottomNavigationBar>(
                find.byType(BottomNavigationBar));

        expect(bottomNav.currentIndex, 0);
      });
    });

    testWidgets('Affiche 5 items dans la BottomNavigationBar',
        (WidgetTester tester) async {

      await mockNetworkImagesFor(() async {

        await tester.pumpWidget(
          const MaterialApp(
            home: HomePage(),
          ),
        );

        final bottomNav =
            tester.widget<BottomNavigationBar>(
                find.byType(BottomNavigationBar));

        expect(bottomNav.items.length, 5);
      });
    });

    testWidgets('Change d’onglet quand on tap sur Subscriptions',
        (WidgetTester tester) async {

      await mockNetworkImagesFor(() async {

        await tester.pumpWidget(
          const MaterialApp(
            home: HomePage(),
          ),
        );

        await tester.tap(find.text('Subscriptions'));
        await tester.pump(); // 👈 remplacer pumpAndSettle()

        final bottomNav =
            tester.widget<BottomNavigationBar>(
                find.byType(BottomNavigationBar));

        expect(bottomNav.currentIndex, 1);
      });
    });

    testWidgets('Change d’onglet quand on tap sur Search',
        (WidgetTester tester) async {

      await mockNetworkImagesFor(() async {

        await tester.pumpWidget(
          const MaterialApp(
            home: HomePage(),
          ),
        );

        await tester.tap(find.text('Search'));
        await tester.pump();

        final bottomNav =
            tester.widget<BottomNavigationBar>(
                find.byType(BottomNavigationBar));

        expect(bottomNav.currentIndex, 2);
      });
    });

    testWidgets('Change d’onglet quand on tap sur Notifications',
        (WidgetTester tester) async {

      await mockNetworkImagesFor(() async {

        await tester.pumpWidget(
          const MaterialApp(
            home: HomePage(),
          ),
        );

        await tester.tap(find.text('Notifications'));
        await tester.pump();

        final bottomNav =
            tester.widget<BottomNavigationBar>(
                find.byType(BottomNavigationBar));

        expect(bottomNav.currentIndex, 3);
      });
    });

    testWidgets('Change d’onglet quand on tap sur Profile',
        (WidgetTester tester) async {

      await mockNetworkImagesFor(() async {

        await tester.pumpWidget(
          const MaterialApp(
            home: HomePage(),
          ),
        );

        await tester.tap(find.text('Profile'));
        await tester.pump();

        final bottomNav =
            tester.widget<BottomNavigationBar>(
                find.byType(BottomNavigationBar));

        expect(bottomNav.currentIndex, 4);
      });
    });

  });
}
