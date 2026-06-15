import '../../core/database/app_database.dart';

class StudySessionController {
  int currentIndex = 0;

  bool isRevealed = false;

  Word currentWord(List<Word> words) {
    return words[currentIndex];
  }

  bool get canGoPrevious {
    return currentIndex > 0;
  }

  void reveal() {
    isRevealed = true;
  }

  void hide() {
    isRevealed = false;
  }

  void previous() {
    if (currentIndex == 0) {
      return;
    }

    currentIndex--;

    isRevealed = false;
  }

  bool next(int totalCount) {
    if (currentIndex < totalCount - 1) {
      currentIndex++;

      isRevealed = false;

      return true;
    }

    return false;
  }

  void restart() {
    currentIndex = 0;

    isRevealed = false;
  }
}
