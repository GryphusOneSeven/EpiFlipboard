import 'package:flutter/material.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {

  final List<Map<String, String>> subscriptions = [
    {
      "title": "Technologie",
      "description": "Les dernières innovations et tendances tech",
      "image": "https://picsum.photos/400/600?1"
    },
    {
      "title": "Gaming",
      "description": "Toute l’actualité du jeu vidéo",
      "image": "https://picsum.photos/400/600?2"
    },
    {
      "title": "Science",
      "description": "Découvertes et recherches fascinantes",
      "image": "https://picsum.photos/400/600?3"
    },
  ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Abonnements"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.builder(
          itemCount: subscriptions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final sub = subscriptions[index];

            return ClipRRect(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      sub["image"]!,
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
                          sub["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          sub["description"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}