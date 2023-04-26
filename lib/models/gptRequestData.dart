class GPTRequestMessage {
  String role;
  String content;

  GPTRequestMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {"role": role, "content": content};
}

class GPTRequestData {
  String model;
  List<GPTRequestMessage> messages;
  int n;
  int max_tokens;
  double? temperature;
  double? frequency_penalty;
  double? presence_penalty;

  GPTRequestData({
    required this.model,
    required this.messages,
    required this.n,
    required this.max_tokens,
    this.temperature,
    this.frequency_penalty,
    this.presence_penalty,
  });

  Map<String, dynamic> toJson() => {
        "model": model,
        "messages": messages,
        "n": n,
        "max_tokens": max_tokens,
        "temperature": temperature ?? 0.0,
        "frequency_penalty": frequency_penalty ?? 0.0,
        "presence_penalty": presence_penalty ?? 0.0,
      };
}
