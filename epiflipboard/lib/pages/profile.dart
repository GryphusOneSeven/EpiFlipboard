import 'package:epiflipboard/models/magazine.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/backend_url.dart';
import '../services/auth_storage.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchMagazine();
  }

  Future<List<dynamic>> _fetchMagazine() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('$backendBaseUrl/magazine'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // final MagData = jsonDecode(response.body);
      // final list = MagData.map<Magazine>((json) => Magazine.fromJson(json)).toList();
      // print(list);

      setState(() {
        _isLoading = false;
      });

      return jsonDecode(response.body);
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
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _user == null
            ? const Center(child: Text("Erreur de chargement"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Profile Image
                    CircleAvatar(
                        radius: 60,
                        backgroundImage: _user!["profile_picture"] != null
                            ? NetworkImage(_user!["profile_picture"])
                            : const AssetImage('assets/profile.jpg')
                                as ImageProvider,
                    ),

                    const SizedBox(height: 16),

                    /// Name
                    Text(
                      _user?["name"] ?? "Votre Profil",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Email (optional)
                    Text(
                      _user?["email"] ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// Stats Row
                    // Row(
                    //   children: [
                    //     statButton("${_user?["adds_count"] ?? 0}\nAjouts", () {}),
                    //     const SizedBox(width: 20),
                    //     statButton("${_user?["likes_count"] ?? 0}\nJ'aime", () {}),
                    //     const SizedBox(width: 20),
                    //     statButton("${_user?["magazines_count"] ?? 0}\nMagazines", () {}),
                    //   ],
                    // ),
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
                        statButton("0\nMagazines", () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Magazines")));
                        }),
                      ],
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
