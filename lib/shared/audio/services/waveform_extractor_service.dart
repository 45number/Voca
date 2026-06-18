import 'dart:io';

import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';

class WaveformExtractorService {
  Future<List<double>> extract(String audioPath) async {
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
        return progress.waveform!.data.map((e) => e.abs() / 32768.0).toList();
      }
    }

    throw Exception('Waveform extraction failed');
  }
}
