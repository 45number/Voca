import 'dart:async';

import '../../shared/audio/services/audio_gc_service.dart';
import '../database/folder_repository.dart';
import '../database/settings_repository.dart';
import '../database/word_repository.dart';

import 'dto/folder_dto.dart';
import 'dto/settings_dto.dart';
import 'dto/word_dto.dart';

import 'firestore_service.dart';

import 'dart:io';

import '../../shared/audio/services/audio_storage_service.dart';
import 'storage_service.dart';

import '../database/app_database.dart';

class SyncService {
  final FolderRepository folders;
  final WordRepository words;
  final SettingsRepository settings;
  final FirestoreService firestore;

  final StorageService storage;

  final AudioStorageService audioStorage;

  final AudioGcService gc;

  // StreamSubscription? _foldersSub;
  // StreamSubscription? _wordsSub;
  // StreamSubscription? _settingsSub;
  StreamSubscription? _foldersRealtimeSub;
  StreamSubscription? _wordsRealtimeSub;
  StreamSubscription? _settingsRealtimeSub;

  StreamSubscription? _dirtyFoldersSub;
  StreamSubscription? _dirtyWordsSub;
  StreamSubscription? _dirtySettingsSub;

  Timer? _debounce;

  bool _uploading = false;

  int _lastFolders = 0;
  int _lastWords = 0;
  int _lastSettings = 0;

  SyncService({
    required this.folders,
    required this.words,
    required this.settings,
    required this.firestore,
    required this.storage,
    required this.audioStorage,
    required this.gc,
  });

  // Future<void> start() async {
  //   await stopRealtime();

  //   await observeDirty();

  //   await startRealtime();

  //   await uploadDirty();
  // }
  Future<void> start() async {
    await dispose();

    // await gc.cleanup();

    await observeDirty();

    await startRealtime();

    await uploadDirty();

    await gc.cleanup();
  }

