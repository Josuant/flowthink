import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;

  GeminiService(this.apiKey);

  GenerativeModel createModel(
      String modelName, GenerationConfig config, String systemInstruction) {
    return GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: config,
      systemInstruction: Content.system(systemInstruction),
    );
  }

  Future<String?> sendQuery(
      GenerativeModel model, List<Content>? chatHistory, String query) async {
    final chat = model.startChat(history: chatHistory);
    final response = await chat.sendMessage(Content.text(query));
    return response.text;
  }
}
