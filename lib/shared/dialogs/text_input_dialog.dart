import 'package:flutter/material.dart';

class TextInputDialog {
  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? initialValue,
    String? hintText,
    String confirmText = 'Save',
  }) async {
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(context, value);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
