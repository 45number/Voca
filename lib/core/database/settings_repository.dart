import 'package:drift/drift.dart';

import 'app_database.dart';

class SettingsRepository {
  final AppDatabase database;

  SettingsRepository(this.database);

  int get _now => DateTime.now().millisecondsSinceEpoch;

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
          ),
        );

    return (await database.select(database.appSettings).get()).first;
  }

  Future<void> updateLoopCards(bool value) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(loopCards: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> updateRandomOrder(bool value) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(randomOrder: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> updateSilentMode(bool value) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(silentMode: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> updateWordsPerDay(int value) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(wordsPerDay: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> updateFrontSide(int value) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(frontSide: Value(value), updatedAt: Value(_now)),
    );
  }

  Future<void> updateThemeMode(int value) async {
    await (database.update(
      database.appSettings,
    )..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(themeMode: Value(value), updatedAt: Value(_now)),
    );
  }
}
