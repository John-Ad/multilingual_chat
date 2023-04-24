class Message {
  int id;
  bool isUserMessage;
  int conversationId;
  String? correction;
  String content;
  String? translation;
  String createdAt;
  String updatedAt;

  Message({
    required this.id,
    required this.isUserMessage,
    required this.conversationId,
    this.correction,
    required this.content,
    this.translation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        id: json["id"],
        isUserMessage: json["is_user_message"] == 1 ? true : false,
        conversationId: json["conversation_id"],
        correction: json["correction"],
        content: json["content"],
        translation: json["translation"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
