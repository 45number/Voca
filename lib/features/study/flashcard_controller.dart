import 'dart:math';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../settings/front_side.dart';
// import '../../core/theme/theme_controller.dart';

class FlashcardData {
  final AppSetting settings;

  final List<Word> originalWords;

  final List<Word> studyWords;

  final bool loopCards;
  final bool randomOrder;
  final bool silentMode;

  final FrontSide frontSide;

  const FlashcardData({
    required this.settings,
    required this.originalWords,
    required this.studyWords,
    required this.loopCards,
    required this.randomOrder,
    required this.silentMode,
    required this.frontSide,
  });
}

class FlashcardController {
  Future<FlashcardData> load(List<Word> words) async {
    final settings = await settingsRepository.getSettings();

    final originalWords = List<Word>.from(words);

    final studyWords = List<Word>.from(words);

    if (settings.randomOrder) {
      studyWords.shuffle(Random());
    }

    return FlashcardData(
      settings: settings,
      originalWords: originalWords,
      studyWords: studyWords,
      loopCards: settings.loopCards,
      randomOrder: settings.randomOrder,
      silentMode: settings.silentMode,
      frontSide: settings.frontSide == 0
          ? FrontSide.word
          : FrontSide.translation,
    );
  }

  Future<void> updateLoopCards(bool value) {
    return settingsRepository.updateLoopCards(value);
  }

  Future<void> updateRandomOrder(bool value) {
    return settingsRepository.updateRandomOrder(value);
  }

  Future<void> updateSilentMode(bool value) {
    return settingsRepository.updateSilentMode(value);
  }

  Future<void> updateFrontSide(FrontSide frontSide) {
    return settingsRepository.updateFrontSide(
      frontSide == FrontSide.word ? 0 : 1,
    );
  }

  List<Word> buildStudyWords({
    required List<Word> originalWords,
    required bool randomOrder,
  }) {
    final words = List<Word>.from(originalWords);

    if (randomOrder) {
      words.shuffle(Random());
    }

    return words;
  }

  Future<void> updateDifficultMemorizing(String wordId, bool value) {
    return wordRepository.setDifficultMemorizing(wordId, value);
  }
}
