import 'package:ai_habits/database/database.dart';
import 'package:ai_habits/presentation/pages/home/state/home.state.dart';
import 'package:ai_habits/repositories/habit_repository.dart';
import 'package:ai_habits/repositories/realm_repository.dart';
import 'package:ai_habits/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing home page state and business logic
class HomeCubit extends Cubit<HomeState> {
  final AppDatabase database;
  late final UserRepository _userRepository;
  late final RealmRepository _realmRepository;
  late final HabitRepository _habitRepository;

  HomeCubit({required this.database}) : super(const HomeInitial()) {
    _userRepository = UserRepository(database);
    _realmRepository = RealmRepository(database);
    _habitRepository = HabitRepository(database);
    _initializeData();
  }

  /// Initialize data on startup
  Future<void> _initializeData() async {
    try {
      emit(const HomeLoading());
      print('Initializing data...');
      
      // Create a default user if none exists
      print('Getting all users...');
      final users = await _userRepository.getAllUsers();
      print('Found ${users.length} users');
      
      if (users.isEmpty) {
        print('Creating demo user...');
        final id = await _userRepository.createUser('Demo User');
        print('Demo user created with ID: $id');
        debugPrint('Demo user created successfully');
      }

      // Load all data
      await loadAllData();
    } catch (e, stackTrace) {
      print('Error initializing data: $e');
      print('Stack trace: $stackTrace');
      debugPrint('Error initializing data: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(HomeError('Database error: $e'));
    }
  }

  /// Load all data (users, realms, habits)
  Future<void> loadAllData() async {
    try {
      final users = await _userRepository.getAllUsers();
      final realms = await _realmRepository.getAllRealms();
      final habits = await _habitRepository.getAllHabits();
      
      emit(HomeLoaded(
        users: users,
        realms: realms,
        habits: habits,
      ));
    } catch (e) {
      emit(HomeError('Error loading data: $e'));
    }
  }

  /// Add a new user
  Future<void> addUser(String name) async {
    try {
      if (state is HomeLoaded) {
        print('Creating user: $name');
        final id = await _userRepository.createUser(name);
        print('User created with ID: $id');
        
        // Reload data
        final users = await _userRepository.getAllUsers();
        final realms = await _realmRepository.getAllRealms();
        final habits = await _habitRepository.getAllHabits();
        
        emit(HomeUserOperation(
          users: users,
          realms: realms,
          habits: habits,
          message: 'User added successfully (ID: $id)',
        ));
        
        // Transition back to loaded state after showing message
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(HomeLoaded(users: users, realms: realms, habits: habits));
        });
      }
    } catch (e) {
      print('Error creating user: $e');
      debugPrint('Error creating user: $e');
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeUserOperation(
          users: currentState.users,
          realms: currentState.realms,
          habits: currentState.habits,
          message: 'Error: $e',
        ));
      }
    }
  }

  /// Delete a user
  Future<void> deleteUser(int id) async {
    try {
      if (state is HomeLoaded) {
        await _userRepository.deleteUser(id);
        
        // Reload data
        final users = await _userRepository.getAllUsers();
        final realms = await _realmRepository.getAllRealms();
        final habits = await _habitRepository.getAllHabits();
        
        emit(HomeUserOperation(
          users: users,
          realms: realms,
          habits: habits,
          message: 'User deleted',
        ));
        
        // Transition back to loaded state after showing message
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(HomeLoaded(users: users, realms: realms, habits: habits));
        });
      }
    } catch (e) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeUserOperation(
          users: currentState.users,
          realms: currentState.realms,
          habits: currentState.habits,
          message: 'Error deleting user: $e',
        ));
      }
    }
  }

  /// Add a new realm
  Future<void> addRealm(String name, {String? description}) async {
    try {
      if (state is HomeLoaded) {
        await _realmRepository.createRealm(
          name: name,
          description: description,
        );
        
        // Reload data
        final users = await _userRepository.getAllUsers();
        final realms = await _realmRepository.getAllRealms();
        final habits = await _habitRepository.getAllHabits();
        
        emit(HomeRealmOperation(
          users: users,
          realms: realms,
          habits: habits,
          message: 'Realm added successfully',
        ));
        
        // Transition back to loaded state after showing message
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(HomeLoaded(users: users, realms: realms, habits: habits));
        });
      }
    } catch (e) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeRealmOperation(
          users: currentState.users,
          realms: currentState.realms,
          habits: currentState.habits,
          message: 'Error adding realm: $e',
        ));
      }
    }
  }

  /// Delete a realm
  Future<void> deleteRealm(int id) async {
    try {
      if (state is HomeLoaded) {
        await _realmRepository.deleteRealm(id);
        
        // Reload data
        final users = await _userRepository.getAllUsers();
        final realms = await _realmRepository.getAllRealms();
        final habits = await _habitRepository.getAllHabits();
        
        emit(HomeRealmOperation(
          users: users,
          realms: realms,
          habits: habits,
          message: 'Realm deleted',
        ));
        
        // Transition back to loaded state after showing message
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(HomeLoaded(users: users, realms: realms, habits: habits));
        });
      }
    } catch (e) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeRealmOperation(
          users: currentState.users,
          realms: currentState.realms,
          habits: currentState.habits,
          message: 'Error deleting realm: $e',
        ));
      }
    }
  }

  /// Add a new habit
  Future<void> addHabit({
    required int userId,
    required int realmId,
    required String name,
    required String frequency,
  }) async {
    try {
      if (state is HomeLoaded) {
        await _habitRepository.createHabit(
          userId: userId,
          realmId: realmId,
          name: name,
          frequency: frequency,
        );
        
        // Reload data
        final users = await _userRepository.getAllUsers();
        final realms = await _realmRepository.getAllRealms();
        final habits = await _habitRepository.getAllHabits();
        
        emit(HomeHabitOperation(
          users: users,
          realms: realms,
          habits: habits,
          message: 'Habit added successfully',
        ));
        
        // Transition back to loaded state after showing message
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(HomeLoaded(users: users, realms: realms, habits: habits));
        });
      }
    } catch (e) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeHabitOperation(
          users: currentState.users,
          realms: currentState.realms,
          habits: currentState.habits,
          message: 'Error adding habit: $e',
        ));
      }
    }
  }

  /// Delete a habit
  Future<void> deleteHabit(int id) async {
    try {
      if (state is HomeLoaded) {
        await _habitRepository.deleteHabit(id);
        
        // Reload data
        final users = await _userRepository.getAllUsers();
        final realms = await _realmRepository.getAllRealms();
        final habits = await _habitRepository.getAllHabits();
        
        emit(HomeHabitOperation(
          users: users,
          realms: realms,
          habits: habits,
          message: 'Habit deleted',
        ));
        
        // Transition back to loaded state after showing message
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(HomeLoaded(users: users, realms: realms, habits: habits));
        });
      }
    } catch (e) {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeHabitOperation(
          users: currentState.users,
          realms: currentState.realms,
          habits: currentState.habits,
          message: 'Error deleting habit: $e',
        ));
      }
    }
  }
}

