import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class StudyNavigationBar extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  final bool isRevealed;

  final bool isDifficult;

  final VoidCallback onPrevious;

  final VoidCallback onNext;

  final VoidCallback onPlayAudio;

  final VoidCallback onToggleDifficult;

  const StudyNavigationBar({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.isRevealed,
    required this.isDifficult,
    required this.onPrevious,
    required this.onNext,
    required this.onPlayAudio,
    required this.onToggleDifficult,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(isRevealed ? 'Tap card for next word' : 'Tap card to reveal'),

        const SizedBox(height: AppSpacing.lg),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left, size: 32),
            ),

            IconButton(
              onPressed: onPlayAudio,
              icon: const Icon(Icons.volume_up, size: 28),
            ),

            IconButton(
              onPressed: onToggleDifficult,
              icon: Icon(
                isDifficult ? Icons.star : Icons.star_border,
                size: 30,
              ),
            ),

            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right, size: 32),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          '${currentIndex + 1} / $totalCount',
          style: AppTypography.progress,
        ),
      ],
    );
  }
}
