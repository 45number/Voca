// import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() {
    return _recorder.hasPermission();
  }

  Future<String?> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();

    final path =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(const RecordConfig(), path: path);

    return path;
  }

  Future<String?> stopRecording() async {
    return _recorder.stop();
  }

  Future<bool> isRecording() {
    return _recorder.isRecording();
  }

  Stream<Amplitude> onAmplitudeChanged() {
    return _recorder.onAmplitudeChanged(const Duration(milliseconds: 100));
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
