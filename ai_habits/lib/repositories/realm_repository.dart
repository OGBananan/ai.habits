import 'package:ai_habits/database/database.dart';
import 'package:drift/drift.dart';

class RealmRepository {
  final AppDatabase _db;

  RealmRepository(this._db);

  /// Get all realms
  Future<List<Realm>> getAllRealms() async {
    return await _db.select(_db.realms).get();
  }

  /// Get a realm by ID
  Future<Realm?> getRealmById(int id) async {
    return await (_db.select(_db.realms)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  /// Get realms by state
  Future<List<Realm>> getRealmsByState(String state) async {
    return await (_db.select(_db.realms)..where((r) => r.state.equals(state))).get();
  }

  /// Create a new realm
  Future<int> createRealm({
    required String name,
    String? description,
    double healthScore = 1.0,
    String state = 'operational',
  }) async {
    final companion = RealmsCompanion.insert(
      name: name,
      description: Value(description),
      healthScore: Value(healthScore),
      state: Value(state),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    return await _db.into(_db.realms).insert(companion);
  }

  /// Update a realm
  Future<bool> updateRealm(
    int id, {
    String? name,
    String? description,
    double? healthScore,
    String? state,
  }) async {
    final companion = RealmsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      description: description != null ? Value(description) : const Value.absent(),
      healthScore: healthScore != null ? Value(healthScore) : const Value.absent(),
      state: state != null ? Value(state) : const Value.absent(),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
    final updated = await (_db.update(_db.realms)..where((r) => r.id.equals(id))).write(companion);
    return updated > 0;
  }

  /// Update realm health score
  Future<bool> updateHealthScore(int id, double healthScore) async {
    return await updateRealm(id, healthScore: healthScore);
  }

  /// Delete a realm
  Future<bool> deleteRealm(int id) async {
    final deleted = await (_db.delete(_db.realms)..where((r) => r.id.equals(id))).go();
    return deleted > 0;
  }

  /// Watch all realms (reactive stream)
  Stream<List<Realm>> watchAllRealms() {
    return _db.select(_db.realms).watch();
  }
}
