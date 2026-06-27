import 'package:drift/drift.dart';

import '../firebase/dto/word_dto.dart';
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

            pendingSync: const Value(true),
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

        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> setDifficultMemorizing(String wordId, bool value) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(
        difficultMemorizing: Value(value),
        updatedAt: Value(_now),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> setDifficultSpelling(String wordId, bool value) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(
        difficultSpelling: Value(value),
        updatedAt: Value(_now),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> softDeleteWord(String wordId) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(wordId))).write(
      WordsCompanion(
        deleted: const Value(true),
        updatedAt: Value(_now),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> softDeleteWordsInFolder(String folderId) async {
    await (database.update(
      database.words,
    )..where((w) => w.folderId.equals(folderId))).write(
      WordsCompanion(
        deleted: const Value(true),
        updatedAt: Value(_now),
        pendingSync: const Value(true),
      ),
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

  Stream<int> watchWordCount(String folderId) {
    return (database.select(database.words)
          ..where((w) => w.folderId.equals(folderId) & w.deleted.equals(false)))
        .watch()
        .map((e) => e.length);
  }

  Stream<List<Word>> watchWords(String folderId) {
    return (database.select(database.words)
          ..where((w) => w.folderId.equals(folderId) & w.deleted.equals(false)))
        .watch();
  }

  Stream<int> watchDifficultMemorizingCount(String? folderId) {
    final query = database.select(database.words);

    query.where((w) {
      final difficult = w.difficultMemorizing.equals(true);
      final deleted = w.deleted.equals(false);

      if (folderId == null) {
        return difficult & deleted;
      }

      return difficult & deleted & w.folderId.equals(folderId);
    });

    return query.watch().map((e) => e.length);
  }

  Stream<int> watchDifficultSpellingCount(String? folderId) {
    final query = database.select(database.words);

    query.where((w) {
      final difficult = w.difficultSpelling.equals(true);
      final deleted = w.deleted.equals(false);

      if (folderId == null) {
        return difficult & deleted;
      }

      return difficult & deleted & w.folderId.equals(folderId);
    });

    return query.watch().map((e) => e.length);
  }

  Stream<List<Word>> watchAllWords() {
    return (database.select(
      database.words,
    )..where((w) => w.deleted.equals(false))).watch();
  }

  ////////////////////

  Future<Word?> getWord(String id) {
    return (database.select(
      database.words,
    )..where((w) => w.id.equals(id))).getSingleOrNull();
  }

  Future<List<Word>> getDirtyWords() {
    return (database.select(
      database.words,
    )..where((w) => w.pendingSync.equals(true))).get();
  }

  Future<List<Word>> getDeletedWords() {
    return (database.select(
      database.words,
    )..where((w) => w.deleted.equals(true))).get();
  }

  Future<void> markWordSynced(String id) async {
    await (database.update(database.words)..where((w) => w.id.equals(id)))
        .write(const WordsCompanion(pendingSync: Value(false)));
  }

  Future<void> applyRemoteDelete(String id) async {
    await (database.update(
      database.words,
    )..where((w) => w.id.equals(id))).write(
      const WordsCompanion(deleted: Value(true), pendingSync: Value(false)),
    );
  }

  Future<void> upsertIfNewer(WordDto dto) async {
    final local = await getWord(dto.id);

    ///////////////////////////////////////
    /// local absent
    ///////////////////////////////////////

    if (local == null) {
      await upsertWord(
        dto.toCompanion().copyWith(pendingSync: const Value(false)),
      );

      return;
    }

    ///////////////////////////////////////
    /// local newer
    ///////////////////////////////////////

    if (dto.updatedAt <= local.updatedAt) {
      return;
    }

    ///////////////////////////////////////
    /// remote delete
    ///////////////////////////////////////

    if (dto.deleted) {
      await applyRemoteDelete(dto.id);

      return;
    }

    ///////////////////////////////////////
    /// remote newer
    ///////////////////////////////////////

    await upsertWord(
      dto.toCompanion().copyWith(pendingSync: const Value(false)),
    );
  }

  Stream<int> watchDirtyWords() {
    return (database.select(
      database.words,
    )..where((w) => w.pendingSync.equals(true))).watch().map((e) => e.length);
  }
}
