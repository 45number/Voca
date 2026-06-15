import 'package:flutter/material.dart';

class SpellingNavigationBar extends StatelessWidget {
  final VoidCallback onPrevious;

  final VoidCallback onNext;

  final VoidCallback onPlayAudio;

  final VoidCallback onToggleDifficult;

  final VoidCallback onToggleLoop;

  final VoidCallback onToggleRandom;

  final VoidCallback onToggleSilent;

  final bool isDifficult;

  final bool loopCards;

  final bool randomOrder;

  final bool silentMode;

  const SpellingNavigationBar({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onPlayAudio,
    required this.onToggleDifficult,
    required this.onToggleLoop,
    required this.onToggleRandom,
    required this.onToggleSilent,
    required this.isDifficult,
    required this.loopCards,
    required this.randomOrder,
    required this.silentMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left, size: 32),
        ),

        PopupMenuButton<String>(
          icon: const Icon(Icons.settings),
          onSelected: (value) {
            switch (value) {
              case 'loop':
                onToggleLoop();
                break;

              case 'random':
                onToggleRandom();
                break;

              case 'silent':
                onToggleSilent();
                break;
            }
          },
          itemBuilder: (context) => [
            CheckedPopupMenuItem(
              value: 'loop',
              checked: loopCards,
              child: const Text('Loop cards'),
            ),

            CheckedPopupMenuItem(
              value: 'random',
              checked: randomOrder,
              child: const Text('Random order'),
            ),

            CheckedPopupMenuItem(
              value: 'silent',
              checked: silentMode,
              child: const Text('Silent mode'),
            ),
          ],
        ),

        IconButton(
          onPressed: onToggleDifficult,
          icon: Icon(isDifficult ? Icons.star : Icons.star_border, size: 30),
        ),

        IconButton(
          onPressed: onPlayAudio,
          icon: const Icon(Icons.volume_up, size: 28),
        ),

        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right, size: 32),
        ),
      ],
    );
  }
}
