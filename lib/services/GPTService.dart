import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multilingual_chat/models/gptRequestData.dart';
import 'package:multilingual_chat/models/message.dart';
import 'package:multilingual_chat/services/SettingsService.dart';
import 'package:http/http.dart' as http;

class GPTService {
  static final SettingsService _settingsService = SettingsService();

  static const String _url = "https://api.openai.com/v1/chat/completions";

  static const _model = "gpt-3.5-turbo-0613";

  static const String _topicSystemPrompt = """
You are a tutor helping a student learn (language). The topic is: (topic).
""";

  static const String _languageResponsePrompt = """
  shortly respond in (language):
  (prompt)
  """;

  static const String _englishTranslationPrompt = """
  shortly translate to english:
  (prompt)
  """;

  static const String _languageCorrectionPrompt = """
  shortly correct the following (language) without an explanation:
  (prompt)
  """;

  static Future<String> getResponseInChosenLanguage(
    String language,
    String topic,
    List<Message> contextMessages,
    String message,
  ) async {
    return _getResponse(
      contextMessages,
      _languageResponsePrompt
          .replaceAll("(language)", language)
          .replaceAll("(prompt)", message),
      topicContextMessage: topic,
      language: language,
    );
  }

  static Future<String> getEnglishTranslation(
    List<Message> contextMessages,
    String message,
  ) async {
    return _getResponse(
      contextMessages,
      _englishTranslationPrompt.replaceAll("(prompt)", message),
    );
  }

  static Future<String> getLanguageCorrection(
    String language,
    List<Message> contextMessages,
    String message,
  ) async {
    return _getResponse(
      contextMessages,
      _languageCorrectionPrompt
          .replaceAll("(language)", language)
          .replaceAll("(prompt)", message),
    );
  }

  static Future<String> _getResponse(
    List<Message> contextMessages,
    String message, {
    String topicContextMessage = "",
    String language = "",
  }) async {
    try {
      final settings = await _settingsService.getSettings();
      if (settings == null) {
        throw Exception('Failed to load settings');
      }

      final apiKey = settings.apiKey;
      final maxTokens = settings.maxTokens;
      final contextMessagesCount = settings.contextMessagesCount;
      if (apiKey.isEmpty) {
        throw Exception('Failed to load api key');
      }

      var skipCount = contextMessages.length - contextMessagesCount;
      contextMessages =
          contextMessages.skip(skipCount < 0 ? 0 : skipCount).toList();

      final List<GPTRequestMessage> contextReqMessages = contextMessages
          .map((e) => GPTRequestMessage(
                role: e.isUserMessage ? "user" : "assistant",
                content: e.content,
              ))
          .toList();

      GPTRequestMessage topicContext = GPTRequestMessage(
        role: "system",
        content: _topicSystemPrompt
            .replaceAll("(language)", language)
            .replaceAll("(topic)", topicContextMessage),
      );
      GPTRequestMessage reqMessage = GPTRequestMessage(
        role: "user",
        content: message,
      );

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(GPTRequestData(
          model: _model,
          messages: [
            if (topicContextMessage.isNotEmpty) topicContext,
            ...contextReqMessages,
            reqMessage,
          ],
          n: 1,
          max_tokens: maxTokens,
        )),
      );

      if (response.statusCode == 200) {
        final responseData = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(responseData);
        final returnMessage = jsonData['choices'][0]['message'];
        return returnMessage['content'];
      } else {
        debugPrint(response.body);
        throw Exception('Failed to generate text: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }
}
