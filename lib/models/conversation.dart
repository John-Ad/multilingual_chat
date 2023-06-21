import 'package:flutter/foundation.dart';

class Conversation {
  int id;
  int languageId;
  String name;
  String createdAt;
  String updatedAt;
  String? languageName;

  Conversation({
    required this.id,
    required this.languageId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.languageName,
  });

  static fromMap(Map<String, dynamic> map) {
    // print type of map['created_at']
    debugPrint(map['created_at'].runtimeType.toString());

    return Conversation(
      id: map['id'],
      languageId: map['language_id'],
      name: map['name'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      languageName: map['language_name'],
    );
  }
}
