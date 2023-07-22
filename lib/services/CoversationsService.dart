import 'package:flutter/foundation.dart';
import 'package:multilingual_chat/models/DBContext.dart';
import 'package:multilingual_chat/models/conversation.dart';
import 'package:sqflite/sqflite.dart';

class ConversationsService {
  late Database db;
  bool dbLoaded = false;

  ConversationsService() {
    init();
  }

  Future<void> init() async {
    try {
      db = await DBContext.database;
    } catch (e) {
      debugPrint("Error: $e");
    }
    dbLoaded = true;
  }

  /// Get all conversations.
  ///
  /// @return List<Conversation> of conversations.
  Future<List<Conversation>> getAll() async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var conversations = await db.rawQuery(
        """
        SELECT
          Conversation.id,
          Conversation.language_id,
          Conversation.name,
          Conversation.created_at,
          Conversation.updated_at,
          Language.name as language_name
        FROM Conversation
        JOIN Language ON Conversation.language_id = Language.id
        """,
        [],
      );
      // debugPrint(conversations.toString());
      List<Conversation> result = [];

      for (var element in conversations) {
        result.add(Conversation.fromMap(element));
      }
      // debugPrint(result.toString());

      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Get all convos: $e");
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
      if (!dbLoaded) {
        await init();
      }

      var conversation = await db.rawQuery(
        """
        SELECT
          Conversation.id,
          Conversation.language_id,
          Conversation.name,
          Conversation.created_at,
          Conversation.updated_at,
          Language.name as language_name
        FROM Conversation
        JOIN Language ON Conversation.language_id = Language.id
        WHERE Conversation.id = ?
        LIMIT 1
        """,
        [id],
      );

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
  /// @param languageId The id of the language.
  ///
  /// @param name The name of the conversation.
  ///
  /// @return int: Id of record if successful, 0 otherwise.
  Future<int> add(int languageId, String name) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      return await db.insert('Conversation', {
        'language_id': languageId,
        'name': name,
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Add Convo: $e");
      }
      return 0;
    }
  }

  /// Delete a conversation by id.
  ///
  /// @param id The id of the conversation.
  ///
  /// @return bool True if the conversation was deleted, false otherwise.
  Future<bool> deleteById(int id) async {
    try {
      if (!dbLoaded) {
        await init();
      }

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
