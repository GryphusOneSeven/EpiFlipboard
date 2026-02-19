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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool _isMagPrivate(String boool) {
    if (boool == "true") {
      return true;
    }
    return false;
  }

  void _loadData() async {
    await _fetchUser();
    await _fetchMagazine();
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
          trailing: _isMagPrivate(mag.private)
              ? const Icon(Icons.lock, size: 18)
              : null,
          onTap: () async {
            // await _addArticleToMagazine(context, mag);
            print("allright");
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Future<void> _addArticleToMagazine(
  //   BuildContext context,
  //   Magazine mag,
  // ) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //         "https://TON_BACKEND/magazine/${mag.id}/add-article",
  //       ),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "title": article.title,
  //         "url": article.url,
  //         "image": article.image,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Ajouté à ${mag.name}")),
  //       );
  //     } else {
  //       throw Exception("Erreur serveur");
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Erreur : $e")),
  //     );
  //   }
  // }

}