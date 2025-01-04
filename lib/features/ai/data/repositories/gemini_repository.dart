import 'package:flow/features/ai/data/datasources/ia_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiRepository {
  final GeminiService iaService;
  late GenerativeModel _model;

  GeminiRepository(this.iaService);

  void initializeModel() {
    _model = iaService.createModel(
      'gemini-2.0-flash-exp',
      GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      'Generate an json of "animationData" for animate a flow diagram.\nTypes and params avaliables:\ngenerateFirst(id,text)\ngenerateAt(idNew,text,direction,idOld,connectedTrueOrFalse)\ndragAt(id,direction)\nconnect(idA,idB)\ncombine(idA,idB)\n\nIf there is a previus list, just add the necessary commands.',
    );
  }

  Future<String?> getIAResponse(
      List<Content>? chatHistory, String query) async {
    String? response = await iaService.sendQuery(_model, chatHistory, query);
    return response;
  }
}
