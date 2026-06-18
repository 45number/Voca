import 'package:flutter/material.dart';

import '../../core/database/database_provider.dart';
import '../../shared/audio/controllers/audio_editor_controller.dart';
import '../../shared/audio/exporters/passthrough_exporter.dart';
import '../../shared/audio/widgets/audio_editor_widget.dart';
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
        ///////////////////////////////////
        const Text(
          'AudioInputWidget Start',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        AudioInputWidget(controller: editor),
        const Text(
          'AudioInputWidget End',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 24),

        /////////////////////////////
        // AnimatedBuilder(
        //   animation: editor,
        //   builder: (_, __) {
        //     if (editor.isRecording) {
        //       return FilledButton.icon(
        //         onPressed: stopRecording,
        //         icon: const Icon(Icons.stop),
        //         label: const Text('Stop Recording'),
        //       );
        //     }

        //     return OutlinedButton.icon(
        //       onPressed: startRecording,
        //       icon: const Icon(Icons.mic),
        //       label: const Text('Start Recording'),
        //     );
        //   },
        // ),

        // AnimatedBuilder(
        //   animation: editor,
        //   builder: (_, __) {
        //     if (!editor.isRecording) {
        //       return const SizedBox();
        //     }

        //     return Container(
        //       height: 80,
        //       margin: const EdgeInsets.only(top: 12, bottom: 12),
        //       padding: const EdgeInsets.symmetric(horizontal: 8),
        //       decoration: BoxDecoration(
        //         border: Border.all(
        //           color: Theme.of(context).colorScheme.outline,
        //         ),
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: editor.liveWaveform.map((value) {
        //           final normalized = ((value + 60) / 60).clamp(0.05, 1.0);

        //           return Expanded(
        //             child: Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 1),
        //               child: Container(
        //                 height: normalized * 60,
        //                 decoration: BoxDecoration(
        //                   color: Theme.of(context).colorScheme.primary,
        //                   borderRadius: BorderRadius.circular(2),
        //                 ),
        //               ),
        //             ),
        //           );
        //         }).toList(),
        //       ),
        //     );
        //   },
        // ),
        // const SizedBox(height: 8),

        // OutlinedButton.icon(
        //   onPressed: pickAudioFile,
        //   icon: const Icon(Icons.attach_file),
        //   label: const Text('Attach Audio File'),
        // ),
        const SizedBox(height: 12),

        AnimatedBuilder(
          animation: editor,
          builder: (_, __) {
            return Text(
              editor.selectedAudioFile == null
                  ? 'No audio selected'
                  : editor.selectedAudioFile!.split('\\').last,
            );
          },
        ),

        const SizedBox(height: 12),

        AnimatedBuilder(
          animation: editor,
          builder: (_, __) {
            if (editor.waveform.isEmpty) {
              return const SizedBox();
            }

            return AudioEditorWidget(controller: editor);
          },
        ),

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

  Future<void> save() async {
    final word = wordController.text.trim();

    final translation = translationController.text.trim();

    if (word.isEmpty || translation.isEmpty) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    await wordRepository.createWord(
      folderId: widget.folderId,
      word: word,
      translation: translation,
      audioFile: editor.selectedAudioFile,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
