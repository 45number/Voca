import 'package:just_waveform/just_waveform.dart';

import 'audio_trim_result.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AudioService {
  Future<AudioTrimResult> detectSilence(String path) async {
    throw UnimplementedError();
  }

  Future<String> trimAudio(String path, double start, double end) async {
    throw UnimplementedError();
  }

  Future<Waveform> generateWaveform(String audioPath) async {
    final tempDir = await getTemporaryDirectory();

    final waveFile = File(
      '${tempDir.path}/'
      '${DateTime.now().millisecondsSinceEpoch}.wave',
    );

    final stream = JustWaveform.extract(
      audioInFile: File(audioPath),

      waveOutFile: waveFile,
    );

    await for (final progress in stream) {
      if (progress.waveform != null) {
        return progress.waveform!;
      }
    }

    throw Exception('Waveform extraction failed');
  }
}
