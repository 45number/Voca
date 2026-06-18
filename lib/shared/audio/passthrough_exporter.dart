import 'audio_exporter.dart';
import 'audio_edit_result.dart';

class PassthroughExporter implements AudioExporter {
  @override
  Future<String> export(AudioEditResult result) async {
    return result.sourcePath;
  }
}
