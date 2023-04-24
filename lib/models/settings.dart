class Settings {
  int id;
  String apiKey;

  Settings({required this.id, required this.apiKey});

  static Settings fromMap(Map<String, dynamic> map) {
    return Settings(id: map['id'], apiKey: map['api_key']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'api_key': apiKey,
    };
  }
}
