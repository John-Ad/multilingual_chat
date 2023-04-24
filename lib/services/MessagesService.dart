import 'package:flutter/foundation.dart';
import 'package:german_tutor/models/DBContext.dart';
import 'package:german_tutor/models/message.dart';
import 'package:sqflite/sqflite.dart';

class MessagesService {
  late Database db;
  bool dbLoaded = false;

  MessagesService() {
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

  /// Get messages for a conversation.
  ///
  /// @param conversationId The id of the conversation.
  ///
  /// @return List<Message> of messages.
  Future<List<Message>> getMessagesForConversation(int conversationId) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      var messages = await db.query('Message',
          where: 'conversation_id = ?', whereArgs: [conversationId]);

      List<Message> result = [];

      for (var element in messages) {
        result.add(Message.fromMap(element));
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("MessagesService getAll: $e");
      }
      return [];
    }
  }

  /// Add a message to a conversation.
  ///
  /// @param conversationId The id of the conversation.
  ///
  /// @param content The content of the message.
  ///
  /// @return int The id of the message.
  Future<int> add(
      int conversationId, String content, bool isUserMessage) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      return await db.insert('Message', {
        "is_user_message": isUserMessage ? 1 : 0,
        "conversation_id": conversationId,
        "content": content,
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint("MessagesService: $e");
      }
      return 0;
    }
  }

  /// Update a message.
  ///
  /// @param id The id of the message.
  ///
  /// @param correction The correction of the message.
  ///
  /// @param translation The translation of the message.
  ///
  /// @return bool True if successful, false otherwise.
  Future<bool> update(int id, String? correction, String? translation) async {
    try {
      if (!dbLoaded) {
        await init();
      }

      if (correction == null && translation == null) {
        return true;
      }

      Map<String, dynamic> updateData = {};
      if (correction != null) {
        updateData["correction"] = correction;
      }
      if (translation != null) {
        updateData["translation"] = translation;
      }

      await db.update('Message', updateData, where: 'id = ?', whereArgs: [id]);

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("MessagesService: $e");
      }
      return false;
    }
  }
}
