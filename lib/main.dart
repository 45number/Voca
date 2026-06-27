import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/database/database_provider.dart';

import 'core/firebase/firestore_service.dart';
import 'core/firebase/sync_service.dart';

import 'core/firebase/storage_service.dart';
import 'shared/audio/services/audio_storage_service.dart';
import 'shared/audio/services/audio_gc_service.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

import 'features/folders/folder_page.dart';

import 'core/database/app_database.dart';

import 'core/database/folder_repository.dart';
import 'core/database/settings_repository.dart';
import 'core/database/word_repository.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.windows) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  // // Database
  // database = AppDatabase();
  // // Repositories
  // folderRepository = FolderRepository(database);
  // wordRepository = WordRepository(database);
  // settingsRepository = SettingsRepository(database);
  // syncService = SyncService(
  //   folders: folderRepository,
  //   words: wordRepository,
  //   settings: settingsRepository,
  //   firestore: FirestoreService(),
  // );

  database = AppDatabase();
  folderRepository = FolderRepository(database);
  wordRepository = WordRepository(database);
  settingsRepository = SettingsRepository(database);

  final firestore = FirestoreService();
  final storage = StorageService();
  final audioStorage = AudioStorageService();
  final gc = AudioGcService(
    storage: audioStorage,
    remoteStorage: storage,
    words: wordRepository,
  );

  syncService = SyncService(
    folders: folderRepository,
    words: wordRepository,
    settings: settingsRepository,
    firestore: firestore,
    storage: storage,
    audioStorage: audioStorage,
    gc: gc,
  );

  // Theme
  final settings = await settingsRepository.getSettings();
  themeController.setFromDatabase(settings.themeMode);

  // await syncService.start();

  runApp(const VocaApp());
}

// class VocaApp extends StatelessWidget {
//   const VocaApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: themeController,
//       builder: (context, child) {
//         return MaterialApp(
//           title: 'Voca',

//           debugShowCheckedModeBanner: false,

//           theme: AppTheme.light,

//           darkTheme: AppTheme.dark,

//           themeMode: themeController.themeMode,

//           home: const FolderPage(),
//         );
//       },
//     );
//   }
// }

class VocaApp extends StatefulWidget {
  const VocaApp({super.key});

  @override
  State<VocaApp> createState() => _VocaAppState();
}

class _VocaAppState extends State<VocaApp> {
  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();

    _authSub = FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    try {
      if (user != null) {
        print("Sync START");

        await syncService.start();
      } else {
        print("Sync STOP");

        await syncService.dispose();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,

      builder: (context, child) {
        return MaterialApp(
          title: 'Voca',

          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,

          darkTheme: AppTheme.dark,

          themeMode: themeController.themeMode,

          home: const FolderPage(),
        );
      },
    );
  }
}
