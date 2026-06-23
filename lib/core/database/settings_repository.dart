// import 'package:drift/drift.dart';

// import 'app_database.dart';

// class SettingsRepository {
//   final AppDatabase database;

//   SettingsRepository(this.database);

//   int get _now => DateTime.now().millisecondsSinceEpoch;

//   Future<AppSetting> getSettings() async {
//     final existing = await database
//         .select(database.appSettings)
//         .getSingleOrNull();

//     if (existing != null) {
//       return existing;
//     }

//     await database
//         .into(database.appSettings)
//         .insert(
//           AppSettingsCompanion.insert(
//             id: const Value(1),

//             createdAt: Value(_now),

//             updatedAt: Value(_now),
//           ),
//         );

//     return (await database.select(database.appSettings).get()).first;
//   }

//   Future<void> updateLoopCards(bool value) async {
//     await (database.update(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).write(
//       AppSettingsCompanion(loopCards: Value(value), updatedAt: Value(_now)),
//     );
//   }

//   Future<void> updateRandomOrder(bool value) async {
//     await (database.update(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).write(
//       AppSettingsCompanion(randomOrder: Value(value), updatedAt: Value(_now)),
//     );
//   }

//   Future<void> updateSilentMode(bool value) async {
//     await (database.update(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).write(
//       AppSettingsCompanion(silentMode: Value(value), updatedAt: Value(_now)),
//     );
//   }

//   Future<void> updateWordsPerDay(int value) async {
//     await (database.update(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).write(
//       AppSettingsCompanion(wordsPerDay: Value(value), updatedAt: Value(_now)),
//     );
//   }

//   Future<void> updateFrontSide(int value) async {
//     await (database.update(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).write(
//       AppSettingsCompanion(frontSide: Value(value), updatedAt: Value(_now)),
//     );
//   }

//   Future<void> updateThemeMode(int value) async {
//     await (database.update(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).write(
//       AppSettingsCompanion(themeMode: Value(value), updatedAt: Value(_now)),
//     );
//   }

//   Future<void> upsertSettings(AppSettingsCompanion settings) async {
//     await database.into(database.appSettings).insertOnConflictUpdate(settings);
//   }

//   Stream<AppSetting> watchSettings() {
//     return (database.select(
//       database.appSettings,
//     )..where((s) => s.id.equals(1))).watchSingle();
//   }
// }

import 'package:drift/drift.dart';

import '../firebase/dto/settings_dto.dart';
import 'app_database.dart';

class SettingsRepository {
  final AppDatabase database;

  SettingsRepository(this.database);

  int get _now => DateTime.now().millisecondsSinceEpoch;

  ////////////////////////////////////////////////////////
  ///
  /// Get
  ///
  ////////////////////////////////////////////////////////

  Future<AppSetting> getSettings() async {
    final existing = await database
        .select(database.appSettings)
        .getSingleOrNull();

    if (existing != null) {
      return existing;
    }

    await database
        .into(database.appSettings)
        .insert(
          AppSettingsCompanion.insert(
            id: const Value(1),

            createdAt: Value(_now),

            updatedAt: Value(_now),

            pendingSync: const Value(true),
          ),
        );

    // return (await database.select(database.appSettings).get()).x;
    return (await database.select(database.appSettings).get()).first;
  }

  Future<AppSetting?> getDirtySettings() async {
    final settings = await getSettings();

    if (settings.pendingSync) {
      return settings;
    }

    return null;
  }

  ////////////////////////////////////////////////////////
  ///
  /// Update
  ///
  ////////////////////////////////////////////////////////

  Future<void> updateLoopCards(bool value) async {
    await _update(AppSettingsCompanion(loopCards: Value(value)));
  }

  Future<void> updateRandomOrder(bool value) async {
    await _update(AppSettingsCompanion(randomOrder: Value(value)));
  }

  Future<void> updateSilentMode(bool value) async {
    await _update(AppSettingsCompanion(silentMode: Value(value)));
  }

  Future<void> updateWordsPerDay(int value) async {
    await _update(AppSettingsCompanion(wordsPerDay: Value(value)));
  }

  Future<void> updateFrontSide(int value) async {
    await _update(AppSettingsCompanion(frontSide: Value(value)));
  }

  Future<void> updateThemeMode(int value) async {
    await _update(AppSettingsCompanion(themeMode: Value(value)));
  }

  Future<void> _update(AppSettingsCompanion companion) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      companion.copyWith(
        updatedAt: Value(_now),

        pendingSync: const Value(true),
      ),
    );
  }

  ////////////////////////////////////////////////////////
  ///
  /// Sync
  ///
  ////////////////////////////////////////////////////////

  Future<void> markSettingsSynced() async {
    await (database.update(database.appSettings)..where((s) => s.id.equals(1)))
        .write(const AppSettingsCompanion(pendingSync: Value(false)));
  }

  Future<void> upsertIfNewer(SettingsDto dto) async {
    final local = await getSettings();

    if (dto.updatedAt <= local.updatedAt) {
      return;
    }

    await upsertSettings(
      dto.toCompanion().copyWith(pendingSync: const Value(false)),
    );
  }

  Future<void> upsertSettings(AppSettingsCompanion settings) async {
    await database.into(database.appSettings).insertOnConflictUpdate(settings);
  }

  ////////////////////////////////////////////////////////
  ///
  /// Watch
  ///
  ////////////////////////////////////////////////////////

  Stream<AppSetting> watchSettings() {
    return (database.select(
      database.appSettings,
    )..where((s) => s.id.equals(1))).watchSingle();
  }

  Stream<int> watchDirtySettings() {
    return watchSettings().map((s) => s.pendingSync ? 1 : 0);
  }
}
