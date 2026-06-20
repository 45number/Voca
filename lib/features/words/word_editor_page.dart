import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import 'word_editor.dart';

class WordEditorPage extends StatelessWidget {
  final String folderId;

  final Word? initialWord;

  const WordEditorPage({super.key, required this.folderId, this.initialWord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(initialWord == null ? 'Add word' : 'Edit word'),
      ),

      body: WordEditor(folderId: folderId, initialWord: initialWord),
    );
  }
}
