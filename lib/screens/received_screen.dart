import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../database/ledger_database.dart';

class ReceivedScreen extends StatefulWidget {
  const ReceivedScreen({super.key});

  @override
  State<ReceivedScreen> createState() => _ReceivedScreenState();
}

class _ReceivedScreenState extends State<ReceivedScreen> {
  late Future<List<Entry>> _futureEntries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureEntries = LedgerDatabase.instance.getAllEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount Received'),
      ),
      body: FutureBuilder<List<Entry>>(
        future: _futureEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allEntries = snapshot.data ?? [];

          final receivedEntries = allEntries
              .where((e) => e.type == EntryType.received)
              .toList();

          if (receivedEntries.isEmpty) {
            return const Center(child: Text('No received entries'));
          }

          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
