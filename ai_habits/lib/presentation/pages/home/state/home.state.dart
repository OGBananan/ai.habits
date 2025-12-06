import 'package:ai_habits/database/database.dart';
import 'package:equatable/equatable.dart';

/// Base state class for home page
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded state with data
class HomeLoaded extends HomeState {
  final List<User> users;
  final List<Realm> realms;
  final List<Habit> habits;

  const HomeLoaded({
    required this.users,
    required this.realms,
    required this.habits,
  });

  @override
  List<Object?> get props => [users, realms, habits];

  HomeLoaded copyWith({
    List<User>? users,
    List<Realm>? realms,
    List<Habit>? habits,
  }) {
    return HomeLoaded(
      users: users ?? this.users,
      realms: realms ?? this.realms,
      habits: habits ?? this.habits,
    );
  }
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for user operations
class HomeUserOperation extends HomeState {
  final List<User> users;
  final List<Realm> realms;
  final List<Habit> habits;
  final String? message;

  const HomeUserOperation({
    required this.users,
    required this.realms,
    required this.habits,
    this.message,
  });

  @override
  List<Object?> get props => [users, realms, habits, message];
}

/// State for realm operations
class HomeRealmOperation extends HomeState {
  final List<User> users;
  final List<Realm> realms;
  final List<Habit> habits;
  final String? message;

  const HomeRealmOperation({
    required this.users,
    required this.realms,
    required this.habits,
    this.message,
  });

  @override
  List<Object?> get props => [users, realms, habits, message];
}

/// State for habit operations
class HomeHabitOperation extends HomeState {
  final List<User> users;
  final List<Realm> realms;
  final List<Habit> habits;
  final String? message;

  const HomeHabitOperation({
    required this.users,
    required this.realms,
    required this.habits,
    this.message,
  });

  @override
  List<Object?> get props => [users, realms, habits, message];
}

