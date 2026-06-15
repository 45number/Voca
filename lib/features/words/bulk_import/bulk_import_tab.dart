import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/database/database_provider.dart';
import 'bulk_word_row.dart';

class BulkImportTab extends StatefulWidget {
  final String folderId;

  const BulkImportTab({
    super.key,
    required this.folderId,
  });

  @override
  State<BulkImportTab> createState() =>
      _BulkImportTabState();
}

class _BulkImportTabState
    extends State<BulkImportTab> {
  bool isSaving = false;

  final List<BulkWordRow> rows = [
    BulkWordRow(),
  ];

  @override
  void dispose() {
    for (final row in rows) {
      row.dispose();
    }

    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
        children: [
        Row(
            children: [
            Expanded(
                child: OutlinedButton.icon(
                onPressed: pasteFromClipboard,
                icon: const Icon(
                    Icons.content_paste,
                ),
                label: const Text(
                    'Paste From Clipboard',
                ),
                ),
            ),
            ],
        ),

        const SizedBox(height: 16),

        Expanded(
            child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (
                context,
                index,
            ) {
                final row = rows[index];

                return Padding(
                padding:
                    const EdgeInsets.only(
                    bottom: 12,
                ),
                child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                    Expanded(
                        flex: 3,
                        child: Focus(
                        onKeyEvent: (
                            node,
                            event,
                        ) {
                            if (event
                                    is KeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey
                                        .tab) {
                            final shiftPressed =
                                HardwareKeyboard
                                    .instance
                                    .isShiftPressed;

                            if (shiftPressed) {
                                if (index > 0) {
                                rows[index - 1]
                                    .translationFocusNode
                                    .requestFocus();
                                }

                                return KeyEventResult
                                    .handled;
                            }

                            row
                                .translationFocusNode
                                .requestFocus();

                            return KeyEventResult
                                .handled;
                            }

                            return KeyEventResult
                                .ignored;
                        },
                        child: TextField(
                            controller:
                                row.wordController,
                            focusNode:
                                row.wordFocusNode,
                            decoration:
                                InputDecoration(
                            labelText:
                                'Word',
                            border:
                                const OutlineInputBorder(),
                            errorText:
                                row.wordError
                                    ? 'Required'
                                    : null,
                            ),
                        ),
                        ),
                    ),

                    const SizedBox(
                        width: 8,
                    ),

                    Expanded(
                        flex: 3,
                        child: Focus(
                        onKeyEvent: (
                            node,
                            event,
                        ) {
                            if (event
                                    is KeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey
                                        .tab) {
                            final shiftPressed =
                                HardwareKeyboard
                                    .instance
                                    .isShiftPressed;

                            if (shiftPressed) {
                                row.wordFocusNode
                                    .requestFocus();

                                return KeyEventResult
                                    .handled;
                            }

                            handleTranslationTab(
                                index,
                            );

                            return KeyEventResult
                                .handled;
                            }

                            return KeyEventResult
                                .ignored;
                        },
                        child: TextField(
                            controller: row
                                .translationController,
                            focusNode: row
                                .translationFocusNode,
                            decoration:
                                InputDecoration(
                            labelText:
                                'Translation',
                            border:
                                const OutlineInputBorder(),
                            errorText: row
                                    .translationError
                                ? 'Required'
                                : null,
                            ),
                        ),
                        ),
                    ),

                    IconButton(
                        tooltip:
                            'Record Audio',
                        onPressed:
                            showAudioComingSoon,
                        icon: const Icon(
                        Icons.mic,
                        ),
                    ),

                    IconButton(
                        tooltip:
                            'Attach Audio',
                        onPressed:
                            showAudioComingSoon,
                        icon: const Icon(
                        Icons.audio_file,
                        ),
                    ),

                    IconButton(
                        tooltip:
                            'Delete Row',
                        onPressed:
                            rows.length > 1
                                ? () =>
                                    deleteRow(
                                    row,
                                    )
                                : null,
                        icon: const Icon(
                        Icons
                            .remove_circle_outline,
                        ),
                    ),
                    ],
                ),
                );
            },
            ),
        ),

        const SizedBox(height: 12),

        Row(
            children: [
            Expanded(
                child: OutlinedButton.icon(
                onPressed: addRow,
                icon: const Icon(
                    Icons.add,
                ),
                label: const Text(
                    'Add Row',
                ),
                ),
            ),
            ],
        ),

        const SizedBox(height: 12),

        SizedBox(
            width: double.infinity,
            child: FilledButton(
            onPressed:
                isSaving
                    ? null
                    : importWords,
            child: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(),
                    )
                : const Text(
                    'Import',
                    ),
            ),
        ),
        ],
      ),
    );
    }

  void addRow() {
    setState(() {
      rows.add(
        BulkWordRow(),
      );
    });
  }

  void deleteRow(
    BulkWordRow row,
  ) {
    row.dispose();

    setState(() {
      rows.remove(row);
    });
  }

  Future<void> pasteFromClipboard() async {
    final data =
        await Clipboard.getData(
        Clipboard.kTextPlain,
    );

    final text = data?.text;

    if (text == null ||
        text.trim().isEmpty) {
        return;
    }

    final importedRows =
        <BulkWordRow>[];

    final lines =
        text.split('\n');

    for (final line in lines) {
        final trimmed =
            line.trim();

        if (trimmed.isEmpty) {
        continue;
        }

        List<String> parts = [];

        if (trimmed.contains('\t')) {
        parts =
            trimmed.split('\t');
        } else if (trimmed.contains(';')) {
        parts =
            trimmed.split(';');
        } else if (trimmed.contains(',')) {
        parts =
            trimmed.split(',');
        }

        if (parts.length < 2) {
        continue;
        }

        final word =
            parts[0].trim();

        final translation =
            parts[1].trim();

        importedRows.add(
        BulkWordRow(
            word: word,
            translation:
                translation,
        ),
        );
    }

    if (importedRows.isEmpty) {
        if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(
            content: Text(
                'Clipboard format not recognized',
            ),
            ),
        );
        }

        return;
    }

    for (final row in rows) {
        row.dispose();
    }

    setState(() {
        rows
        ..clear()
        ..addAll(importedRows);

        rows.add(
        BulkWordRow(),
        );
    });

    if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
        SnackBar(
            content: Text(
            '${importedRows.length} rows imported',
            ),
        ),
        );
    }
    }

  Future<void> importWords() async {
    bool hasErrors = false;

    for (final row in rows) {
      row.wordError = false;
      row.translationError = false;

      if (row.isEmpty) {
        continue;
      }

      final word =
          row.wordController.text
              .trim();

      final translation = row
          .translationController.text
          .trim();

      if (word.isEmpty) {
        row.wordError = true;
        hasErrors = true;
      }

      if (translation.isEmpty) {
        row.translationError =
            true;
        hasErrors = true;
      }
    }

    setState(() {});

    if (hasErrors) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all highlighted cells',
          ),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    for (final row in rows) {
      if (row.isEmpty) {
        continue;
      }

      await wordRepository
          .createWord(
        folderId:
            widget.folderId,
        word: row.wordController.text
            .trim(),
        translation: row
            .translationController.text
            .trim(),
      );
    }

    if (mounted) {
      Navigator.pop(
        context,
        true,
      );
    }
  }

  void showAudioComingSoon() {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Audio support coming soon',
        ),
      ),
    );
  }

  void handleTranslationTab(
    int rowIndex,
    ) {
    final isLastRow =
        rowIndex ==
        rows.length - 1;

    if (isLastRow) {
        setState(() {
        rows.add(
            BulkWordRow(),
        );
        });

        WidgetsBinding.instance
            .addPostFrameCallback(
        (_) {
            rows.last.wordFocusNode
                .requestFocus();
        },
        );

        return;
    }

    rows[rowIndex + 1]
        .wordFocusNode
        .requestFocus();
    }
}