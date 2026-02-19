import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:epiflipboard/models/magazine.dart';
import 'package:epiflipboard/widgets/magazineCard.dart';

void main() {
  late Magazine magazinePublic;
  late Magazine magazinePrivate;

  setUp(() {
    magazinePublic = Magazine(
      name: "Public Mag",
      description: "This is public",
      private: "false",
      owner: 1,
      id: 1,
    );

    magazinePrivate = Magazine(
      name: "Private Mag",
      description: "This is private",
      private: "true",
      owner: 2,
      id: 2,
    );
  });

  testWidgets('MagazineCard affiche correctement le nom et description',
      (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MagazineCard(magazine: magazinePublic),
          ),
        ),
      );

      expect(find.text("Public Mag"), findsOneWidget);
      expect(find.text("This is public"), findsOneWidget);

      expect(find.byIcon(Icons.lock), findsNothing);
    });
  });

  testWidgets('MagazineCard affiche lock si magazine privé',
      (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MagazineCard(magazine: magazinePrivate),
          ),
        ),
      );

      expect(find.text("Private Mag"), findsOneWidget);
      expect(find.text("This is private"), findsOneWidget);

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });

  testWidgets('MagazineCard onTap fonctionne',
      (tester) async {
    bool tapped = false;

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MagazineCard(
              magazine: magazinePublic,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
