//Theme imports:
import 'package:flutter/material.dart';

//Database imports:
import '../../core/database/database_provider.dart';

//AudioEditor import:
import '../../shared/audio/controllers/audio_editor_controller.dart';
import '../../shared/audio/widgets/audio_input_widget.dart';

import '../../core/database/app_database.dart';

import 'package:drift/drift.dart';

class WordEditor extends StatefulWidget {
  final String folderId;

  // final dynamic initialWord;
  final Word? initialWord;

  const WordEditor({super.key, required this.folderId, this.initialWord});

  @override
  State<WordEditor> createState() => _WordEditorState();
}

class _WordEditorState extends State<WordEditor> {
  bool isSaving = false;

  final editor = AudioEditorController();

  final wordController = TextEditingController();

  final translationController = TextEditingController();

  final wordFocusNode = FocusNode();

  bool get isEditMode {
    return widget.initialWord != null;
  }

  @override
  void initState() {
    super.initState();

    _loadInitialWord();
  }

  // Future<void> _loadInitialWord() async {
  //   if (!isEditMode) {
  //     return;
  //   }

  //   final word = widget.initialWord;

  //   wordController.text = word.word;

  //   translationController.text = word.translation;

  //   if (word.audioFile != null) {
  //     await editor.loadFile(word.audioFile);
  //   }
  // }

  Future<void> _loadInitialWord() async {
    if (!isEditMode) {
      return;
    }

    final word = widget.initialWord!;

    wordController.text = word.word;

    translationController.text = word.translation;

    final audioFile = word.audioFile;

    if (audioFile != null && audioFile.isNotEmpty) {
      await editor.loadFile(audioFile);
    }
  }

  @override
  void dispose() {
    wordController.dispose();

    translationController.dispose();

    wordFocusNode.dispose();

    editor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // TextField(
        //   controller: wordController,
        //   textDirection: TextDirection.rtl,
        //   decoration: const InputDecoration(
        //     labelText: 'Word',
        //     border: OutlineInputBorder(),
        //   ),
        // ),
        TextField(
          controller: wordController,

          focusNode: wordFocusNode,

          textDirection: TextDirection.rtl,

          decoration: const InputDecoration(
            labelText: 'Word',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: translationController,
          textDirection: TextDirection.ltr,
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
              : Text(isEditMode ? 'Update' : 'Save'),
        ),
      ],
    );
  }

  Future<void> startRecording() async {
    final success = await editor.startRecording();

    if (!success) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );

      return;
    }
  }

  Future<void> stopRecording() async {
    final success = await editor.stopRecording();

    if (!success) {
      return;
    }
  }

  Future<void> pickAudioFile() async {
    await editor.importAudioFile();
  }

  // Future<void> save() async {
  //   final word = wordController.text.trim();
  //   final translation = translationController.text.trim();
  //   if (word.isEmpty || translation.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Word and translation are required')),
  //     );

  //     return;
  //   }
  //   setState(() {
  //     isSaving = true;
  //   });

  //   try {
  //     await wordRepository.createWord(
  //       folderId: widget.folderId,
  //       word: word,
  //       translation: translation,
  //       audioFile: editor.selectedAudioFile,
  //     );

  //     // Сообщаем контроллеру, что файл успешно сохранен
  //     editor.markSaved();

  //     // Очищаем редактор аудио
  //     await editor.reset();

  //     // Очищаем поля ввода
  //     wordController.clear();
  //     translationController.clear();

  //     wordFocusNode.requestFocus();

  //     if (!mounted) {
  //       return;
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Word saved'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   } catch (e) {
  //     if (!mounted) {
  //       return;
  //     }

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Failed to save word: $e')));
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         isSaving = false;
  //       });
  //     }
  //   }
  // }

  Future<void> save() async {
    final word = wordController.text.trim();
    final translation = translationController.text.trim();

    if (word.isEmpty || translation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word and translation are required')),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      if (isEditMode) {
        await wordRepository.updateWord(
          id: widget.initialWord!.id,

          word: word,

          translation: translation,

          audioFile: editor.selectedAudioFile,
        );

        editor.markSaved();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word updated'),

            duration: Duration(seconds: 1),
          ),
        );

        // Navigator.pop(context, true);
        final updatedWord = widget.initialWord!.copyWith(
          word: word,

          translation: translation,

          audioFile: Value(editor.selectedAudioFile),
        );

        Navigator.pop(context, updatedWord);

        return;
      } else {
        await wordRepository.createWord(
          folderId: widget.folderId,

          word: word,

          translation: translation,

          audioFile: editor.selectedAudioFile,
        );

        editor.markSaved();

        await editor.reset();

        wordController.clear();

        translationController.clear();

        wordFocusNode.requestFocus();
      }

      if (!mounted) return;

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(isEditMode ? 'Word updated' : 'Word saved')),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Word saved'),

          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }
}
