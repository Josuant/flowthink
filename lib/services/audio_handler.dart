import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

// Feed your own stream of bytes into the player
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class AudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playRawPCM(Uint8List pcmData) async {
    try {
      // Crear encabezado WAV
      Uint8List wavHeader = _createWavHeader(
        pcmData.length,
        sampleRate: 24000,
        channels: 1,
        bitsPerSample: 16,
      );

      // Combinar encabezado con datos PCM
      Uint8List wavData = Uint8List.fromList(wavHeader + pcmData);

      await _audioPlayer.setAudioSource(MyCustomSource(wavData));
      await _audioPlayer.play();
    } catch (e) {
      print("Error al reproducir audio: $e");
    }
  }

  // Crear encabezado WAV
  Uint8List _createWavHeader(int pcmDataLength,
      {required int sampleRate,
      required int channels,
      required int bitsPerSample}) {
    int fileSize = 44 +
        pcmDataLength; // Tamaño total del archivo (44 bytes de encabezado + datos PCM)
    int byteRate = sampleRate * channels * (bitsPerSample ~/ 8);

    // Encabezado WAV en formato little-endian
    return Uint8List.fromList([
      // ChunkID: "RIFF"
      0x52, 0x49, 0x46, 0x46,
      // ChunkSize (fileSize - 8)
      ..._intToBytes(fileSize - 8, 4),
      // Format: "WAVE"
      0x57, 0x41, 0x56, 0x45,
      // Subchunk1ID: "fmt "
      0x66, 0x6D, 0x74, 0x20,
      // Subchunk1Size: 16 (PCM)
      0x10, 0x00, 0x00, 0x00,
      // AudioFormat: 1 (PCM)
      0x01, 0x00,
      // NumChannels
      ..._intToBytes(channels, 2),
      // SampleRate
      ..._intToBytes(sampleRate, 4),
      // ByteRate
      ..._intToBytes(byteRate, 4),
      // BlockAlign
      ..._intToBytes(channels * (bitsPerSample ~/ 8), 2),
      // BitsPerSample
      ..._intToBytes(bitsPerSample, 2),
      // Subchunk2ID: "data"
      0x64, 0x61, 0x74, 0x61,
      // Subchunk2Size (pcmDataLength)
      ..._intToBytes(pcmDataLength, 4),
    ]);
  }

  // Convierte un entero a bytes little-endian
  List<int> _intToBytes(int value, int byteCount) {
    return List.generate(byteCount, (index) => (value >> (index * 8)) & 0xFF);
  }
}
