class Language {
  int id;
  String name;

  Language({
    required this.id,
    required this.name,
  });

  factory Language.fromMap(Map<String, dynamic> json) => Language(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
