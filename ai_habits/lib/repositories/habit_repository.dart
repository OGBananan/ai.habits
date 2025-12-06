import 'package:ai_habits/database/database.dart';
import 'package:drift/drift.dart';

class HabitRepository {
  final AppDatabase _db;

  HabitRepository(this._db);

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    return await _db.select(_db.habits).get();
  }

  /// Get a habit by ID
  Future<Habit?> getHabitById(int id) async {
    return await (_db.select(_db.habits)..where((h) => h.id.equals(id))).getSingleOrNull();
  }

  /// Get habits by user ID
  Future<List<Habit>> getHabitsByUserId(int userId) async {
    return await (_db.select(_db.habits)..where((h) => h.userId.equals(userId))).get();
  }

  /// Get habits by realm ID
  Future<List<Habit>> getHabitsByRealmId(int realmId) async {
    return await (_db.select(_db.habits)..where((h) => h.realmId.equals(realmId))).get();
  }

  /// Create a new habit
  Future<int> createHabit({
    required int userId,
    required int realmId,
    required String name,
    String? description,
    required String frequency, // daily / weekly / custom
  }) async {
    final companion = HabitsCompanion.insert(
      userId: userId,
      realmId: realmId,
      name: name,
      description: Value(description),
      frequency: frequency,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    return await _db.into(_db.habits).insert(companion);
  }

  /// Update a habit
  Future<bool> updateHabit(
    int id, {
    String? name,
    String? description,
    String? frequency,
  }) async {
    final companion = HabitsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      description: description != null ? Value(description) : const Value.absent(),
      frequency: frequency != null ? Value(frequency) : const Value.absent(),
    );
    final updated = await (_db.update(_db.habits)..where((h) => h.id.equals(id))).write(companion);
    return updated > 0;
  }

  /// Delete a habit
  Future<bool> deleteHabit(int id) async {
    final deleted = await (_db.delete(_db.habits)..where((h) => h.id.equals(id))).go();
    return deleted > 0;
  }

  /// Watch habits by user ID (reactive stream)
  Stream<List<Habit>> watchHabitsByUserId(int userId) {
    return (_db.select(_db.habits)..where((h) => h.userId.equals(userId))).watch();
  }

  /// Watch all habits (reactive stream)
  Stream<List<Habit>> watchAllHabits() {
    return _db.select(_db.habits).watch();
  }
}


