import 'app_database.dart';
import 'folder_repository.dart';
import 'settings_repository.dart';
import 'word_repository.dart';

import '../firebase/sync_service.dart';
// import '../firebase/firestore_service.dart';

late final AppDatabase database;

late final FolderRepository folderRepository;

late final WordRepository wordRepository;

late final SettingsRepository settingsRepository;

late SyncService syncService;
