import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'audio_handler.dart';

class OpenAIResponseHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioHandler _audioHandler = AudioHandler();

  final List<Uint8List> _audioBuffer =
      []; // Buffer para almacenar fragmentos de audio
  bool _isPlaying = false; // Para evitar múltiples reproducciones simultáneas

  // Obtener texto de la respuesta
  String getResponseText(Map<String, dynamic> json) {
    // Extraer el texto del transcript en "formatted"
    if (json.containsKey('formatted') &&
        json['formatted']['transcript'] != null) {
      return json['formatted']['transcript'];
    }
    // Si no está en "formatted", busca en "item.content"
    if (json.containsKey('item') && json['item']['content'] != null) {
      final content = json['item']['content'] as List;
      for (var part in content) {
        if (part['transcript'] != null) {
          return part['transcript'];
        }
      }
    }
    return "";
  }

  // Añadir fragmento de audio al buffer
  void addAudioToBuffer(Map<String, dynamic> json) {
    if (json.containsKey('formatted') && json['formatted']['audio'] != null) {
      final audioList = json['formatted']['audio'] as List<int>;
      if (audioList.isNotEmpty) {
        _audioBuffer.add(Uint8List.fromList(audioList));
        if (!_isPlaying) {
          _playFromBuffer(); // Inicia la reproducción si no hay audio en curso
        }
      } else {
        print("Lista de audio vacía.");
      }
    } else {
      print("No se encontró audio en el JSON.");
    }
  }

  // Reproducir desde el buffer
  Future<void> _playFromBuffer() async {
    if (_audioBuffer.isEmpty) {
      _isPlaying = false;
      return;
    }

    _isPlaying = true;

    try {
      final audioData =
          _audioBuffer.removeAt(0); // Saca el primer fragmento del buffer
      await _audioHandler.playRawPCM(audioData); // Reproduce el fragmento
    } catch (e) {
      print("Error al reproducir audio: $e");
    } finally {
      if (_audioBuffer.isNotEmpty) {
        await _playFromBuffer(); // Reproduce el siguiente fragmento si existe
      } else {
        _isPlaying = false;
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
