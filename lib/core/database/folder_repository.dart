import 'package:drift/drift.dart';

import '../firebase/dto/folder_dto.dart';
import 'app_database.dart';

class FolderRepository {
  final AppDatabase database;

  FolderRepository(this.database);

  Future<List<Folder>> getFolders() {
    return (database.select(
      database.folders,
    )..where((f) => f.parentId.isNull() & f.deleted.equals(false))).get();
  }

  Future<List<Folder>> getChildFolders(String parentId) {
    return (database.select(database.folders)
          ..where((f) => f.parentId.equals(parentId) & f.deleted.equals(false)))
        .get();
  }

  // Future<void> createFolder(String name, {String? parentId}) async {
  //   await database
  //       .into(database.folders)
  //       .insert(
  //         FoldersCompanion.insert(
  //           id: DateTime.now().millisecondsSinceEpoch.toString(),
  //           name: name,
  //           parentId: Value(parentId),
  //           updatedAt: DateTime.now().millisecondsSinceEpoch,
  //         ),
  //       );
  // }

  Future<void> createFolder(String name, {String? parentId}) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await database
        .into(database.folders)
        .insert(
          // FoldersCompanion.insert(
          //   id: now.toString(),

          //   name: name,

          //   parentId: Value(parentId),

          //   createdAt: now,

          //   updatedAt: now,

          //   sortOrder: const Value(0),
          // ),
          FoldersCompanion.insert(
            id: now.toString(),
            name: name,
            parentId: Value(parentId),
            createdAt: Value(now),
            updatedAt: now,
            sortOrder: const Value(0),

            pendingSync: const Value(true),
          ),
        );
  }

  Future<void> renameFolder(String folderId, String newName) async {
    await (database.update(
      database.folders,
    )..where((f) => f.id.equals(folderId))).write(
      FoldersCompanion(
        name: Value(newName),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> moveFolder({required String folderId, String? parentId}) async {
    await (database.update(
      database.folders,
    )..where((f) => f.id.equals(folderId))).write(
      FoldersCompanion(
        parentId: Value(parentId),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> softDeleteFolder(String folderId) async {
    await (database.update(
      database.folders,
    )..where((f) => f.id.equals(folderId))).write(
      FoldersCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<void> softDeleteFolderTree(String folderId) async {
    final children = await getChildFolders(folderId);

    for (final child in children) {
      await softDeleteFolderTree(child.id);
    }

    await softDeleteFolder(folderId);
  }

  Future<Folder?> getFolder(String folderId) {
    return (database.select(database.folders)
          ..where((f) => f.id.equals(folderId) & f.deleted.equals(false)))
        .getSingleOrNull();
  }

  Future<List<Folder>> getFolderPath(String folderId) async {
    final result = <Folder>[];

    Folder? current = await getFolder(folderId);

    while (current != null) {
      result.insert(0, current);

      final parentId = current.parentId;

      if (parentId == null) {
        break;
      }

      current = await getFolder(parentId);
    }

    return result;
  }

  Future<List<String>> getFolderTreeIds(String? folderId) async {
    final result = <String>[];

    Future<void> collect(String id) async {
      result.add(id);

      final children = await getChildFolders(id);

      for (final child in children) {
        await collect(child.id);
      }
    }

    if (folderId == null) {
      final roots = await getFolders();

      for (final root in roots) {
        await collect(root.id);
      }

      return result;
    }

    await collect(folderId);

    return result;
  }

  Future<List<Folder>> getAllFolders() {
    return (database.select(
      database.folders,
    )..where((f) => f.deleted.equals(false))).get();
  }

  Future<List<String>> getDescendantFolderIds(String folderId) async {
    final result = <String>[];

    Future<void> collect(String parentId) async {
      final children = await getChildFolders(parentId);

      for (final child in children) {
        result.add(child.id);

        await collect(child.id);
      }
    }

    await collect(folderId);

    return result;
  }

  Future<void> upsertFolder(FoldersCompanion folder) async {
    await database.into(database.folders).insertOnConflictUpdate(folder);
  }

  Stream<List<Folder>> watchFolders() {
    return (database.select(
      database.folders,
    )..where((f) => f.parentId.isNull() & f.deleted.equals(false))).watch();
  }

  Stream<List<Folder>> watchChildFolders(String parentId) {
    return (database.select(database.folders)
          ..where((f) => f.parentId.equals(parentId) & f.deleted.equals(false)))
        .watch();
  }

  Stream<List<Folder>> watchAllFolders() {
    return (database.select(
      database.folders,
    )..where((f) => f.deleted.equals(false))).watch();
  }

  ///////////////////

  // Future<List<Folder>> getDirtyFolders() {
  //   return (database.select(
  //     database.folders,
  //   )..where((f) => f.pendingSync.equals(true))).get();
  // }

  // Future<void> markFolderSynced(String id) async {
  //   await (database.update(database.folders)..where((f) => f.id.equals(id)))
  //       .write(const FoldersCompanion(pendingSync: Value(false)));
  // }

  // Future<void> upsertIfNewer(FoldersCompanion folder) async {
  //   if (!folder.id.present || !folder.updatedAt.present) {
  //     return;
  //   }

  //   final id = folder.id.value;

  //   final local = await getFolder(id);

  //   if (local == null) {
  //     await upsertFolder(folder);
  //     return;
  //   }

  //   final remoteUpdated = folder.updatedAt.value;

  //   if (remoteUpdated > local.updatedAt) {
  //     await upsertFolder(folder.copyWith(pendingSync: const Value(false)));
  //   }
  // }

  /////////////

  Future<List<Folder>> getDirtyFolders() {
    return (database.select(
      database.folders,
    )..where((f) => f.pendingSync.equals(true))).get();
  }

  Future<void> markFolderSynced(String id) async {
    await (database.update(database.folders)..where((f) => f.id.equals(id)))
        .write(const FoldersCompanion(pendingSync: Value(false)));
  }

  Future<void> applyRemoteDelete(String id) async {
    await (database.update(
      database.folders,
    )..where((f) => f.id.equals(id))).write(
      FoldersCompanion(
        deleted: const Value(true),

        pendingSync: const Value(false),
      ),
    );
  }

  Future<void> upsertIfNewer(FolderDto dto) async {
    final local = await getFolder(dto.id);

    ////////////////////////
    /// local absent
    ////////////////////////

    if (local == null) {
      await upsertFolder(
        dto.toCompanion().copyWith(pendingSync: const Value(false)),
      );

      return;
    }

    ////////////////////////
    /// local newer
    ////////////////////////

    if (dto.updatedAt <= local.updatedAt) {
      return;
    }

    ////////////////////////
    /// remote delete
    ////////////////////////

    if (dto.deleted) {
      await applyRemoteDelete(dto.id);

      return;
    }

    ////////////////////////
    /// remote newer
    ////////////////////////

    await upsertFolder(
      dto.toCompanion().copyWith(pendingSync: const Value(false)),
    );
  }

  Stream<int> watchDirtyFolders() {
    return (database.select(
      database.folders,
    )..where((f) => f.pendingSync.equals(true))).watch().map((e) => e.length);
  }
}
