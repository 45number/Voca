import 'dart:async';

import 'package:flutter/foundation.dart';

import 'audio_player_service.dart';

// import 'audio_trim_service.dart';

import 'audio_edit_result.dart';

class AudioEditorController extends ChangeNotifier {
  final player = AudioPlayerService();

  // final trimService = AudioTrimService();

  StreamSubscription<Duration>? playheadSubscription;

  List<double> samples = [];

  String? path;

  Duration duration = Duration.zero;

  int trimStart = 0;

  int trimEnd = 0;

  double playhead = 0;

  bool isPlaying = false;

  // StreamSubscription<Duration>? subscription;

  void load({
    required String path,
    required List<double> samples,
    required int trimStart,
    required int trimEnd,
    required Duration duration,
  }) {
    this.path = path;

    this.duration = duration;

    this.samples = samples;

    this.trimStart = trimStart;

    this.trimEnd = trimEnd;

    playhead = trimStart.toDouble();

    notifyListeners();
  }

  void setTrimStart(int value) {
    trimStart = value;

    notifyListeners();
  }

  void setTrimEnd(int value) {
    trimEnd = value;

    notifyListeners();
  }

  void setPlayhead(double value) {
    playhead = value;

    notifyListeners();
  }

  void setPlaying(bool value) {
    isPlaying = value;

    notifyListeners();
  }

  void resetPlayhead() {
    playhead = trimStart.toDouble();

    notifyListeners();
  }

  Future<void> play() async {
    if (path == null) {
      return;
    }

    if (samples.isEmpty) {
      return;
    }

    if (player.isPlaying) {
      await player.pause();

      setPlaying(false);

      return;
    }

    if (player.pausedPosition != null) {
      await player.resume();

      setPlaying(true);

      return;
    }

    _subscribePlayhead();

    setPlaying(true);

    await player.playSegment(
      path: path!,

      trimStart: trimStart,

      trimEnd: trimEnd,

      sampleCount: samples.length,
    );
  }

  void _subscribePlayhead() {
    playheadSubscription?.cancel();

    playheadSubscription = player.positionStream.listen(_onPosition);
  }

  void _onPosition(Duration position) {
    final duration = player.currentDuration;

    if (duration == null) {
      return;
    }

    if (duration.inMilliseconds == 0) {
      return;
    }

    final progress = position.inMilliseconds / duration.inMilliseconds;

    final sample = progress * samples.length;

    setPlayhead(sample);

    final trimEndPosition = trimEnd.toDouble();

    if (sample >= trimEndPosition) {
      resetPlayhead();

      setPlaying(false);
    }
  }

  Future<void> toggle() async {
    await play();
  }

  AudioEditResult? buildResult() {
    if (path == null) {
      return null;
    }

    if (duration == null) {
      return null;
    }

    if (samples.isEmpty) {
      return null;
    }

    return AudioEditResult(
      sourcePath: path!,

      duration: duration!,

      trimStart: trimStart,

      trimEnd: trimEnd,

      sampleCount: samples.length,
    );
  }

  // @Deprecated('Use AudioExporter')
  // Future<String?> exportTrimmed() async {
  //   if (path == null) {
  //     return null;
  //   }

  //   if (samples.isEmpty) {
  //     return null;
  //   }

  //   final duration = await player.getDuration(path!);

  //   if (duration == null) {
  //     return null;
  //   }

  //   final startSeconds =
  //       duration.inMilliseconds * trimStart / samples.length / 1000;

  //   final endSeconds =
  //       duration.inMilliseconds * trimEnd / samples.length / 1000;

  //   final durationSeconds = endSeconds - startSeconds;

  //   return await trimService.trimFile(
  //     path: path!,

  //     startSeconds: startSeconds,

  //     durationSeconds: durationSeconds,
  //   );
  // }

  @override
  void dispose() {
    playheadSubscription?.cancel();

    player.dispose();

    super.dispose();
  }

  Duration _indexToDuration(double index) {
    if (duration == null) {
      return Duration.zero;
    }

    if (samples.isEmpty) {
      return Duration.zero;
    }

    final ms = duration!.inMilliseconds * index / samples.length;

    return Duration(milliseconds: ms.round());
  }

  Duration get playheadTime {
    return _indexToDuration(playhead);
  }

  Duration get trimStartTime {
    return _indexToDuration(trimStart.toDouble());
  }

  Duration get trimEndTime {
    return _indexToDuration(trimEnd.toDouble());
  }

  Duration get selectionDuration {
    return trimEndTime - trimStartTime;
  }
}
