import 'package:drift/drift.dart';

// class Folders extends Table {
//   TextColumn get id => text()();

//   TextColumn get name => text()();

//   TextColumn get parentId => text().nullable()();

//   IntColumn get updatedAt => integer()();

//   BoolColumn get deleted =>
//       boolean().withDefault(const Constant(false))();

//   @override
//   Set<Column> get primaryKey => {id};
// }

class Folders extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get parentId => text().nullable()();

  // NEW
  // IntColumn get createdAt => integer()();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();

  IntColumn get updatedAt => integer()();

  // NEW
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
