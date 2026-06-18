class AudioEditResult {
  final String sourcePath;

  final Duration duration;

  final int trimStart;
  final int trimEnd;

  final int sampleCount;

  const AudioEditResult({
    required this.sourcePath,

    required this.duration,

    required this.trimStart,
    required this.trimEnd,

    required this.sampleCount,
  });
}
