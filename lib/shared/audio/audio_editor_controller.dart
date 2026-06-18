import 'dart:async';

import 'package:flutter/foundation.dart';

import 'audio_player_service.dart';

class AudioEditorController extends ChangeNotifier {
  final player = AudioPlayerService();

  StreamSubscription<Duration>? playheadSubscription;

  List<double> samples = [];

  String? path;

  int trimStart = 0;

  int trimEnd = 0;

  double? playhead;

  bool isPlaying = false;

  StreamSubscription<Duration>? subscription;

  void load({
    required String path,
    required List<double> samples,
    required int trimStart,
    required int trimEnd,
  }) {
    this.path = path;

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

  void setPlayhead(double? value) {
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

  @override
  void dispose() {
    playheadSubscription?.cancel();

    player.dispose();

    super.dispose();
  }
}
