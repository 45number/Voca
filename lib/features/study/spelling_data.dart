import '../../core/database/app_database.dart';

class SpellingData {
  final List<Word> originalWords;

  final List<Word> studyWords;

  final bool loopCards;

  final bool randomOrder;

  final bool silentMode;

  const SpellingData({
    required this.originalWords,
    required this.studyWords,
    required this.loopCards,
    required this.randomOrder,
    required this.silentMode,
  });
}
