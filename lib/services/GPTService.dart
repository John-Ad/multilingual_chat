import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:german_tutor/models/gptRequestData.dart';
import 'package:german_tutor/models/message.dart';
import 'package:german_tutor/services/SettingsService.dart';
import 'package:http/http.dart' as http;

class GPTService {
  static final SettingsService _settingsService = SettingsService();

  static const String _url = "https://api.openai.com/v1/chat/completions";

  static const _model = "gpt-3.5-turbo";

  static const String _germanResponsePrompt = """
  respond shortly in german:
  (prompt)
  """;

  static const String _englishTranslationPrompt = """
  shortly translate to english:
  (prompt)
  """;

  static const String _germanCorrectionPrompt = """
  in german shortly correct no explanation:
  (prompt)
  """;

  static Future<String> getGermanResponse(
      List<Message> contextMessages, String message) async {
    return _getResponse(
        contextMessages, _germanResponsePrompt.replaceAll("(prompt)", message));
  }

  static Future<String> getEnglishTranslation(
      List<Message> contextMessages, String message) async {
    return _getResponse(contextMessages,
        _englishTranslationPrompt.replaceAll("(prompt)", message));
  }

  static Future<String> getGermanCorrection(
      List<Message> contextMessages, String message) async {
    return _getResponse(contextMessages,
        _germanCorrectionPrompt.replaceAll("(prompt)", message));
  }

  static Future<String> _getResponse(
      List<Message> contextMessages, String message) async {
    try {
      final settings = await _settingsService.getSettings();
      if (settings == null) {
        throw Exception('Failed to load api key');
      }

      final apiKey = settings.apiKey;
      if (apiKey.isEmpty) {
        throw Exception('Failed to load api key');
      }

      final List<GPTRequestMessage> contextReqMessages = contextMessages
          .map((e) => GPTRequestMessage(
                role: e.isUserMessage ? "user" : "assistant",
                content: e.content,
              ))
          .toList();

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
          messages: [...contextReqMessages, reqMessage],
          n: 1,
          max_tokens: 100,
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
