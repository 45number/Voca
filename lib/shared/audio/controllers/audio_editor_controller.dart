import 'dart:async';
import '../services/audio_recorder_service.dart';
import '../services/audio_trim_service.dart';
import 'package:flutter/foundation.dart';
import '../services/audio_player_service.dart';
import 'package:file_picker/file_picker.dart';
import '../services/waveform_extractor_service.dart';
import '../models/audio_edit_result.dart';

class AudioEditorController extends ChangeNotifier {
  final player = AudioPlayerService();

  final recorder = AudioRecorderService();

  final trimService = AudioTrimService();

  final waveformExtractor = WaveformExtractorService();

  StreamSubscription<Duration>? playheadSubscription;

  StreamSubscription? amplitudeSubscription;

  List<double> samples = [];

  String? path;

  Duration duration = Duration.zero;

  int trimStart = 0;

  int trimEnd = 0;

  double playhead = 0;

  bool isPlaying = false;

  bool isRecording = false;

  String? get selectedAudioFile => path;

  List<double> waveform = [];

  List<double> liveWaveform = [];

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

  bool get hasAudio {
    return path != null && samples.isNotEmpty;
  }

  AudioEditResult buildResult() {
    if (!hasAudio) {
      throw StateError('No audio loaded');
    }

    return AudioEditResult(
      sourcePath: path!,
      duration: duration,
      trimStart: trimStart,
      trimEnd: trimEnd,
      sampleCount: samples.length,
    );
  }

  @override
  void dispose() {
    playheadSubscription?.cancel();

    player.dispose();

    super.dispose();
  }

  Duration _indexToDuration(double index) {
    if (samples.isEmpty) {
      return Duration.zero;
    }

    final ms = duration.inMilliseconds * index / samples.length;

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

  Future<bool> startRecording() async {
    final hasPermission = await recorder.hasPermission();

    if (!hasPermission) {
      return false;
    }

    liveWaveform.clear();

    await recorder.startRecording();

    amplitudeSubscription?.cancel();

    amplitudeSubscription = recorder.onAmplitudeChanged().listen((amplitude) {
      liveWaveform.add(amplitude.current);

      if (liveWaveform.length > 100) {
        liveWaveform.removeAt(0);
      }

      notifyListeners();
    });

    isRecording = true;

    notifyListeners();

    return true;
  }

  Future<bool> stopRecording() async {
    final path = await recorder.stopRecording();

    if (path == null) {
      return false;
    }

    await amplitudeSubscription?.cancel();
    amplitudeSubscription = null;

    final normalizedWaveform = liveWaveform.map((v) {
      return ((v + 60) / 60).clamp(0.05, 1.0);
    }).toList();

    final start = trimService.findSpeechStart(normalizedWaveform);

    final end = trimService.findSpeechEnd(normalizedWaveform);

    final audioDuration = await player.getDuration(path) ?? Duration.zero;

    isRecording = false;

    waveform = normalizedWaveform;

    liveWaveform.clear();

    load(
      path: path,
      samples: waveform,
      trimStart: start,
      trimEnd: end,
      duration: audioDuration,
    );

    notifyListeners();

    return true;
  }

  Future<bool> importAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
    );

    if (result == null) {
      return false;
    }

    final path = result.files.single.path;

    if (path == null) {
      return false;
    }

    await loadFile(path);

    return true;
  }

  Future<void> loadFile(String path) async {
    final waveform = await waveformExtractor.extract(path);
    final start = trimService.findSpeechStart(waveform);
    final end = trimService.findSpeechEnd(waveform);
    final audioDuration = await player.getDuration(path) ?? Duration.zero;

    load(
      path: path,
      samples: waveform,
      trimStart: start,
      trimEnd: end,
      duration: audioDuration,
    );

    notifyListeners();
  }

  String formatPosition(int sampleIndex) {
    if (samples.isEmpty) return "00:00";

    final ratio = sampleIndex / samples.length;
    final ms = duration.inMilliseconds * ratio;
    final d = Duration(milliseconds: ms.toInt());
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    final millis = (d.inMilliseconds % 1000).toString().padLeft(3, '0');

    return "$minutes:$seconds.$millis";
  }
}
