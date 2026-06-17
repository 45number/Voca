import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Timer? _timer;

  Duration? currentDuration;

  bool isPlaying = false;

  Duration? pausedPosition;

  Stream<Duration> get positionStream {
    return _player.onPositionChanged;
  }

  Future<void> playSegment({
    required String path,

    required int trimStart,

    required int trimEnd,

    required int sampleCount,
  }) async {
    await _player.stop();

    await _player.setSource(DeviceFileSource(path));

    final duration = await _player.getDuration();

    currentDuration = duration;

    // print("DURATION");
    // print(duration?.inMilliseconds);

    if (duration == null || sampleCount == 0) {
      return;
    }

    final startMs = (trimStart / sampleCount) * duration.inMilliseconds;

    final endMs = (trimEnd / sampleCount) * duration.inMilliseconds;

    await _player.seek(Duration(milliseconds: startMs.round()));

    await _player.resume();

    isPlaying = true;

    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: (endMs - startMs).round()), () async {
      await _player.pause();
      isPlaying = false;
    });
  }

  Future<void> pause() async {
    pausedPosition = await _player.getCurrentPosition();

    await _player.pause();

    _timer?.cancel();

    isPlaying = false;
  }

  Future<void> resume() async {
    if (pausedPosition != null) {
      await _player.seek(pausedPosition!);
    }

    await _player.resume();

    isPlaying = true;
  }

  Future<void> dispose() async {
    _timer?.cancel();

    await _player.dispose();
  }
}
