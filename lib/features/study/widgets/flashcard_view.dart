import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/theme.dart';

class FlashcardView extends StatelessWidget {
  final Word word;

  final String frontText;
  final String backText;

  final bool isRevealed;

  final VoidCallback onTap;
  final VoidCallback onPlayAudio;

  const FlashcardView({
    super.key,
    required this.word,
    required this.frontText,
    required this.backText,
    required this.isRevealed,
    required this.onTap,
    required this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: AppSizes.cardElevation,
        child: Padding(
          padding: AppPadding.card,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  frontText,
                  textAlign: TextAlign.center,
                  style: AppTypography.flashcardFront,
                ),

                if (word.audioFile != null && word.audioFile!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: IconButton(
                      iconSize: 40,
                      onPressed: onPlayAudio,
                      icon: const Icon(Icons.volume_up),
                    ),
                  ),

                if (isRevealed) ...[
                  const SizedBox(height: AppSpacing.lg),

                  const Divider(),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    backText,
                    textAlign: TextAlign.center,
                    style: AppTypography.flashcardBack,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
