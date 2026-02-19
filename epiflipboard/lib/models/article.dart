class Article {
  final String title;
  final String author;
  final String description;
  final String content;
  final String source;
  final String imageUrl;
  final String url;

  Article({
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
    required this.imageUrl,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json["title"] ?? "",
      author: json["author"] ?? "",
      description: json["description"] ?? "",
      content: json["content"] ?? "",
      source: json["source"]?["name"] ?? "",
      imageUrl: json["urlToImage"] ??
          "https://via.placeholder.com/120x90.png?text=No+Image",
      url: json["url"] ?? "",
    );
  }

  factory Article.empty() {
    return Article(
      title: "",
      author: "",
      description: "",
      content: "",
      url: "",
      imageUrl: "",
      source: "",
    );
  }
}
