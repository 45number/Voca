import 'package:flutter/material.dart';

import '../../core/database/database_provider.dart';
import '../../shared/audio/controllers/audio_editor_controller.dart';
import '../../shared/audio/exporters/passthrough_exporter.dart';
import '../../shared/audio/widgets/audio_input_widget.dart';

class SingleWordTab extends StatefulWidget {
  final String folderId;

  const SingleWordTab({super.key, required this.folderId});

  @override
  State<SingleWordTab> createState() => _SingleWordTabState();
}

class _SingleWordTabState extends State<SingleWordTab> {
  bool isSaving = false;

  final editor = AudioEditorController();
  final exporter = PassthroughExporter();

  final wordController = TextEditingController();

  final translationController = TextEditingController();

  @override
  void dispose() {
    wordController.dispose();
    translationController.dispose();
    editor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: wordController,
          decoration: const InputDecoration(
            labelText: 'Word',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: translationController,
          decoration: const InputDecoration(
            labelText: 'Translation',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Audio',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 12),

        AudioInputWidget(controller: editor),

        const SizedBox(height: 32),

        FilledButton(
          onPressed: isSaving ? null : save,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> save() async {
    final word = wordController.text.trim();
    final translation = translationController.text.trim();
    if (word.isEmpty || translation.isEmpty) {
      return;
    }
    setState(() {
      isSaving = true;
    });
    // await wordRepository.createWord(
    //   folderId: widget.folderId,
    //   word: word,
    //   translation: translation,
    //   audioFile: editor.selectedAudioFile,
    // );

    // String? audioPath;

    // final result = editor.buildResult();

    // if (result != null) {
    //   audioPath = await exporter.export(result);
    // }

    String? audioPath;

    if (editor.hasAudio) {
      final result = editor.buildResult();

      audioPath = await exporter.export(result);
    }

    await wordRepository.createWord(
      folderId: widget.folderId,
      word: word,
      translation: translation,
      audioFile: audioPath,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
