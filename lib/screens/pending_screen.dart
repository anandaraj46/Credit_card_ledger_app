import 'package:flutter/material.dart';
import '../data/dummy_entries.dart';
import '../utils/pending_utils.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingMap = pendingByPerson(dummyEntries);
    final people = pendingMap.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Amount'),
      ),
      body: people.isEmpty
          ? const Center(
              child: Text('No pending balances 🎉'),
            )
          : ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];
                final amount = pendingMap[person]!;

                return ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.orange,
                  ),
                  title: Text(person),
                  trailing: Text(
                    '₹ $amount',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
