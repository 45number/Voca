import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const EdgeInsets screen = EdgeInsets.all(md);

  static const EdgeInsets card = EdgeInsets.all(md);

  static const EdgeInsets spellingInputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // =========================
  // Spelling Result
  // =========================

  static const double spellingResultRadius = 16;

  static const double spellingTileRadius = 12;

  static const double spellingTileWidth = 44;

  static const double spellingTileHeight = 54;

  static const double spellingBorderWidth = 1.5;

  // =========================
  // Spelling Page
  // =========================

  static const double spellingInputRadius = 12;

  static const double spellingInputBorderWidth = 1.5;

  static const double spellingSectionSpacing = sm;
}
