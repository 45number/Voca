import 'package:flutter/material.dart';

class SpellingToolbar extends StatelessWidget {
  final bool loopCards;

  final bool randomOrder;

  final bool silentMode;

  final VoidCallback onToggleLoop;

  final VoidCallback onToggleRandom;

  final VoidCallback onToggleSilent;

  const SpellingToolbar({
    super.key,
    required this.loopCards,
    required this.randomOrder,
    required this.silentMode,
    required this.onToggleLoop,
    required this.onToggleRandom,
    required this.onToggleSilent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: loopCards ? 'Loop On' : 'Loop Off',
          onPressed: onToggleLoop,
          icon: Icon(loopCards ? Icons.repeat_on : Icons.repeat),
        ),
        IconButton(
          tooltip: randomOrder ? 'Random On' : 'Random Off',
          onPressed: onToggleRandom,
          icon: Icon(randomOrder ? Icons.shuffle : Icons.swap_horiz),
        ),
        IconButton(
          tooltip: silentMode ? 'Silent On' : 'Silent Off',
          onPressed: onToggleSilent,
          icon: Icon(silentMode ? Icons.volume_off : Icons.volume_up),
        ),
      ],
    );
  }
}
