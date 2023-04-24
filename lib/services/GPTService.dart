import 'dart:convert';
import 'package:http/http.dart' as http;

class GPTService {
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
    return "";
  }

  static Future<String> getEnglishTranslation(String message) async {
    return "";
  }

  static Future<String> getGermanCorrection(String message) async {
    return "";
  }
}
