import 'package:flutter/material.dart';
import '../services/newsAPI.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  final NewsApiService newsService = NewsApiService();
  late Future<List<dynamic>> articles;

  @override
  void initState() {
    super.initState();
    articles = newsService.searchKeyword("gundam");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Actualités")),
      body: FutureBuilder(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final news = snapshot.data ?? [];

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: news.length,
            itemBuilder: (context, index) {
              final article = news[index];

              return Stack(
                children: [

                  Positioned.fill(
                    child: article["urlToImage"] != null
                        ? Image.network(
                            article["urlToImage"],
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.black),
                  ),

                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withAlpha(80),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),

                        Text(
                          article["title"] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          article["description"] ?? "",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}