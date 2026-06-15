enum SpellingMatchType { correct, wrong, missing, extra }

class SpellingMatch {
  final String character;

  final String? actualCharacter;

  final SpellingMatchType type;

  const SpellingMatch({
    required this.character,
    required this.type,
    this.actualCharacter,
  });
}
