import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/newsAPI.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

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

          return ListView.builder(
            itemCount: news.length,
            itemBuilder: (context, index) {
              final article = news[index];

              return ListTile(
                leading: article["urlToImage"] != null
                    ? Image.network(article["urlToImage"], width: 80, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported),
                title: Text(article["title"] ?? "Sans titre"),
                subtitle: Text(article["source"]["name"] ?? "Source inconnue"),
                onTap: () async {
                    final url = Uri.parse(article["url"]);
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                },
              );
            },
          );
        },
      ),
    );
  }
}
