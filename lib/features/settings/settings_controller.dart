import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import '../../core/theme/theme_controller.dart';

class SettingsController {
  Future<AppSetting> load() {
    return settingsRepository.getSettings();
  }

  Future<void> updateWordsPerDay(int value) async {
    await settingsRepository.updateWordsPerDay(value);
  }

  Future<void> updateFrontSide(int value) async {
    await settingsRepository.updateFrontSide(value);
  }

  Future<void> updateLoopCards(bool value) async {
    await settingsRepository.updateLoopCards(value);
  }

  Future<void> updateRandomOrder(bool value) async {
    await settingsRepository.updateRandomOrder(value);
  }

  Future<void> updateSilentMode(bool value) async {
    await settingsRepository.updateSilentMode(value);
  }

  Future<void> updateThemeMode(
    int value,
    ThemeController themeController,
  ) async {
    await settingsRepository.updateThemeMode(value);

    switch (value) {
      case 1:
        themeController.setThemeMode(ThemeMode.light);
        break;

      case 2:
        themeController.setThemeMode(ThemeMode.dark);
        break;

      default:
        themeController.setThemeMode(ThemeMode.system);
    }
  }
}
