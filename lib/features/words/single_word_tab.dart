import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/database/database_provider.dart';
import '../study/audio_recorder_service.dart';

import 'dart:async';

class SingleWordTab extends StatefulWidget {
  final String folderId;

  const SingleWordTab({super.key, required this.folderId});

  @override
  State<SingleWordTab> createState() => _SingleWordTabState();
}

class _SingleWordTabState extends State<SingleWordTab> {
  bool isSaving = false;

  bool isRecording = false;

  List<double> amplitudes = [];

  String? selectedAudioFile;

  StreamSubscription? amplitudeSubscription;

  final recorder = AudioRecorderService();

  final wordController = TextEditingController();

  final translationController = TextEditingController();

  @override
  void dispose() {
    wordController.dispose();
    translationController.dispose();

    amplitudeSubscription?.cancel();

    recorder.dispose();

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

        if (!isRecording)
          OutlinedButton.icon(
            onPressed: startRecording,
            icon: const Icon(Icons.mic),
            label: const Text('Start Recording'),
          ),

        if (isRecording)
          FilledButton.icon(
            onPressed: stopRecording,
            icon: const Icon(Icons.stop),
            label: const Text('Stop Recording'),
          ),

        if (isRecording)
          Container(
            height: 80,
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: amplitudes.map((value) {
                final normalized = ((value + 60) / 60).clamp(0.05, 1.0);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      height: normalized * 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 8),

        OutlinedButton.icon(
          onPressed: pickAudioFile,
          icon: const Icon(Icons.attach_file),
          label: const Text('Attach Audio File'),
        ),

        const SizedBox(height: 12),

        Text(
          selectedAudioFile == null
              ? 'No audio selected'
              : selectedAudioFile!.split('\\').last,
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
    final hasPermission = await recorder.hasPermission();

    if (!hasPermission) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );

      return;
    }

    await recorder.startRecording();

    amplitudeSubscription?.cancel();

    amplitudeSubscription = recorder.onAmplitudeChanged().listen((amplitude) {
      if (!mounted) {
        return;
      }

      setState(() {
        amplitudes.add(amplitude.current);

        if (amplitudes.length > 40) {
          amplitudes.removeAt(0);
        }
      });
    });

    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    final path = await recorder.stopRecording();

    await amplitudeSubscription?.cancel();

    amplitudeSubscription = null;

    setState(() {
      isRecording = false;

      amplitudes.clear();

      selectedAudioFile = path;
    });
  }

  Future<void> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
    );

    if (result == null) {
      return;
    }

    final path = result.files.single.path;

    if (path == null) {
      return;
    }

    setState(() {
      selectedAudioFile = path;
    });
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
      audioFile: selectedAudioFile,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
