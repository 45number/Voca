import 'package:drift/drift.dart';

class AppSettings extends Table {
  IntColumn get id => integer()();

  IntColumn get wordsPerDay => integer().withDefault(const Constant(5))();

  IntColumn get frontSide => integer().withDefault(const Constant(0))();

  BoolColumn get loopCards => boolean().withDefault(const Constant(true))();

  BoolColumn get randomOrder => boolean().withDefault(const Constant(false))();

  BoolColumn get silentMode => boolean().withDefault(const Constant(false))();

  /// 0 = System
  /// 1 = Light
  /// 2 = Dark
  IntColumn get themeMode => integer().withDefault(const Constant(0))();

  IntColumn get createdAt => integer().withDefault(const Constant(0))();

  // IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(Constant(0))();

  BoolColumn get pendingSync => boolean().withDefault(Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
