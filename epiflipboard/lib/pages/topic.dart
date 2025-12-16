import 'package:flutter/material.dart';
import '../services/newsAPI.dart';

class TopicPage extends StatefulWidget {
  final String title;
  final String topic;

  const TopicPage({
    super.key,
    this.title = "Topic",
    this.topic = "general",
  });

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final NewsApiService _newsService = NewsApiService();
  late Future<List<dynamic>> _articles;

  @override
  void initState() {
    super.initState();
    _articles = _newsService.searchTopic(widget.topic.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final articles = snapshot.data ?? [];

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

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

                        const SizedBox(height: 10),

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