import 'package:flutter/material.dart';
import '../services/newsAPI.dart';
import '../models/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class _ArticleCard extends StatelessWidget {
  final Article article;

  const _ArticleCard({required this.article});

  Future<void> _openArticle() async {
    final uri = Uri.parse(article.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }


  Widget _buildActionsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionItem(Icons.favorite_border, "Like", () {debugPrintSynchronously("like");}),
        _actionItem(Icons.chat_bubble_outline, "Commenter", () {debugPrintSynchronously("comment");}),
        _actionItem(Icons.add, "Ajouter", () {debugPrintSynchronously("add");}),
        _actionItem(Icons.share_outlined, "Partager", () {debugPrintSynchronously("share");}),
      ],
    );
  }

  Widget _actionItem(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              article.imageUrl,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 240,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            article.source.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            article.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const Spacer(),

          _buildActionsBar(),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openArticle,
              child: const Text("Lire l’article"),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicPage extends StatelessWidget {
  final String topic;

  const TopicPage({
    super.key,
    this.topic = "general",
  });

  Future<List<Article>> _fetchArticles() {
    return NewsApiService.getArticlesByTopic(topic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.toUpperCase()),
      ),
      body: FutureBuilder<List<Article>>(
        future: _fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Erreur de chargement"));
          }

          final articles = snapshot.data!;

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return _ArticleCard(article: articles[index]);
            },
          );
        },
      ),
    );
  }
}