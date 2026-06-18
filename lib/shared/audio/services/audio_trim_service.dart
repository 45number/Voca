// import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class AudioTrimService {
  int findSpeechStart(List<double> waveform) {
    const threshold = 0.20;
    const requiredSamples = 3;

    for (int i = 0; i < waveform.length - requiredSamples; i++) {
      bool speech = true;

      for (int j = 0; j < requiredSamples; j++) {
        if (waveform[i + j] < threshold) {
          speech = false;

          break;
        }
      }

      if (speech) {
        return i;
      }
    }

    return 0;
  }

  int findSpeechEnd(List<double> waveform) {
    const threshold = 0.20;
    const requiredSamples = 3;

    for (int i = waveform.length - 1; i > requiredSamples; i--) {
      bool speech = true;

      for (int j = 0; j < requiredSamples; j++) {
        if (waveform[i - j] < threshold) {
          speech = false;

          break;
        }
      }

      if (speech) {
        return i;
      }
    }

    return waveform.length - 1;
  }

  Future<String> trimFile({
    required String path,
    required double startSeconds,
    required double durationSeconds,
  }) async {
    final dir = await getTemporaryDirectory();

    final outputPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_trimmed.m4a';

    final command =
        '-i "$path" '
        '-ss $startSeconds '
        '-t $durationSeconds '
        '-c copy '
        '"$outputPath"';

    await FFmpegKit.execute(command);

    return outputPath;
  }
}
