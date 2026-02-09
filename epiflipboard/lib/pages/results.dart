import 'package:flutter/material.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({
    super.key,
    required this.query,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {

  final List<String> categories = [
    "Articles",
    "Sujets",
    "Magazines",
    "Personnes",
  ];

  String selectedCategory = "Articles";

Widget _buildCategoryCarousel() {
  return SizedBox(
    height: 56,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final bool isSelected = category == selectedCategory;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade200,
            ),
            child: Text(
              category,
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

Widget _buildArticlesList() {
  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 6,
    separatorBuilder: (_, __) => const Divider(height: 24),
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          // ouvrir l’article
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://picsum.photos/120/90?random=$index",
                width: 120,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Article ${index + 1} sur ${widget.query}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Source · Il y a 2h",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildTopics() {
  return GridView.builder(
    itemCount: 6,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      childAspectRatio: 0.75,
    ),
    itemBuilder: (context, index) {
      // final sub = subscriptions[index];

      return InkWell(
        onTap: () {
          print("yeah");
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const TopicPage(
          //   title: "topic",
          //   topic: "business",
          // )));
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://picsum.photos/400/600?1",
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(80),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Titre",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "description",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMagazines() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 4,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text("Magazine ${widget.query}"),
          subtitle: const Text("Publication hebdomadaire"),
          trailing: ElevatedButton(
            onPressed: () {},
            child: const Text("S’abonner"),
          ),
        ),
      );
    },
  );
}

Widget _buildPeople() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder: (context, index) {
      return ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text("${widget.query} Personne ${index + 1}"),
        subtitle: const Text("Auteur · Journaliste"),
        trailing: TextButton(
          onPressed: () {},
          child: const Text("Suivre"),
        ),
      );
    },
  );
}

Widget _buildResults() {
  switch (selectedCategory) {
    case "Articles":
      return _buildArticlesList();

    case "Sujets":
      return _buildTopics();

    case "Magazines":
      return _buildMagazines();

    case "Personnes":
      return _buildPeople();

    default:
      return const SizedBox();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Résultats : \"${widget.query}\""),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildCategoryCarousel(),
          const SizedBox(height: 12),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }
}
