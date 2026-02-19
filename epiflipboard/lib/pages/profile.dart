import 'package:epiflipboard/models/magazine.dart';
import 'package:epiflipboard/pages/createMagazine.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/backend_url.dart';
import '../services/auth_storage.dart';
import '../widgets/magazineCard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _user;
  List<Magazine> _userMags = List.empty();

  @override
  void initState() async {
    super.initState();
    await _fetchProfile();
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

  Future<void> _fetchProfile() async {
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
        title: const Text("Profil"),
        elevation: 0,

        actions: [
            IconButton(
            tooltip: "Historique",
            icon: const Icon(Icons.history),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Historique")),
              );
            },
          ),
          IconButton(
            tooltip: "Touver personnes",
            icon: const Icon(Icons.person_add_alt_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Trouver personnes a suivre")),
              );
            },
          ),
          IconButton(
            tooltip: "Parametres",
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Parametres")),
              );
            },
          ),
        ],

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        tooltip: "Créer un magazine",
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMagazinePage(userId: _user!["id"]),
            ),
          );
        },
      ),

      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _user == null
            ? const Center(child: Text("Erreur de chargement"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CircleAvatar(
                        radius: 60,
                        backgroundImage: _user!["profile_picture"] != null
                            ? NetworkImage(_user!["profile_picture"])
                            : const AssetImage('assets/profile.jpg')
                                as ImageProvider,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      _user?["name"] ?? "Votre Profil",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _user?["email"] ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        statButton("0\nAjouts", () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Ajouts")),
                          );
                        }),
                        const SizedBox(width: 20),
                        statButton("0\nJ'aime", () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("J'aime")),
                          );
                        }),
                        const SizedBox(width: 20),
                        statButton("${_userMags.length}\nMagazines", () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Magazines")));
                        }),
                      ],
                    ),

                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _userMags.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final magazine = _userMags[index];
                        return MagazineCard(magazine: magazine);
                      },
                    ),
                  ],
                ),
              ),
            );
  }
}

Widget statButton(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
