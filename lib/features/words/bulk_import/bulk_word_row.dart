import 'package:flutter/material.dart';

class BulkWordRow {
  final TextEditingController wordController;

  final TextEditingController translationController;

  final FocusNode wordFocusNode;

  final FocusNode translationFocusNode;

  bool wordError;

  bool translationError;

  String? audioFile;

  bool isRecordedAudio;

  BulkWordRow({
    String word = '',
    String translation = '',
    this.wordError = false,
    this.translationError = false,
    this.audioFile,
    this.isRecordedAudio = false,
  })  : wordController =
            TextEditingController(
          text: word,
        ),
        translationController =
            TextEditingController(
          text: translation,
        ),
        wordFocusNode = FocusNode(),
        translationFocusNode = FocusNode();

  bool get isEmpty {
    return wordController.text
            .trim()
            .isEmpty &&
        translationController.text
            .trim()
            .isEmpty;
  }

  bool get hasPartialData {
    final word =
        wordController.text.trim();

    final translation =
        translationController.text.trim();

    return (word.isNotEmpty &&
            translation.isEmpty) ||
        (word.isEmpty &&
            translation.isNotEmpty);
  }

  void dispose() {
    wordController.dispose();
    translationController.dispose();

    wordFocusNode.dispose();
    translationFocusNode.dispose();
  }
}