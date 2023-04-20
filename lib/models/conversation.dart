class Conversation {
  int id;
  String name;
  int createdAt;
  int updatedAt;

  Conversation({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  static fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      name: map['name'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
