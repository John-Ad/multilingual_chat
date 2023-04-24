class Settings {
  String apiKey;

  Settings({required this.apiKey});

  static Settings fromMap(Map<String, dynamic> map) {
    return Settings(apiKey: map['api_key']);
  }

  Map<String, dynamic> toMap() {
    return {'api_key': apiKey};
  }
}
