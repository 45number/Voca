import 'package:drift/drift.dart';

class Folders extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get parentId => text().nullable()();

  IntColumn get updatedAt => integer()();

  BoolColumn get deleted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}