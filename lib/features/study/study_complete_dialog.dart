import 'package:flutter/material.dart';

class StudyCompleteDialog extends StatelessWidget {
  const StudyCompleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Deck Complete',
      ),
      content: const Text(
        'You have finished all cards in this deck.',
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'OK',
          ),
        ),
      ],
    );
  }
}