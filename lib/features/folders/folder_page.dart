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
        actions: isRoot
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
              ]
            : null,
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

    // if (mode == StudyMode.spelling) {
    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (_) => SpellingPage(words: words)),
    //   );

    //   return;
    // }
    if (mode == StudyMode.spelling) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SpellingPage(words: words, folder: widget.folder!, deck: deck),
        ),
      );

      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardPage(words: words, mode: mode),
      ),
    );
  }
}
