import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class WordDto {
  final String id;

  final String folderId;

  final String word;

  final String translation;

  final String? audioFile;

  final bool difficultMemorizing;

  final bool difficultSpelling;

  final int createdAt;

  final int updatedAt;

  final bool deleted;

  const WordDto({
    required this.id,

    required this.folderId,

    required this.word,

    required this.translation,

    required this.audioFile,

    required this.difficultMemorizing,

    required this.difficultSpelling,

    required this.createdAt,

    required this.updatedAt,

    required this.deleted,
  });

  factory WordDto.fromWord(Word w) {
    return WordDto(
      id: w.id,

      folderId: w.folderId,

      word: w.word,

      translation: w.translation,

      audioFile: w.audioFile,

      difficultMemorizing: w.difficultMemorizing,

      difficultSpelling: w.difficultSpelling,

      createdAt: w.createdAt,

      updatedAt: w.updatedAt,

      deleted: w.deleted,
    );
  }

  factory WordDto.fromJson(Map<String, dynamic> json) {
    return WordDto(
      id: json['id'],

      folderId: json['folderId'],

      word: json['word'],

      translation: json['translation'],

      audioFile: json['audioFile'],

      difficultMemorizing: json['difficultMemorizing'] ?? false,

      difficultSpelling: json['difficultSpelling'] ?? false,

      createdAt: json['createdAt'],

      updatedAt: json['updatedAt'],

      deleted: json['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'folderId': folderId,

      'word': word,

      'translation': translation,

      'audioFile': audioFile,

      'difficultMemorizing': difficultMemorizing,

      'difficultSpelling': difficultSpelling,

      'createdAt': createdAt,

      'updatedAt': updatedAt,

      'deleted': deleted,
    };
  }

  WordsCompanion toCompanion() {
    return WordsCompanion(
      id: Value(id),

      folderId: Value(folderId),

      word: Value(word),

      translation: Value(translation),

      audioFile: Value(audioFile),

      difficultMemorizing: Value(difficultMemorizing),

      difficultSpelling: Value(difficultSpelling),

      createdAt: Value(createdAt),

      updatedAt: Value(updatedAt),

      deleted: Value(deleted),
    );
  }
}
