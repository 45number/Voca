import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/theme.dart';

import 'audio_service.dart';
import 'spelling_checker.dart';
import 'spelling_controller.dart';
import 'spelling_data.dart';
import 'spelling_session_controller.dart';
import 'study_complete_dialog.dart';

import 'widgets/spelling_navigation_bar.dart';
import 'widgets/spelling_result_view.dart';
import 'widgets/study_progress.dart';

import '../decks/deck_info.dart';
import 'widgets/study_breadcrumb_bar.dart';
import '../../core/database/database_provider.dart';

class SpellingPage extends StatefulWidget {
  final List<Word> words;

  final Folder folder;

  final DeckInfo deck;

  final String? customBreadcrumb;

  const SpellingPage({
    super.key,
    required this.words,
    required this.folder,
    required this.deck,
    this.customBreadcrumb,
  });

  @override
  State<SpellingPage> createState() => _SpellingPageState();
}

class _SpellingPageState extends State<SpellingPage> {
  final controller = SpellingController();

  final session = SpellingSessionController();

  final checker = SpellingChecker();

  final audioService = AudioService();

  final textController = TextEditingController();

  final focusNode = FocusNode();

  SpellingData? data;

  String breadcrumb = '';

  Future<void> loadBreadcrumb() async {
    if (widget.customBreadcrumb != null) {
      breadcrumb = widget.customBreadcrumb!;
      return;
    }

    final folders = await folderRepository.getFolderPath(widget.folder.id);

    final parts = folders.map((f) => f.name).toList();

    parts.add('Deck ${widget.deck.index}');

    breadcrumb = parts.join(' / ');
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    textController.dispose();

    focusNode.dispose();

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

    refocusInput();
  }

