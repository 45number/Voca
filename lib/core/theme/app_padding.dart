import 'package:flutter/material.dart';

import 'app_spacing.dart';

class AppPadding {
  /// Стандартный отступ экрана
  static const screen = EdgeInsets.all(AppSpacing.md);

  /// Отступ секции
  static const section = EdgeInsets.fromLTRB(
    AppSpacing.md,
    AppSpacing.md,
    AppSpacing.md,
    AppSpacing.sm,
  );

  /// Отступ внутри карточек
  static const card = EdgeInsets.all(AppSpacing.md);

  /// Заголовок секции (Folders, Decks и т.д.)
  static const sectionTitle = EdgeInsets.only(
    left: AppSpacing.xs,
    bottom: AppSpacing.sm,
  );

  /// Маленький вертикальный отступ
  static const verticalSmall = EdgeInsets.symmetric(vertical: AppSpacing.sm);

  /// Средний вертикальный отступ
  static const verticalMedium = EdgeInsets.symmetric(vertical: AppSpacing.md);

  /// Маленький горизонтальный отступ
  static const horizontalSmall = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );

  /// Средний горизонтальный отступ
  static const horizontalMedium = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );

  // =========================
  // Spelling
  // =========================

  static const spellingResult = EdgeInsets.all(AppSpacing.md);
}
