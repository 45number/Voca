import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class FolderDto {
  final String id;

  final String name;

  final String? parentId;

  final int createdAt;

  final int updatedAt;

  final int sortOrder;

  final bool deleted;

  const FolderDto({
    required this.id,

    required this.name,

    required this.parentId,

    required this.createdAt,

    required this.updatedAt,

    required this.sortOrder,

    required this.deleted,
  });

  factory FolderDto.fromFolder(Folder folder) {
    return FolderDto(
      id: folder.id,

      name: folder.name,

      parentId: folder.parentId,

      createdAt: folder.createdAt,

      updatedAt: folder.updatedAt,

      sortOrder: folder.sortOrder,

      deleted: folder.deleted,
    );
  }

  factory FolderDto.fromJson(Map<String, dynamic> json) {
    return FolderDto(
      id: json['id'],

      name: json['name'],

      parentId: json['parentId'],

      createdAt: json['createdAt'],

      updatedAt: json['updatedAt'],

      sortOrder: json['sortOrder'],

      deleted: json['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,

      'parentId': parentId,

      'createdAt': createdAt,

      'updatedAt': updatedAt,

      'sortOrder': sortOrder,

      'deleted': deleted,
    };
  }

  FoldersCompanion toCompanion() {
    return FoldersCompanion(
      id: Value(id),

      name: Value(name),

      parentId: Value(parentId),

      createdAt: Value(createdAt),

      updatedAt: Value(updatedAt),

      sortOrder: Value(sortOrder),

      deleted: Value(deleted),
    );
  }
}
