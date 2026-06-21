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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Database
  database = AppDatabase();

  // Repositories
  folderRepository = FolderRepository(database);
  wordRepository = WordRepository(database);
  settingsRepository = SettingsRepository(database);

  syncService = SyncService(
    folders: folderRepository,

    words: wordRepository,

    settings: settingsRepository,

    firestore: FirestoreService(),
  );

  // Theme
  final settings = await settingsRepository.getSettings();

  themeController.setFromDatabase(settings.themeMode);

  runApp(const VocaApp());
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
