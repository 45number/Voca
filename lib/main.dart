import 'package:flutter/material.dart';

import 'core/database/database_provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

import 'features/folders/folder_page.dart';

///
// import 'package:flutter/material.dart';

import 'core/database/app_database.dart';
// import 'core/database/database_provider.dart';

import 'core/database/folder_repository.dart';
import 'core/database/settings_repository.dart';
import 'core/database/word_repository.dart';

// import 'core/theme/app_theme.dart';
// import 'core/theme/theme_controller.dart';

// import 'features/folders/folder_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const VocaApp());
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final settings = await settingsRepository.getSettings();

//   themeController.setFromDatabase(settings.themeMode);

//   runApp(const VocaApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Database
  database = AppDatabase();

  // Repositories
  folderRepository = FolderRepository(database);
  wordRepository = WordRepository(database);
  settingsRepository = SettingsRepository(database);

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
