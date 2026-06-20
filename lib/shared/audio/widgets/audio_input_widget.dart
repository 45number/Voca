import 'package:flutter/material.dart';

import '../controllers/audio_editor_controller.dart';
import 'audio_editor_widget.dart';

class AudioInputWidget extends StatelessWidget {
  final AudioEditorController controller;

  const AudioInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!controller.isRecording)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await controller.startRecording();
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text('Start Recording'),
                ),
              ),

            if (controller.isRecording)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await controller.stopRecording();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop Recording'),
                ),
              ),
            if (controller.isRecording)
              Container(
                height: 80,

                margin: const EdgeInsets.only(top: 12, bottom: 12),

                padding: const EdgeInsets.symmetric(horizontal: 8),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: controller.liveWaveform.map((value) {
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

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: () async {
                  await controller.importAudioFile();
                },

                icon: const Icon(Icons.attach_file),

                label: const Text('Attach Audio File'),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              controller.selectedAudioFile == null
                  ? 'No audio selected'
                  : controller.selectedAudioFile!.split('\\').last,
            ),

            const SizedBox(height: 12),

            if (controller.waveform.isNotEmpty)
              AudioEditorWidget(controller: controller),
          ],
        );
      },
    );
  }
}
