class Magazine {
  final String name;
  final String description;
  final String private;
  final int owner;
  final int id;

  Magazine({
    required this.name,
    required this.description,
    required this.private,
    required this.owner,
    required this.id,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      private: json["private"] ?? "false",
      owner: json["owner"] ?? 0,
      id: json["id"] ?? 0,
    );
  }

}