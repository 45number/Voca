import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/theme.dart';

import '../settings/front_side.dart';

import 'audio_service.dart';
import 'flashcard_controller.dart';
import 'study_complete_dialog.dart';
import 'study_mode.dart';
import 'study_session_controller.dart';

import 'widgets/flashcard_view.dart';
import 'widgets/study_progress.dart';
import 'widgets/study_toolbar.dart';
import 'widgets/study_navigation_bar.dart';

// import '../../core/ui/study_screen_mode.dart';

class FlashcardPage extends StatefulWidget {
  final List<Word> words;
  final StudyMode mode;

  const FlashcardPage({super.key, required this.words, required this.mode});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final controller = FlashcardController();

  final session = StudySessionController();

  final audioService = AudioService();

  FlashcardData? data;

  @override
  void initState() {
    super.initState();

    // StudyScreenMode.enter();

    loadData();
  }

  @override
  void dispose() {
    audioService.dispose();

    super.dispose();
  }

  Future<void> loadData() async {
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
      appBar: AppBar(
        title: const Text('Memorizing'),
        actions: [
          StudyToolbar(
            loopCards: loopCards,
            randomOrder: randomOrder,
            silentMode: silentMode,
            frontSide: frontSide,
            onToggleLoop: toggleLoopCards,
            onToggleRandom: toggleRandom,
            onToggleSilent: toggleSilentMode,
            onToggleFrontSide: toggleFrontSide,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            children: [
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
                currentIndex: session.currentIndex,
                totalCount: studyWords.length,
                isRevealed: session.isRevealed,
                isDifficult: currentWord.difficultMemorizing,
                onPrevious: previousCard,
                onNext: nextCard,
                onPlayAudio: playAudio,
                onToggleDifficult: toggleDifficultMemorizing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> playAudio() async {
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
    if (!session.isRevealed) {
      setState(() {
        session.reveal();
      });

      if (!silentMode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
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

      await preloadCurrentAudio();

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
