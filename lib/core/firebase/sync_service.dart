import 'dart:async';

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
  });

  // Future<void> start() async {
  //   await stopRealtime();

  //   await observeDirty();

  //   await startRealtime();

  //   await uploadDirty();
  // }
  Future<void> start() async {
    await dispose();

    await observeDirty();

    await startRealtime();

    await uploadDirty();
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

    _wordsRealtimeSub = firestore.listenWords().listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        final data = change.doc.data();

        if (data == null) continue;

        final dto = WordDto.fromJson(data);

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

  Future<void> uploadDirty() async {
    await Future.wait([
      uploadDirtyFolders(),
      uploadDirtyWords(),
      uploadDirtySettings(),
    ]);
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

  Future<void> uploadDirtyWords() async {
    final dirty = await words.getDirtyWords();

    for (final word in dirty) {
      try {
        final dto = WordDto.fromWord(word);

        await firestore.uploadWord(dto);

        await words.markWordSynced(word.id);
      } catch (e) {
        print(e);
      }
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
}
