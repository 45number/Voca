import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

import '../decks/deck_builder.dart';
import '../decks/deck_info.dart';

// class FolderData {
//   final List<Folder> childFolders;
//   final List<DeckInfo> decks;
//   final int wordCount;

//   const FolderData({
//     required this.childFolders,
//     required this.decks,
//     required this.wordCount,
//   });
// }

class FolderData {
  final List<Folder> childFolders;

  final List<DeckInfo> decks;

  final int wordCount;

  final int difficultMemorizingCount;

  final int difficultSpellingCount;

  const FolderData({
    required this.childFolders,
    required this.decks,
    required this.wordCount,
    required this.difficultMemorizingCount,
    required this.difficultSpellingCount,
  });

  bool get hasDifficultWords =>
      difficultMemorizingCount > 0 || difficultSpellingCount > 0;
}

class FolderController {
  Future<FolderData> load(Folder? folder) async {
    List<Folder> childFolders;

    if (folder == null) {
      childFolders = await folderRepository.getFolders();
    } else {
      childFolders = await folderRepository.getChildFolders(folder.id);
    }

    int wordCount = 0;
    List<DeckInfo> decks = [];

    if (folder != null) {
      final settings = await settingsRepository.getSettings();

      wordCount = await wordRepository.getWordCount(folder.id);

      decks = DeckBuilder.build(
        totalWords: wordCount,
        wordsPerDeck: settings.wordsPerDay,
      );
    }

    final folderIds = await folderRepository.getFolderTreeIds(folder?.id);

    final difficultMemorizingCount = await wordRepository
        .getDifficultMemorizingCount(folderIds);

    final difficultSpellingCount = await wordRepository
        .getDifficultSpellingCount(folderIds);

    return FolderData(
      childFolders: childFolders,
      decks: decks,
      wordCount: wordCount,
      difficultMemorizingCount: difficultMemorizingCount,
      difficultSpellingCount: difficultSpellingCount,
    );
  }

  Future<void> createFolder({required String name, String? parentId}) async {
    await folderRepository.createFolder(name, parentId: parentId);
  }

  Future<void> renameFolder({
    required String folderId,
    required String name,
  }) async {
    await folderRepository.renameFolder(folderId, name);
  }

  Future<void> deleteFolder(String folderId) async {
    await folderRepository.softDeleteFolderTree(folderId);
  }

  Future<List<Word>> loadDeckWords({
    required String folderId,
    required int deckIndex,
  }) async {
    final settings = await settingsRepository.getSettings();

    return wordRepository.getDeckWords(
      folderId: folderId,
      deckIndex: deckIndex,
      wordsPerDeck: settings.wordsPerDay,
    );
  }

  Future<List<Word>> loadDifficultMemorizingWords(String? folderId) async {
    final folderIds = await folderRepository.getFolderTreeIds(folderId);

    return wordRepository.getDifficultMemorizingWords(folderIds);
  }

  Future<List<Word>> loadDifficultSpellingWords(String? folderId) async {
    final folderIds = await folderRepository.getFolderTreeIds(folderId);

    return wordRepository.getDifficultSpellingWords(folderIds);
  }

  Future<String> buildDifficultBreadcrumb(Folder? folder) async {
    if (folder == null) {
      return 'All difficult words';
    }

    final folders = await folderRepository.getFolderPath(folder.id);

    final parts = folders.map((f) => f.name).toList();

    parts.add('Difficult');

    return parts.join(' / ');
  }
}
