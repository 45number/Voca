import 'package:drift/drift.dart';

import 'app_database.dart';

class WordRepository {
  final AppDatabase database;

  WordRepository(this.database);

  Future<List<Word>> getWords(String folderId) {
    return (database.select(database.words)
          ..where((w) => w.folderId.equals(folderId) & w.deleted.equals(false)))
        .get();
  }

  Future<List<Word>> getDeckWords({
    required String folderId,
    required int deckIndex,
    required int wordsPerDeck,
  }) async {
    final words = await getWords(folderId);

    final start = (deckIndex - 1) * wordsPerDeck;

    if (start >= words.length) {
      return [];
    }

    final end = (start + wordsPerDeck) > words.length
        ? words.length
        : start + wordsPerDeck;

    return words.sublist(start, end);
  }

  Future<int> getWordCount(String folderId) async {
    final words = await getWords(folderId);

    return words.length;
  }

  Future<void> createWord({
    required String folderId,
    required String word,
    required String translation,
    String? audioFile,
  }) async {
    await database
        .into(database.words)
        .insert(
          WordsCompanion.insert(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            folderId: folderId,
            word: word,
            translation: translation,
            audioFile: Value(audioFile),
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  Future<void> updateWord({
    required String id,
    required String word,
    required String translation,
    String? audioFile,
  }) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(id))).write(
      WordsCompanion(
        word: Value(word),
        translation: Value(translation),
        audioFile: Value(audioFile),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> setDifficultMemorizing(String wordId, bool value) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(
        difficultMemorizing: Value(value),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> setDifficultSpelling(String wordId, bool value) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(
        difficultSpelling: Value(value),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> softDeleteWord(String wordId) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> softDeleteWordsInFolder(String folderId) async {
    await (database.update(
      database.words,
    )..where((w) => w.folderId.equals(folderId))).write(
      WordsCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
