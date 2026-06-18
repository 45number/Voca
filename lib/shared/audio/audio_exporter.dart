import 'audio_edit_result.dart';

abstract class AudioExporter {
  Future<String> export(AudioEditResult result);
}
