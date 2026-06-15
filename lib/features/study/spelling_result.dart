import 'spelling_match.dart';

class SpellingResult {
  final bool isCorrect;

  final List<SpellingMatch> matches;

  const SpellingResult({required this.isCorrect, required this.matches});
}
