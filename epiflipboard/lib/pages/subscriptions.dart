import 'package:epiflipboard/pages/topic.dart';
import 'package:flutter/material.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {

  String getTheme(String? str) {
    if (str != null) {
      return str;
    }
    else {
      return "general";
    }
  }

  final List<Map<String, String>> subscriptions = [
    {
      "title": "Technologie",
      "description": "Les dernières innovations et tendances tech",
      "image": "https://picsum.photos/id/3/367/267",
      "theme": "technology"
    },
    {
      "title": "Divertissement",
      "description": "Actualités du divertissement",
      "image": "https://picsum.photos/id/96/367/267",
      "theme": "entertainment"
    },
    {
      "title": "Science",
      "description": "Découvertes et recherches fascinantes",
      "image": "https://picsum.photos/id/407/367/267",
      "theme": "science"
    },
    {
      "title": "Sports",
      "description": "Actualités du sport",
      "image": "https://picsum.photos/id/328/367/267",
      "theme": "sports"
    },
    {
      "title": "Santé",
      "description": "Santé et bien-être",
      "image": "https://picsum.photos/id/18/367/267",
      "theme": "health"
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

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TopicPage(
                  topic: getTheme(sub["theme"]),
                )));
              },
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