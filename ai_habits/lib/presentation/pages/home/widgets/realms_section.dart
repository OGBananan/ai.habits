import 'package:ai_habits/database/database.dart';
import 'package:flutter/material.dart';

class RealmsSection extends StatelessWidget {
  final List<Realm> realms;
  final VoidCallback onAddRealm;
  final Function(int) onDeleteRealm;

  const RealmsSection({
    super.key,
    required this.realms,
    required this.onAddRealm,
    required this.onDeleteRealm,
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
                  'Realms',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: onAddRealm,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Realm'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (realms.isEmpty)
              const Text('No realms yet')
            else
              Column(
                children: realms.map((realm) {
                  return ListTile(
                    title: Text(realm.name),
                    subtitle: Text(
                      '${realm.description ?? "No description"} - Health: ${realm.healthScore.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(realm.state),
                          backgroundColor: _getStateColor(realm.state),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => onDeleteRealm(realm.id),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStateColor(String state) {
    switch (state) {
      case 'operational':
        return Colors.green.shade100;
      case 'needs_attention':
        return Colors.orange.shade100;
      case 'critical':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
