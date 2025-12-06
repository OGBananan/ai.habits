import 'package:drift/drift.dart';

// Common mixin for auto-incrementing primary keys
mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

// ---------------------------------------
// USER
// ---------------------------------------
@DataClassName('User')
class Users extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();
  IntColumn get createdAt => integer()();
}

// ---------------------------------------
// REALMS
// ---------------------------------------
@DataClassName('Realm')
class Realms extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get healthScore => real().withDefault(const Constant(1))();
  TextColumn get state => text().withDefault(const Constant('operational'))();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

// ---------------------------------------
// HABITS
// ---------------------------------------
@DataClassName('Habit')
class Habits extends Table with AutoIncrementingPrimaryKey {
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get realmId => integer().references(Realms, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get frequency => text()(); // daily / weekly / custom
  IntColumn get createdAt => integer()();
}

// ---------------------------------------
// HABIT LOGS (actual performance)
// ---------------------------------------
@DataClassName('HabitLog')
class HabitLogs extends Table with AutoIncrementingPrimaryKey {
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get date => integer()(); // stored as unix timestamp (midnight)
  TextColumn get status => text()(); // completed / missed / skipped
  IntColumn get createdAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {habitId, date},
  ];
}

// ---------------------------------------
// JOURNAL ENTRIES
// ---------------------------------------
@DataClassName('JournalEntry')
class JournalEntries extends Table with AutoIncrementingPrimaryKey {
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get content => text()();
  IntColumn get createdAt => integer()();
}

// ---------------------------------------
// TASKS (coach-generated or user-added)
// ---------------------------------------
@DataClassName('Task')
class Tasks extends Table with AutoIncrementingPrimaryKey {
  IntColumn get realmId => integer().references(Realms, #id)();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get source => text()(); // coach / user
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending / done / cancelled / revoked
  IntColumn get createdAt => integer()();
  IntColumn get dueDate => integer().nullable()();
  IntColumn get completedAt => integer().nullable()();
}

// ---------------------------------------
// TASK REVOCATION CACHE (prevents immediate repeats)
// ---------------------------------------
@DataClassName('TaskRevocation')
class TaskRevocations extends Table with AutoIncrementingPrimaryKey {
  IntColumn get taskId => integer().references(Tasks, #id)();
  IntColumn get realmId => integer().references(Realms, #id)();
  IntColumn get revokedAt => integer()();
}

// ---------------------------------------
// COACH METRICS (lightweight internal signals)
// ---------------------------------------
@DataClassName('CoachSignal')
class CoachSignals extends Table with AutoIncrementingPrimaryKey {
  IntColumn get realmId => integer().references(Realms, #id)();
  TextColumn get signalType => text()(); // e.g. "trend_drop", "habit_miss_cluster"
  RealColumn get value => real().nullable()(); // optional numeric magnitude
  IntColumn get createdAt => integer()();
}
