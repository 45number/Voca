// import '../database/folder_repository.dart';
// import '../database/settings_repository.dart';
// import '../database/word_repository.dart';

// import 'dto/folder_dto.dart';
// import 'dto/settings_dto.dart';
// import 'dto/word_dto.dart';

// import 'firestore_service.dart';

// class SyncService {
//   final FolderRepository folders;

//   final WordRepository words;

//   final SettingsRepository settings;

//   final FirestoreService firestore;

//   SyncService({
//     required this.folders,

//     required this.words,

//     required this.settings,

//     required this.firestore,
//   });

//   // Future<void> uploadEverything() async {
//   //   ///////////////////////////////////
//   //   /// folders
//   //   ///////////////////////////////////

//   //   final localFolders = await folders.getAllFolders();

//   //   for (final folder in localFolders) {
//   //     final dto = FolderDto.fromFolder(folder);

//   //     await firestore.uploadFolder(dto);
//   //   }

//   //   ///////////////////////////////////
//   //   /// words
//   //   ///////////////////////////////////

//   //   final localWords = await words.getAllWords();

//   //   for (final word in localWords) {
//   //     final dto = WordDto.fromWord(word);

//   //     await firestore.uploadWord(dto);
//   //   }

//   //   ///////////////////////////////////
//   //   /// settings
//   //   ///////////////////////////////////

//   //   final s = await settings.getSettings();

//   //   final dto = SettingsDto.fromSettings(s);

//   //   await firestore.uploadSettings(dto);
//   // }

//   Future<void> uploadEverything() async {
//     print("====== START SYNC ======");

//     final localFolders = await folders.getAllFolders();

//     print("Folders count: ${localFolders.length}");

//     for (final folder in localFolders) {
//       print("Uploading folder: ${folder.name}");

//       final dto = FolderDto.fromFolder(folder);

//       await firestore.uploadFolder(dto);
//     }

//     final localWords = await words.getAllWords();

//     print("Words count: ${localWords.length}");

//     for (final word in localWords) {
//       print("Uploading word: ${word.word}");

//       final dto = WordDto.fromWord(word);

//       await firestore.uploadWord(dto);
//     }

//     final s = await settings.getSettings();

//     print("Uploading settings");

//     await firestore.uploadSettings(SettingsDto.fromSettings(s));

//     print("====== END SYNC ======");
//   }

//   Future<void> downloadEverything() async {
//     print("DOWNLOAD START");

//     //////////////////////////////////////////

//     /// folders

//     //////////////////////////////////////////

//     final foldersCloud = await firestore.getFolders();

//     print("Folders ${foldersCloud.length}");

//     for (final dto in foldersCloud) {
//       await folders.upsertFolder(dto.toCompanion());
//     }

//     //////////////////////////////////////////

//     /// words

//     //////////////////////////////////////////

//     // final wordsCloud = await firestore.getWords();

//     // print("Words ${wordsCloud.length}");

//     // for (final dto in wordsCloud) {
//     //   await words.upsertWord(dto.toCompanion());
//     // }

//     final wordsCloud = await firestore.getWords();

//     print("WORDS FROM CLOUD: ${wordsCloud.length}");

//     for (final dto in wordsCloud) {
//       try {
//         print("ID: ${dto.id}");
//         print("WORD: ${dto.word}");
//         print("FOLDER: ${dto.folderId}");

//         await words.upsertWord(dto.toCompanion());

//         // print("INSERTED ${dto.word}");
//       } catch (e) {
//         print("ERROR");
//         print(e);
//       }
//     }

//     final localWords = await words.getAllWords();

//     print("LOCAL WORDS ${localWords.length}");

//     for (final w in localWords) {
//       print("${w.id}  ${w.word}");
//     }

//     //////////////////////////////////////////

//     /// settings

//     //////////////////////////////////////////

//     final settingsCloud = await firestore.getSettings();

//     if (settingsCloud != null) {
//       await settings.upsertSettings(settingsCloud.toCompanion());
//     }

