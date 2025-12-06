import 'package:ai_habits/database/database.dart';
import 'package:flutter/material.dart';

class HabitsSection extends StatelessWidget {
  final List<Habit> habits;
  final List<User> users;
  final List<Realm> realms;
  final VoidCallback onAddHabit;
  final Function(int) onDeleteHabit;

  const HabitsSection({
    super.key,
    required this.habits,
    required this.users,
    required this.realms,
    required this.onAddHabit,
    required this.onDeleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Habits',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: onAddHabit,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Habit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (habits.isEmpty)
              const Text('No habits yet')
            else
              Column(
                children: habits.map((habit) {
                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Text(
                      'Frequency: ${habit.frequency} - User: ${habit.userId} - Realm: ${habit.realmId}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onDeleteHabit(habit.id),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
