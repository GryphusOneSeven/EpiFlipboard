import 'package:epiflipboard/api/backend_url.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateMagazinePage extends StatefulWidget {
  const CreateMagazinePage({super.key});

  @override
  State<CreateMagazinePage> createState() => _CreateMagazinePageState();
}

class _CreateMagazinePageState extends State<CreateMagazinePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isPrivate = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validate() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le titre est obligatoire")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$backendBaseUrl/magazine'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": title,
        "description": description,
        "private": _isPrivate,
        "owner": 12,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erreur lors de la création');
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un magazine"),
        actions: [
          TextButton(
            onPressed: _validate,
            child: const Text(
              "Valider",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Titre du magazine",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Entrer un nom",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Ajouter une courte description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SwitchListTile(
              title: const Text("Magazine privé"),
              subtitle: Text(_isPrivate ? "Oui" : "Non"),
              value: _isPrivate,
              activeThumbColor: Colors.red,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
