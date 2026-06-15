import 'package:drift/drift.dart';

import 'app_database.dart';

class SettingsRepository {
  final AppDatabase database;

  SettingsRepository(
    this.database,
  );

  Future<AppSetting>
      getSettings() async {
    final existing =
        await database.select(
      database.appSettings,
    ).getSingleOrNull();

    if (existing != null) {
      return existing;
    }

    await database
        .into(database.appSettings)
        .insert(
      AppSettingsCompanion.insert(
        id: const Value(1),
      ),
    );

    return (await database.select(
      database.appSettings,
    ).get())
        .first;
  }

  Future<void> updateLoopCards(
    bool value,
  ) async {
    await (database.update(
      database.appSettings,
    )..where(
            (s) =>
                s.id.equals(1),
          ))
        .write(
      AppSettingsCompanion(
        loopCards:
            Value(value),
      ),
    );
  }

  Future<void> updateRandomOrder(
    bool value,
  ) async {
    await (database.update(
      database.appSettings,
    )..where(
            (s) =>
                s.id.equals(1),
          ))
        .write(
      AppSettingsCompanion(
        randomOrder:
            Value(value),
      ),
    );
  }

  Future<void> updateSilentMode(
    bool value,
  ) async {
    await (database.update(
      database.appSettings,
    )..where(
            (s) =>
                s.id.equals(1),
          ))
        .write(
      AppSettingsCompanion(
        silentMode:
            Value(value),
      ),
    );
  }

  Future<void> updateWordsPerDay(
    int value,
  ) async {
    await (database.update(
      database.appSettings,
    )..where(
            (s) =>
                s.id.equals(1),
          ))
        .write(
      AppSettingsCompanion(
        wordsPerDay:
            Value(value),
      ),
    );
  }

  Future<void> updateFrontSide(
    int value,
  ) async {
    await (database.update(
      database.appSettings,
    )..where(
            (s) =>
                s.id.equals(1),
          ))
        .write(
      AppSettingsCompanion(
        frontSide:
            Value(value),
      ),
    );
  }

  Future<void> updateThemeMode(
    int value,
  ) async {
    await (database.update(
      database.appSettings,
    )..where(
            (s) =>
                s.id.equals(1),
          ))
        .write(
      AppSettingsCompanion(
        themeMode:
            Value(value),
      ),
    );
  }
}