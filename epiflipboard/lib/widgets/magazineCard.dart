import 'package:flutter/material.dart';
import '../models/magazine.dart';

class MagazineCard extends StatelessWidget {
  Magazine magazine;

  MagazineCard({required this.magazine});

  bool _isMagPrivate(String boool) {
    if (boool == "true") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            magazine.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            magazine.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          if (_isMagPrivate(magazine.private))
            const Icon(Icons.lock, size: 16, color: Colors.red),
        ],
      ),
    );
  }
}
