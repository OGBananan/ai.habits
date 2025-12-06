import 'package:ai_habits/database/database.dart';
import 'package:ai_habits/presentation/pages/home/state/home.cubit.dart';
import 'package:ai_habits/presentation/pages/home/state/home.state.dart';
import 'package:ai_habits/presentation/pages/home/widgets/habits_section.dart';
import 'package:ai_habits/presentation/pages/home/widgets/realms_section.dart';
import 'package:ai_habits/presentation/pages/home/widgets/users_section.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  final AppDatabase database;

  const HomePage({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(database: database),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // Handle snackbar messages for operations
        if (state is HomeUserOperation && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.message!.contains('Error') ? Colors.red : null,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is HomeRealmOperation && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.message!.contains('Error') ? Colors.red : null,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is HomeHabitOperation && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: state.message!.contains('Error') ? Colors.red : null,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 10),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Habits - Database Demo'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    // Get current data from state
    List<User> users = [];
    List<Realm> realms = [];
    List<Habit> habits = [];

    if (state is HomeLoaded) {
      users = state.users;
      realms = state.realms;
      habits = state.habits;
    } else if (state is HomeUserOperation) {
      users = state.users;
      realms = state.realms;
      habits = state.habits;
    } else if (state is HomeRealmOperation) {
      users = state.users;
      realms = state.realms;
      habits = state.habits;
    } else if (state is HomeHabitOperation) {
      users = state.users;
      realms = state.realms;
      habits = state.habits;
    }

    final cubit = context.read<HomeCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UsersSection(
            users: users,
            onAddUser: () => _addUser(context, cubit),
            onDeleteUser: (id) => _deleteUser(context, cubit, id),
          ),
          const SizedBox(height: 24),
          RealmsSection(
            realms: realms,
            onAddRealm: () => _addRealm(context, cubit),
            onDeleteRealm: (id) => _deleteRealm(context, cubit, id),
          ),
          const SizedBox(height: 24),
          HabitsSection(
            habits: habits,
            users: users,
            realms: realms,
            onAddHabit: () => _addHabit(context, cubit, users, realms),
            onDeleteHabit: (id) => _deleteHabit(context, cubit, id),
          ),
        ],
      ),
    );
  }

  Future<void> _addUser(BuildContext context, HomeCubit cubit) async {
    final nameController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Enter user name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await cubit.addUser(result);
    }
  }

  Future<void> _deleteUser(BuildContext context, HomeCubit cubit, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deleteUser(id);
    }
  }

  Future<void> _addRealm(BuildContext context, HomeCubit cubit) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Realm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter realm name',
              ),
              autofocus: true,
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      await cubit.addRealm(
        nameController.text,
        description: descController.text.isEmpty ? null : descController.text,
      );
    }
  }

  Future<void> _deleteRealm(BuildContext context, HomeCubit cubit, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Realm'),
        content: const Text('Are you sure you want to delete this realm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deleteRealm(id);
    }
  }

  Future<void> _addHabit(
    BuildContext context,
    HomeCubit cubit,
    List<User> users,
    List<Realm> realms,
  ) async {
    if (users.isEmpty || realms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please create a user and realm first'),
        ),
      );
      return;
    }

    final nameController = TextEditingController();
    final frequencyController = TextEditingController(text: 'daily');
    int? selectedUserId = users.first.id;
    int? selectedRealmId = realms.first.id;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g., Exercise, Meditation',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedUserId,
                decoration: const InputDecoration(labelText: 'User'),
                items: users.map((u) {
                  return DropdownMenuItem(value: u.id, child: Text(u.name));
                }).toList(),
                onChanged: (value) => setState(() => selectedUserId = value),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedRealmId,
                decoration: const InputDecoration(labelText: 'Realm'),
                items: realms.map((r) {
                  return DropdownMenuItem(value: r.id, child: Text(r.name));
                }).toList(),
                onChanged: (value) => setState(() => selectedRealmId = value),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  hintText: 'daily / weekly / custom',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result == true && nameController.text.isNotEmpty && selectedUserId != null && selectedRealmId != null) {
      await cubit.addHabit(
        userId: selectedUserId!,
        realmId: selectedRealmId!,
        name: nameController.text,
        frequency: frequencyController.text,
      );
    }
  }

  Future<void> _deleteHabit(BuildContext context, HomeCubit cubit, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deleteHabit(id);
    }
  }
}
