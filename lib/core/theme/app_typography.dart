import 'package:flutter/material.dart';

class AppTypography {
  /// Заголовок карточки (слово)
  static const flashcardFront = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  /// Обратная сторона карточки (перевод)
  static const flashcardBack = TextStyle(fontSize: 28);

  /// Прогресс обучения
  static const progress = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  /// Заголовки секций (Folders, Decks)
  static const sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Заголовки страниц
  static const pageTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  /// Обычный текст
  static const body = TextStyle(fontSize: 14);

  /// Второстепенный текст
  static const bodySecondary = TextStyle(fontSize: 14, color: Colors.grey);

  /// Подзаголовки
  static const subtitle = TextStyle(fontSize: 16);

  // =========================
  // Spelling Mode
  // =========================

  /// Перевод слова
  static const spellingPrompt = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Текст в поле ввода
  static const spellingInput = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Подписи в блоке результата
  static const spellingResultCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Правильное слово
  static const spellingCorrectWord = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Верхний символ в тайле разбора
  static const spellingTilePrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Нижний символ в тайле разбора
  static const spellingTileSecondary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}
