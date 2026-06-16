import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/theme.dart';

import '../decks/deck_info.dart';

import '../settings/settings_page.dart';

import '../study/dialogs/study_mode_dialog.dart';
import '../study/flashcard_page.dart';
import '../study/study_mode.dart';

import '../words/add_word_page.dart';
import '../words/words_page.dart';

import '../../shared/dialogs/confirm_dialog.dart';
import '../../shared/dialogs/text_input_dialog.dart';

import 'dialogs/add_menu_dialog.dart';
import 'folder_controller.dart';

import 'widgets/deck_tile.dart';
import 'widgets/empty_folder_view.dart';
import 'widgets/folder_tile.dart';
import '../study/spelling_page.dart';
import 'dialogs/move_folder_dialog.dart';

class FolderPage extends StatefulWidget {
  final Folder? folder;

  const FolderPage({super.key, this.folder});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final controller = FolderController();

  List<Folder> childFolders = [];

  int wordCount = 0;

  List<DeckInfo> decks = [];

  bool hasDifficultWords = false;

  int difficultMemorizingCount = 0;

  int difficultSpellingCount = 0;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    final data = await controller.load(widget.folder);

    childFolders = data.childFolders;

    decks = data.decks;

    wordCount = data.wordCount;

    hasDifficultWords = data.hasDifficultWords;

    difficultMemorizingCount = data.difficultMemorizingCount;

    difficultSpellingCount = data.difficultSpellingCount;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRoot = widget.folder == null;

    final hasFolders = childFolders.isNotEmpty;

    final hasDecks = decks.isNotEmpty;

    final isEmpty = !hasFolders && !hasDecks;

