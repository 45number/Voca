import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

import 'spelling_data.dart';

class SpellingController {
  Future<SpellingData> load(List<Word> words) async {
    final settings = await settingsRepository.getSettings();

    final studyWords = buildStudyWords(
      originalWords: words,
      randomOrder: settings.randomOrder,
    );

    return SpellingData(
      originalWords: words,
      studyWords: studyWords,
      loopCards: settings.loopCards,
      randomOrder: settings.randomOrder,
      silentMode: settings.silentMode,
    );
  }

  List<Word> buildStudyWords({
    required List<Word> originalWords,
    required bool randomOrder,
  }) {
    final words = List<Word>.from(originalWords);

    if (randomOrder) {
      words.shuffle();
    }

    return words;
  }

  Future<void> updateLoopCards(bool value) async {
    await settingsRepository.updateLoopCards(value);
  }

  Future<void> updateRandomOrder(bool value) async {
    await settingsRepository.updateRandomOrder(value);
  }

  Future<void> updateSilentMode(bool value) async {
    await settingsRepository.updateSilentMode(value);
  }

  Future<void> updateDifficultSpelling(String wordId, bool value) {
    return wordRepository.setDifficultSpelling(wordId, value);
  }
}
