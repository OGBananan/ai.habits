import 'package:ai_habits/database/database.dart';
import 'package:drift/drift.dart';

class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  /// Get all users
  Future<List<User>> getAllUsers() async {
    try {
      print('Getting all users...');
      final users = await _db.select(_db.users).get();
      print('Got ${users.length} users');
      return users;
    } catch (e, stackTrace) {
      print('Error getting users: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get a user by ID
  Future<User?> getUserById(int id) async {
    return await (_db.select(_db.users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Create a new user
  Future<int> createUser(String name) async {
    try {
      final companion = UsersCompanion.insert(
        name: name,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      final id = await _db.into(_db.users).insert(companion);
      return id;
    } catch (e, stackTrace) {
      print('Error creating user: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Update a user
  Future<bool> updateUser(int id, String name) async {
    final companion = UsersCompanion(
      name: Value(name),
    );
    final updated = await (_db.update(_db.users)..where((u) => u.id.equals(id))).write(companion);
    return updated > 0;
  }

  /// Delete a user
  Future<bool> deleteUser(int id) async {
    final deleted = await (_db.delete(_db.users)..where((u) => u.id.equals(id))).go();
    return deleted > 0;
  }

  /// Watch all users (reactive stream)
  Stream<List<User>> watchAllUsers() {
    try {
      return _db.select(_db.users).watch();
    } catch (e, stackTrace) {
      print('Error watching users: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