    return Scaffold(
      appBar: AppBar(
        title: Text(isRoot ? 'Voca' : widget.folder!.name),
        centerTitle: true,
        actions: [
          if (hasDifficultWords)
            IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                showDifficultWordsDialog();
              },
            ),

          if (isRoot)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
        ],
      ),
      body: isEmpty
          ? EmptyFolderView(isRoot: isRoot)
          : ListView(
              padding: AppPadding.screen,
              children: [
                if (hasFolders) ...[
                  const Padding(
                    padding: AppPadding.sectionTitle,
                    child: Text('Folders', style: AppTypography.sectionTitle),
                  ),
                  ...childFolders.map((folder) {
                    return FolderTile(
                      folder: folder,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FolderPage(folder: folder),
                          ),
                        );

                        if (!mounted) {
                          return;
                        }

                        await loadData();
                      },
                      onRename: () {
                        renameFolder(folder);
                      },
                      onMove: () {
                        moveFolder(folder);
                      },
                      onDelete: () {
                        deleteFolder(folder);
                      },
                    );
                  }),
                ],

                if (hasFolders && hasDecks)
                  const SizedBox(height: AppSpacing.md),

                if (hasDecks) ...[
                  const Padding(
                    padding: AppPadding.sectionTitle,
                    child: Text('Decks', style: AppTypography.sectionTitle),
                  ),
                  ...decks.map((deck) {
                    return DeckTile(
                      deck: deck,
                      onTap: () async {
                        await showStudyModeDialog(deck);
                      },
                    );
                  }),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddMenu,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showAddMenu() async {
    final result = await AddMenuDialog.show(
      context: context,
      isRoot: widget.folder == null,
    );

    if (!mounted) {
      return;
    }

    switch (result) {
      case AddMenuResult.folder:
        await createFolder();
        break;

      case AddMenuResult.word:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddWordPage(folderId: widget.folder!.id),
          ),
        );

        if (!mounted) {
          return;
        }

        await loadData();
        break;

      case AddMenuResult.browseWords:
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WordsPage(folderId: widget.folder!.id),
          ),
        );

        if (!mounted) {
          return;
        }

        await loadData();
        break;

      case null:
        break;
    }
  }

  Future<void> createFolder() async {
    final name = await TextInputDialog.show(
      context: context,
      title: 'Create Folder',
      hintText: 'Folder name',
      confirmText: 'Create',
    );

    if (!mounted) {
      return;
    }

    if (name == null) {
      return;
    }

    await controller.createFolder(name: name, parentId: widget.folder?.id);

    await loadData();
  }

  Future<void> renameFolder(Folder folder) async {
    final name = await TextInputDialog.show(
      context: context,
      title: 'Rename Folder',
      initialValue: folder.name,
    );

    if (!mounted) {
      return;
    }

    if (name == null) {
      return;
    }

    await controller.renameFolder(folderId: folder.id, name: name);

    await loadData();
  }

  Future<void> moveFolder(Folder folder) async {
    final result = await MoveFolderDialog.show(
      context: context,
      folder: folder,
    );

    if (result == false) {
      return;
    }

    final parentId = result as String?;

    if (!mounted) {
      return;
    }

    if (parentId == folder.parentId) {
      return;
    }

    await controller.moveFolder(folderId: folder.id, parentId: parentId);

    await loadData();
  }

  Future<void> deleteFolder(Folder folder) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Delete Folder',
      message: 'Are you sure you want to delete folder "${folder.name}"?',
    );

    if (!mounted) {
      return;
    }

    if (!confirmed) {
      return;
    }

    await controller.deleteFolder(folder.id);

    await loadData();
  }

  Future<void> showStudyModeDialog(DeckInfo deck) async {
    final mode = await StudyModeDialog.show(context);

    if (!mounted) {
      return;
    }

    if (mode == null) {
      return;
    }

    final words = await controller.loadDeckWords(
      folderId: widget.folder!.id,
      deckIndex: deck.index,
    );

    if (words.isEmpty) {
      return;
    }

    if (!mounted) {
      return;
    }

    if (mode == StudyMode.spelling) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SpellingPage(words: words, folder: widget.folder!, deck: deck),
        ),
      );

      if (!mounted) {
        return;
      }

      await loadData();

      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardPage(
          words: words,
          mode: mode,
          folder: widget.folder,
          deck: deck,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await loadData();
  }

  Future<void> showDifficultWordsDialog() async {
    final items = <PopupMenuEntry<StudyMode>>[];

    if (difficultMemorizingCount > 0) {
      items.add(
        PopupMenuItem(
          value: StudyMode.memorizing,
          child: Text('Memorizing ($difficultMemorizingCount)'),
        ),
      );
    }

    if (difficultSpellingCount > 0) {
      items.add(
        PopupMenuItem(
          value: StudyMode.spelling,
          child: Text('Spelling ($difficultSpellingCount)'),
        ),
      );
    }

    final mode = await showMenu<StudyMode>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
      items: items,
    );

    if (!mounted) {
      return;
    }

    if (mode == null) {
      return;
    }

    await openDifficultWords(mode);
  }

  Future<void> openDifficultWords(StudyMode mode) async {
    List<Word> words;

    if (mode == StudyMode.spelling) {
      words = await controller.loadDifficultSpellingWords(widget.folder?.id);
    } else {
      words = await controller.loadDifficultMemorizingWords(widget.folder?.id);
    }

    if (words.isEmpty) {
      return;
    }

    if (!mounted) {
      return;
    }

    // final breadcrumb = await controller.buildDifficultBreadcrumb(widget.folder);
    final breadcrumb = await controller.buildBreadcrumb(
      folder: widget.folder,
      difficult: true,
    );

    if (mode == StudyMode.spelling) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SpellingPage(
            words: words,
            folder:
                widget.folder ??
                Folder(
                  id: 'difficult',
                  name: 'Difficult words',
                  parentId: null,
                  deleted: false,
                  updatedAt: 0,
                ),
            deck: const DeckInfo(index: 1, wordCount: 0),
            customBreadcrumb: breadcrumb,
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      await loadData();

      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardPage(
          words: words,
          mode: mode,
          customBreadcrumb: breadcrumb,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await loadData();

    if (!mounted) {
      return;
    }

    await loadData();
  }
}
