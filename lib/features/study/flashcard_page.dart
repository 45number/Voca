import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/theme.dart';

import '../settings/front_side.dart';

// import '../../shared/audio/services/audio_service.dart';
import '../../shared/audio/services/audio_player_service.dart';
import 'flashcard_controller.dart';
import 'study_complete_dialog.dart';
import 'study_mode.dart';
import 'study_session_controller.dart';

import 'widgets/flashcard_view.dart';
import 'widgets/study_progress.dart';

import 'widgets/study_navigation_bar.dart';

import '../decks/deck_info.dart';
import '../folders/folder_controller.dart';
import 'widgets/study_breadcrumb_bar.dart';

class FlashcardPage extends StatefulWidget {
  final List<Word> words;

  final StudyMode mode;

  final Folder? folder;

  final DeckInfo? deck;

  final String? customBreadcrumb;

  const FlashcardPage({
    super.key,
    required this.words,
    required this.mode,
    this.folder,
    this.deck,
    this.customBreadcrumb,
  });

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final controller = FlashcardController();

  final session = StudySessionController();

  final audioService = AudioPlayerService();

  FlashcardData? data;

  String breadcrumb = '';

  Future<void> loadBreadcrumb() async {
    if (widget.customBreadcrumb != null) {
      breadcrumb = widget.customBreadcrumb!;
      return;
    }

    if (widget.folder == null || widget.deck == null) {
      breadcrumb = 'Memorizing';
      return;
    }

    final folderController = FolderController();

    breadcrumb = await folderController.buildBreadcrumb(
      folder: widget.folder,
      deck: widget.deck,
    );
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    audioService.dispose();

    super.dispose();
  }

