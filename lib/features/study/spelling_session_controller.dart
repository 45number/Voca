import 'spelling_result.dart';
import 'spelling_state.dart';

class SpellingSessionController {
  int currentIndex = 0;

  SpellingState state = SpellingState.typing;

  String userAnswer = '';

  SpellingResult? result;

  bool get isChecked {
    return state != SpellingState.typing;
  }

  bool get isCorrect {
    return state == SpellingState.correct;
  }

  bool get isIncorrect {
    return state == SpellingState.incorrect;
  }

  void check({required String answer, required SpellingResult spellingResult}) {
    userAnswer = answer;

    result = spellingResult;

    state = spellingResult.isCorrect
        ? SpellingState.correct
        : SpellingState.incorrect;
  }

  void resetAnswer() {
    userAnswer = '';

    result = null;

    state = SpellingState.typing;
  }

  bool next(int totalWords) {
    if (currentIndex >= totalWords - 1) {
      return false;
    }

    currentIndex++;

    resetAnswer();

    return true;
  }

  bool previous() {
    if (currentIndex <= 0) {
      return false;
    }

    currentIndex--;

    resetAnswer();

    return true;
  }

  void restart() {
    currentIndex = 0;

    resetAnswer();
  }
}
