import 'package:flutter/foundation.dart';
import 'package:german_tutor/models/DBContext.dart';
import 'package:german_tutor/models/conversation.dart';
import 'package:sqflite/sqflite.dart';

class ConversationsService {
  late Database db;

  ConversationsService() {
    init();
  }

  void init() async {
    db = await DBContext.database;
  }

  /// Get all conversations.
  ///
  /// @return List<Conversation> of conversations.
  Future<List<Conversation>> getAll() async {
    try {
      var conversations = await db.query('Conversation');
      List<Conversation> result = [];

      for (var element in conversations) {
        result.add(Conversation.fromMap(element));
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  /// Get a conversation by id.
  ///
  /// @param id The id of the conversation.
  ///
  /// @return Conversation? The conversation if it exists, null otherwise.
  Future<Conversation?> getById(int id) async {
    try {
      var conversation = await db.query('Conversation',
          where: 'id = ?', whereArgs: [id], limit: 1);

      if (conversation.isEmpty) {
        return null;
      }

      return Conversation.fromMap(conversation[0]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  /// Add a conversation.
  ///
  /// @param name The name of the conversation.
  ///
  /// @return bool True if the conversation was added, false otherwise.
  Future<bool> add(String name) async {
    try {
      await db.insert('Conversation', {'name': name});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  /// Delete a conversation by id.
  ///
  /// @param id The id of the conversation.
  ///
  /// @return bool True if the conversation was deleted, false otherwise.
  Future<bool> deleteById(int id) async {
    try {
      await db.delete('Conversation', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
