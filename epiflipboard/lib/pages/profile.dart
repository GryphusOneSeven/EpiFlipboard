import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 16),

            const Text(
              "VOTRE PROFIL",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

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

            const SizedBox(height: 20),
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
