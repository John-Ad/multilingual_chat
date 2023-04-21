import 'package:flutter/foundation.dart';

class Conversation {
  int id;
  String name;
  String createdAt;
  String updatedAt;

  Conversation({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  static fromMap(Map<String, dynamic> map) {
    // print type of map['created_at']
    debugPrint(map['created_at'].runtimeType.toString());

    return Conversation(
      id: map['id'],
      name: map['name'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
