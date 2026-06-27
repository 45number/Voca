import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../core/database/word_repository.dart';

import '../../../core/firebase/storage_service.dart';
import 'audio_storage_service.dart';

class AudioGcService {
  final AudioStorageService storage;

  final StorageService remoteStorage;

  final WordRepository words;

  AudioGcService({
    required this.storage,
    required this.remoteStorage,
    required this.words,
  });

  // Future<void> cleanup() async {
  //   final files = await storage.getAllFiles();

  //   final dbWords = await words.getAllWords();

  //   final used = dbWords
  //       .where((w) => w.audioFile != null)
  //       .map((w) => w.audioFile!)
  //       .toSet();

  //   for (final file in files) {
  //     final id = p.basename(file.path);

  //     if (!used.contains(id)) {
  //       try {
  //         await file.delete();
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //   }
  // }

  // Future<void> cleanup() async {
  //   ////////////////////////////////////////////
  //   /// Used audio ids
  //   ////////////////////////////////////////////

  //   final dbWords = await words.getAllWords();

  //   final used = dbWords
  //       .where((w) => w.audioFile != null)
  //       .map((w) => w.audioFile!)
  //       .toSet();

  //   ////////////////////////////////////////////
  //   /// Local orphan cleanup
  //   ////////////////////////////////////////////

  //   final files = await storage.getAllFiles();

  //   for (final file in files) {
  //     final id = p.basename(file.path);

  //     if (!used.contains(id)) {
  //       try {
  //         await file.delete();
  //       } catch (e) {
  //         print('GC local: $e');
  //       }
  //     }
  //   }

  //   ////////////////////////////////////////////
  //   /// Remote deleted words
  //   ////////////////////////////////////////////

  //   final deleted = await words.getDeletedWords();

  //   for (final word in deleted) {
  //     final audioId = word.audioFile;

  //     if (audioId == null || audioId.isEmpty) {
  //       continue;
  //     }

  //     try {
  //       await remoteStorage.deleteAudio(audioId);
  //     } catch (e) {
  //       print('GC remote: $e');
  //     }
  //   }
  // }

  // Future<void> cleanup() async {
  //   ////////////////////////////////////////////
  //   /// Used audio ids
  //   ////////////////////////////////////////////

  //   final dbWords = await words.getAllWords();

  //   final used = dbWords
  //       .where((w) => w.audioFile != null)
  //       .map((w) => w.audioFile!)
  //       .toSet();

  //   ////////////////////////////////////////////
  //   /// Local orphan cleanup
  //   ////////////////////////////////////////////

  //   final files = await storage.getAllFiles();

  //   for (final file in files) {
  //     final id = p.basename(file.path);

  //     if (!used.contains(id)) {
  //       try {
  //         await file.delete();
  //       } catch (e) {
  //         print('GC local: $e');
  //       }
  //     }
  //   }

  //   ////////////////////////////////////////////
  //   /// Remote deleted words
  //   ////////////////////////////////////////////

  //   final deleted = await words.getDeletedWords();

  //   for (final word in deleted) {
  //     // Слово еще не синхронизировано с Firestore.
  //     // Не удаляем удаленное аудио раньше времени.
  //     if (word.pendingSync) {
  //       continue;
  //     }

  //     final audioId = word.audioFile;

  //     if (audioId == null || audioId.isEmpty) {
  //       continue;
  //     }

  //     try {
  //       await remoteStorage.deleteAudio(audioId);
  //     } catch (e) {
  //       print('GC remote: $e');
  //     }
  //   }
  // }

  Future<void> cleanup() async {
    ////////////////////////////////////////////
    /// Used audio ids
    ////////////////////////////////////////////

    final dbWords = await words.getAllWords();

    final used = dbWords
        .where((w) => w.audioFile != null)
        .map((w) => w.audioFile!)
        .toSet();

    ////////////////////////////////////////////
    /// Local orphan cleanup
    ////////////////////////////////////////////

    final files = await storage.getAllFiles();

    for (final file in files) {
      final id = p.basename(file.path);

      if (!used.contains(id)) {
        try {
          await file.delete();
        } catch (e) {
          print('GC local: $e');
        }
      }
    }

    ////////////////////////////////////////////
    /// Remote cleanup
    ////////////////////////////////////////////

    final deleted = await words.getDeletedWords();

    for (final word in deleted) {
      if (word.pendingSync) {
        continue;
      }

      final audioId = word.audioFile;

      if (audioId == null || audioId.isEmpty) {
        continue;
      }

      try {
        final exists = await remoteStorage.exists(audioId);

        if (!exists) {
          continue;
        }

        await remoteStorage.deleteAudio(audioId);
      } catch (e) {
        print('GC remote: $e');
      }
    }
  }
}
