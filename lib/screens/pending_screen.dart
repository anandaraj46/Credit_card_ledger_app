import 'package:flutter/material.dart';
import '../database/ledger_database.dart';
import '../models/entry.dart';
import '../utils/pending_utils.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
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
        title: const Text('Pending Amount'),
      ),
      body: FutureBuilder<List<Entry>>(
        future: _futureEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data ?? [];

          final pendingMap = pendingByPerson(entries);
          final people = pendingMap.keys.toList();

          if (people.isEmpty) {
            return const Center(child: Text('No pending balances 🎉'));
          }

          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
