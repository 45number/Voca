import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class SettingsDto {
  final int id;

  final int wordsPerDay;

  final int frontSide;

  final bool loopCards;

  final bool randomOrder;

  final bool silentMode;

  final int themeMode;

  final int createdAt;

  final int updatedAt;

  const SettingsDto({
    required this.id,

    required this.wordsPerDay,

    required this.frontSide,

    required this.loopCards,

    required this.randomOrder,

    required this.silentMode,

    required this.themeMode,

    required this.createdAt,

    required this.updatedAt,
  });

  factory SettingsDto.fromSettings(AppSetting s) {
    return SettingsDto(
      id: s.id,

      wordsPerDay: s.wordsPerDay,

      frontSide: s.frontSide,

      loopCards: s.loopCards,

      randomOrder: s.randomOrder,

      silentMode: s.silentMode,

      themeMode: s.themeMode,

      createdAt: s.createdAt,

      updatedAt: s.updatedAt,
    );
  }

  factory SettingsDto.fromJson(Map<String, dynamic> json) {
    return SettingsDto(
      id: json['id'],

      wordsPerDay: json['wordsPerDay'],

      frontSide: json['frontSide'],

      loopCards: json['loopCards'],

      randomOrder: json['randomOrder'],

      silentMode: json['silentMode'],

      themeMode: json['themeMode'],

      createdAt: json['createdAt'],

      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'wordsPerDay': wordsPerDay,

      'frontSide': frontSide,

      'loopCards': loopCards,

      'randomOrder': randomOrder,

      'silentMode': silentMode,

      'themeMode': themeMode,

      'createdAt': createdAt,

      'updatedAt': updatedAt,
    };
  }

  AppSettingsCompanion toCompanion() {
    return AppSettingsCompanion(
      id: Value(id),

      wordsPerDay: Value(wordsPerDay),

      frontSide: Value(frontSide),

      loopCards: Value(loopCards),

      randomOrder: Value(randomOrder),

      silentMode: Value(silentMode),

      themeMode: Value(themeMode),

      createdAt: Value(createdAt),

      updatedAt: Value(updatedAt),
    );
  }
}
