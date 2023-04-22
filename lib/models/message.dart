class Message {
  int id;
  int conversationId;
  String? correction;
  String content;
  String? translation;
  int createdAt;
  int updatedAt;

  Message({
    required this.id,
    required this.conversationId,
    this.correction,
    required this.content,
    this.translation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        id: json["id"],
        conversationId: json["conversation_id"],
        correction: json["correction"],
        content: json["content"],
        translation: json["translation"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
