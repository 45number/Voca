import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

import '../spelling_match.dart';
import '../spelling_result.dart';

class SpellingResultView extends StatelessWidget {
  final String correctAnswer;

  final SpellingResult result;

  const SpellingResultView({
    super.key,
    required this.correctAnswer,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.spellingResult,
      decoration: BoxDecoration(
        color: AppColors.spellingPanel,
        borderRadius: BorderRadius.circular(AppSpacing.spellingResultRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Text(
          //   'Correct word',
          //   style: AppTypography.spellingResultCaption.copyWith(
          //     color: Colors.white.withValues(alpha: 0.7),
          //   ),
          // ),

          // const SizedBox(height: AppSpacing.sm),

          // Text(
          //   correctAnswer,
          //   textDirection: TextDirection.rtl,
          //   style: AppTypography.spellingCorrectWord.copyWith(
          //     color: Colors.white,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: AppTypography.spellingCorrectWord.fontSize,
              ),

              const SizedBox(width: AppSpacing.sm),

              Text(
                correctAnswer,
                textDirection: TextDirection.rtl,
                style: AppTypography.spellingCorrectWord.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Divider(color: Colors.white.withValues(alpha: 0.08)),

          const SizedBox(height: AppSpacing.sm),

          // Text(
          //   'Answer breakdown',
          //   style: AppTypography.spellingResultCaption.copyWith(
          //     color: Colors.white.withValues(alpha: 0.7),
          //   ),
          // ),

          // const SizedBox(height: AppSpacing.md),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: result.matches
                  .map((match) => _MatchTile(match: match))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final SpellingMatch match;

  const _MatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    late Color borderColor;
    late Color backgroundColor;

    switch (match.type) {
      case SpellingMatchType.correct:
        borderColor = AppColors.success;
        backgroundColor = AppColors.successBackground;
        break;

      case SpellingMatchType.wrong:
        borderColor = AppColors.error;
        backgroundColor = AppColors.errorBackground;
        break;

      case SpellingMatchType.missing:
        borderColor = AppColors.warning;
        backgroundColor = AppColors.warningBackground;
        break;

      case SpellingMatchType.extra:
        borderColor = AppColors.error;
        backgroundColor = AppColors.errorBackground;
        break;
    }

    return Container(
      width: AppSpacing.spellingTileWidth,
      height: AppSpacing.spellingTileHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.spellingTileRadius),
        border: Border.all(
          color: borderColor,
          width: AppSpacing.spellingBorderWidth,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _topText(),
            textAlign: TextAlign.center,
            style: AppTypography.spellingTilePrimary.copyWith(
              color: Colors.white,
            ),
          ),

          // const SizedBox(height: AppSpacing.xs),
          Text(
            _bottomText(),
            textAlign: TextAlign.center,
            style: AppTypography.spellingTileSecondary.copyWith(
              color: borderColor,
            ),
          ),
        ],
      ),
    );
  }

  String _topText() {
    switch (match.type) {
      case SpellingMatchType.extra:
        return '+';

      default:
        return match.character;
    }
  }

  String _bottomText() {
    switch (match.type) {
      case SpellingMatchType.correct:
        return '✓';

      case SpellingMatchType.wrong:
        return match.actualCharacter ?? '';

      case SpellingMatchType.missing:
        return '—';

      case SpellingMatchType.extra:
        return match.character;
    }
  }
}
