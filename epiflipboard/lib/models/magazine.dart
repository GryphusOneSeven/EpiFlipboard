class Magazine {
  final String name;
  final String description;
  final String private;

  Magazine({
    required this.name,
    required this.description,
    required this.private,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      private: json["private"] ?? "false",
    );
  }

}