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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isMagPrivate(magazine.private)
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔒 Badge privé
          if (_isMagPrivate(magazine.private))
            Row(
              children: [
                Icon(
                  Icons.lock,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  "Privé",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

          if (_isMagPrivate(magazine.private)) const SizedBox(height: 12),

          // 📰 Nom
          Text(
            magazine.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // 📝 Description
          Text(
            magazine.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),

          const Spacer(),

          // ➕ Action
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.chevron_right,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
