// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    createdAt,
    updatedAt,
    sortOrder,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Folder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final String id;
  final String name;
  final String? parentId;
  final int createdAt;
  final int updatedAt;
  final int sortOrder;
  final bool deleted;
  const Folder({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sort_order'] = Variable<int>(sortOrder);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sortOrder: Value(sortOrder),
      deleted: Value(deleted),
    );
  }

  factory Folder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Folder copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? sortOrder,
    bool? deleted,
  }) => Folder(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    deleted: deleted ?? this.deleted,
  );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parentId, createdAt, updatedAt, sortOrder, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sortOrder == this.sortOrder &&
          other.deleted == this.deleted);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> sortOrder;
  final Value<bool> deleted;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    required int updatedAt,
    this.sortOrder = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<Folder> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? sortOrder,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? sortOrder,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioFileMeta = const VerificationMeta(
    'audioFile',
  );
  @override
  late final GeneratedColumn<String> audioFile = GeneratedColumn<String>(
    'audio_file',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultMemorizingMeta =
      const VerificationMeta('difficultMemorizing');
  @override
  late final GeneratedColumn<bool> difficultMemorizing = GeneratedColumn<bool>(
    'difficult_memorizing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("difficult_memorizing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _difficultSpellingMeta = const VerificationMeta(
    'difficultSpelling',
  );
  @override
  late final GeneratedColumn<bool> difficultSpelling = GeneratedColumn<bool>(
    'difficult_spelling',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("difficult_spelling" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    word,
    translation,
    audioFile,
    difficultMemorizing,
    difficultSpelling,
    createdAt,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('audio_file')) {
      context.handle(
        _audioFileMeta,
        audioFile.isAcceptableOrUnknown(data['audio_file']!, _audioFileMeta),
      );
    }
    if (data.containsKey('difficult_memorizing')) {
      context.handle(
        _difficultMemorizingMeta,
        difficultMemorizing.isAcceptableOrUnknown(
          data['difficult_memorizing']!,
          _difficultMemorizingMeta,
        ),
      );
    }
    if (data.containsKey('difficult_spelling')) {
      context.handle(
        _difficultSpellingMeta,
        difficultSpelling.isAcceptableOrUnknown(
          data['difficult_spelling']!,
          _difficultSpellingMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      audioFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_file'],
      ),
      difficultMemorizing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}difficult_memorizing'],
      )!,
      difficultSpelling: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}difficult_spelling'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
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
  const Word({
    required this.id,
    required this.folderId,
    required this.word,
    required this.translation,
    this.audioFile,
    required this.difficultMemorizing,
    required this.difficultSpelling,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder_id'] = Variable<String>(folderId);
    map['word'] = Variable<String>(word);
    map['translation'] = Variable<String>(translation);
    if (!nullToAbsent || audioFile != null) {
      map['audio_file'] = Variable<String>(audioFile);
    }
    map['difficult_memorizing'] = Variable<bool>(difficultMemorizing);
    map['difficult_spelling'] = Variable<bool>(difficultSpelling);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      folderId: Value(folderId),
      word: Value(word),
      translation: Value(translation),
      audioFile: audioFile == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFile),
      difficultMemorizing: Value(difficultMemorizing),
      difficultSpelling: Value(difficultSpelling),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<String>(json['id']),
      folderId: serializer.fromJson<String>(json['folderId']),
      word: serializer.fromJson<String>(json['word']),
      translation: serializer.fromJson<String>(json['translation']),
      audioFile: serializer.fromJson<String?>(json['audioFile']),
      difficultMemorizing: serializer.fromJson<bool>(
        json['difficultMemorizing'],
      ),
      difficultSpelling: serializer.fromJson<bool>(json['difficultSpelling']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folderId': serializer.toJson<String>(folderId),
      'word': serializer.toJson<String>(word),
      'translation': serializer.toJson<String>(translation),
      'audioFile': serializer.toJson<String?>(audioFile),
      'difficultMemorizing': serializer.toJson<bool>(difficultMemorizing),
      'difficultSpelling': serializer.toJson<bool>(difficultSpelling),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Word copyWith({
    String? id,
    String? folderId,
    String? word,
    String? translation,
    Value<String?> audioFile = const Value.absent(),
    bool? difficultMemorizing,
    bool? difficultSpelling,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
  }) => Word(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    word: word ?? this.word,
    translation: translation ?? this.translation,
    audioFile: audioFile.present ? audioFile.value : this.audioFile,
    difficultMemorizing: difficultMemorizing ?? this.difficultMemorizing,
    difficultSpelling: difficultSpelling ?? this.difficultSpelling,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      word: data.word.present ? data.word.value : this.word,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      audioFile: data.audioFile.present ? data.audioFile.value : this.audioFile,
      difficultMemorizing: data.difficultMemorizing.present
          ? data.difficultMemorizing.value
          : this.difficultMemorizing,
      difficultSpelling: data.difficultSpelling.present
          ? data.difficultSpelling.value
          : this.difficultSpelling,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('word: $word, ')
          ..write('translation: $translation, ')
          ..write('audioFile: $audioFile, ')
          ..write('difficultMemorizing: $difficultMemorizing, ')
          ..write('difficultSpelling: $difficultSpelling, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folderId,
    word,
    translation,
    audioFile,
    difficultMemorizing,
    difficultSpelling,
    createdAt,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.word == this.word &&
          other.translation == this.translation &&
          other.audioFile == this.audioFile &&
          other.difficultMemorizing == this.difficultMemorizing &&
          other.difficultSpelling == this.difficultSpelling &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<String> id;
  final Value<String> folderId;
  final Value<String> word;
  final Value<String> translation;
  final Value<String?> audioFile;
  final Value<bool> difficultMemorizing;
  final Value<bool> difficultSpelling;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.word = const Value.absent(),
    this.translation = const Value.absent(),
    this.audioFile = const Value.absent(),
    this.difficultMemorizing = const Value.absent(),
    this.difficultSpelling = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String folderId,
    required String word,
    required String translation,
    this.audioFile = const Value.absent(),
    this.difficultMemorizing = const Value.absent(),
    this.difficultSpelling = const Value.absent(),
    this.createdAt = const Value.absent(),
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       folderId = Value(folderId),
       word = Value(word),
       translation = Value(translation),
       updatedAt = Value(updatedAt);
  static Insertable<Word> custom({
    Expression<String>? id,
    Expression<String>? folderId,
    Expression<String>? word,
    Expression<String>? translation,
    Expression<String>? audioFile,
    Expression<bool>? difficultMemorizing,
    Expression<bool>? difficultSpelling,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (word != null) 'word': word,
      if (translation != null) 'translation': translation,
      if (audioFile != null) 'audio_file': audioFile,
      if (difficultMemorizing != null)
        'difficult_memorizing': difficultMemorizing,
      if (difficultSpelling != null) 'difficult_spelling': difficultSpelling,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith({
    Value<String>? id,
    Value<String>? folderId,
    Value<String>? word,
    Value<String>? translation,
    Value<String?>? audioFile,
    Value<bool>? difficultMemorizing,
    Value<bool>? difficultSpelling,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      audioFile: audioFile ?? this.audioFile,
      difficultMemorizing: difficultMemorizing ?? this.difficultMemorizing,
      difficultSpelling: difficultSpelling ?? this.difficultSpelling,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (audioFile.present) {
      map['audio_file'] = Variable<String>(audioFile.value);
    }
    if (difficultMemorizing.present) {
      map['difficult_memorizing'] = Variable<bool>(difficultMemorizing.value);
    }
    if (difficultSpelling.present) {
      map['difficult_spelling'] = Variable<bool>(difficultSpelling.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('word: $word, ')
          ..write('translation: $translation, ')
          ..write('audioFile: $audioFile, ')
          ..write('difficultMemorizing: $difficultMemorizing, ')
          ..write('difficultSpelling: $difficultSpelling, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordsPerDayMeta = const VerificationMeta(
    'wordsPerDay',
  );
  @override
  late final GeneratedColumn<int> wordsPerDay = GeneratedColumn<int>(
    'words_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _frontSideMeta = const VerificationMeta(
    'frontSide',
  );
  @override
  late final GeneratedColumn<int> frontSide = GeneratedColumn<int>(
    'front_side',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _loopCardsMeta = const VerificationMeta(
    'loopCards',
  );
  @override
  late final GeneratedColumn<bool> loopCards = GeneratedColumn<bool>(
    'loop_cards',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("loop_cards" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _randomOrderMeta = const VerificationMeta(
    'randomOrder',
  );
  @override
  late final GeneratedColumn<bool> randomOrder = GeneratedColumn<bool>(
    'random_order',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("random_order" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _silentModeMeta = const VerificationMeta(
    'silentMode',
  );
  @override
  late final GeneratedColumn<bool> silentMode = GeneratedColumn<bool>(
    'silent_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("silent_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<int> themeMode = GeneratedColumn<int>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordsPerDay,
    frontSide,
    loopCards,
    randomOrder,
    silentMode,
    themeMode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('words_per_day')) {
      context.handle(
        _wordsPerDayMeta,
        wordsPerDay.isAcceptableOrUnknown(
          data['words_per_day']!,
          _wordsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('front_side')) {
      context.handle(
        _frontSideMeta,
        frontSide.isAcceptableOrUnknown(data['front_side']!, _frontSideMeta),
      );
    }
    if (data.containsKey('loop_cards')) {
      context.handle(
        _loopCardsMeta,
        loopCards.isAcceptableOrUnknown(data['loop_cards']!, _loopCardsMeta),
      );
    }
    if (data.containsKey('random_order')) {
      context.handle(
        _randomOrderMeta,
        randomOrder.isAcceptableOrUnknown(
          data['random_order']!,
          _randomOrderMeta,
        ),
      );
    }
    if (data.containsKey('silent_mode')) {
      context.handle(
        _silentModeMeta,
        silentMode.isAcceptableOrUnknown(data['silent_mode']!, _silentModeMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}words_per_day'],
      )!,
      frontSide: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}front_side'],
      )!,
      loopCards: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}loop_cards'],
      )!,
      randomOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}random_order'],
      )!,
      silentMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}silent_mode'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_mode'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final int wordsPerDay;
  final int frontSide;
  final bool loopCards;
  final bool randomOrder;
  final bool silentMode;

  /// 0 = System
  /// 1 = Light
  /// 2 = Dark
  final int themeMode;
  final int createdAt;
  final int updatedAt;
  const AppSetting({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['words_per_day'] = Variable<int>(wordsPerDay);
    map['front_side'] = Variable<int>(frontSide);
    map['loop_cards'] = Variable<bool>(loopCards);
    map['random_order'] = Variable<bool>(randomOrder);
    map['silent_mode'] = Variable<bool>(silentMode);
    map['theme_mode'] = Variable<int>(themeMode);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
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

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      wordsPerDay: serializer.fromJson<int>(json['wordsPerDay']),
      frontSide: serializer.fromJson<int>(json['frontSide']),
      loopCards: serializer.fromJson<bool>(json['loopCards']),
      randomOrder: serializer.fromJson<bool>(json['randomOrder']),
      silentMode: serializer.fromJson<bool>(json['silentMode']),
      themeMode: serializer.fromJson<int>(json['themeMode']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordsPerDay': serializer.toJson<int>(wordsPerDay),
      'frontSide': serializer.toJson<int>(frontSide),
      'loopCards': serializer.toJson<bool>(loopCards),
      'randomOrder': serializer.toJson<bool>(randomOrder),
      'silentMode': serializer.toJson<bool>(silentMode),
      'themeMode': serializer.toJson<int>(themeMode),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSetting copyWith({
    int? id,
    int? wordsPerDay,
    int? frontSide,
    bool? loopCards,
    bool? randomOrder,
    bool? silentMode,
    int? themeMode,
    int? createdAt,
    int? updatedAt,
  }) => AppSetting(
    id: id ?? this.id,
    wordsPerDay: wordsPerDay ?? this.wordsPerDay,
    frontSide: frontSide ?? this.frontSide,
    loopCards: loopCards ?? this.loopCards,
    randomOrder: randomOrder ?? this.randomOrder,
    silentMode: silentMode ?? this.silentMode,
    themeMode: themeMode ?? this.themeMode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      wordsPerDay: data.wordsPerDay.present
          ? data.wordsPerDay.value
          : this.wordsPerDay,
      frontSide: data.frontSide.present ? data.frontSide.value : this.frontSide,
      loopCards: data.loopCards.present ? data.loopCards.value : this.loopCards,
      randomOrder: data.randomOrder.present
          ? data.randomOrder.value
          : this.randomOrder,
      silentMode: data.silentMode.present
          ? data.silentMode.value
          : this.silentMode,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('wordsPerDay: $wordsPerDay, ')
          ..write('frontSide: $frontSide, ')
          ..write('loopCards: $loopCards, ')
          ..write('randomOrder: $randomOrder, ')
          ..write('silentMode: $silentMode, ')
          ..write('themeMode: $themeMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wordsPerDay,
    frontSide,
    loopCards,
    randomOrder,
    silentMode,
    themeMode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.wordsPerDay == this.wordsPerDay &&
          other.frontSide == this.frontSide &&
          other.loopCards == this.loopCards &&
          other.randomOrder == this.randomOrder &&
          other.silentMode == this.silentMode &&
          other.themeMode == this.themeMode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<int> wordsPerDay;
  final Value<int> frontSide;
  final Value<bool> loopCards;
  final Value<bool> randomOrder;
  final Value<bool> silentMode;
  final Value<int> themeMode;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.wordsPerDay = const Value.absent(),
    this.frontSide = const Value.absent(),
    this.loopCards = const Value.absent(),
    this.randomOrder = const Value.absent(),
    this.silentMode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.wordsPerDay = const Value.absent(),
    this.frontSide = const Value.absent(),
    this.loopCards = const Value.absent(),
    this.randomOrder = const Value.absent(),
    this.silentMode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<int>? wordsPerDay,
    Expression<int>? frontSide,
    Expression<bool>? loopCards,
    Expression<bool>? randomOrder,
    Expression<bool>? silentMode,
    Expression<int>? themeMode,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordsPerDay != null) 'words_per_day': wordsPerDay,
      if (frontSide != null) 'front_side': frontSide,
      if (loopCards != null) 'loop_cards': loopCards,
      if (randomOrder != null) 'random_order': randomOrder,
      if (silentMode != null) 'silent_mode': silentMode,
      if (themeMode != null) 'theme_mode': themeMode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? wordsPerDay,
    Value<int>? frontSide,
    Value<bool>? loopCards,
    Value<bool>? randomOrder,
    Value<bool>? silentMode,
    Value<int>? themeMode,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      wordsPerDay: wordsPerDay ?? this.wordsPerDay,
      frontSide: frontSide ?? this.frontSide,
      loopCards: loopCards ?? this.loopCards,
      randomOrder: randomOrder ?? this.randomOrder,
      silentMode: silentMode ?? this.silentMode,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordsPerDay.present) {
      map['words_per_day'] = Variable<int>(wordsPerDay.value);
    }
    if (frontSide.present) {
      map['front_side'] = Variable<int>(frontSide.value);
    }
    if (loopCards.present) {
      map['loop_cards'] = Variable<bool>(loopCards.value);
    }
    if (randomOrder.present) {
      map['random_order'] = Variable<bool>(randomOrder.value);
    }
    if (silentMode.present) {
      map['silent_mode'] = Variable<bool>(silentMode.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(themeMode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('wordsPerDay: $wordsPerDay, ')
          ..write('frontSide: $frontSide, ')
          ..write('loopCards: $loopCards, ')
          ..write('randomOrder: $randomOrder, ')
          ..write('silentMode: $silentMode, ')
          ..write('themeMode: $themeMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    folders,
    words,
    appSettings,
  ];
}

typedef $$FoldersTableCreateCompanionBuilder =
    FoldersCompanion Function({
      required String id,
      required String name,
      Value<String?> parentId,
      Value<int> createdAt,
      required int updatedAt,
      Value<int> sortOrder,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$FoldersTableUpdateCompanionBuilder =
    FoldersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> sortOrder,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          Folder,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
          Folder,
          PrefetchHooks Function()
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                required int updatedAt,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sortOrder: sortOrder,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      Folder,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
      Folder,
      PrefetchHooks Function()
    >;
typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      required String id,
      required String folderId,
      required String word,
      required String translation,
      Value<String?> audioFile,
      Value<bool> difficultMemorizing,
      Value<bool> difficultSpelling,
      Value<int> createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<String> id,
      Value<String> folderId,
      Value<String> word,
      Value<String> translation,
      Value<String?> audioFile,
      Value<bool> difficultMemorizing,
      Value<bool> difficultSpelling,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioFile => $composableBuilder(
    column: $table.audioFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get difficultMemorizing => $composableBuilder(
    column: $table.difficultMemorizing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get difficultSpelling => $composableBuilder(
    column: $table.difficultSpelling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioFile => $composableBuilder(
    column: $table.audioFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get difficultMemorizing => $composableBuilder(
    column: $table.difficultMemorizing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get difficultSpelling => $composableBuilder(
    column: $table.difficultSpelling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioFile =>
      $composableBuilder(column: $table.audioFile, builder: (column) => column);

  GeneratedColumn<bool> get difficultMemorizing => $composableBuilder(
    column: $table.difficultMemorizing,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get difficultSpelling => $composableBuilder(
    column: $table.difficultSpelling,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
          Word,
          PrefetchHooks Function()
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folderId = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String?> audioFile = const Value.absent(),
                Value<bool> difficultMemorizing = const Value.absent(),
                Value<bool> difficultSpelling = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                folderId: folderId,
                word: word,
                translation: translation,
                audioFile: audioFile,
                difficultMemorizing: difficultMemorizing,
                difficultSpelling: difficultSpelling,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String folderId,
                required String word,
                required String translation,
                Value<String?> audioFile = const Value.absent(),
                Value<bool> difficultMemorizing = const Value.absent(),
                Value<bool> difficultSpelling = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                folderId: folderId,
                word: word,
                translation: translation,
                audioFile: audioFile,
                difficultMemorizing: difficultMemorizing,
                difficultSpelling: difficultSpelling,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
      Word,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> wordsPerDay,
      Value<int> frontSide,
      Value<bool> loopCards,
      Value<bool> randomOrder,
      Value<bool> silentMode,
      Value<int> themeMode,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<int> wordsPerDay,
      Value<int> frontSide,
      Value<bool> loopCards,
      Value<bool> randomOrder,
      Value<bool> silentMode,
      Value<int> themeMode,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordsPerDay => $composableBuilder(
    column: $table.wordsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frontSide => $composableBuilder(
    column: $table.frontSide,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get loopCards => $composableBuilder(
    column: $table.loopCards,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get randomOrder => $composableBuilder(
    column: $table.randomOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get silentMode => $composableBuilder(
    column: $table.silentMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordsPerDay => $composableBuilder(
    column: $table.wordsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frontSide => $composableBuilder(
    column: $table.frontSide,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get loopCards => $composableBuilder(
    column: $table.loopCards,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get randomOrder => $composableBuilder(
    column: $table.randomOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get silentMode => $composableBuilder(
    column: $table.silentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wordsPerDay => $composableBuilder(
    column: $table.wordsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frontSide =>
      $composableBuilder(column: $table.frontSide, builder: (column) => column);

  GeneratedColumn<bool> get loopCards =>
      $composableBuilder(column: $table.loopCards, builder: (column) => column);

  GeneratedColumn<bool> get randomOrder => $composableBuilder(
    column: $table.randomOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get silentMode => $composableBuilder(
    column: $table.silentMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordsPerDay = const Value.absent(),
                Value<int> frontSide = const Value.absent(),
                Value<bool> loopCards = const Value.absent(),
                Value<bool> randomOrder = const Value.absent(),
                Value<bool> silentMode = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                wordsPerDay: wordsPerDay,
                frontSide: frontSide,
                loopCards: loopCards,
                randomOrder: randomOrder,
                silentMode: silentMode,
                themeMode: themeMode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordsPerDay = const Value.absent(),
                Value<int> frontSide = const Value.absent(),
                Value<bool> loopCards = const Value.absent(),
                Value<bool> randomOrder = const Value.absent(),
                Value<bool> silentMode = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                wordsPerDay: wordsPerDay,
                frontSide: frontSide,
                loopCards: loopCards,
                randomOrder: randomOrder,
                silentMode: silentMode,
                themeMode: themeMode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
