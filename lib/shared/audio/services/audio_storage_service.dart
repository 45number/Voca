import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AudioStorageService {
  Future<Directory> getAudioDirectory() async {
    final dir = await getApplicationDocumentsDirectory();

    final audioDir = Directory(p.join(dir.path, 'audio'));

    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    return audioDir;
  }

  Future<String> getAudioPath(String audioId) async {
    final dir = await getAudioDirectory();

    return p.join(dir.path, audioId);
  }

  Future<File> getFile(String audioId) async {
    final path = await getAudioPath(audioId);

    return File(path);
  }

  Future<bool> exists(String audioId) async {
    final file = await getFile(audioId);

    return file.exists();
  }

  Future<void> delete(String audioId) async {
    final file = await getFile(audioId);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<File>> getAllFiles() async {
    final dir = await getAudioDirectory();

    if (!await dir.exists()) {
      return [];
    }

    return dir.listSync().whereType<File>().toList();
  }
}
