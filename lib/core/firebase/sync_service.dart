import '../database/folder_repository.dart';
import '../database/settings_repository.dart';
import '../database/word_repository.dart';

import 'dto/folder_dto.dart';
import 'dto/settings_dto.dart';
import 'dto/word_dto.dart';

import 'firestore_service.dart';

class SyncService {
  final FolderRepository folders;

  final WordRepository words;

  final SettingsRepository settings;

  final FirestoreService firestore;

  SyncService({
    required this.folders,

    required this.words,

    required this.settings,

    required this.firestore,
  });

  // Future<void> uploadEverything() async {
  //   ///////////////////////////////////
  //   /// folders
  //   ///////////////////////////////////

  //   final localFolders = await folders.getAllFolders();

  //   for (final folder in localFolders) {
  //     final dto = FolderDto.fromFolder(folder);

  //     await firestore.uploadFolder(dto);
  //   }

  //   ///////////////////////////////////
  //   /// words
  //   ///////////////////////////////////

  //   final localWords = await words.getAllWords();

  //   for (final word in localWords) {
  //     final dto = WordDto.fromWord(word);

  //     await firestore.uploadWord(dto);
  //   }

  //   ///////////////////////////////////
  //   /// settings
  //   ///////////////////////////////////

  //   final s = await settings.getSettings();

  //   final dto = SettingsDto.fromSettings(s);

  //   await firestore.uploadSettings(dto);
  // }

  Future<void> uploadEverything() async {
    print("====== START SYNC ======");

    final localFolders = await folders.getAllFolders();

    print("Folders count: ${localFolders.length}");

    for (final folder in localFolders) {
      print("Uploading folder: ${folder.name}");

      final dto = FolderDto.fromFolder(folder);

      await firestore.uploadFolder(dto);
    }

    final localWords = await words.getAllWords();

    print("Words count: ${localWords.length}");

    for (final word in localWords) {
      print("Uploading word: ${word.word}");

      final dto = WordDto.fromWord(word);

      await firestore.uploadWord(dto);
    }

    final s = await settings.getSettings();

    print("Uploading settings");

    await firestore.uploadSettings(SettingsDto.fromSettings(s));

    print("====== END SYNC ======");
  }

  Future<void> downloadEverything() async {
    print("DOWNLOAD START");

    //////////////////////////////////////////

    /// folders

    //////////////////////////////////////////

    final foldersCloud = await firestore.getFolders();

    print("Folders ${foldersCloud.length}");

    for (final dto in foldersCloud) {
      await folders.upsertFolder(dto.toCompanion());
    }

    //////////////////////////////////////////

    /// words

    //////////////////////////////////////////

    final wordsCloud = await firestore.getWords();

    print("Words ${wordsCloud.length}");

    for (final dto in wordsCloud) {
      await words.upsertWord(dto.toCompanion());
    }

    //////////////////////////////////////////

    /// settings

    //////////////////////////////////////////

    final settingsCloud = await firestore.getSettings();

    if (settingsCloud != null) {
      await settings.upsertSettings(settingsCloud.toCompanion());
    }

    print("DOWNLOAD END");
  }
}
