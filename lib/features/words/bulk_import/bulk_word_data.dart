class BulkWordData {
  final String word;

  final String translation;

  final String? audioFile;

  const BulkWordData({
    required this.word,
    required this.translation,
    this.audioFile,
  });
}