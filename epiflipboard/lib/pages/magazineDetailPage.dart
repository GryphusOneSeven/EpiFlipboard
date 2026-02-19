import 'package:flutter/material.dart';
import 'package:epiflipboard/models/articleResult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/backend_url.dart';
import 'package:url_launcher/url_launcher.dart';

class MagazineDetailPage extends StatefulWidget {
  final int magazineId;
  final String magazineDescription;
  final int ownerId;

  final String initialMagazineName;

  const MagazineDetailPage({
    super.key,
    required this.magazineId,
    required this.initialMagazineName,
    required this.magazineDescription,
    required this.ownerId,
  });

  @override
  State<MagazineDetailPage> createState() => _MagazineDetailPageState();
}

class _MagazineDetailPageState extends State<MagazineDetailPage> {
  late Future<List<Article>> _articlesFuture;
  late String _magazineName; // nom modifiable dynamiquement

  @override
  void initState() {
    super.initState();
    _magazineName = widget.initialMagazineName;
    _articlesFuture = _fetchMagazineArticles();
  }

  Future<List<Article>> _fetchMagazineArticles() async {
    final response = await http.get(
      Uri.parse('$backendBaseUrl/magazine/${widget.magazineId}/articles'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des articles du magazine');
    }
  }

  Future<void> _openArticle(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildArticleCard(Article article) {
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
            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.3),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openArticle(article.url),
              child: const Text("Lire l’article"),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Modifier le nom"),
              onTap: () {
                Navigator.pop(context);
                _editMagazineName();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Supprimer le magazine", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMagazine();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editMagazineName() {
    final controller = TextEditingController(text: _magazineName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier le nom du magazine"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _magazineName = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Valider"),
          ),
        ],
      ),
    );
  }

  void _deleteMagazine() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer le magazine ?"),
        content: const Text("Êtes-vous sûr de vouloir supprimer ce magazine ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final response = await http.delete(
        Uri.parse('$backendBaseUrl/magazine/${widget.magazineId}'),
        headers: {'Content-Type': 'application/json'},
      );

      // Utiliser `mounted` pour vérifier si le widget est toujours actif
      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Magazine supprimé")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la suppression")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_magazineName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'more') _showMoreActions();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'more', child: Icon(Icons.more_vert)),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun article trouvé"));
          }
          final articles = snapshot.data!;
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: articles.length,
            itemBuilder: (context, index) => _buildArticleCard(articles[index]),
          );
        },
      ),
    );
  }
}
