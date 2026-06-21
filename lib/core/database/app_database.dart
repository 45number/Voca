import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/app_settings.dart';
import 'tables/folders.dart';
import 'tables/words.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Folders, Words, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(appSettings);
      }

      if (from < 3) {
        await m.addColumn(appSettings, appSettings.themeMode);
      }

      if (from < 4) {
        await m.addColumn(
          words,
          words.difficultMemorizing as GeneratedColumn<Object>,
        );

        await m.addColumn(
          words,
          words.difficultSpelling as GeneratedColumn<Object>,
        );
      }

      if (from < 5) {
        await m.addColumn(
          folders,
          folders.createdAt as GeneratedColumn<Object>,
        );

        await m.addColumn(
          folders,
          folders.sortOrder as GeneratedColumn<Object>,
        );

        await m.addColumn(words, words.createdAt as GeneratedColumn<Object>);

        await m.addColumn(
          appSettings,
          appSettings.createdAt as GeneratedColumn<Object>,
        );

        await m.addColumn(
          appSettings,
          appSettings.updatedAt as GeneratedColumn<Object>,
        );
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    // final dir = await getApplicationSupportDirectory();

    final file = File(p.join(dir.path, 'voca.db'));

    return NativeDatabase(file);
  });
}
