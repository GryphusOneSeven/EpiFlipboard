import 'package:flutter/material.dart';
import 'package:epiflipboard/models/magazine.dart';

class MagazineCard extends StatelessWidget {
  final Magazine magazine;
  final VoidCallback? onTap;

  const MagazineCard({super.key, required this.magazine, this.onTap});

  bool _isMagPrivate(String boool) {
    if (boool == "true") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () { print("train go boom"); },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://picsum.photos/id/328/367/267",
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(80),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    magazine.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  Text(
                    magazine.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  if (_isMagPrivate(magazine.private))
                    const Icon(Icons.lock, size: 16, color: Colors.red),
                ],
              ),
            ),
          ],
      ),
    );
  }
}
