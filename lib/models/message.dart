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
}
