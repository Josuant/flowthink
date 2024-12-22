import 'dart:async';
import 'dart:typed_data';
import 'package:openai_realtime_dart/openai_realtime_dart.dart';
import 'package:record/record.dart';

import 'openai_response_handler.dart';

class OpenAIService {
  final String apiKey;
  late RealtimeClient _client;
  final StreamController<String> _messageController =
      StreamController<String>();
  List<FormattedItem>? items;
  Stream<Uint8List>? stream;
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  OpenAIResponseHandler? _openAIResponseHandler;

  OpenAIService({required this.apiKey}) {
    _openAIResponseHandler = OpenAIResponseHandler();
    _initializeClient();
  }

  void _initializeClient() {
    _client = RealtimeClient(apiKey: apiKey);

    // Configurar la sesión
    _client.updateSession(
        voice: Voice.ash,
        turnDetection: const TurnDetection(type: TurnDetectionType.serverVad),
        instructions:
            'Eres un asistente amigable. Contesta las preguntas del usuario',
        inputAudioTranscription: const InputAudioTranscriptionConfig(
          model: 'whisper-1',
        ));

    // Manejar eventos de conversación actualizada
    _client.on(RealtimeEventType.conversationUpdated, (event) {
      final result = (event as RealtimeEventConversationUpdated).result;
      final item = result.item;
      final delta = result.delta;
      // get all items, e.g. if you need to update a chat window
      items = _client.conversation.getItems();

      if (item?.item case final ItemMessage message) {
        if (message.role == ItemRole.assistant) {
          final json = item?.toJson();
          _openAIResponseHandler?.addAudioToBuffer(json!);
          _messageController
              .add(_openAIResponseHandler!.getResponseText(json!));
        }
      } else if (item?.item case final ItemFunctionCall functionCall) {
      } else if (item?.item
          case final ItemFunctionCallOutput functionCallOutput) {}

      if (delta != null) {}
    });

    _client.on(RealtimeEventType.conversationItemCompleted, (event) {
      final item = (event as RealtimeEventConversationItemCompleted).item;

      if (item.item case final ItemMessage message) {
        if (message.role == ItemRole.assistant) {
          final json = item.toJson();
          _openAIResponseHandler?.addAudioToBuffer(json);
        }
      }
    });
    _client.connect();
    sendMessage("hola");
  }

  final _record = AudioRecorder();

  Future<void> startRecording() async {
    // Verificar y solicitar permisos si es necesario
    if (await _record.hasPermission()) {
      // Configurar la sesión con la frecuencia de muestreo correcta
      const int sampleRate = 24000;

      // Iniciar el stream de grabación
      Stream<Uint8List> stream = await _record.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: sampleRate,
        numChannels: 1,
      ) // Canal mono
          );

      // Escuchar el stream y enviar datos al cliente conforme llegan
      _audioStreamSubscription = stream.listen((data) async {
        // Enviar datos de audio al cliente
        await _client.appendInputAudio(data);
      }, onError: (err) {
        print('Error en el stream de audio: $err');
      });
    } else {
      print('Permiso de micrófono no concedido');
    }
  }

  Future<void> stopRecording() async {
    // Detener la grabación
    await _record.stop();

    // Cancelar la suscripción al stream
    await _audioStreamSubscription?.cancel();
    _audioStreamSubscription = null;

    // Comprometer cualquier audio pendiente y solicitar una respuesta
    await _client.createResponse();
  }

  Future<void> connect() async {
    await _client.connect();
  }

  Future<void> disconnect() async {
    await _client.disconnect();
    await _messageController.close();
  }

  Future<void> sendMessage(String message) async {
    await _client.sendUserMessageContent([
      ContentPart.text(text: message),
    ]);
  }

  Stream<String> get messages => _messageController.stream;
}