  void refocusInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNode.requestFocus();
      }
    });
  }

  List<Word> get studyWords => data!.studyWords;

  List<Word> get originalWords => data!.originalWords;

  bool get loopCards => data!.loopCards;

  bool get randomOrder => data!.randomOrder;

  bool get silentMode => data!.silentMode;

  Word get currentWord => studyWords[session.currentIndex];

  Future<void> preloadCurrentAudio() async {
    final audioFile = currentWord.audioFile;

    if (audioFile == null || audioFile.isEmpty) {
      return;
    }

    await audioService.preload(audioFile);
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Color borderColor;
    Color backgroundColor;
    Widget? suffixIcon;

    if (!session.isChecked) {
      borderColor = const Color(0xFF3A5FA8);
      backgroundColor = const Color(0xFF08152F);
      suffixIcon = null;
    } else if (session.isCorrect) {
      borderColor = const Color(0xFF2ECC71);
      backgroundColor = const Color(0xFF13281D);

      suffixIcon = const Icon(Icons.check_circle, color: Color(0xFF2ECC71));
    } else {
      borderColor = const Color(0xFFFF5A5A);
      backgroundColor = const Color(0xFF2A1518);

      suffixIcon = const Icon(Icons.cancel, color: Color(0xFFFF5A5A));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Spelling'),
      //   actions: [
      //     SpellingToolbar(
      //       loopCards: loopCards,
      //       randomOrder: randomOrder,
      //       silentMode: silentMode,
      //       onToggleLoop: toggleLoopCards,
      //       onToggleRandom: toggleRandom,
      //       onToggleSilent: toggleSilentMode,
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
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

              const SizedBox(height: AppSpacing.spellingSectionSpacing),

              Text(
                currentWord.translation,
                textAlign: TextAlign.center,
                style: AppTypography.spellingPrompt,
              ),

              const SizedBox(height: AppSpacing.spellingSectionSpacing),

              TextField(
                controller: textController,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTypography.spellingInput.copyWith(
                  color: Colors.white,
                ),
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  // Не даём Flutter автоматически
                  // снять фокус и закрыть клавиатуру.
                },
                onSubmitted: (_) {
                  onEnterPressed();
                },
                onChanged: (_) {
                  if (session.isChecked && !session.isCorrect) {
                    textController.clear();

                    session.resetAnswer();

                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Type the word',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),

                  filled: true,
                  fillColor: backgroundColor,

                  suffixIcon: suffixIcon,

                  contentPadding: AppSpacing.spellingInputPadding,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor, width: 2),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: borderColor, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.spellingSectionSpacing),

              if (session.isChecked &&
                  session.result != null &&
                  !session.result!.isCorrect)
                SpellingResultView(
                  correctAnswer: currentWord.word,
                  result: session.result!,
                ),
              const SizedBox(height: AppSpacing.spellingSectionSpacing),

              // SpellingNavigationBar(
              //   onPrevious: previousWord,
              //   onNext: nextWord,
              //   onPlayAudio: playAudio,
              //   onToggleDifficult: toggleDifficultSpelling,
              //   isDifficult: currentWord.difficultSpelling,
              // ),
              SpellingNavigationBar(
                onPrevious: previousWord,
                onNext: nextWord,
                onPlayAudio: playAudio,
                onToggleDifficult: toggleDifficultSpelling,

                isDifficult: currentWord.difficultSpelling,

                loopCards: loopCards,
                randomOrder: randomOrder,
                silentMode: silentMode,

                onToggleLoop: toggleLoopCards,
                onToggleRandom: toggleRandom,
                onToggleSilent: toggleSilentMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onEnterPressed() async {
    if (!session.isChecked) {
      await check();
      return;
    }

    if (session.isCorrect) {
      await nextWord();
      return;
    }

    textController.clear();

    session.resetAnswer();

    setState(() {});
  }

  Future<void> check() async {
    final answer = textController.text.trim();

    final result = checker.check(expected: currentWord.word, actual: answer);

    session.check(answer: answer, spellingResult: result);

    if (!silentMode) {
      await playAudio();
    }

    setState(() {});
  }

  // Future<void> playAudio() async {
  //   final audioFile = currentWord.audioFile;

  //   if (audioFile == null || audioFile.isEmpty) {
  //     return;
  //   }

  //   await audioService.play(audioFile);
  // }

  Future<void> playAudio() async {
    print('SPELLING playAudio()');

    final audioFile = currentWord.audioFile;

    if (audioFile == null || audioFile.isEmpty) {
      return;
    }

    await audioService.play(audioFile);
  }

  Future<void> previousWord() async {
    if (session.currentIndex == 0) {
      return;
    }

    session.currentIndex--;

    session.resetAnswer();

    textController.clear();

    // await preloadCurrentAudio();

    setState(() {});
  }

  Future<void> nextWord() async {
    final hasNext = session.next(studyWords.length);

    if (hasNext) {
      textController.clear();

      // await preloadCurrentAudio();

      setState(() {});

      return;
    }

    if (loopCards) {
      session.restart();

      textController.clear();

      // await preloadCurrentAudio();

      setState(() {});

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

  Future<void> toggleDifficultSpelling() async {
    final value = !currentWord.difficultSpelling;

    await controller.updateDifficultSpelling(currentWord.id, value);

    final updatedStudyWords = List<Word>.from(studyWords);

    updatedStudyWords[session.currentIndex] = currentWord.copyWith(
      difficultSpelling: value,
    );

    final updatedOriginalWords = originalWords.map((word) {
      if (word.id == currentWord.id) {
        return word.copyWith(difficultSpelling: value);
      }

      return word;
    }).toList();

    data = SpellingData(
      originalWords: updatedOriginalWords,
      studyWords: updatedStudyWords,
      loopCards: loopCards,
      randomOrder: randomOrder,
      silentMode: silentMode,
    );

    setState(() {});
  }

  Future<void> toggleLoopCards() async {
    final value = !loopCards;

    await controller.updateLoopCards(value);

    data = SpellingData(
      originalWords: originalWords,
      studyWords: studyWords,
      loopCards: value,
      randomOrder: randomOrder,
      silentMode: silentMode,
    );

    setState(() {});
  }

  Future<void> toggleRandom() async {
    final value = !randomOrder;

    await controller.updateRandomOrder(value);

    data = SpellingData(
      originalWords: originalWords,
      studyWords: controller.buildStudyWords(
        originalWords: originalWords,
        randomOrder: value,
      ),
      loopCards: loopCards,
      randomOrder: value,
      silentMode: silentMode,
    );

    session.restart();

    textController.clear();

    await preloadCurrentAudio();

    setState(() {});
  }

  Future<void> toggleSilentMode() async {
    final value = !silentMode;

    await controller.updateSilentMode(value);

    data = SpellingData(
      originalWords: originalWords,
      studyWords: studyWords,
      loopCards: loopCards,
      randomOrder: randomOrder,
      silentMode: value,
    );

    setState(() {});
  }
}
