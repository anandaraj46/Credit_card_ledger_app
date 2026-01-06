import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../data/cards.dart';
import '../database/ledger_database.dart';
import 'spent_entry_detail_screen.dart';

class SpentScreen extends StatefulWidget {
  const SpentScreen({super.key});

  @override
  State<SpentScreen> createState() => _SpentScreenState();
}

class _SpentScreenState extends State<SpentScreen> {
  late Future<List<Entry>> _futureEntries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureEntries = LedgerDatabase.instance.getAllEntries();
  }

  // ---------------- UNDO SNACKBAR ----------------
  void _showUndoSnackbar(List<Entry> deleted) {
    if (deleted.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text('${deleted.length} transactions deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await LedgerDatabase.instance.insertMany(deleted);
            setState(_load);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // ---------------- CLEAR ALL ----------------
  Future<void> _confirmClearAll(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all transactions'),
        content: const Text(
          'This will permanently delete ALL spent transactions. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // 1. Read what will be deleted
              final deleted = await LedgerDatabase.instance.getAllSpent();

              // 2. Delete from DB
              await LedgerDatabase.instance.deleteAll();

              // 3. Close dialog
              Navigator.pop(context);

              // 4. Show undo
              _showUndoSnackbar(deleted);

              // 5. Reload UI
              setState(_load);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // ---------------- CLEAR BY CARD ----------------
  Future<void> _selectCardToClear(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear by card'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: cards.map((card) {
              return ListTile(
                title: Text(card.name),
                onTap: () async {
                  // 1. Read what will be deleted
                  final deleted =
                      await LedgerDatabase.instance.getSpentByCard(card.name);

                  // 2. Delete from DB
                  await LedgerDatabase.instance.deleteByCard(card.name);

                  // 3. Close dialog
                  Navigator.pop(context);

                  // 4. Show undo
                  _showUndoSnackbar(deleted);

                  // 5. Reload UI
                  setState(_load);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount Spent'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _confirmClearAll(context);
              } else if (value == 'clear_by_card') {
                _selectCardToClear(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all transactions'),
              ),
              PopupMenuItem(
                value: 'clear_by_card',
                child: Text('Clear by card'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Entry>>(
        future: _futureEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final spentEntries = (snapshot.data ?? [])
              .where((e) => e.type == EntryType.spent)
              .toList();

          if (spentEntries.isEmpty) {
            return const Center(child: Text('No spent entries'));
          }

          return ListView.builder(
            itemCount: spentEntries.length,
            itemBuilder: (context, index) {
              final entry = spentEntries[index];

              return ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.red),
                title: Text('₹ ${entry.amount}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.person),
                    if (entry.card != null)
                      Text(
                        entry.card!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                trailing: Text(
                  '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SpentEntryDetailScreen(entry: entry),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
