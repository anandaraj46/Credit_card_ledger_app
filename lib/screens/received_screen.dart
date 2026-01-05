import 'package:flutter/material.dart';
import '../data/dummy_entries.dart';
import '../models/entry.dart';

class ReceivedScreen extends StatelessWidget {
  const ReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final receivedEntries = dummyEntries
        .where((e) => e.type == EntryType.received)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount Received'),
      ),
      body: receivedEntries.isEmpty
          ? const Center(
              child: Text('No received entries'),
            )
          : ListView.builder(
              itemCount: receivedEntries.length,
              itemBuilder: (context, index) {
                final entry = receivedEntries[index];

                return ListTile(
                  leading:
                      const Icon(Icons.arrow_downward, color: Colors.green),
                  title: Text('₹ ${entry.amount}'),
                  subtitle: Text(entry.person),
                  trailing: Text(
                    '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
}