//     print("DOWNLOAD END");
//   }
// }

import 'dart:async';

import '../database/folder_repository.dart';
import '../database/settings_repository.dart';
import '../database/word_repository.dart';

import 'dto/folder_dto.dart';
import 'dto/settings_dto.dart';
import 'dto/word_dto.dart';

import 'firestore_service.dart';

import 'package:flutter/foundation.dart';

class SyncService {
  final FolderRepository folders;
  final WordRepository words;
  final SettingsRepository settings;
  final FirestoreService firestore;

  StreamSubscription? _foldersSub;
  StreamSubscription? _wordsSub;
  StreamSubscription? _settingsSub;

  SyncService({
    required this.folders,

    required this.words,

    required this.settings,

    required this.firestore,
  });

  ////////////////////////////////////////////////////////
  ///
  /// Upload
  ///
  ////////////////////////////////////////////////////////

  Future<void> uploadEverything() async {
    final localFolders = await folders.getAllFolders();

    for (final folder in localFolders) {
      final dto = FolderDto.fromFolder(folder);

      await firestore.uploadFolder(dto);
    }

    final localWords = await words.getAllWords();

    for (final word in localWords) {
      final dto = WordDto.fromWord(word);

      await firestore.uploadWord(dto);
    }

    final s = await settings.getSettings();

    final dto = SettingsDto.fromSettings(s);

    await firestore.uploadSettings(dto);
  }

  ////////////////////////////////////////////////////////
  ///
  /// Download
  ///
  ////////////////////////////////////////////////////////

  Future<void> downloadEverything() async {
    ///////////////////////////
    ///
    /// folders
    ///
    ///////////////////////////

    final foldersCloud = await firestore.getFolders();

    for (final dto in foldersCloud) {
      await folders.upsertFolder(dto.toCompanion());
    }

    ///////////////////////////
    ///
    /// words
    ///
    ///////////////////////////

    final wordsCloud = await firestore.getWords();

    for (final dto in wordsCloud) {
      await words.upsertWord(dto.toCompanion());
    }

    ///////////////////////////
    ///
    /// settings
    ///
    ///////////////////////////

    final settingsCloud = await firestore.getSettings();

    if (settingsCloud != null) {
      await settings.upsertSettings(settingsCloud.toCompanion());
    }
  }

  ////////////////////////////////////////////////////////
  ///
  /// Realtime
  ///
  ////////////////////////////////////////////////////////

  // Future<void> startRealtime() async {
  Future<void> startRealtime({VoidCallback? onChanged}) async {
    await stopRealtime();

    /////////////////////////////////////

    /// folders

    /////////////////////////////////////

    _foldersSub = firestore.listenFolders().listen((snapshot) async {
      for (final doc in snapshot.docs) {
        final dto = FolderDto.fromJson(doc.data());

        await folders.upsertFolder(dto.toCompanion());

        onChanged?.call();
      }
    });

    /////////////////////////////////////

    /// words

    /////////////////////////////////////

    _wordsSub = firestore.listenWords().listen((snapshot) async {
      for (final doc in snapshot.docs) {
        final dto = WordDto.fromJson(doc.data());

        await words.upsertWord(dto.toCompanion());

        onChanged?.call();
      }
    });

    /////////////////////////////////////

    /// settings

    /////////////////////////////////////

    _settingsSub = firestore.listenSettings().listen((doc) async {
      if (!doc.exists) {
        return;
      }

      final dto = SettingsDto.fromJson(doc.data()!);

      await settings.upsertSettings(dto.toCompanion());
    });
  }

  ////////////////////////////////////////////////////////
  ///
  /// Stop
  ///
  ////////////////////////////////////////////////////////

  Future<void> stopRealtime() async {
    await _foldersSub?.cancel();

    await _wordsSub?.cancel();

    await _settingsSub?.cancel();

    _foldersSub = null;
    _wordsSub = null;
    _settingsSub = null;
  }
}
