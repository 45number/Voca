import 'deck_info.dart';

class DeckBuilder {
  static List<DeckInfo> build({
    required int totalWords,
    required int wordsPerDeck,
  }) {
    final result = <DeckInfo>[];

    if (totalWords == 0) {
      return result;
    }

    final deckCount =
        (totalWords / wordsPerDeck).ceil();

    for (int i = 0; i < deckCount; i++) {
      final start =
          i * wordsPerDeck;

      final remaining =
          totalWords - start;

      result.add(
        DeckInfo(
          index: i + 1,
          wordCount:
              remaining >
                      wordsPerDeck
                  ? wordsPerDeck
                  : remaining,
        ),
      );
    }

    return result;
  }
}