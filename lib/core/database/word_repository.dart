import 'package:drift/drift.dart';

import 'app_database.dart';

class WordRepository {
  final AppDatabase database;

  WordRepository(this.database);

  int get _now => DateTime.now().millisecondsSinceEpoch;

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
          // WordsCompanion.insert(
          //   id: _now.toString(),

          //   folderId: folderId,

          //   word: word,

          //   translation: translation,

          //   audioFile: Value(audioFile),

          //   createdAt: _now,

          //   updatedAt: _now,
          // ),
          WordsCompanion.insert(
            id: _now.toString(),

            folderId: folderId,

            word: word,

            translation: translation,

            audioFile: Value(audioFile),

            createdAt: Value(_now),

            updatedAt: _now,
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

        updatedAt: Value(_now),
      ),
    );
  }

  Future<void> setDifficultMemorizing(String wordId, bool value) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(difficultMemorizing: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> setDifficultSpelling(String wordId, bool value) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(difficultSpelling: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> softDeleteWord(String wordId) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(deleted: const Value(true), updatedAt: Value(_now)),
    );
  }

  Future<void> softDeleteWordsInFolder(String folderId) async {
    await (database.update(
      database.words,
    )..where((w) => w.folderId.equals(folderId))).write(
      WordsCompanion(deleted: const Value(true), updatedAt: Value(_now)),
    );
  }

  Future<int> getDifficultMemorizingCount(List<String> folderIds) async {
    if (folderIds.isEmpty) {
      return 0;
    }

    final words =
        await (database.select(database.words)..where(
              (w) =>
                  w.folderId.isIn(folderIds) &
                  w.deleted.equals(false) &
                  w.difficultMemorizing.equals(true),
            ))
            .get();

    return words.length;
  }

  Future<int> getDifficultSpellingCount(List<String> folderIds) async {
    if (folderIds.isEmpty) {
      return 0;
    }

    final words =
        await (database.select(database.words)..where(
              (w) =>
                  w.folderId.isIn(folderIds) &
                  w.deleted.equals(false) &
                  w.difficultSpelling.equals(true),
            ))
            .get();

    return words.length;
  }

  Future<List<Word>> getDifficultMemorizingWords(List<String> folderIds) {
    if (folderIds.isEmpty) {
      return Future.value([]);
    }

    return (database.select(database.words)..where(
          (w) =>
              w.folderId.isIn(folderIds) &
              w.deleted.equals(false) &
              w.difficultMemorizing.equals(true),
        ))
        .get();
  }

  Future<List<Word>> getDifficultSpellingWords(List<String> folderIds) {
    if (folderIds.isEmpty) {
      return Future.value([]);
    }

    return (database.select(database.words)..where(
          (w) =>
              w.folderId.isIn(folderIds) &
              w.deleted.equals(false) &
              w.difficultSpelling.equals(true),
        ))
        .get();
  }

  Future<List<Word>> getAllWords() {
    return (database.select(
      database.words,
    )..where((w) => w.deleted.equals(false))).get();
  }

  Future<void> upsertWord(WordsCompanion word) async {
    await database.into(database.words).insertOnConflictUpdate(word);
  }
}
