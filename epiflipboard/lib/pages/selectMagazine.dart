import 'dart:convert';
import 'package:epiflipboard/api/backend_url.dart';
import 'package:epiflipboard/models/article.dart';
import 'package:epiflipboard/models/magazine.dart';
import 'package:epiflipboard/services/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectMagazinePage extends StatefulWidget {
  final Article article;

  const SelectMagazinePage({
    super.key,
    required this.article,
  });

  @override
  State<SelectMagazinePage> createState() => _SelectMagazinePageState();
}

class _SelectMagazinePageState extends State<SelectMagazinePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _user;
  List<Magazine> _userMags = List.empty();
  int articleid = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await _fetchUser();
    await _fetchMagazine();
    await _addArticle(widget.article);
  }

  Future<void> _fetchMagazine() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('$backendBaseUrl/magazine?owner=${_user!["id"]}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final magData = jsonDecode(response.body);
      _userMags = magData.map<Magazine>((json) => Magazine.fromJson(json)).toList();

      setState(() {
        _isLoading = false;
      });

    } else {
        setState(() {
          _isLoading = false;
        });
      throw Exception('Erreur lors du chargement des articles');
    }
  }

  Future<void> _fetchUser() async {
    try {
      final token = await AuthStorage.getToken();

      if (token == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("$backendBaseUrl/profile"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _user = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addArticle(Article article) async {
      final response = await http.post(
      Uri.parse('$backendBaseUrl/add_article'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "title": article.title,
        "author": article.author,
        "description": article.description,
        "content": article.content,
        "source": article.source,
        "url": article.url,
        "urlToImage": article.imageUrl,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erreur lors de la création');
    }

    final tmp = jsonDecode(response.body);
    articleid = tmp[0]["id"];
  }

  Future<void> _addMagazineArticle(int magazienId, int articleId) async {
    final response = await http.post(
      Uri.parse('$backendBaseUrl/magazine_article'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "magazine_id": magazienId,
        "article_id": articleId,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erreur lors de la création');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir un magazine"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : _buildMagazineList(context),
    );
  }


  Widget _buildMagazineList(BuildContext context) {
    if (_userMags.isEmpty) {
      return const Center(
        child: Text("Vous n'avez pas encore de magazines"),
      );
    }

    return ListView.builder(
      itemCount: _userMags.length,
      itemBuilder: (context, index) {
        final mag = _userMags[index];

        return ListTile(
          title: Text(mag.name),
          subtitle: Text(mag.description),
          trailing: _isAlreadyAdded()
              ? const Icon(Icons.check, color: Colors.green)
              : null,
          onTap: () async {
            await _addMagazineArticle(mag.id, articleid);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Article ajouté au magazine")),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  bool _isAlreadyAdded() {
    return true;
  }

}