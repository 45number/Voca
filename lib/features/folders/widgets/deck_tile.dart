import 'package:flutter/material.dart';

import '../../decks/deck_info.dart';

class DeckTile extends StatelessWidget {
  final DeckInfo deck;
  final VoidCallback onTap;

  const DeckTile({
    super.key,
    required this.deck,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.style_outlined,
        ),
        title: Text(
          'Deck ${deck.index}',
        ),
        subtitle: Text(
          '${deck.wordCount} words',
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}