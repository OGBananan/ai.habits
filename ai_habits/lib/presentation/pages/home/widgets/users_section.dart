import 'package:ai_habits/database/database.dart';
import 'package:flutter/material.dart';

class UsersSection extends StatelessWidget {
  final List<User> users;
  final VoidCallback onAddUser;
  final Function(int) onDeleteUser;

  const UsersSection({
    super.key,
    required this.users,
    required this.onAddUser,
    required this.onDeleteUser,
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
                  'Users',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: onAddUser,
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (users.isEmpty)
              const Text('No users yet')
            else
              Column(
                children: users.map((user) {
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('ID: ${user.id}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onDeleteUser(user.id),
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
