import 'package:drift/drift.dart';

class Words extends Table {
  TextColumn get id => text()();

  TextColumn get folderId => text()();

  TextColumn get word => text()();

  TextColumn get translation => text()();

  TextColumn get audioFile => text().nullable()();

  BoolColumn get difficultMemorizing =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get difficultSpelling =>
      boolean().withDefault(const Constant(false))();

  IntColumn get updatedAt => integer()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
