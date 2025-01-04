import 'package:flow/features/ai/data/repositories/gemini_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class IANotifier extends StateNotifier<AsyncValue<String>> {
  final GeminiRepository iaRepository;
  List<Content> _chatHistory = [];

  IANotifier(this.iaRepository) : super(const AsyncValue.loading());

  void init() {
    iaRepository.initializeModel();
    resetChat();
  }

  Future<void> fetchResponse(String query) async {
    state = const AsyncValue.loading();

    try {
      if (_chatHistory.isEmpty) {
        query = 'Diagram about: $query';
      } else {
        query = 'Only respond to the necessary changes: $query';
      }

      // Agrega la consulta al historial
      _chatHistory.add(Content.text(query));

      // Obtiene la respuesta del modelo
      final response = await iaRepository.getIAResponse(_chatHistory, query);

      // Agrega la respuesta al historial
      _chatHistory.add(Content.text(response ?? ' '));

      // Actualiza el estado con la respuesta
      state = AsyncValue.data(response ?? ' ');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void resetChat() {
    _chatHistory = [];
  }

  void clear() {
    state = const AsyncValue.loading();
  }
}
