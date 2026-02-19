class Article {
  final String title;
  final String source;
  final String imageUrl;
  final String url;

  Article({
    required this.title,
    required this.source,
    required this.imageUrl,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json["title"] ?? "",
      source: json["source"]?["name"] ?? "",
      imageUrl: json["urlToImage"] ??
          "https://via.placeholder.com/120x90.png?text=No+Image",
      url: json["url"] ?? "",
    );
  }
}
