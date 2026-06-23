import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/database/database_provider.dart';

import 'core/firebase/firestore_service.dart';
import 'core/firebase/sync_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

import 'features/folders/folder_page.dart';

import 'core/database/app_database.dart';

import 'core/database/folder_repository.dart';
import 'core/database/settings_repository.dart';
import 'core/database/word_repository.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

////////////////
// import 'dart:io';

// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

Future<void> main() async {
  print("1");
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  //////////////////////
  ///
  /////////////////////

  // const resetDb = true;

  // if (resetDb) {
  //   final dir = await getApplicationDocumentsDirectory();

  //   final dbFile = File(p.join(dir.path, 'voca.db'));

  //   if (await dbFile.exists()) {
  //     await dbFile.delete();
  //   }
  // }

  //////////////////
  ///
  ///

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
  print("2");
  // try {
  //   Firebase.app();
  // } catch (_) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  if (defaultTargetPlatform == TargetPlatform.windows) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  print("3");
  // Database
  database = AppDatabase();
  print("4");
  // Repositories
  folderRepository = FolderRepository(database);
  print("5");
  wordRepository = WordRepository(database);
  print("6");
  settingsRepository = SettingsRepository(database);
  print("7");

  syncService = SyncService(
    folders: folderRepository,

    words: wordRepository,

    settings: settingsRepository,

    firestore: FirestoreService(),
  );

  print("8");

  // Theme
  final settings = await settingsRepository.getSettings();

  print("9");

  themeController.setFromDatabase(settings.themeMode);

  print("10");

  runApp(const VocaApp());

  print("11");
}

class VocaApp extends StatelessWidget {
  const VocaApp({super.key});

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
