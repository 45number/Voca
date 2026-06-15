import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/theme.dart';
import '../../core/theme/theme_controller.dart';

import 'front_side.dart';
import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = SettingsController();

  AppSetting? settings;

  @override
  void initState() {
    super.initState();

    loadSettings();
  }

  Future<void> loadSettings() async {
    settings = await controller.load();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final frontSide = settings!.frontSide == 0
        ? FrontSide.word
        : FrontSide.translation;

    final themeMode = settings!.themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Words Per Day'),
            subtitle: Text(settings!.wordsPerDay.toString()),
            trailing: const Icon(Icons.chevron_right),
            onTap: changeWordsPerDay,
          ),

          const Divider(),

          const Padding(padding: AppPadding.section, child: Text('Front Side')),

          RadioGroup<FrontSide>(
            groupValue: frontSide,
            onChanged: updateFrontSide,
            child: Column(
              children: [
                RadioListTile<FrontSide>(
                  value: FrontSide.word,
                  title: const Text('Word'),
                ),
                RadioListTile<FrontSide>(
                  value: FrontSide.translation,
                  title: const Text('Translation'),
                ),
              ],
            ),
          ),

          const Divider(),

          const Padding(padding: AppPadding.section, child: Text('Theme')),

          RadioGroup<int>(
            groupValue: themeMode,
            onChanged: updateThemeMode,
            child: Column(
              children: [
                RadioListTile<int>(value: 0, title: const Text('System')),
                RadioListTile<int>(value: 1, title: const Text('Light')),
                RadioListTile<int>(value: 2, title: const Text('Dark')),
              ],
            ),
          ),

          const Divider(),

          SwitchListTile(
            title: const Text('Default Loop'),
            value: settings!.loopCards,
            onChanged: updateLoopCards,
          ),

          SwitchListTile(
            title: const Text('Default Random'),
            value: settings!.randomOrder,
            onChanged: updateRandomOrder,
          ),

          SwitchListTile(
            title: const Text('Default Silent'),
            value: settings!.silentMode,
            onChanged: updateSilentMode,
          ),
        ],
      ),
    );
  }

  Future<void> changeWordsPerDay() async {
    final textController = TextEditingController(
      text: settings!.wordsPerDay.toString(),
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Words Per Day'),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final value = int.tryParse(textController.text);

                if (value == null || value <= 0) {
                  return;
                }

                await controller.updateWordsPerDay(value);

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

                await loadSettings();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateFrontSide(FrontSide? value) async {
    if (value == null) {
      return;
    }

    await controller.updateFrontSide(value == FrontSide.word ? 0 : 1);

    await loadSettings();
  }

  Future<void> updateThemeMode(int? value) async {
    if (value == null) {
      return;
    }

    await controller.updateThemeMode(value, themeController);

    await loadSettings();
  }

  Future<void> updateLoopCards(bool value) async {
    await controller.updateLoopCards(value);

    await loadSettings();
  }

  Future<void> updateRandomOrder(bool value) async {
    await controller.updateRandomOrder(value);

    await loadSettings();
  }

  Future<void> updateSilentMode(bool value) async {
    await controller.updateSilentMode(value);

    await loadSettings();
  }
}
