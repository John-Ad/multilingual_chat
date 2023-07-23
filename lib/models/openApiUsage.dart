class OpenApiUsage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  OpenApiUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  static OpenApiUsage fromMap(Map<String, dynamic> map) {
    return OpenApiUsage(
      promptTokens: map['prompt_tokens'],
      completionTokens: map['completion_tokens'],
      totalTokens: map['total_tokens'],
    );
  }
}
