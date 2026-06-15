import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

import '../decks/deck_builder.dart';
import '../decks/deck_info.dart';

class FolderData {
  final List<Folder> childFolders;
  final List<DeckInfo> decks;
  final int wordCount;

  const FolderData({
    required this.childFolders,
    required this.decks,
    required this.wordCount,
  });
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

    return FolderData(
      childFolders: childFolders,
      decks: decks,
      wordCount: wordCount,
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
}
