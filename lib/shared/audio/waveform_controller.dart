import 'package:flutter/foundation.dart';

class WaveformController extends ChangeNotifier {
  int trimStart = 0;
  int trimEnd = 0;

  double? playhead;

  bool isPlaying = false;

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
