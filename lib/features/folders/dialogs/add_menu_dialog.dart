import 'package:flutter/material.dart';

enum AddMenuResult { folder, word, browseWords }

class AddMenuDialog {
  static Future<AddMenuResult?> show({
    required BuildContext context,
    required bool isRoot,
  }) {
    return showDialog<AddMenuResult>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Add Folder'),
                onTap: () {
                  Navigator.pop(context, AddMenuResult.folder);
                },
              ),

              if (!isRoot)
                ListTile(
                  leading: const Icon(Icons.translate_outlined),
                  title: const Text('Add Word'),
                  onTap: () {
                    Navigator.pop(context, AddMenuResult.word);
                  },
                ),

              if (!isRoot)
                ListTile(
                  leading: const Icon(Icons.list_alt_outlined),
                  title: const Text('Browse Words'),
                  onTap: () {
                    Navigator.pop(context, AddMenuResult.browseWords);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
