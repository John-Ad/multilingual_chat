class Settings {
  int id;
  String apiKey;
  int maxTokens;
  int contextMessagesCount;

  Settings(
      {required this.id,
      required this.apiKey,
      required this.maxTokens,
      required this.contextMessagesCount});

  static Settings fromMap(Map<String, dynamic> map) {
    return Settings(
        id: map['id'],
        apiKey: map['api_key'],
        maxTokens: map['max_tokens'],
        contextMessagesCount: map['context_messages_count']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'api_key': apiKey,
      'max_tokens': maxTokens,
      'context_messages_count': contextMessagesCount
    };
  }
}
