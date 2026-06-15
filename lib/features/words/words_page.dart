import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';

class WordsPage extends StatefulWidget {
  final String folderId;

  const WordsPage({
    super.key,
    required this.folderId,
  });

  @override
  State<WordsPage> createState() =>
      _WordsPageState();
}

class _WordsPageState
    extends State<WordsPage> {
  List<Word> words = [];

  int wordsPerDay = 5;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    final settings =
        await settingsRepository.getSettings();

    words = await wordRepository.getWords(
      widget.folderId,
    );

    wordsPerDay =
        settings.wordsPerDay;

    if (mounted) {
      setState(() {});
    }
  }

  int get deckCount {
    if (words.isEmpty) {
      return 0;
    }

    return (words.length / wordsPerDay)
        .ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Words',
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${words.length} words',
                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '$wordsPerDay words per deck',
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '$deckCount decks',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: words.isEmpty
                ? const Center(
                    child: Text(
                      'No words yet',
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        words.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final word =
                          words[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(
                            word.word,
                          ),
                          subtitle: Text(
                            word.translation,
                          ),
                          trailing:
                              PopupMenuButton<
                                  String>(
                            onSelected:
                                (value) {
                              switch (
                                  value) {
                                case 'edit':
                                  editWord(
                                    word,
                                  );
                                  break;

                                case 'delete':
                                  deleteWord(
                                    word,
                                  );
                                  break;
                              }
                            },
                            itemBuilder:
                                (_) => const [
                              PopupMenuItem(
                                value:
                                    'edit',
                                child: Text(
                                  'Edit',
                                ),
                              ),
                              PopupMenuItem(
                                value:
                                    'delete',
                                child: Text(
                                  'Delete',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> editWord(
    Word word,
  ) async {
    final wordController =
        TextEditingController(
      text: word.word,
    );

    final translationController =
        TextEditingController(
      text: word.translation,
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Edit Word',
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    wordController,
                decoration:
                    const InputDecoration(
                  labelText: 'Word',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller:
                    translationController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Translation',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child:
                  const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final newWord =
                    wordController.text
                        .trim();

                final newTranslation =
                    translationController
                        .text
                        .trim();

                if (newWord.isEmpty ||
                    newTranslation
                        .isEmpty) {
                  return;
                }

                await wordRepository
                    .updateWord(
                  id: word.id,
                  word: newWord,
                  translation:
                      newTranslation,
                  audioFile:
                      word.audioFile,
                );

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }

                await loadData();
              },
              child:
                  const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteWord(
    Word word,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Delete Word',
          ),
          content: Text(
            'Are you sure you want to delete "${word.word}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child:
                  const Text('No'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
                  const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await wordRepository
        .softDeleteWord(
      word.id,
    );

    await loadData();
  }
}