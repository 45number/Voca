import 'package:flutter/material.dart';

import '../study_mode.dart';

class StudyModeDialog {
  static Future<StudyMode?> show(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Study Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('Memorizing'),
                onTap: () {
                  Navigator.pop(context, 'memorizing');
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Spelling'),
                onTap: () {
                  Navigator.pop(context, 'spelling');
                },
              ),
            ],
          ),
        );
      },
    );

    switch (result) {
      case 'memorizing':
        return StudyMode.memorizing;

      case 'spelling':
        return StudyMode.spelling;

      default:
        return null;
    }
  }
}
