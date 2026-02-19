class Magazine {
  final String name;
  final String description;
  final String private;
  final int owner;

  Magazine({
    required this.name,
    required this.description,
    required this.private,
    required this.owner,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      private: json["private"] ?? "false",
      owner: json["owner"] ?? 0,
    );
  }

}