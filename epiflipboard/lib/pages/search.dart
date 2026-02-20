import 'package:flutter/material.dart';
// import '../services/newsAPI.dart';
import './results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // final NewsApiService _newsService = NewsApiService();
  final TextEditingController _searchController = TextEditingController();

final List<Map<String, dynamic>> themes = [
  {
    "name": "Français",
    "items": [
      {"title": "Le monde", "id": "le-monde", "image": "https://picsum.photos/400/600?1"},
      {"title": "L'equipe", "id": "lequipe", "image": "https://picsum.photos/400/600?2"},
      {"title": "Les echos", "id": "les_echos", "image": "https://picsum.photos/400/600?3"},
    ],
  },
  {
    "name": "Anglais",
    "items": [
      {"title": "ABC News", "id": "abc-news", "image": "https://picsum.photos/400/600?4"},
      {"title": "BBC News", "id": "bbc-news", "image": "https://picsum.photos/400/600?5"},
      {"title": "Bloomberg", "id": "bloomberg", "image": "https://picsum.photos/400/600?6"},
    ],
  },
  {
    "name": "Allemand",
    "items": [
      {"title": "Bild", "id": "bild", "image": "https://picsum.photos/400/600?7"},
      {"title": "Der Tagesspiegel", "id": "der-tagesspiegel", "image": "https://picsum.photos/400/600?8"},
      {"title": "Die Zeit", "id": "die-zeit", "image": "https://picsum.photos/400/600?9"},
    ],
  },
  {
    "name": "Espagnol",
    "items": [
      {"title": "CNN Spanish", "id": "cnn-es", "image": "https://picsum.photos/400/600?10"},
      {"title": "El Mundo", "id": "el-mundo", "image": "https://picsum.photos/400/600?11"},
    ],
  },
  {
    "name": "Italien",
    "items": [
      {"title": "ANSA.it", "id": "ansa", "image": "https://picsum.photos/400/600?12"},
      {"title": "Il Sole 24 Ore", "id": "il-sole-24-ore", "image": "https://picsum.photos/400/600?13"},
    ],
  },
  {
    "name": "Russe",
    "items": [
      {"title": "Lenta", "id": "lenta", "image": "https://picsum.photos/400/600?11"},
      {"title": "RBC", "id": "rbc", "image": "https://picsum.photos/400/600?12"},
    ],
  },
];

  String selectedTheme = "Français";

Widget _buildSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: (query) {
        if (query.trim().isEmpty) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchResultsPage(query: query),
          ),
        );
      },
      decoration: InputDecoration(
        hintText: "Rechercher sur epiFlipboard",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

Widget _buildThemeCarousel() {
  return SizedBox(
    height: 60,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final bool isSelected = theme["name"] == selectedTheme;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTheme = theme["name"];
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade200,
            ),
            alignment: Alignment.center,
            child: Text(
              theme["name"],
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

Widget _buildThemeItems() {
  final theme = themes.firstWhere(
    (t) => t["name"] == selectedTheme,
  );

  final List items = theme["items"];

  return Padding(
    padding: const EdgeInsets.all(16),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  item["image"],
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(2),
                ),
              ),

              Center(
                child: Text(
                  item["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explorer")
        ),
        body: ListView(
          children: [
            _buildSearchBar(context),
            _buildThemeCarousel(), 
            _buildThemeItems()]));
  }
}