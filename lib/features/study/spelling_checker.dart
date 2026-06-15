import 'package:characters/characters.dart';

import 'arabic_text_normalizer.dart';
import 'spelling_match.dart';
import 'spelling_result.dart';

class SpellingChecker {
  SpellingResult check({required String expected, required String actual}) {
    expected = ArabicTextNormalizer.normalize(expected);

    actual = ArabicTextNormalizer.normalize(actual);

    final expectedChars = expected.characters.toList();

    final actualChars = actual.characters.toList();

    final matches = _buildMatches(expectedChars, actualChars);

    final isCorrect = matches.every((m) => m.type == SpellingMatchType.correct);

    return SpellingResult(isCorrect: isCorrect, matches: matches);
  }

  List<SpellingMatch> _buildMatches(
    List<String> expected,
    List<String> actual,
  ) {
    final m = expected.length;
    final n = actual.length;

    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = m - 1; i >= 0; i--) {
      for (int j = n - 1; j >= 0; j--) {
        if (expected[i] == actual[j]) {
          dp[i][j] = dp[i + 1][j + 1] + 1;
        } else {
          dp[i][j] = dp[i + 1][j] > dp[i][j + 1] ? dp[i + 1][j] : dp[i][j + 1];
        }
      }
    }

    final matches = <SpellingMatch>[];

    int i = 0;
    int j = 0;

    while (i < m && j < n) {
      if (expected[i] == actual[j]) {
        matches.add(
          SpellingMatch(
            character: expected[i],
            type: SpellingMatchType.correct,
          ),
        );

        i++;
        j++;

        continue;
      }

      final removeScore = dp[i + 1][j];

      final insertScore = dp[i][j + 1];

      if (removeScore == insertScore) {
        matches.add(
          SpellingMatch(
            character: expected[i],
            actualCharacter: actual[j],
            type: SpellingMatchType.wrong,
          ),
        );

        i++;
        j++;

        continue;
      }

      if (removeScore > insertScore) {
        matches.add(
          SpellingMatch(
            character: expected[i],
            type: SpellingMatchType.missing,
          ),
        );

        i++;

        continue;
      }

      matches.add(
        SpellingMatch(character: actual[j], type: SpellingMatchType.extra),
      );

      j++;
    }

    while (i < m) {
      matches.add(
        SpellingMatch(character: expected[i], type: SpellingMatchType.missing),
      );

      i++;
    }

    while (j < n) {
      matches.add(
        SpellingMatch(character: actual[j], type: SpellingMatchType.extra),
      );

      j++;
    }

    return matches;
  }
}
