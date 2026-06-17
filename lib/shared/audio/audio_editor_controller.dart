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
}