  Future<void> loadData() async {
    await loadBreadcrumb();

    data = await controller.load(widget.words);

    await preloadCurrentAudio();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> preloadCurrentAudio() async {
    if (data == null) {
      return;
    }

    final audioFile = currentWord.audioFile;

    if (audioFile == null || audioFile.isEmpty) {
      return;
    }

    await audioService.preload(audioFile);
  }

  List<Word> get studyWords => data!.studyWords;

  List<Word> get originalWords => data!.originalWords;

  bool get loopCards => data!.loopCards;

  bool get randomOrder => data!.randomOrder;

  bool get silentMode => data!.silentMode;

  FrontSide get frontSide => data!.frontSide;

  Word get currentWord => session.currentWord(studyWords);

  String get frontText {
    return frontSide == FrontSide.word
        ? currentWord.word
        : currentWord.translation;
  }

  String get backText {
    return frontSide == FrontSide.word
        ? currentWord.translation
        : currentWord.word;
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            children: [
              StudyBreadcrumbBar(
                path: breadcrumb,
                currentIndex: session.currentIndex,
                totalCount: studyWords.length,
              ),

              StudyProgress(
                currentIndex: session.currentIndex,
                totalCount: studyWords.length,
              ),

              const SizedBox(height: AppSpacing.md),

              Expanded(
                child: FlashcardView(
                  word: currentWord,
                  frontText: frontText,
                  backText: backText,
                  isRevealed: session.isRevealed,
                  onTap: onCardTap,
                  onPlayAudio: playAudio,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              StudyNavigationBar(
                onPrevious: previousCard,
                onNext: nextCard,
                onPlayAudio: playAudio,
                onToggleDifficult: toggleDifficultMemorizing,

                isDifficult: currentWord.difficultMemorizing,

                loopCards: loopCards,
                randomOrder: randomOrder,
                silentMode: silentMode,

                onToggleLoop: toggleLoopCards,
                onToggleRandom: toggleRandom,
                onToggleSilent: toggleSilentMode,

                showWordFirst: frontSide == FrontSide.word,

                onToggleFrontSide: toggleFrontSide,
                hasAudio:
                    currentWord.audioFile != null &&
                    currentWord.audioFile!.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> playAudio() async {
    // print('FLASHCARD playAudio()');

    final audioFile = currentWord.audioFile;

    if (audioFile == null || audioFile.isEmpty) {
      return;
    }

    await audioService.play(audioFile);
  }

  Future<void> previousCard() async {
    setState(() {
      session.previous();
    });

    await preloadCurrentAudio();
  }

  Future<void> onCardTap() async {
    // print('CARD TAP revealed=${session.isRevealed}');

    if (!session.isRevealed) {
      // print('REVEAL');

      setState(() {
        session.reveal();
      });

      if (!silentMode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // print('AUTO PLAY AUDIO');
          playAudio();
        });
      }

      return;
    }

    await nextCard();
  }

  Future<void> nextCard() async {
    final hasNext = session.next(studyWords.length);

    if (hasNext) {
      setState(() {});

      return;
    }

    if (loopCards) {
      setState(() {
        session.restart();
      });

      await preloadCurrentAudio();

      return;
    }

    await showDialog(
      context: context,
      builder: (_) => const StudyCompleteDialog(),
    );

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> toggleLoopCards() async {
    final value = !loopCards;

    await controller.updateLoopCards(value);

    data = FlashcardData(
      settings: data!.settings,
      originalWords: data!.originalWords,
      studyWords: data!.studyWords,
      loopCards: value,
      randomOrder: data!.randomOrder,
      silentMode: data!.silentMode,
      frontSide: data!.frontSide,
    );

    setState(() {});
  }

  Future<void> toggleRandom() async {
    final value = !randomOrder;

    await controller.updateRandomOrder(value);

    data = FlashcardData(
      settings: data!.settings,
      originalWords: originalWords,
      studyWords: controller.buildStudyWords(
        originalWords: originalWords,
        randomOrder: value,
      ),
      loopCards: data!.loopCards,
      randomOrder: value,
      silentMode: data!.silentMode,
      frontSide: data!.frontSide,
    );

    session.restart();

    await preloadCurrentAudio();

    setState(() {});
  }

  Future<void> toggleSilentMode() async {
    final value = !silentMode;

    await controller.updateSilentMode(value);

    data = FlashcardData(
      settings: data!.settings,
      originalWords: data!.originalWords,
      studyWords: data!.studyWords,
      loopCards: data!.loopCards,
      randomOrder: data!.randomOrder,
      silentMode: value,
      frontSide: data!.frontSide,
    );

    setState(() {});
  }

  Future<void> toggleFrontSide() async {
    final newFrontSide = frontSide == FrontSide.word
        ? FrontSide.translation
        : FrontSide.word;

    await controller.updateFrontSide(newFrontSide);

    data = FlashcardData(
      settings: data!.settings,
      originalWords: data!.originalWords,
      studyWords: data!.studyWords,
      loopCards: data!.loopCards,
      randomOrder: data!.randomOrder,
      silentMode: data!.silentMode,
      frontSide: newFrontSide,
    );

    session.restart();

    await preloadCurrentAudio();

    setState(() {});
  }

  Future<void> toggleDifficultMemorizing() async {
    final value = !currentWord.difficultMemorizing;

    await controller.updateDifficultMemorizing(currentWord.id, value);

    final updatedStudyWords = List<Word>.from(studyWords);

    updatedStudyWords[session.currentIndex] = currentWord.copyWith(
      difficultMemorizing: value,
    );

    final updatedOriginalWords = originalWords.map((word) {
      if (word.id == currentWord.id) {
        return word.copyWith(difficultMemorizing: value);
      }

      return word;
    }).toList();

    data = FlashcardData(
      settings: data!.settings,
      originalWords: updatedOriginalWords,
      studyWords: updatedStudyWords,
      loopCards: loopCards,
      randomOrder: randomOrder,
      silentMode: silentMode,
      frontSide: frontSide,
    );

    setState(() {});
  }
}
