import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/articleResult.dart';
import '../services/newsAPI.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _ArticlesView extends StatelessWidget {
  final Future<List<Article>> future;

  const _ArticlesView({required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
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
    );
  }
}

class _ThemesList extends StatelessWidget {
  final List<Map<String, String>> themes = const [
    {"label": "Actualités", "key": "general"},
    {"label": "Économie", "key": "business"},
    {"label": "Tech", "key": "technology"},
    {"label": "Science", "key": "science"},
    {"label": "Sport", "key": "sports"},
    {"label": "Art", "key": "entertainment"},
    {"label": "Musique", "key": "entertainment"},
    {"label": "Voyage", "key": "general"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: themes.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final theme = themes[index];

        return ListTile(
          title: Text(
            theme["label"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            debugPrintSynchronously("heee");
          },
        );
      },
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<String> tabs = ["Pour vous", "Nouveauté", "Thèmes"];
  String selectedTab = "Pour vous";

  Widget _buildTopCarousel() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final bool isSelected = tab == selectedTab;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = tab;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade200,
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedTab) {
      case "Pour vous":
        return _ArticlesView(
          future: NewsApiService.searchArticles("actualité"),
        );

      case "Nouveauté":
        return _ArticlesView(
          future: NewsApiService.getLatestArticles(),
        );

      case "Thèmes":
        return _ThemesList();

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(12)),
          const SizedBox(height: 12),
          _buildTopCarousel(),
          const SizedBox(height: 12),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