  Future<void> startRealtime() async {
    await stopRealtime();

    //////////////////////////////////////////
    /// Folders
    //////////////////////////////////////////

    _foldersRealtimeSub = firestore.listenFolders().listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        final data = change.doc.data();

        if (data == null) continue;

        final dto = FolderDto.fromJson(data);

        await folders.upsertIfNewer(dto);
      }
    });

    //////////////////////////////////////////
    /// Words
    //////////////////////////////////////////

    // _wordsRealtimeSub = firestore.listenWords().listen((snapshot) async {
    //   for (final change in snapshot.docChanges) {
    //     final data = change.doc.data();

    //     if (data == null) continue;

    //     final dto = WordDto.fromJson(data);

    //     await words.upsertIfNewer(dto);
    //   }
    // });

    _wordsRealtimeSub = firestore.listenWords().listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        final data = change.doc.data();

        if (data == null) {
          continue;
        }

        final dto = WordDto.fromJson(data);

        try {
          await downloadMissingAudio(dto);
        } catch (e) {
          print('downloadMissingAudio: $e');
        }

        await words.upsertIfNewer(dto);
      }
    });

    //////////////////////////////////////////
    /// Settings
    //////////////////////////////////////////

    _settingsRealtimeSub = firestore.listenSettings().listen((doc) async {
      if (!doc.exists) {
        return;
      }

      final data = doc.data();

      if (data == null) {
        return;
      }

      final dto = SettingsDto.fromJson(data);

      await settings.upsertIfNewer(dto);
    });
  }

  Future<void> observeDirty() async {
    await _dirtyFoldersSub?.cancel();
    await _dirtyWordsSub?.cancel();
    await _dirtySettingsSub?.cancel();

    //////////////////////////////

    _dirtyFoldersSub = folders.watchDirtyFolders().listen((count) {
      if (count > _lastFolders) {
        notifyDirty();
      }

      _lastFolders = count;
    });

    //////////////////////////////

    _dirtyWordsSub = words.watchDirtyWords().listen((count) {
      if (count > _lastWords) {
        notifyDirty();
      }

      _lastWords = count;
    });

    //////////////////////////////

    _dirtySettingsSub = settings.watchDirtySettings().listen((count) {
      if (count > _lastSettings) {
        notifyDirty();
      }

      _lastSettings = count;
    });
  }

  void notifyDirty() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 2), () async {
      if (_uploading) {
        return;
      }

      _uploading = true;

      try {
        await uploadDirty();
      } finally {
        _uploading = false;
      }
    });
  }

  // Future<void> uploadDirty() async {
  //   await Future.wait([
  //     uploadDirtyFolders(),
  //     uploadDirtyWords(),
  //     uploadDirtySettings(),
  //   ]);
  // }

  Future<void> uploadDirty() async {
    await Future.wait([
      uploadDirtyFolders(),
      uploadDirtyWords(),
      uploadDirtySettings(),
    ]);

    // await gc.cleanup();
  }

  Future<void> uploadDirtyFolders() async {
    final dirty = await folders.getDirtyFolders();

    for (final folder in dirty) {
      try {
        final dto = FolderDto.fromFolder(folder);

        await firestore.uploadFolder(dto);

        await folders.markFolderSynced(folder.id);
      } catch (e) {
        print(e);
      }
    }
  }

  // Future<void> uploadDirtyWords() async {
  //   final dirty = await words.getDirtyWords();

  //   for (final word in dirty) {
  //     try {
  //       final dto = WordDto.fromWord(word);

  //       await firestore.uploadWord(dto);

  //       await words.markWordSynced(word.id);
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  // Future<void> uploadDirtyWords() async {
  //   final dirty = await words.getDirtyWords();

  //   for (final word in dirty) {
  //     try {
  //       // Сначала синхронизируем аудио, если оно есть
  //       await syncAudioForWord(word);

  //       // Затем синхронизируем само слово
  //       final dto = WordDto.fromWord(word);

  //       await firestore.uploadWord(dto);

  //       // Помечаем локальную запись как синхронизированную
  //       await words.markWordSynced(word.id);
  //     } catch (e) {
  //       print('uploadDirtyWords: $e');
  //     }
  //   }
  // }

  ////////////////////////////

  // Future<void> uploadDirtyWords() async {
  //   final dirty = await words.getDirtyWords();

  //   print("DIRTY ${dirty.length}");

  //   for (final word in dirty) {
  //     try {
  //       await syncAudioForWord(word);
  //     } catch (e) {
  //       print("AUDIO ERROR $e");
  //     }

  //     try {
  //       final dto = WordDto.fromWord(word);

  //       await firestore.uploadWord(dto);

  //       print("WORD UPLOADED");

  //       await words.markWordSynced(word.id);
  //     } catch (e) {
  //       print("FIRESTORE ERROR $e");
  //     }
  //   }
  // }

  Future<void> uploadDirtyWords() async {
    final dirty = await words.getDirtyWords();

    print('DIRTY WORDS: ${dirty.length}');

    for (final word in dirty) {
      print('Processing: ${word.word}');

      //
      // Аудио не должно блокировать Firestore
      //
      try {
        await syncAudioForWord(word);
      } catch (e) {
        print('AUDIO ERROR: $e');
      }

      //
      // Firestore
      //
      try {
        final dto = WordDto.fromWord(word);

        await firestore.uploadWord(dto);

        print('FIRESTORE OK');

        await words.markWordSynced(word.id);

        print('SYNCED');
      } catch (e) {
        print('FIRESTORE ERROR: $e');
      }
    }
  }

  // Future<void> syncAudioForWord(dynamic word) async {
  //   final audioId = word.audioFile;

  //   if (audioId == null || audioId.isEmpty) {
  //     return;
  //   }

  //   final localExists = await audioStorage.exists(audioId);

  //   if (!localExists) {
  //     return;
  //   }

  //   final remoteExists = await storage.exists(audioId);

  //   if (remoteExists) {
  //     return;
  //   }

  //   final file = await audioStorage.getFile(audioId);

  //   await storage.uploadAudio(file, audioId);
  // }

  // Future<void> syncAudioForWord(Word word) async {
  //   final audioId = word.audioFile;

  //   if (audioId == null || audioId.isEmpty) {
  //     return;
  //   }

  //   //////////////////////////////////////
  //   /// Word deleted
  //   //////////////////////////////////////

  //   if (word.deleted) {
  //     try {
  //       await storage.deleteAudio(audioId);
  //     } catch (e) {
  //       print('delete remote audio: $e');
  //     }

  //     try {
  //       await audioStorage.delete(audioId);
  //     } catch (e) {
  //       print('delete local audio: $e');
  //     }

  //     return;
  //   }

  //   //////////////////////////////////////
  //   /// Upload audio
  //   //////////////////////////////////////

  //   final localExists = await audioStorage.exists(audioId);

  //   if (!localExists) {
  //     return;
  //   }

  //   final remoteExists = await storage.exists(audioId);

  //   if (remoteExists) {
  //     return;
  //   }

  //   final file = await audioStorage.getFile(audioId);

  //   await storage.uploadAudio(file, audioId);
  // }

  //////////////////
  ///
  ///

  // Future<void> syncAudioForWord(Word word) async {
  //   final audioId = word.audioFile;

  //   if (audioId == null || audioId.isEmpty) {
  //     return;
  //   }

  //   final localExists = await audioStorage.exists(audioId);

  //   if (!localExists) {
  //     return;
  //   }

  //   final remoteExists = await storage.exists(audioId);

  //   if (remoteExists) {
  //     return;
  //   }

  //   try {
  //     final file = await audioStorage.getFile(audioId);

  //     await storage.uploadAudio(file, audioId);
  //   } catch (e) {
  //     print('syncAudioForWord $e');
  //   }
  // }

  Future<void> syncAudioForWord(Word word) async {
    final audioId = word.audioFile;

    if (audioId == null || audioId.isEmpty) {
      return;
    }

    final localExists = await audioStorage.exists(audioId);

    if (!localExists) {
      return;
    }

    final remoteExists = await storage.exists(audioId);

    if (remoteExists) {
      return;
    }

    try {
      final file = await audioStorage.getFile(audioId);

      await storage.uploadAudio(file, audioId);

      print('AUDIO UPLOADED');
    } catch (e) {
      print('syncAudioForWord: $e');
    }
  }

  Future<void> uploadDirtySettings() async {
    final s = await settings.getDirtySettings();

    if (s == null) {
      return;
    }

    try {
      await firestore.uploadSettings(SettingsDto.fromSettings(s));

      await settings.markSettingsSynced();
    } catch (e) {
      print(e);
    }
  }

  Future<void> dispose() async {
    await stopRealtime();

    await _dirtyFoldersSub?.cancel();
    await _dirtyWordsSub?.cancel();
    await _dirtySettingsSub?.cancel();

    _dirtyFoldersSub = null;
    _dirtyWordsSub = null;
    _dirtySettingsSub = null;

    _debounce?.cancel();
    _debounce = null;
  }

  Future<void> stopRealtime() async {
    await _foldersRealtimeSub?.cancel();
    await _wordsRealtimeSub?.cancel();
    await _settingsRealtimeSub?.cancel();

    _foldersRealtimeSub = null;
    _wordsRealtimeSub = null;
    _settingsRealtimeSub = null;
  }

  Future<void> downloadMissingAudio(WordDto dto) async {
    final audioId = dto.audioFile;

    if (audioId == null || audioId.isEmpty) {
      return;
    }

    final localExists = await audioStorage.exists(audioId);

    if (localExists) {
      return;
    }

    final file = await audioStorage.getFile(audioId);

    await storage.downloadAudio(audioId, file);
  }
}
