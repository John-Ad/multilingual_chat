import 'dart:convert';
import 'package:german_tutor/models/gptRequestData.dart';
import 'package:german_tutor/services/SettingsService.dart';
import 'package:http/http.dart' as http;

class GPTService {
  static final SettingsService _settingsService = SettingsService();

  static const String _url = "https://api.openai.com/v1/completions";

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

  static Future<String> getGermanResponse(String message) async {
    return _getResponse(_germanResponsePrompt.replaceAll("(prompt)", message));
  }

  static Future<String> getEnglishTranslation(String message) async {
    return _getResponse(
        _englishTranslationPrompt.replaceAll("(prompt)", message));
  }

  static Future<String> getGermanCorrection(String message) async {
    return _getResponse(
        _germanCorrectionPrompt.replaceAll("(prompt)", message));
  }

  static Future<String> _getResponse(String message) async {
    try {
      final settings = await _settingsService.getSettings();
      if (settings == null) {
        throw Exception('Failed to load api key');
      }

      final apiKey = settings.apiKey;
      if (apiKey.isEmpty) {
        throw Exception('Failed to load api key');
      }

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
        body: GPTRequestData(
          model: _model,
          messages: [reqMessage],
          n: 1,
          max_tokens: 100,
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final text = jsonResponse['choices'][0]['text'].toString();
        return text;
      } else {
        throw Exception('Failed to generate text: ${response.statusCode}');
      }
    } catch (e) {
      return "";
    }
  }
}
