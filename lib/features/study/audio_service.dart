import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  String? _loadedPath;

  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> preload(String path) async {
    if (path.isEmpty) {
      return;
    }

    if (_loadedPath == path) {
      return;
    }

    await _player.setSource(DeviceFileSource(path));

    _loadedPath = path;
  }

  // Future<void> play(String path) async {
  //   if (path.isEmpty) {
  //     return;
  //   }

  //   if (_loadedPath != path) {
  //     await preload(path);
  //   }

  //   await _player.seek(Duration.zero);

  //   await _player.resume();
  // }

  Future<void> play(String path) async {
    print('AUDIO PLAY: $path');

    if (path.isEmpty) {
      return;
    }

    if (_loadedPath != path) {
      await preload(path);
    }

    await _player.seek(Duration.zero);

    await _player.resume();
  }
  ///////

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
